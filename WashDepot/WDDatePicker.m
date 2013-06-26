//
//  WDDatePicker.m
//  WashDepot
//
//  Created by Vova Musiienko on 25.06.13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import "WDDatePicker.h"

@interface WDDatePicker () {
    
IBOutlet UIDatePicker* picker;

}

- (IBAction) closeTapped:(id)sender;

@end

@implementation WDDatePicker

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
    // Do any additional setup after loading the view from its nib.
}


- (IBAction) closeTapped:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
    [self.delegate newDatePicked:[picker date]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
