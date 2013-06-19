//
//  WDLoginVC.m
//  WashDepot
//
//  Created by Balazh Vasyl on 6/10/13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import "WDLoginVC.h"
#import "WDLoadingVC.h"
//#import <AFNetworking/AFNetworking.h>
#import "WDAPIClient.h"

@interface WDLoginVC ()

@property (strong, nonatomic) WDLoadingVC* loadingVC;

@end

@implementation WDLoginVC

@synthesize loginTextField, passwordTextField, loginButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customizeTextFields];
    [self customizeButton];
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


-(void) customizeButton {
    UIImage *buttonBackground = [[UIImage imageNamed:@"but_blue"]
                                    resizableImageWithCapInsets:UIEdgeInsetsMake(0, 32, 0, 100)];
    [loginButton setBackgroundImage:buttonBackground forState:UIControlStateNormal];
    [loginButton setBackgroundImage:buttonBackground forState:UIControlStateHighlighted];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)submitTapped:(id)sender {

    //request: "{\"user\":{\"email\":\"john.carney@washdepot.com\",\"password\":\"123456789\"}}
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:/*loginTextField.text*/@"john.carney@washdepot.com" forKey:@"email"];
    [params setObject:/*passwordTextField.text*/@"123456789" forKey:@"password"];
    NSMutableDictionary *userDic = [[NSMutableDictionary alloc] init];
    [userDic setObject:params forKey:@"user"];
    
    //Parsing to JSON!
    NSError *error = nil;
    NSData *json = [NSJSONSerialization dataWithJSONObject:userDic options:0 error:&error];
    //NSString* s = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    
    //If no error we send the post, voila!
    if (!error){
        [[WDLoadingVC sharedLoadingVC] showInController:self withText:@"Checking creditentals..."];
        
        AFHTTPClient *client = [WDAPIClient sharedClient];//[AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://wash-depot.herokuapp.com/"]];
        NSString *path = [NSString stringWithFormat:@"api/users/sign_in"];
        NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:path parameters:nil];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:json];
        [request setHTTPShouldHandleCookies:YES];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            NSString* atoken = [[JSON objectForKey:@"data"] objectForKey:@"auth_token"];
            [[NSUserDefaults standardUserDefaults] setValue:atoken forKey:@"a_token"];
            
            UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"LOGIN" message:@"Login success" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [av show];
            [[WDLoadingVC sharedLoadingVC] hide];
            [self dismissModalViewControllerAnimated:YES];
        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSString* errMsg = nil;
            if (JSON != nil) {
                errMsg = [JSON  objectForKey:@"info"];
            } else {
                errMsg = [error localizedDescription];
            }
            UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"LOGIN" message:[NSString stringWithFormat:@"Login unsuccessful: %@", errMsg] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [av show];
            [[WDLoadingVC sharedLoadingVC] hide];
        }];
        
        [operation start];
    }
}


#pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}


- (void)viewDidUnload {
    [self setLoginButton:nil];
    [super viewDidUnload];
}
@end
