//
//  MGInterpreter.h
//  Parsnip
//
//  Created by Willi Müller on 26.04.14.
//  Copyright (c) 2014 UFMG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGCodeViewController.h"

@interface MGInterpreter : NSObject

-(void)observeContext:(NSString*)context;
-(void)observeSensor:(NSString*)context;

-(void)registerCodeViewController:(MGCodeViewController *)codeViewController;

@end
