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

#import "MGInputTableViewController.h"
#import "MGContextsAndSensors.h"
#import "MGInputDetailViewController.h"

@interface MGInputTableViewController ()

@property NSMutableArray *sensorsAndContexts;
@property NSArray *sectionTitles;
@property NSString* defaultUrl;

@property NSMutableSet* activeContexts;

@end

@implementation MGInputTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.defaultUrl = @"http://174.23.23.23:5000";
	self.sectionTitles = @[@"Activity", @"Device", @"Other Sensors"];
	self.sensorsAndContexts = [NSMutableArray arrayWithArray:@[
							   @{@"name": MGContextIdle,
								 @"section": self.sectionTitles[0],
								 @"url": self.defaultUrl},
							   @{@"name": MGContextRunning,
								 @"section": self.sectionTitles[0],
								 @"url": self.defaultUrl},
							   @{@"name": MGContextWalking,
								 @"section":self.sectionTitles[0],
								 @"url": self.defaultUrl},
							   @{@"name": MGSensorMotion,
								 @"section": self.sectionTitles[0],
								 @"url": self.defaultUrl},
							   @{@"name": MGContextDeviceInHand,
								 @"section": self.sectionTitles[1],
								 @"url": self.defaultUrl},
							   @{@"name": MGContextDeviceOnBody,
								 @"section": self.sectionTitles[1],
								 @"url": self.defaultUrl},
							   @{@"name": MGSensorProximity,
								 @"section": self.sectionTitles[2],
								 @"url": self.defaultUrl},
							   @{@"name": MGSensorMicrophone,
								 @"section": self.sectionTitles[2],
								 @"url": self.defaultUrl},
							   ]];
//							   @{@"Activity": @[MGContextIdle, MGContextRunning, MGContextWalking, MGSensorMotion],
//								@"Device": @[MGContextDeviceInHand, MGContextDeviceOnBody],
//								@"Other Sensors": @[MGSensorProximity, MGSensorMicrophone]
//								}];

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
	NSString *url = @"http://"; // TODO THIS IS MOTION DATA, get MOTION URL
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	[manager POST:[@"http://" stringByAppendingString:url] parameters:sensorData success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

-(NSDictionary*)inputForIndexPath:(NSIndexPath*)indexPath
{
	NSString *sectionTitle = [self.sectionTitles objectAtIndex:indexPath.section];
	return [[self allOfSection:sectionTitle] objectAtIndex:indexPath.row];
}

-(NSArray*)allOfSection:(NSString*)sectionTitle
{
	return _.filter(self.sensorsAndContexts, ^BOOL(NSDictionary* input){
		return [[input valueForKey:@"section"] isEqualToString: sectionTitle];
	});
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	NSMutableDictionary *input = [NSMutableDictionary dictionaryWithDictionary:[self inputForIndexPath:indexPath]];
	[[segue destinationViewController] setInputItem:input];
}

-(void)updateInputItem:(NSDictionary *)inputItem
{
	[self.sensorsAndContexts setValue:inputItem forKey:[inputItem valueForKey:@"name"]];
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
	
}


@end
