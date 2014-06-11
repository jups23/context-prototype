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
	self.defaultUrl = @"http://169.254.154.130:5000";
	NSString* defaultContextUrl = [self.defaultUrl stringByAppendingString:@"/context"];
	self.sectionTitles = @[@"Activity", @"Device", @"Other Sensors"];
	self.sensorsAndContexts = [NSMutableArray arrayWithArray:@[
								[[MGSensorInput alloc] initWithName: MGContextIdle url:defaultContextUrl isObserved:NO isContext:TRUE section:self.sectionTitles[0]],
								[[MGSensorInput alloc] initWithName: MGContextRunning url:defaultContextUrl isObserved:NO isContext:TRUE section:self.sectionTitles[0]],
								[[MGSensorInput alloc] initWithName: MGContextWalking url:defaultContextUrl isObserved:NO isContext:TRUE section:self.sectionTitles[0]],
								[[MGSensorInput alloc] initWithName: MGContextCycling url:self.defaultUrl isObserved:NO isContext:TRUE section:self.sectionTitles[0]],
								[[MGSensorInput alloc] initWithName: MGSensorMotion url:self.defaultUrl isObserved:NO isContext:FALSE section:self.sectionTitles[0]],

								[[MGSensorInput alloc] initWithName: MGContextDeviceInHand url:defaultContextUrl isObserved:NO  isContext:TRUE section:self.sectionTitles[1]],
								[[MGSensorInput alloc] initWithName: MGContextDeviceOnBody url:defaultContextUrl isObserved:NO isContext:TRUE section:self.sectionTitles[1]],

								[[MGSensorInput alloc] initWithName: MGSensorProximity url:self.defaultUrl isObserved:NO isContext:FALSE section:self.sectionTitles[2]],
								[[MGSensorInput alloc] initWithName: MGSensorMicrophone url:self.defaultUrl isObserved:NO isContext:FALSE section:self.sectionTitles[2]],
							   ]];
	self.sensorObserver = [[MGInterpreter alloc] init];
	self.activeContexts = [[NSMutableSet alloc] init];
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
	MGSensorInput* context = [notification.userInfo valueForKey:@"context"];
	[self.activeContexts addObject:context];
	[self notifyServerAtUrl:context.url aboutData:@{@"context": context.name, @"active":@YES}];
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.tableView reloadData];
	});
}

-(void)contextBecameInActive:(NSNotification*)notification
{
	MGSensorInput* context = [notification.userInfo valueForKey:@"context"];
	[self.activeContexts removeObject:context];
	[self notifyServerAtUrl:context.url aboutData:@{@"context": context.name, @"active":@NO}];
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.tableView reloadData];
	});
}

-(void)processSensorData:(NSNotification*)notification
{
	NSDictionary* sensorData = [notification.userInfo objectForKey:@"values"];

	MGSensorInput* sensor = [notification.userInfo objectForKey:@"sensor"];
	NSString* url = sensor.url;
	[self notifyServerAtUrl:url aboutData:sensorData];
}

#pragma mark - Server Communication

-(void)notifyServerAtUrl:(NSString*)url aboutData:(NSDictionary*)data
{
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	manager.responseSerializer = [AFHTTPResponseSerializer serializer];
	[manager POST:url parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"Response Code: %ld", (long)[operation.response statusCode]);
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
	MGSensorInput* sensorInput = [self inputForIndexPath:indexPath];
	cell.textLabel.text = sensorInput.name;
	[cell.textLabel setTextColor:[UIColor blackColor]];
	if ([self.activeContexts containsObject:sensorInput]) {
		[cell.textLabel setTextColor:[UIColor greenColor]];
	}
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
		[self.sensorObserver observeSensor:sensor];
	}
}


@end
