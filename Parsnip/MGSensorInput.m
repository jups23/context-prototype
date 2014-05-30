//
//  MGSensorInput.m
//  Parsnip
//
//  Created by Willi Müller on 29.05.14.
//  Copyright (c) 2014 UFMG. All rights reserved.
//

#import "MGSensorInput.h"

@implementation MGSensorInput

-(id)initWithName: (NSString*)name url:(NSString*)url isObserved:(BOOL) isObserved section:(NSString*)section
{
	self = [super init];
	if(self) {
		self.name = name;
		self.url = url;
		self.isObserved = isObserved;
		self.section = section;
	}
	return self;
}
@end
