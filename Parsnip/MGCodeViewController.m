//
//  MGCodeViewController.m
//  Parsnip
//
//  Created by Willi Müller on 13.04.14.
//  Copyright (c) 2014 UFMG. All rights reserved.
//

#import "MGCodeViewController.h"

@interface MGCodeViewController ()

@property NSMutableArray* tokens;
@property NSInteger cursorPosition;

@end

@implementation MGCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.tokens = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)insertCode:(NSString *)token
{
	[self.tokens insertObject:token atIndex:self.cursorPosition];
	[self reloadCodeWithoutAnimation];
	self.cursorPosition++;
}

-(void)reloadCodeWithoutAnimation
{
	BOOL animationsEnabled = [UIView areAnimationsEnabled];
	[UIView setAnimationsEnabled:NO];
	[self.collectionView reloadData]; // TODO optimization: for cell only
	[UIView setAnimationsEnabled:animationsEnabled];
}

-(void)moveCursorLeft
{
	if((self.cursorPosition == self.tokens.count) && [self.tokens.lastObject isEqualToString:@""])
		// make shure there only exist placeholders tokens and between cursor and last token position
		// prevents memory leaking when placeholders are piling up at the end of self.tokens
		[self.tokens removeLastObject];
	if (self.cursorPosition > 0)
		self.cursorPosition--;
}

-(void)moveCursorRight
{
	if(self.cursorPosition < self.tokens.count) {
		self.cursorPosition++;
	} else {
		if (self.cursorPosition == self.tokens.count) {
			[self.tokens addObject:@""];
			self.cursorPosition++;
		}
	}
}

-(void)deleteToken
{
	if ([self hasTokenAtCursorPosition]) {
		if (self.cursorPosition > 0) {
			self.cursorPosition--;
		}
			[self.tokens removeObjectAtIndex:(self.cursorPosition)];
			[self reloadCodeWithoutAnimation];
	}
}


-(BOOL)hasTokenAtCursorPosition
{
	return [self.tokens count] > 0 && self.cursorPosition > 0;
}

#pragma mark - DataSource

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return [self.tokens count];
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	// set in Storyboard
	static NSString *identifier = @"Cell";
	static NSInteger buttonViewTag = 100;
	
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
	UIButton *button = (UIButton *) [cell viewWithTag:buttonViewTag];
	[button setTitle: [self.tokens objectAtIndex:indexPath.item] forState:UIControlStateNormal];
	return cell;
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