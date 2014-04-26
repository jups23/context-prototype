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
@property NSString *cursorSymbol;

@end

@implementation MGTokenStoreTestCase

- (void)setUp
{
    [super setUp];
	self.store = [[MGTokenStore alloc] init];
}

- (void)tearDown
{
	// insert code here
    [super tearDown];
}

- (void)testInsertCodeInEmptyProgram
{
	[self.store insertToken:@"token1"];
	XCTAssertTrue([@"token1;◄" isEqualToString:[self.store tokenText]]);
}

-(void)testInsertCodeInNonEmptyProgram
{
	[self.store insertToken:@"token1"];
	[self.store insertToken:@"token2"];
	XCTAssertTrue([@"token1;token2;◄" isEqualToString:[self.store tokenText]]);
}

-(void)testInsertTokenBeforeOtherToken
{
	[self.store insertToken:@"token1"];
	[self.store moveCursorLeft];
	[self.store insertToken:@"token2"];
	XCTAssertTrue([@"token2;◄;token1" isEqualToString:[self.store tokenText]]);
}

-(void)testCannotInsertCodeWithSpaceAfterLastToken
{
	[self.store insertToken:@"test1"];
	[self.store moveCursorRight];
	[self.store moveCursorRight];
	[self.store insertToken:@"test2"];
	NSLog(@"%@", [self.store tokenText]);
	XCTAssertTrue([[self.store tokenText] isEqualToString:@"test1;test2;◄"]);
}

-(void)testCannotInsertCodeAtNegativeCursorPosition
{
	[self.store insertToken:@"test1"];
	[self.store moveCursorLeft];
	[self.store moveCursorLeft];
	[self.store insertToken:@"test2"];
	XCTAssertTrue([@"test2;◄;test1" isEqualToString:[self.store tokenText]]);
}

-(void)testTokenCountOfEmptyTokenStoreCountsOnlyCursor
{
	XCTAssertEqual(1, [self.store tokenCount]);
}

-(void)testTokenCountOfNonEmptyTokenStore
{
	[self.store insertToken:@"test1"];
	XCTAssertEqual(2, [self.store tokenCount]);
}

-(void)testDoesNotDeleteWhenNoTokenLeftToCursor
{
	int count = [self.store tokenCount];
	[self.store deleteToken];
	XCTAssertEqual(count, [self.store tokenCount]);
	XCTAssertTrue([@"◄" isEqualToString: [self.store tokenText]]);
}

-(void)testDeletesTokenLeftToCursor
{
	[self.store insertToken:@"token1"];
	int count = [self.store tokenCount];
	[self.store deleteToken];
	XCTAssertEqual(count-1, [self.store tokenCount]);
	XCTAssertTrue([@"◄" isEqualToString: [self.store tokenText]]);
}

@end
