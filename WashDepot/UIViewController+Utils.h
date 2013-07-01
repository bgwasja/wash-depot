//
//  UIViewController+Utils.h
//  WashDepot
//
//  Created by Vova Musiienko on 21.06.13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Utils)

- (UIBarButtonItem*) navBarButtonWithTitle:(NSString*) title selector:(SEL)s;
- (void) userLogout;


@end
