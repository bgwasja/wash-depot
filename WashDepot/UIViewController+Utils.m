//
//  UIViewController+Utils.m
//  WashDepot
//
//  Created by Vova Musiienko on 21.06.13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import "UIViewController+Utils.h"
#import "WDAPIClient.h"


@implementation UIViewController (Utils)

- (UIBarButtonItem*) navBarButtonWithTitle:(NSString*) title selector:(SEL)s {
    UIImage *backButtonImage = [[UIImage imageNamed:@"but_header"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(22, 12, 22, 12)];
    UIButton* _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    _backButton.adjustsImageWhenHighlighted = NO;
    [_backButton setTitleColor:[UIColor colorWithRed:128/255.0 green:130/255.0 blue:133/255.0 alpha:1] forState:UIControlStateHighlighted];
    [_backButton setFrame:CGRectMake(0, 0, 50, 27)];
    _backButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_backButton setTitle:title forState:UIControlStateNormal];
    [_backButton addTarget:self action:s forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:_backButton];
}


- (void) userLogout {
    NSError *error = nil;
    NSString* a_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"a_token"];
    //If no error we send the post, voila!
    if (!error){
        AFHTTPClient *client = [WDAPIClient sharedClient];//[AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://wash-depot.herokuapp.com/"]];
        NSString *path = [NSString stringWithFormat:@"api/sessions/?auth_token=%@", a_token];
        NSMutableURLRequest *request = [client requestWithMethod:@"DELETE" path:path parameters:nil];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            

        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSString* errMsg = nil;
            if (JSON != nil) {
                errMsg = [JSON  objectForKey:@"info"];
            } else {
                errMsg = [error localizedDescription];
            }
            NSLog(@"Logout failed: %@", errMsg);
        }];
        
        [operation start];
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"a_token"];
}


@end
