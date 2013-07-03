//
//  WDPickerVC.h
//  WashDepot
//
//  Created by Vova Musiienko on 24.06.13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import <UIKit/UIKit.h>

enum WD_PIKER_TYPE{
    WDPiker=0,
    WDFilterPiker
};

@protocol WDPickerVCDelegate <NSObject>

- (void) newElementPicked:(NSString*) newElement;

@end


@interface WDPickerVC : UIViewController

@property (strong, nonatomic) NSArray* elements;
@property (strong, nonatomic) id defaultElement;
@property (strong, nonatomic) id <WDPickerVCDelegate> delegate;
@property (nonatomic) enum WD_PIKER_TYPE type;

@end
