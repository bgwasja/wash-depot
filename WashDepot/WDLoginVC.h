//
//  WDLoginVC.h
//  WashDepot
//
//  Created by Balazh Vasyl on 6/10/13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDLoginVC : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *loginTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)submitTapped:(id)sender;

@end
