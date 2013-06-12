//
//  WDLoginVC.m
//  WashDepot
//
//  Created by Balazh Vasyl on 6/10/13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import "WDLoginVC.h"

@interface WDLoginVC ()

@end

@implementation WDLoginVC
@synthesize loginTextField, passwordTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customizeTextFields];
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.view.backgroundColor = background;
}


- (void) customizeTextFields {
    UIImage *textFieldBackground = [[UIImage imageNamed:@"text_input"]
                                    resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    loginTextField.leftView = paddingView;
    loginTextField.leftViewMode = UITextFieldViewModeAlways;
    loginTextField.background = textFieldBackground;
    paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    passwordTextField.leftView = paddingView;
    passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    passwordTextField.background = textFieldBackground;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)submitTapped:(id)sender {
    
}


#pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}


@end
