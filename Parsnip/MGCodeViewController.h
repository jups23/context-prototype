//
//  MGCodeViewController.h
//  Parsnip
//
//  Created by Willi Müller on 13.04.14.
//  Copyright (c) 2014 UFMG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGCodeViewController : UICollectionViewController

-(void)insertCode:(NSString *) token;
-(void)moveCursorLeft;
-(void)moveCursorRight;

@end
