//
//  MGTokenList.h
//  Parsnip
//
//  Created by Willi Müller on 25.04.14.
//  Copyright (c) 2014 UFMG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGTokenStore : NSObject

-(void)insertToken:(NSString*) token;
-(void)deleteToken;
-(void)moveCursorRight;
-(void)moveCursorLeft;

-(NSString *)tokenText;
-(NSInteger)tokenCount;
-(NSString *)tokenAtIndex:(NSInteger) index;
-(NSString *)tokenAtCursor;

@end
