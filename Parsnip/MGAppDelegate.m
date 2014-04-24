//
//  MGAppDelegate.m
//  Parsnip
//
//  Created by Willi Müller on 28.03.14.
//  Copyright (c) 2014 UFMG. All rights reserved.
//

#import <SensePlatform/CSSensePlatform.h>
#import <SensePlatform/CSSettings.h>
#import "Factory.h"


#import "MGAppDelegate.h"

@implementation MGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
//	[CSSensePlatform initialize];
//	NSArray *sensors = [CSSensePlatform availableSensors];
//	
//	//Modules expect 50Hz sample rate, 3 a duration of three seconds works quite well for activity detection and step counting
//    [[CSSettings sharedSettings] setSettingType:kCSSettingTypeSpatial setting:kCSSpatialSettingFrequency value:@"50"];
//    [[CSSettings sharedSettings] setSettingType:kCSSettingTypeSpatial setting:kCSSpatialSettingNrSamples value:@"150"];
//    [[CSSettings sharedSettings] setSensor:kCSSENSOR_ACCELEROMETER enabled:YES];
//    
//    //acceleration is used by the Activity and stepcounter module
//    [[CSSettings sharedSettings] setSensor:kCSSENSOR_ACCELERATION enabled:YES];
//    [[CSSettings sharedSettings] setSensor:kCSSENSOR_ACCELERATION_BURST enabled:YES];
//	
//	[Factory sharedFactory];
	return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//	[CSSensePlatform willTerminate];
}

@end
