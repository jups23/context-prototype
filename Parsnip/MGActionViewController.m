//
//  MGActionViewController.m
//  Parsnip
//
//  Created by Willi Müller on 12.05.14.
//  Copyright (c) 2014 UFMG. All rights reserved.
//

#import "MGActionViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface MGActionViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation MGActionViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self callSpecifiedAPIWithParameters:@{@"started": @YES}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - HTTP request

// TODO with sensor data as PARAMETERS
- (void)callSpecifiedAPIWithParameters:(NSDictionary *)parameterDictionary
{
	NSString *url = self.textField.text;
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	[manager POST:url parameters:parameterDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
		//NSLog(@"%@", responseObject);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			NSLog(@"%@", error);
	}];
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
