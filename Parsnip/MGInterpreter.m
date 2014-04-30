//
//  MGInterpreter.m
//  Parsnip
//
//  Created by Willi Müller on 26.04.14.
//  Copyright (c) 2014 UFMG. All rights reserved.
//

#import "MGInterpreter.h"
#import "Factory.h"
#import <SensePlatform/CSSensePlatform.h>
#import "Underscore.h"
#import "MGMainViewController.h"


@interface MGInterpreter()

@property NSMutableArray* observedContexts;

@property MGCodeViewController* codeViewController;

@end

@implementation MGInterpreter

-(id)init
{
	self = [super init];
	if(self) {
		self.observedContexts = [[NSMutableArray alloc] init];
		//subscribe to all sensor data
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNewData:) name:kCSNewSensorDataNotification object:nil];
	}
	return self;
}

-(void)observeContext:(NSString *)context
{
	[self.observedContexts addObject:context];
}

-(void)onNewData:(NSNotification*)notification
{
	if([self containsDataForWalking:notification]){
		if([self observesWalking]) {
			[self notifyIfWalking:notification];
		}
	}
}

-(void)notifyIfWalking:(NSNotification*)notification
{
	NSDictionary *json = [notification.userInfo valueForKey:@"value"];
	double stepsPerMinute = [[json valueForKey:@"steps per minute"] doubleValue];
	if(stepsPerMinute > [self minWalkingStepsPerMinute]){
		NSLog(@"Walking with: %f steps per minute", stepsPerMinute);
		[self.codeViewController contextBecameActive:@"walking"];
	}
}

-(BOOL)observesWalking
{
	return [self.observedContexts containsObject:@"walking"];
}

-(BOOL)containsDataForWalking:(NSNotification*)notification
{
	return [notification.object isEqualToString:
			[[Factory sharedFactory].stepCounterModule name]];
}

-(void)registerCodeViewController:(MGCodeViewController *)codeViewController
{
	self.codeViewController = codeViewController;
}

#pragma mark constants

-(double)minWalkingStepsPerMinute {return 40.0;}

@end
