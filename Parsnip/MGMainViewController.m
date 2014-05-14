//
//  MGViewController.m
//  Parsnip
//
//  Created by Willi Müller on 11.04.14.
//  Copyright (c) 2014 UFMG. All rights reserved.
//

#import "MGMainViewController.h"
#import "MGCodeViewController.h"
#import "MGKeyboardViewController.h"

@interface MGMainViewController ()

@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIView *keyboardView;
@property (weak, nonatomic) IBOutlet UIView *actionView;
@property MGCodeViewController *codeVC;
@property MGKeyboardViewController *keyboardVC;
@property MGActionViewController *actionVC;

@end

@implementation MGMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.keyboardVC registerCodeViewController:self.codeVC];
	[self.codeVC registerActionViewController:self.actionVC];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if([segue.identifier isEqualToString:@"codeViewController"]) {
		self.codeVC = [segue destinationViewController];
	}
	if ([segue.identifier isEqualToString:@"keyboardViewController"]) {
		self.keyboardVC = [segue destinationViewController];
	}
	if ([segue.identifier isEqualToString:@"actionViewController"]) {
		self.actionVC = [segue destinationViewController];
	}
}

@end
