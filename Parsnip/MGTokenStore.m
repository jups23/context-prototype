//
//  MGTokenList.m
//  Parsnip
//
//  Created by Willi Müller on 25.04.14.
//  Copyright (c) 2014 UFMG. All rights reserved.
//

#import "MGTokenStore.h"
#import "Underscore.h"

#define _ Underscore

@interface MGTokenStore ()

@property NSMutableArray* tokens;
@property NSInteger cursorPosition;
@property NSString* cursorString;

@end

@implementation MGTokenStore

-(id)init
{
	self = [super init];
	if(self) {
		self.cursorPosition = 0;
		self.cursorString = @"◄";
		self.tokens = [[NSMutableArray alloc] init];
		[self.tokens insertObject:self.cursorString atIndex:0];
	}
	return self;
}

-(void)moveCursorRight
{
	if(self.cursorPosition < [self.tokens count] && ![self cursorAtEnd]) {
		[self.tokens removeObjectAtIndex:self.cursorPosition];
		self.cursorPosition++;
		[self.tokens insertObject:self.cursorString atIndex:self.cursorPosition];
	}
}

-(void)moveCursorLeft
{
	if(self.cursorPosition>0 && ![self cursorAtFront]) {
		[self.tokens removeObjectAtIndex:self.cursorPosition];
		self.cursorPosition--;
		[self.tokens insertObject:self.cursorString atIndex:self.cursorPosition];
	}
}

-(void)insertToken:(NSString *) token
{
	[self.tokens removeObjectAtIndex:self.cursorPosition];
	[self.tokens insertObject:token atIndex:self.cursorPosition];
	self.cursorPosition++;
	[self.tokens insertObject:self.cursorString atIndex:self.cursorPosition];
}

-(void)deleteToken
{
	if (![self cursorAtFront]) {
		// remove cursor
		[self.tokens removeObjectAtIndex:self.cursorPosition];
		self.cursorPosition--;
		//remove item before cursor
		[self.tokens removeObjectAtIndex:self.cursorPosition];
		//insert cursor
		[self.tokens insertObject:self.cursorString atIndex:self.cursorPosition];
	}
}

-(NSString *)tokenText
{
	return [self.tokens componentsJoinedByString:@";"];
}

-(NSInteger)tokenCount
{
	return [self.tokens count];
}

-(NSString*)tokenAtIndex:(NSInteger)index
{
	return [self.tokens objectAtIndex:index];
}

-(NSIndexSet*)indexesOfToken:(NSString *)token
{
	return [self.tokens indexesOfObjectsPassingTest:^BOOL(id object, NSUInteger index, BOOL *stop) {
		return [[self.tokens objectAtIndex:index] isEqualToString:token];
	}];
}

-(BOOL)cursorAtFront
{
	return [_.first(self.tokens) isEqualToString:self.cursorString];
}

-(BOOL)cursorAtEnd
{
	return [_.last(self.tokens) isEqualToString: self.cursorString];
}

@end
