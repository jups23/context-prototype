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
	if([self containsDataAboutObservedContext:notification]){
		[self notifyIfWalking:notification];
		[self notifyIfIdle:notification];
	}
}

-(void)notifyIfWalking:(NSNotification*)notification
{
	if([[notification.userInfo valueForKey:@"value"] isEqualToString:@"\"Walking\"" ]) {
		NSDate* date = [NSDate dateWithTimeIntervalSince1970:[[notification.userInfo valueForKey:@"date"] doubleValue]];
		[self.contextTimeStamps setValue:date forKey:@"walking"];
		[self.codeViewController contextBecameActive:@"walking"];
	}
}

-(void)notifyIfIdle:(NSNotification*)notification
{
	if([[notification.userInfo valueForKey:@"value"] isEqualToString:@"\"Idle\"" ]) {
		NSDate* date = [NSDate dateWithTimeIntervalSince1970:[[notification.userInfo valueForKey:@"date"] doubleValue]];
		[self.contextTimeStamps setValue:date forKey:@"idle"];
		[self.codeViewController contextBecameActive:@"idle"];
	}
}

-(BOOL)containsDataAboutObservedContext:(NSNotification*)notification
{
	return [self containsDataForActivity:notification] &&
	([self observes:@"walking"] || [self observes:@"idle"]);
}

-(BOOL)observes:(NSString*)context
{
	return [self.observedContexts containsObject:context];
}

-(BOOL)containsDataForActivity:(NSNotification*)notification
{
	return [notification.object isEqualToString:
			[[Factory sharedFactory].activityModule name]];
}

-(void)registerCodeViewController:(MGCodeViewController *)codeViewController
{
	self.codeViewController = codeViewController;
}

#pragma mark constants

-(double)minWalkingStepsPerMinute {return 40.0;}
-(double)activityTimeOut {return 7;}	// seconds

@end
