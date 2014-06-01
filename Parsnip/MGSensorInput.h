//
//  MGSensorInput.h
//  Parsnip
//
//  Created by Willi Müller on 29.05.14.
//  Copyright (c) 2014 UFMG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGSensorInput : NSObject

@property BOOL isObserved;
@property NSString* name;
@property NSString* url;
@property NSString* section;
@property BOOL isContext;

-(id)initWithName: (NSString*)name url:(NSString*)url isObserved:(BOOL)isObserved isContext:(BOOL)isContext section:(NSString*)section;

@end
