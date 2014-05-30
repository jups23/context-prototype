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
@property (weak, nonatomic) IBOutlet UISwitch *isObservedToggle;
@property (weak, nonatomic) IBOutlet UIPickerView *conditionPicker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@end

@implementation MGInputDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// catch keyboard events
	self.urlTextField.delegate = self;
	
	self.title = self.inputItem.name;
	self.urlTextField.text = self.inputItem.url;
	[self.isObservedToggle setOn:self.inputItem.isObserved];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)isObservedSwitchChanged:(id)sender
{
	// even if Cancel will be pressed, this state will be changed
	self.inputItem.isObserved = [sender isOn];
}

#pragma mark Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if(sender != self.doneButton) return;
	// user pressed Done without closing the keyboard
	self.inputItem.url = self.urlTextField.text;
}


#pragma mark Text Field
-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
	[textField resignFirstResponder];
	self.inputItem.url = self.urlTextField.text;
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
