//
//  WDPickerVC.m
//  WashDepot
//
//  Created by Vova Musiienko on 24.06.13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import "WDPickerVC.h"

@interface WDPickerVC () {
}

- (IBAction) closeTapped:(id)sender;
@property (nonatomic, strong) id currentElement;

@end

@implementation WDPickerVC

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

    int rowIndex = 0;
    

    for (int i = 0; i < [self.elements count]; i++) {
        if ([self.defaultElement isEqualToString:[self.elements objectAtIndex:i]]) {
            rowIndex = i;
            break;
        }
    }
    
    [_picker selectRow:rowIndex inComponent:0 animated:NO];
}


- (IBAction) closeTapped:(id)sender {
    
    if(_type == WDFilterPiker){
        [self.delegate markFilterHidden];
    }

//    [self dismissModalViewControllerAnimated:YES];
    [UIView animateWithDuration:.2 animations:^{
        CGRect newFrame = self.view.frame;
        newFrame.origin.y = 200;
        self.view.frame =newFrame;
        self.view.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
    

}


#pragma mark -
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [self.elements count];
}


- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [self.elements objectAtIndex:row];
}


#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    self.currentElement = [self.elements objectAtIndex:row];
    
    
//    if (!self.currentElement) {
//        self.currentElement = self.defaultElement;
//    }
    if(_type == WDPiker){
        [self.delegate newElementPicked:self.currentElement];
    }else{
        int newFilterOption = [self.elements indexOfObject:self.currentElement];
        [[NSUserDefaults standardUserDefaults] setObject:@(newFilterOption) forKey:@"filter_option"];
    }
    [self.delegate reloadData];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
