//
//  UIViewController+Utils.m
//  WashDepot
//
//  Created by Vova Musiienko on 21.06.13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import "UIViewController+Utils.h"

@implementation UIViewController (Utils)

- (UIBarButtonItem*) navBarButtonWithTitle:(NSString*) title selector:(SEL)s {
    UIImage *backButtonImage = [[UIImage imageNamed:@"but_header"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(22, 12, 22, 12)];
    UIButton* _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    [_backButton setFrame:CGRectMake(0, 0, 50, 27)];
    _backButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_backButton setTitle:title forState:UIControlStateNormal];
    [_backButton addTarget:self action:s forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:_backButton];
}

@end
