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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	//TODO move to model
	self.keyConfig = @[
		@{@"text": @"walking", @"isToken": @YES},    @{@"text": @"in hand", @"isToken": @YES}, @{@"text": @"enter", @"isToken": @YES},    @{@"text": @"delete", @"isToken": @NO},
		@{@"text": @"cycling", @"isToken": @YES},    @{@"text": @"on body", @"isToken": @YES}, @{@"text": @"leave", @"isToken": @YES},    @{@"text": @"undo", @"isToken": @NO},
		@{@"text": @"running", @"isToken": @YES},    @{@"text": @"falling", @"isToken": @YES}, @{@"text": @"top", @"isToken": @YES},      @{@"text": @"redo", @"isToken": @NO},
		@{@"text": @"sleep time", @"isToken": @YES}, @{@"text": @"--", @"isToken": @NO},       @{@"text": @"backwards", @"isToken": @NO}, @{@"text": @"forwards", @"isToken": @NO}
		];
					   
//		@"walking",     @"in hand", @"enter",    @"delete",
//		@"cycling",     @"on body", @"leave",    @"undo",
//		@"running",     @"falling", @"top",      @"redo",
//		@"sleep time",  @"--",      @"backwards",@"forwards",
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.keyConfig.count;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	// set in Storyboard
	static NSString *identifier = @"Cell";
	static NSInteger imageViewTag = 100;
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
	UIButton *button = (UIButton *) [cell viewWithTag:imageViewTag];
	[button setTitle: [[self.keyConfig objectAtIndex:indexPath.row] objectForKey:@"text"] forState:UIControlStateNormal];
	return cell;
}

- (void)registerCodeViewController:(MGCodeViewController *)codeVC
{
	self.codeVC = codeVC;
}

- (IBAction)keyUp:(UIButton *)sender
{
	NSString *buttonText = sender.currentTitle;
	if ([buttonText isEqualToString:@"forwards"]) {
		[self.codeVC moveCursorRight];
	}
	if ([buttonText isEqualToString:@"backwards"]) {
		[self.codeVC moveCursorLeft];
	}
	for (NSDictionary *conf in self.keyConfig) {
		if([[conf objectForKey:@"text"] isEqualToString:buttonText] && ([[conf objectForKey:@"isToken"] isEqual:@YES])) {
			[self.codeVC insertCode:[sender currentTitle]];
			break;
		}
	}
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
