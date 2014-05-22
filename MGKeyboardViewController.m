//
//  MGKeyboardViewController.m
//  Parsnip
//
//  Created by Willi Müller on 11.04.14.
//  Copyright (c) 2014 UFMG. All rights reserved.
//

#import "MGKeyboardViewController.h"
#import "MGCodeViewController.h"

@interface MGKeyboardViewController ()

@property NSArray* keyConfig;
@property MGCodeViewController* codeVC;

@end

@implementation MGKeyboardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	//TODO move to model
	self.keyConfig = @[
		@{@"text": @"walking", @"isToken": @YES},    @{@"text": @"in hand", @"isToken": @YES}, @{@"text": @"motion", @"isToken": @YES},    @{@"text": @"delete", @"isToken": @NO},
		@{@"text": @"cycling", @"isToken": @YES},    @{@"text": @"on body", @"isToken": @YES}, @{@"text": @"mic", @"isToken": @YES},    @{@"text": @"undo", @"isToken": @NO},
		@{@"text": @"running", @"isToken": @YES},    @{@"text": @"falling", @"isToken": @YES}, @{@"text": @"proximity", @"isToken": @YES},      @{@"text": @"redo", @"isToken": @NO},
		@{@"text": @"idle", @"isToken": @YES}, @{@"text": @"--", @"isToken": @NO},       @{@"text": @"backwards", @"isToken": @NO}, @{@"text": @"forwards", @"isToken": @NO}
		];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DataSource

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.keyConfig.count;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	// identifier and tag set in Storyboard
	static NSString *identifier = @"Cell";
	static NSInteger imageViewTag = 100;
	
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
	UIButton *button = (UIButton *) [cell viewWithTag:imageViewTag];
	[button setTitle: [[self.keyConfig objectAtIndex:indexPath.row] objectForKey:@"text"] forState:UIControlStateNormal];
	return cell;
}

#pragma mark - Communication with CodeViewController

- (void)registerCodeViewController:(MGCodeViewController *)codeVC
{
	self.codeVC = codeVC;
}

- (IBAction)keyUp:(UIButton *)sender
{
	NSString *buttonText = sender.currentTitle;
	[self notifyCodeViewIfCursorMovement:buttonText];
	[self notifyCodeViewIfDeleteKey:buttonText];
	
	// TODO make button text the lookup key, this is stupid!
	for (NSDictionary *conf in self.keyConfig) {
		if([[conf objectForKey:@"text"] isEqualToString:buttonText] && ([[conf objectForKey:@"isToken"] isEqual:@YES])) {
			[self.codeVC insertToken:[sender currentTitle]];
			break;
		}
	}
}

-(void)notifyCodeViewIfCursorMovement:(NSString *)buttonText
{
	if ([buttonText isEqualToString:@"forwards"])
		[self.codeVC moveCursorRight];
	else
		if ([buttonText isEqualToString:@"backwards"])
			[self.codeVC moveCursorLeft];
}

-(void)notifyCodeViewIfDeleteKey:(NSString *)buttonText
{
	if([buttonText isEqualToString:@"delete"])
		[self.codeVC deleteToken];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
