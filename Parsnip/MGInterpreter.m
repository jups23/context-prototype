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
		NSTimer* timer = [NSTimer timerWithTimeInterval:1.0f
											 target:self
										   selector:@selector(checkIfAnyContextTimedOut)
										   userInfo:nil
											repeats:YES];
		[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
	}

	return self;
}

-(void)checkIfAnyContextTimedOut
{
	[self checkIfActivityTimedOut];
}

- (void)checkIfActivityTimedOut
{
	for (NSString *context in @[@"walking", @"idle", @"cycling"]) {
		NSDate* t0 = [self.contextTimeStamps valueForKey:context];
		if(t0) {
			NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:t0];
			if(secondsBetween > [self activityTimeOut]) {
				[self.codeViewController contextBecameInActive:context];
			}
		}
	}
}

-(void)observeContext:(NSString *)context
{
	[self.observedContexts addObject:context];
}

-(void)onNewData:(NSNotification*)notification
{
	if([self observesActivity:notification]){
		[self notifyIfActivity:notification];
	}
}

-(void)notifyIfActivity:(NSNotification*)notification
{
	if([self containsStepCountData:notification]) {
		double stepsPerMinute = [[[notification.userInfo valueForKey:@"value"]
								  valueForKey:@"steps per minute"] doubleValue];
		[self notifyIfWalkingWithStepsPerMinute:stepsPerMinute fromNotification:notification];
		[self notifyIfIdleWithStepsPerMinute:stepsPerMinute fromNotification:notification];
	} else {
		if([self containsActivityData:notification]) {
			[self notifyIfWalking:notification];
			[self notifyIfIdle:notification];
		}
	}
}

-(void)notifyIfWalkingWithStepsPerMinute:(double)stepsPerMinute fromNotification:(NSNotification*)notification
{
	if(stepsPerMinute > [self minWalkingStepsPerMinute]){
		NSLog(@"Walking with %f steps per minute", stepsPerMinute);
		[self saveWalkingIsActive:notification];
	}
}

-(void)notifyIfWalking:(NSNotification*)notification
{
	if([[notification.userInfo valueForKey:@"value"] isEqualToString:@"\"Walking\""]) {
		NSLog(@"Walking");
		[self saveWalkingIsActive:notification];
	}
}

-(void)notifyIfIdleWithStepsPerMinute:(double)stepsPerMinute fromNotification:(NSNotification*)notification
{
	if(stepsPerMinute < [self minWalkingStepsPerMinute]) {
		NSLog(@"Idle with %f steps per minute", stepsPerMinute);
		[self saveIdleIsActive:notification];
	}
}

-(void)notifyIfIdle:(NSNotification*)notification
{
	if([[notification.userInfo valueForKey:@"value"] isEqualToString:@"\"Idle\""]) {
		NSLog(@"Idle");
		[self saveIdleIsActive:notification];
	}
}

-(void)saveWalkingIsActive:(NSNotification*)notification
{
	[self saveContextBecameActive:@"walking" fromNotification:notification];
}

- (void)saveIdleIsActive:(NSNotification *)notification
{
	[self saveContextBecameActive:@"idle" fromNotification:notification];
}

-(void)saveContextBecameActive:(NSString*)context fromNotification:(NSNotification*)notification
{
	NSDate* date = [NSDate dateWithTimeIntervalSince1970:[[notification.userInfo valueForKey:@"date"] doubleValue]];
	[self.contextTimeStamps setValue:date forKey:context];
	[self.codeViewController contextBecameActive:context];
}

-(BOOL)observesActivity:(NSNotification*)notification
{
	// TODO pass array here
	return [self observes:@"walking"] || [self observes:@"idle"] || [self observes:@"cycling"];
}

-(BOOL)containsActivityData:(NSNotification*)notification
{
	return [notification.object isEqualToString: [[Factory sharedFactory].activityModule name]];
}

-(BOOL)containsStepCountData:(NSNotification*)notification
{
	return [notification.object isEqualToString: [[Factory sharedFactory].stepCounterModule name]];
}

-(BOOL)observes:(NSString*)context
{	// TODO _.any()
	return [self.observedContexts containsObject:context];
}

-(void)registerCodeViewController:(MGCodeViewController *)codeViewController
{
	self.codeViewController = codeViewController;
}

#pragma mark constants

-(double)minWalkingStepsPerMinute {return 40.0;}
-(double)activityTimeOut {return 7;}	// seconds

@end
