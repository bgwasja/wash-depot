//
//  WDPageControl.h
//
//  Created by Eugene on 08.01.13.
//

#import <UIKit/UIKit.h>

@interface WDPageControl : UIPageControl{
    UIImage* mImageNormal;
    UIImage* mImageCurrent;
}

@property (nonatomic, readwrite, retain) UIImage* imageNormal;
@property (nonatomic, readwrite, retain) UIImage* imageCurrent;

@end