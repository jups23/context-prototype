//
//  MGCodeViewController.m
//  Parsnip
//
//  Created by Willi Müller on 13.04.14.
//  Copyright (c) 2014 UFMG. All rights reserved.
//

#import "MGCodeViewController.h"
#import "MGTokenStore.h"
#import "MGInterpreter.h"


@interface MGCodeViewController ()

@property MGTokenStore* tokenStore;
@property MGInterpreter* interpreter;
@property NSMutableSet* activeContexts;
@property MGActionViewController* actionVC;

@end

@implementation MGCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.tokenStore = [[MGTokenStore alloc] init];
	self.interpreter = [[MGInterpreter alloc] init];
	self.activeContexts = [[NSMutableSet alloc] init];
	[self.interpreter registerCodeViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Keyboard
-(void)insertToken:(NSString *)token
{
	[self.tokenStore insertToken:token];
	if([token isEqualToString:@"motion"]) {
		[self.interpreter observeSensor: token];
	} else {
		[self.interpreter observeContext:token];
	}
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
	[self reloadCodeWithoutAnimation];
}

-(void)moveCursorRight
{
	[self.tokenStore moveCursorRight];
	[self reloadCodeWithoutAnimation];
}

-(void)deleteToken
{
	NSString* token = [self.tokenStore tokenAtCursor];
	if ([self isSensorToken:token]) {
		[self.interpreter unObserveSensor:token];
	}
	[self.tokenStore deleteToken];
	[self reloadCodeWithoutAnimation];
}

-(BOOL)isSensorToken:(NSString*)token
{
	return [@[@"motion", @"mic", @"proximity"] containsObject:token];
}

#pragma mark - Context Notification
-(void)contextBecameActive:(NSString *)context
{
	if([self hasNotBeenActive:context]) {
		[self.activeContexts addObject:context];
		dispatch_async(dispatch_get_main_queue(), ^{
			// does not work when called synchronously!!!
			[self.collectionView reloadData];
			[self.actionVC callSpecifiedAPIWithParameters:@{@"context":context, @"active":@YES}];
		});
	}
}

-(void)contextBecameInActive:(NSString *)context
{
	if ([self.activeContexts containsObject:context]) {
		[self.activeContexts removeObject:context];
		dispatch_async(dispatch_get_main_queue(), ^{
			// does not work when called synchronously!!!
			[self.collectionView reloadData];
			[self.actionVC callSpecifiedAPIWithParameters:@{@"context":context, @"active":@NO}];
		});
	}
}

- (BOOL)hasNotBeenActive:(NSString *)context
{
	return ![self.activeContexts containsObject:context];
}

#pragma mark - Communicate contexts to ActionView

- (void)registerActionViewController:(MGActionViewController *)actionView
{
	self.actionVC = actionView;
}

#pragma mark - DataSource
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return [self.tokenStore tokenCount];
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	// set in Storyboard
	NSString *identifier = @"Cell";
	NSInteger buttonViewTag = 100;
	NSString *title = [self.tokenStore tokenAtIndex:indexPath.item];
	
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
	UIButton *button = (UIButton *) [cell viewWithTag:buttonViewTag];
	[button setTitle: title forState:UIControlStateNormal];
	[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	
	if([self.activeContexts containsObject:title]) {
		[button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
	}
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