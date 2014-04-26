//
//  MGCodeViewController.m
//  Parsnip
//
//  Created by Willi Müller on 13.04.14.
//  Copyright (c) 2014 UFMG. All rights reserved.
//

#import "MGCodeViewController.h"
#import "MGTokenStore.h"


@interface MGCodeViewController ()

@property MGTokenStore* tokenStore;

@end

@implementation MGCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.tokenStore = [[MGTokenStore alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)insertToken:(NSString *)token
{
	[self.tokenStore insertToken:token];
	[self reloadCodeWithoutAnimation];
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
	[self.tokenStore moveCursorLeft];
	[self  reloadCodeWithoutAnimation];
}

-(void)moveCursorRight
{
	[self.tokenStore moveCursorRight];
	[self reloadCodeWithoutAnimation];
}

-(void)deleteToken
{

}


#pragma mark - DataSource

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return [self.tokenStore tokenCount];
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	// set in Storyboard
	static NSString *identifier = @"Cell";
	static NSInteger buttonViewTag = 100;
	
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
	UIButton *button = (UIButton *) [cell viewWithTag:buttonViewTag];
	[button setTitle: [self.tokenStore tokenAtIndex:indexPath.item] forState:UIControlStateNormal];
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