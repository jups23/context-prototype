//
//  MGViewController.m
//  Parsnip
//
//  Created by Willi Müller on 28.03.14.
//  Copyright (c) 2014 UFMG. All rights reserved.
//

#import "MGViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface MGViewController ()

@property (weak, nonatomic) IBOutlet UILabel *sensorDisplay;

@property (weak, nonatomic) IBOutlet UILabel *userShakingDisplay;

@property (weak, nonatomic) IBOutlet UIPickerView *userContextPicker;
@property (strong, nonatomic) NSArray *availableUserContexts;
@property (strong, nonatomic) NSString *watchForUserContext;

@property (weak, nonatomic) IBOutlet UIPickerView *thenPicker;
@property (strong, nonatomic) NSArray *availableThenActions;
@property (strong, nonatomic) NSString *performThenAction;


@property CMMotionManager *motionManager;
@property NSOperationQueue *deviceQueue;
@property (weak, nonatomic) IBOutlet UITextField *sensorValueInputLabel;

@end

@implementation MGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.sensorDisplay.text = @"Huhu";
	self.availableUserContexts = @[@"moving", @"still", @"walking"];
	self.availableThenActions = @[@"magenta", @"blue"];
	int defaultPickerRow = 0;
	[self.userContextPicker selectRow:defaultPickerRow inComponent:0 animated:NO];
	[self.thenPicker selectRow:defaultPickerRow inComponent:0 animated:NO];
	self.watchForUserContext = self.availableUserContexts[defaultPickerRow];
	self.performThenAction = self.availableThenActions[defaultPickerRow];
	
	self.deviceQueue = [[NSOperationQueue alloc] init];
	self.motionManager = [[CMMotionManager alloc] init];
	self.motionManager.deviceMotionUpdateInterval = 5.0 / 60.0;
	
	// UIDevice *device = [UIDevice currentDevice];
	
	[self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical
															toQueue:self.deviceQueue
														withHandler:^(CMDeviceMotion *motion, NSError *error)
	{
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			[self handleMotionChangeOf: motion.gravity.x ofY: motion.gravity.y ofZ: motion.gravity.z];
		}];
	}];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
	self.sensorValueInputLabel.text = textField.text;
    return YES;
}

#pragma mark - Handle device motion

- (BOOL)canBecomeFirstResponder
{
	return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [self becomeFirstResponder];
}

- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
	if([self.watchForUserContext isEqualToString:@"moving"] && motion == UIEventSubtypeMotionShake) {
		self.userShakingDisplay.text = @"User is shaking";
		if ([self.performThenAction isEqualToString: @"magenta"])
			self.userShakingDisplay.textColor = [UIColor magentaColor];
		else
			self.userShakingDisplay.textColor = [UIColor blueColor];
	}
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
	if ([self.watchForUserContext isEqualToString:@"moving"] && motion == UIEventSubtypeMotionShake)
    {
		self.userShakingDisplay.text = @"User is still";
		self.userShakingDisplay.textColor = [UIColor blackColor];
	}
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
	[self motionEnded:motion withEvent:event];
}

- (void) handleMotionChangeOf: (CGFloat) x ofY: (CGFloat) y ofZ: (CGFloat) z
{
	self.sensorDisplay.text = [NSString stringWithFormat:@"x: %.2f, y: %.2f, z: %.2f", x, y, z];
}

#pragma mark - PickerView data source

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
	if (pickerView == self.userContextPicker) {
		return self.availableUserContexts.count;
	} else {
		return self.availableThenActions.count;
	}
}


#pragma mark - PickerView delegate
- (NSString *)pickerView:(UIPickerView *)pickerView
			 titleForRow:(NSInteger)row
			forComponent:(NSInteger)component
{
	if (pickerView == self.userContextPicker) {
		return self.availableUserContexts[row];
	} else {
		return self.availableThenActions[row];
	}
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if (pickerView == self.userContextPicker) {
		self.watchForUserContext = self.availableUserContexts[row];
	} else {
		self.performThenAction = self.availableThenActions[row];
	}
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
