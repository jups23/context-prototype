//
//  MGInputDetailViewController.m
//  Parsnip
//
//  Created by Willi Müller on 28.05.14.
//  Copyright (c) 2014 UFMG. All rights reserved.
//

#import "MGInputDetailViewController.h"
#import "MGInputTableViewController.h"

@interface MGInputDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *conditionPicker;

@end

@implementation MGInputDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.urlTextField.text = [self.inputItem valueForKey:@"url"];
	self.title = [self.inputItem valueForKey:@"name"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setDetailItem:(NSDictionary *)detail
{
	self.inputItem = [NSMutableDictionary dictionaryWithDictionary: detail];
	self.urlTextField.text = [self.inputItem valueForKey:@"url"];
}


#pragma mark Text Field
-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
	[textField resignFirstResponder];
	[self.inputItem setValue:self.urlTextField.text forKey:@"url"];
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


@end
