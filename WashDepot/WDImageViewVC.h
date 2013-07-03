//
//  WDImageViewVC.h
//  WashDepot
//
//  Created by Vova Musiienko on 03.07.13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDImageViewVC : UIViewController <UIScrollViewDelegate>

@property (nonatomic, retain) NSString* base64Image;

@property (nonatomic, retain) IBOutlet UIScrollView *imageScrollView;
@property (nonatomic, retain) UIImageView* imageView;


- (IBAction) closeTapped;

@end
