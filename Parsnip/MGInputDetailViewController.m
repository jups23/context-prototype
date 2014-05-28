//
//  MGInputDetailViewController.m
//  Parsnip
//
//  Created by Willi Müller on 28.05.14.
//  Copyright (c) 2014 UFMG. All rights reserved.
//

#import "MGInputDetailViewController.h"

@interface MGInputDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *conditionPicker;

@end

@implementation MGInputDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Text Field
-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
	[textField resignFirstResponder];
	return YES;
}

#pragma mark Picker View

-(int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return 0;
}

-(int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 0;
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
