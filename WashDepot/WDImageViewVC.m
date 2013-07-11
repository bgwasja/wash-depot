//
//  WDImageViewVC.m
//  WashDepot
//
//  Created by Vova Musiienko on 03.07.13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import "WDImageViewVC.h"
#import "NSData+Base64.h"
#import "TapDetectingImageView.h"
#import "WDLoadingVC.h"
#import <AFNetworking/AFImageRequestOperation.h>
#import "WDAPIClient.h"

#define ZOOM_STEP 2.0

@interface WDImageViewVC ()

@property (nonatomic, retain) UIImage* currentImage;

@end

@implementation WDImageViewVC

@synthesize imageURLString;
@synthesize imageView;
@synthesize imageScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (IBAction) closeTapped {
    [self dismissModalViewControllerAnimated:YES];
}


//- (void) setImageURLString:(NSString *)imageURLString {
//    
//}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[WDLoadingVC sharedLoadingVC] showInController:self withText:@"Loading image..."];

    AFImageRequestOperation* operation = [AFImageRequestOperation imageRequestOperationWithRequest:[[WDAPIClient sharedClient] requestWithMethod:@"GET" path:self.imageURLString parameters:nil] imageProcessingBlock:nil success:
                                          ^(NSURLRequest* r, NSHTTPURLResponse* res, UIImage* image){
                                              self.currentImage = image;
                                              [self initImageContainer];
                                              [[WDLoadingVC sharedLoadingVC] hide];
                                          } failure:^(NSURLRequest* r, NSHTTPURLResponse* res, NSError* error){
                                              UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"IMAGE VIEW" message:@"Can't load image." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                              [av show];
                                              [[WDLoadingVC sharedLoadingVC] hide];
                                          }];
    
    [operation start];
}


- (void) initImageContainer {
    //Setting up the scrollView
    imageScrollView.bouncesZoom = YES;
    imageScrollView.delegate = self;
    imageScrollView.clipsToBounds = YES;
    
    //Setting up the imageView
    imageView = [[UIImageView alloc] initWithImage:self.currentImage];
    imageView.userInteractionEnabled = YES;
    
    imageView.frame = imageScrollView.bounds;
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    //Adding the imageView to the scrollView as subView
    [imageScrollView addSubview:imageView];
    imageScrollView.contentSize = CGSizeMake(imageView.bounds.size.width, imageView.bounds.size.height);
    imageScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    
    //UITapGestureRecognizer set up
    //UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerTap:)];
    
    [doubleTap setNumberOfTapsRequired:2];
    [twoFingerTap setNumberOfTouchesRequired:2];
    
    //Adding gesture recognizer
    [imageView addGestureRecognizer:doubleTap];
    [imageView addGestureRecognizer:twoFingerTap];
    
    // calculate minimum scale to perfectly fit image width, and begin at that scale
    float minimumScale = 1.0;//This is the minimum scale, set it to whatever you want. 1.0 = default
    imageScrollView.maximumZoomScale = 4.0;
    imageScrollView.minimumZoomScale = minimumScale;
    imageScrollView.zoomScale = minimumScale;
    [imageScrollView setContentMode:UIViewContentModeScaleAspectFit];
    [imageScrollView setContentSize:CGSizeMake(imageView.frame.size.width, imageView.frame.size.height)];
    
    [self scrollViewDidZoom:imageScrollView];

}


- (void)scrollViewDidZoom:(UIScrollView *)aScrollView {
    CGFloat offsetX = (imageScrollView.bounds.size.width > imageScrollView.contentSize.width)?
    (imageScrollView.bounds.size.width - imageScrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (imageScrollView.bounds.size.height > imageScrollView.contentSize.height)?
    (imageScrollView.bounds.size.height - imageScrollView.contentSize.height) * 0.5 : 0.0;
    imageView.center = CGPointMake(imageScrollView.contentSize.width * 0.5 + offsetX,
                                   imageScrollView.contentSize.height * 0.5 + offsetY);
}



#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return imageView;
}

#pragma mark TapDetectingImageViewDelegate methods

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    // zoom in
    float newScale = [imageScrollView zoomScale] * ZOOM_STEP;
    
    if (newScale > self.imageScrollView.maximumZoomScale){
        newScale = self.imageScrollView.minimumZoomScale;
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
        
        [imageScrollView zoomToRect:zoomRect animated:YES];
        
    }
    else{
        
        newScale = self.imageScrollView.maximumZoomScale;
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
        
        [imageScrollView zoomToRect:zoomRect animated:YES];
    }
}


- (void)handleTwoFingerTap:(UIGestureRecognizer *)gestureRecognizer {
    // two-finger tap zooms out
    float newScale = [imageScrollView zoomScale] / ZOOM_STEP;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
    [imageScrollView zoomToRect:zoomRect animated:YES];
}

#pragma mark Utility methods

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates.
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [imageScrollView frame].size.height / scale;
    zoomRect.size.width  = [imageScrollView frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
