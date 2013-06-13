//
//  WDLoadingVC.h
//  WashDepot
//
//  Created by Vova Musiienko on 12.06.13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDLoadingVC : UIViewController

+ (WDLoadingVC*) sharedLoadingVC;
- (void) showInController:(UIViewController*) c withText:(NSString*) text;
- (void) hide;

@end
