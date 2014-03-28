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

@property CMMotionManager *motionManager;
@property NSOperationQueue *deviceQueue;

@end

@implementation MGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.sensorDisplay.text = @"Huhu";

	self.deviceQueue = [[NSOperationQueue alloc] init];
	self.motionManager = [[CMMotionManager alloc] init];
	self.motionManager.deviceMotionUpdateInterval = 5.0 / 60.0;
	
	// UIDevice *device = [UIDevice currentDevice];
	
	[self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical
															toQueue:self.deviceQueue
														withHandler:^(CMDeviceMotion *motion, NSError *error)
	{
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			CGFloat x = motion.gravity.x;
			CGFloat y = motion.gravity.y;
			CGFloat z = motion.gravity.z;
			self.sensorDisplay.text = [NSString stringWithFormat:@"x: %.2f, y: %.2f, z: %.2f", x, y, z];
		}];
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
