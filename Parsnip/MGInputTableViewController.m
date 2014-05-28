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

@property NSArray *activitySourcesList;
@property NSArray *deviceSourcesList;
@property NSArray *sensorList;
@property NSArray *sections;

@end

@implementation MGInputTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

	self.activitySourcesList = @[MGContextIdle, MGContextRunning, MGContextWalking, MGSensorMotion];
	self.deviceSourcesList = @[MGContextDeviceInHand, MGContextDeviceOnBody];
	self.sensorList = @[MGSensorProximity, MGSensorMicrophone];
	self.sections = @[@"Activity", @"Device", @"Other Sensors"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(section == 0) {
		return [self.activitySourcesList count];
	}
	if(section == 1) {
		return [self.deviceSourcesList count];
	}
	if(section == 2){
		return [self.sensorList count];
	} else {
		NSAssert(YES, @"specify number of entries for section");
		return 0;
	}
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [self.sections objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *identifier = @"Cell";
    UITableViewCell *cell;
	cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
	if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
	NSString *text;

	if (indexPath.section == 0) {
		text = [self.activitySourcesList objectAtIndex:indexPath.row];
	}
	if(indexPath.section == 1) {
		text = [self.deviceSourcesList objectAtIndex:indexPath.row];
	}
	if(indexPath.section == 2){
		text = [self.sensorList objectAtIndex:indexPath.row];
	}
	
	NSLog(@"%@", text);
	cell.textLabel.text = text;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
