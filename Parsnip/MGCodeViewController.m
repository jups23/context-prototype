//
//  MGCodeViewController.m
//  Parsnip
//
//  Created by Willi Müller on 13.04.14.
//  Copyright (c) 2014 UFMG. All rights reserved.
//

#import "MGCodeViewController.h"

@interface MGCodeViewController ()

@property NSArray* keyTexts;

@end

@implementation MGCodeViewController

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
	self.keyTexts = @[
					  @"walking",     @"falling",     @"placeholder", @"delete",
					  @"placeholder", @"placeholder", @"placeholder", @"undo",
					  @"placeholder", @"placeholder", @"placeholder", @"redo",
					  @"placeholder", @"placeholder", @"backwards",   @"forwards",
					  ];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return 16;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	// set in Storyboard
	static NSString *identifier = @"Cell";
	static NSInteger imageViewTag = 100;
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
	UIButton *button = (UIButton *) [cell viewWithTag:imageViewTag];
	[button setTitle: [self.keyTexts objectAtIndex:indexPath.row] forState:UIControlStateNormal];
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
