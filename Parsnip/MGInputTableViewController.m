//
//  MGInputTableViewController.m
//  Parsnip
//
//  Created by Willi Müller on 28.05.14.
//  Copyright (c) 2014 UFMG. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "Underscore.h"
#define _ Underscore

#import "MGSensorInput.h"
#import "MGInputTableViewController.h"
#import "MGContextsAndSensors.h"
#import "MGInputDetailViewController.h"

#import "MGInterpreter.h"

@interface MGInputTableViewController ()

@property NSMutableArray *sensorsAndContexts;
@property NSArray *sectionTitles;
@property NSString* defaultUrl;
@property MGInterpreter* sensorObserver;

@property NSMutableSet* activeContexts;

@end

@implementation MGInputTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.defaultUrl = @"http://174.23.23.23:5000";
	self.sectionTitles = @[@"Activity", @"Device", @"Other Sensors"];
	self.sensorsAndContexts = [NSMutableArray arrayWithArray:@[
								[[MGSensorInput alloc] initWithName: MGContextIdle url:self.defaultUrl isObserved:NO section:self.sectionTitles[0]],
								[[MGSensorInput alloc] initWithName: MGContextRunning url:self.defaultUrl isObserved:NO section:self.sectionTitles[0]],
								[[MGSensorInput alloc] initWithName: MGContextWalking url:self.defaultUrl isObserved:NO section:self.sectionTitles[0]],
								[[MGSensorInput alloc] initWithName: MGSensorMotion url:self.defaultUrl isObserved:NO section:self.sectionTitles[0]],
								
								[[MGSensorInput alloc] initWithName: MGContextDeviceInHand url:self.defaultUrl isObserved:NO section:self.sectionTitles[1]],
								[[MGSensorInput alloc] initWithName: MGContextDeviceOnBody url:self.defaultUrl isObserved:NO section:self.sectionTitles[1]],
								
								[[MGSensorInput alloc] initWithName: MGSensorProximity url:self.defaultUrl isObserved:NO section:self.sectionTitles[2]],
								[[MGSensorInput alloc] initWithName: MGSensorMicrophone url:self.defaultUrl isObserved:NO section:self.sectionTitles[2]],
							   ]];
	self.sensorObserver = [[MGInterpreter alloc] init];
	[self subscribeToSensorInfo];
	[self subscribeToContextInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Sensor Data

-(void)subscribeToSensorInfo
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processSensorData:) name:@"newSensorData" object:nil];
}

-(void)subscribeToContextInfo
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextBecameActive:) name:@"contextActive" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextBecameInActive:) name:@"contextInActive" object:nil];
}

-(void)contextBecameActive:(NSNotification*)notification
{
	[self.activeContexts addObject:[notification.userInfo valueForKey:@"context"]];
}

-(void)contextBecameInActive:(NSNotification*)notification
{
	[self.activeContexts removeObject:[notification.userInfo valueForKey:@"context"]];
}

-(void)processSensorData:(NSNotification*)notification
{
	NSDictionary* sensorData = notification.userInfo;
	NSString *url = [self inputForName:@"motion"].url; // TODO THIS IS UP TO NOW ALWAYS MOTION DATA, get MOTION URL
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	[manager POST:url parameters:sensorData success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"%@", responseObject);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"%@", error);
	}];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionTitles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
	return [[self allOfSection:[self.sectionTitles objectAtIndex:sectionIndex]] count];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [self.sectionTitles objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *identifier = @"Cell";
    UITableViewCell *cell;
	cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
	if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
	cell.textLabel.text = [[self inputForIndexPath:indexPath] valueForKey:@"name"];
	return cell;
}

-(NSArray*)allOfSection:(NSString*)sectionTitle
{
	return _.filter(self.sensorsAndContexts, ^BOOL(MGSensorInput* sensor){
		return [sensor.section isEqualToString: sectionTitle];
	});
}

-(MGSensorInput*)inputForIndexPath:(NSIndexPath*)indexPath
{
	NSString *sectionTitle = [self.sectionTitles objectAtIndex:indexPath.section];
	return [[self allOfSection:sectionTitle] objectAtIndex:indexPath.row];
}

-(MGSensorInput*)inputForName:(NSString*)name
{
	return _.find(self.sensorsAndContexts, ^BOOL (MGSensorInput* sensor) {
		return [sensor.name isEqualToString:name];
	});
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	MGSensorInput *input = [self inputForIndexPath:indexPath];
	MGInputDetailViewController* detailVc = (MGInputDetailViewController*)[[segue destinationViewController] topViewController];
	[detailVc setInputItem:input];
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
	MGSensorInput *updatedItem = [[segue sourceViewController] inputItem];
	if(updatedItem != nil) {
		[self updateInputItem:updatedItem];
		[self.tableView reloadData];
	}
}

-(void)updateInputItem:(MGSensorInput *)inputItem
{
	MGSensorInput* sensor = [self inputForName:inputItem.name];
	sensor.isObserved = inputItem.isObserved;
	sensor.url = inputItem.url;
	if(sensor.isObserved){
		[self.sensorObserver observeSensor:sensor.name];
	}
}


@end
