//
//  WDRegularVCiPad.m
//  WashDepot
//
//  Created by Eugene on 16.07.13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import "WDRegularVCiPad.h"
#import "WDReportPhotosVC.h"
#import "WDReportVC.h"


@interface WDRegularVCiPad ()

@end

@implementation WDRegularVCiPad

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
	// Do any additional setup after loading the view.
    
    if (self.storyboard) {
        _reportPhotoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WDReportPhotosVC"];
        _reportVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WDReportVC"];
    }
    
    [self addChildViewController:_reportVC];
    _reportVC.view.frame = self.leftContainerView.frame;
    [self.leftContainerView addSubview:_reportVC.view];
    
    CGRect reportPhotoFrame = self.rightContainerView.frame;
    reportPhotoFrame.origin.x = 0;
    _reportPhotoVC.view.frame = reportPhotoFrame;
    [self addChildViewController:_reportPhotoVC];
    [self.rightContainerView addSubview:_reportPhotoVC.view];
    
}


#pragma mark - rotation

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return USING_IPAD?UIInterfaceOrientationIsLandscape(toInterfaceOrientation):UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLeftContainerView:nil];
    [self setRightContainerView:nil];
    [super viewDidUnload];
}
@end
