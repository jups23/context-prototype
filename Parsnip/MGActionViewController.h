//
//  MGActionViewController.h
//  Parsnip
//
//  Created by Willi Müller on 12.05.14.
//  Copyright (c) 2014 UFMG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGActionViewController : UIViewController <NSURLConnectionDataDelegate>

-(void)callSpecifiedAPIWithParameters:(NSDictionary*)parameterDictionary;

@end
