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
@property NSDictionary* contextTimeStamps;

@property MGCodeViewController* codeViewController;
@property NSTimer* timer;

@end

@implementation MGInterpreter

-(id)init
{
	self = [super init];
	if(self) {
		self.observedContexts = [[NSMutableArray alloc] init];
		self.contextTimeStamps = [[NSMutableDictionary alloc] init];
		//subscribe to all sensor data
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(onNewData:)
													 name:kCSNewSensorDataNotification
												   object:nil];
	}
	self.timer = [NSTimer timerWithTimeInterval:1.0f
										 target:self
									   selector:@selector(checkIfAnyContextTimedOut)
									   userInfo:nil
										repeats:YES];
	[[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];

	return self;
}

-(void)checkIfAnyContextTimedOut
{
	double walkingTimeOut = 5;
	NSDate* t0 = [self.contextTimeStamps valueForKey:@"walking"];
	if(t0) {
		NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:t0];
		if(secondsBetween > walkingTimeOut) {
			[self.codeViewController contextBecameInActive:@"walking"];
		}
	}
}

-(void)observeContext:(NSString *)context
{
	[self.observedContexts addObject:context];
}

-(void)onNewData:(NSNotification*)notification
{
	if([self containsDataAboutObservedContext:notification]){
		[self notifyIfWalking:notification];
	}
}

-(void)notifyIfWalking:(NSNotification*)notification
{
	NSDictionary *json = [notification.userInfo valueForKey:@"value"];
	double stepsPerMinute = [[json valueForKey:@"steps per minute"] doubleValue];
	if(stepsPerMinute > [self minWalkingStepsPerMinute]){
		NSDate* date = [NSDate dateWithTimeIntervalSince1970:[[notification.userInfo valueForKey:@"date"] doubleValue]];
		[self.contextTimeStamps setValue:date forKey:@"walking"];
		NSLog(@"Walking with: %f steps per minute at date %@", stepsPerMinute, date);
		[self.codeViewController contextBecameActive:@"walking"];
	}
}

-(BOOL)containsDataAboutObservedContext:(NSNotification*)notification
{
	return [self observesWalking] && [self containsDataForWalking:notification];
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
