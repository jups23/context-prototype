//
//  MGInterpreter.m
//  Parsnip
//
//  Created by Willi Müller on 26.04.14.
//  Copyright (c) 2014 UFMG. All rights reserved.
//

#import "MGMainViewController.h"
#import "MGInterpreter.h"
#import "MGContextsAndSensors.h"

#import "Factory.h"
#import <SensePlatform/CSSensePlatform.h>
#import <CoreMotion/CMMotionManager.h>

#import "AFHTTPRequestOperationManager.h"
#import "Underscore.h"
#define _ Underscore


@interface MGInterpreter()

@property NSMutableSet* observedContexts;
@property NSMutableSet* observedSensors;
@property NSDictionary* contextTimeStamps;
@property NSArray* implementedContexts;
@property NSMutableArray* sensorValues;

@property NSOperationQueue* queue;
@property BOOL observingDeviceMotion;

@property MGCodeViewController* codeViewController;
@property NSObject* sensorObserver;
@property CMMotionManager *motionManager;

@end

@implementation MGInterpreter

-(id)init
{
	self = [super init];
	if(self) {
		self.observedContexts = [[NSMutableSet alloc] init];
		self.contextTimeStamps = [[NSMutableDictionary alloc] init];
		self.observedSensors = [[NSMutableSet alloc] init];
		self.sensorValues = [[NSMutableArray alloc] init];
		
		self.implementedContexts = @[@"walking", @"idle", @"running"];

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


		self.motionManager = [[CMMotionManager alloc] init];
		self.motionManager.deviceMotionUpdateInterval = 1.0f/60; // Hz
		self.queue = [NSOperationQueue currentQueue];
	}
	return self;
}


#pragma mark - Sensors

-(void)observeSensor:(NSString*)sensor
{
	[self.observedSensors addObject:sensor];
	if([self.observedSensors containsObject:MGSensorMotion] && !self.observingDeviceMotion) {
		[self observeDeviceMotion];
	}
}

-(void)unObserveSensor:(NSString *)sensor
{
	if ([sensor isEqualToString:MGSensorMotion]) {
		[self.motionManager stopDeviceMotionUpdates];
		self.observingDeviceMotion = NO;
	}
}

- (void)notifyServer:(NSDictionary *)avgs
{
	//[self.codeViewController sendMotionData:avgs];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"newSensorData" object:self userInfo:avgs];
}

-(void)observeDeviceMotion
{
	self.observingDeviceMotion = YES;
	int WINDOW_SIZE = 10;
	[self.motionManager startDeviceMotionUpdatesToQueue:self.queue withHandler:^ (CMDeviceMotion *motionData, NSError *error) {
		if([self.sensorValues count] < WINDOW_SIZE) {
			[self.sensorValues addObject:@{
										   @"accelerationX": [NSNumber numberWithDouble:motionData.userAcceleration.y],
										   @"accelerationY": [NSNumber numberWithDouble:motionData.userAcceleration.y],
										   @"accelerationZ": [NSNumber numberWithDouble:motionData.userAcceleration.z],
										   @"attitudeRoll":  [NSNumber numberWithDouble:motionData.attitude.roll],
										   @"attitudePitch": [NSNumber numberWithDouble:motionData.attitude.pitch],
										   @"attitudeYaw":   [NSNumber numberWithDouble:motionData.attitude.yaw],
										   @"rotationRateX": [NSNumber numberWithDouble:motionData.rotationRate.x],
										   @"rotationRateY": [NSNumber numberWithDouble:motionData.rotationRate.y],
										   @"rotationRateZ": [NSNumber numberWithDouble:motionData.rotationRate.z]
										   }];
		} else {
			NSDictionary *avgs = [self filterMovement];
			self.sensorValues = [[NSMutableArray alloc] init]; // @[]
			[self notifyServer:avgs];
		}
	}];
}
- (NSDictionary *)filterMovement
{
	NSDictionary *avgs = @{@"accelerationX": [[self.sensorValues valueForKeyPath:@"accelerationX"] valueForKeyPath:@"@avg.self"],
						   @"accelerationY": [[self.sensorValues valueForKeyPath:@"accelerationY"] valueForKeyPath:@"@avg.self"],
						   @"accelerationZ": [[self.sensorValues valueForKeyPath:@"accelerationZ"] valueForKeyPath:@"@avg.self"],
						   
						   @"attitudeRoll":  [[self.sensorValues valueForKeyPath:@"attitudeRoll"] valueForKeyPath:@"@avg.self"],
						   @"attitudePitch": [[self.sensorValues valueForKeyPath:@"attitudePitch"] valueForKeyPath:@"@avg.self"],
						   @"attitudeYaw":   [[self.sensorValues valueForKeyPath:@"attitudeYaw"] valueForKeyPath:@"@avg.self"],
						   
						   @"rotationRateX": [[self.sensorValues valueForKeyPath:@"rotationRateX"] valueForKeyPath:@"@avg.self"],
						   @"rotationRateY": [[self.sensorValues valueForKeyPath:@"rotationRateY"] valueForKeyPath:@"@avg.self"],
						   @"rotationRateZ": [[self.sensorValues valueForKeyPath:@"rotationRateZ"] valueForKeyPath:@"@avg.self"],
						};
	return avgs;
}

		
#pragma mark - Contexts

-(void)checkIfAnyContextTimedOut
{
	[self checkIfActivityTimedOut];
}

- (void)checkIfActivityTimedOut
{
	for (NSString *context in self.implementedContexts) {
		NSDate* t0 = [self.contextTimeStamps valueForKey:context];
		if(t0) {
			NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:t0];
			if(secondsBetween > [self activityTimeOut]) {
//				[self.codeViewController contextBecameInActive:context];
				[[NSNotificationCenter defaultCenter] postNotificationName:@"contextInactive" object:self userInfo:@{@"context":context}];
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
			[self notifyIfRunning:notification];
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

-(void)notifyIfRunning:(NSNotification*)notification
{
	if([[notification.userInfo valueForKey:@"value"] isEqualToString:@"\"Running\""]) {
		NSLog(@"Running");
		[self saveRunningIsActive:notification];
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

-(void)saveRunningIsActive:(NSNotification*)notification
{
	[self saveContextBecameActive:@"running" fromNotification:notification];
}

-(void)saveContextBecameActive:(NSString*)context fromNotification:(NSNotification*)notification
{
	NSDate* date = [NSDate dateWithTimeIntervalSince1970:[[notification.userInfo valueForKey:@"date"] doubleValue]];
	[self.contextTimeStamps setValue:date forKey:context];
	//[self.codeViewController contextBecameActive:context];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"contextActive" object:self userInfo:@{@"context": context}];
}

-(BOOL)observesActivity:(NSNotification*)notification
{
	return _.any(self.implementedContexts, ^BOOL (NSString *context) {
		return [self.observedContexts containsObject:context];
	});
}

-(BOOL)containsActivityData:(NSNotification*)notification
{
	return [notification.object isEqualToString: [[Factory sharedFactory].activityModule name]];
}

-(BOOL)containsStepCountData:(NSNotification*)notification
{
	return [notification.object isEqualToString: [[Factory sharedFactory].stepCounterModule name]];
}

-(void)registerCodeViewController:(MGCodeViewController *)codeViewController
{
	self.codeViewController = codeViewController;
}


#pragma mark - constants

-(double)minWalkingStepsPerMinute {return 40.0;}
-(double)activityTimeOut {return 7;}	// seconds

@end
