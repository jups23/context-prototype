//
//  MGInputTableViewController.m
//  Parsnip
//
//  Created by Willi Müller on 28.05.14.
//  Copyright (c) 2014 UFMG. All rights reserved.
//

#import "MGInputTableViewController.h"
#import "MGContextsAndSensors.h"

@interface MGInputTableViewController ()

@property NSDictionary *sensorsAndContexts;
@property NSArray *sectionTitles;

@property NSMutableSet* activeContexts;

@end

@implementation MGInputTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.sensorsAndContexts = @{@"Activity": @[MGContextIdle, MGContextRunning, MGContextWalking, MGSensorMotion],
								@"Device": @[MGContextDeviceInHand, MGContextDeviceOnBody],
								@"Other Sensors": @[MGSensorProximity, MGSensorMicrophone]
								};
	self.sectionTitles = @[@"Activity", @"Device", @"Other Sensors"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionTitles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[self.sensorsAndContexts objectForKey:[self.sectionTitles objectAtIndex:section]] count];
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
	cell.textLabel.text = [self inputForIndexPath:indexPath];
	return cell;
}

-(NSString*)inputForIndexPath:(NSIndexPath*)indexPath
{
	NSString *sectionTitle = [self.sectionTitles objectAtIndex:indexPath.section];
	return [[self.sensorsAndContexts objectForKey:sectionTitle] objectAtIndex:indexPath.row];
}

#pragma mark - Navigation

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//
//	if ([[segue identifier] isEqualToString:@"showDetail"]) {
//		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//		NSString *input = [self inputForIndexPath:indexPath];
//		[[segue destinationViewController] setDetailItem:input];
//	}
//}


@end
