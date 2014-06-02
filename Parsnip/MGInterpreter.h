//
//  MGInterpreter.h
//  Parsnip
//
//  Created by Willi Müller on 26.04.14.
//  Copyright (c) 2014 UFMG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGSensorInput.h"

@interface MGInterpreter : NSObject

-(void)observeContext:(MGSensorInput*)context;
-(void)observeSensor:(MGSensorInput*)sensor;
-(void)unObserveSensor:(MGSensorInput*)sensor;

@end
