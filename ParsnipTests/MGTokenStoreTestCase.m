//
//  MGCodeViewControllerTestCase.m
//  Parsnip
//
//  Created by Willi Müller on 25.04.14.
//  Copyright (c) 2014 UFMG. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MGTokenStore.h"

@interface MGTokenStoreTestCase : XCTestCase

@property MGTokenStore *store;
@property NSString *code;

@end

@implementation MGTokenStoreTestCase

- (void)setUp
{
    [super setUp];
	self.store = [[MGTokenStore alloc] init];
	self.code = @"Test";
}

- (void)tearDown
{
	// insert code here
    [super tearDown];
}

- (void)testInsertCodeInEmptyProgram
{
	[self.store insertToken:self.code];
	XCTAssertTrue([self.code isEqualToString:[self.store getTokenText]]);
}

-(void)testInsertCodeInNonEmptyProgram
{
	[self.store insertToken:@"token1"];
	[self.store insertToken:@"token2"];
	XCTAssertTrue([@"token1;token2" isEqualToString:[self.store getTokenText]]);
}

@end
