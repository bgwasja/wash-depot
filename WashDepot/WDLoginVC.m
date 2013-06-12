//
//  WDLoginVC.m
//  WashDepot
//
//  Created by Balazh Vasyl on 6/10/13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import "WDLoginVC.h"
#import <RestKit/RestKit.h>
#import <QuartzCore/QuartzCore.h>

@interface WDLoginVC ()

@end

@implementation WDLoginVC
@synthesize loginTextField, passwordTextField;

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
    UIImage *textFieldBackground = [[UIImage imageNamed:@"text_input"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
    loginTextField.background = textFieldBackground;
    passwordTextField.background = textFieldBackground;
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.view.backgroundColor = background;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitTapped:(id)sender {

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:loginTextField.text/*@"suser@washdepot.com"*/ forKey:@"email"];
    [params setObject:passwordTextField.text/*@"suser123"*/ forKey:@"password"];
    NSMutableDictionary *userDic = [[NSMutableDictionary alloc] init];
    [userDic setObject:params forKey:@"user"];
    
    //Parsing to JSON!
    NSError *error = nil;
    NSData *json = [NSJSONSerialization dataWithJSONObject:userDic options:0 error:&error];
    //NSString* s = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    
    //If no error we send the post, voila!
    if (!error){
        AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://wash-depot.herokuapp.com/"]];
        NSString *path = [NSString stringWithFormat:@"api/users/sign_in"];
        NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:path parameters:nil];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:json];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"LOGIN" message:@"Login success" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [av show];

        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"LOGIN" message:@"Login error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [av show];
        }];
        
        [operation start];
    }
}




@end
