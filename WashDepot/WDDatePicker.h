//
//  WDDatePicker.h
//  WashDepot
//
//  Created by Vova Musiienko on 25.06.13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WDDatePickerDelegate <NSObject>

- (void) newDatePicked:(NSDate*) newDate;

@end


@interface WDDatePicker : UIViewController

@property (strong, nonatomic) id <WDDatePickerDelegate> delegate;

@end
