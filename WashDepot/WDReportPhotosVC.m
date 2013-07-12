//
//  WDReportPhotosVC.m
//  WashDepot
//
//  Created by Eugene on 18.06.13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import "WDReportPhotosVC.h"
#import <QuartzCore/QuartzCore.h>
#import "WDRequest.h"
#import "WDAppDelegate.h"
#import "NSData+Base64.h"
#import "WDLoadingVC.h"


@interface NonRotatingUIImagePickerController : UIImagePickerController
@end
@implementation NonRotatingUIImagePickerController
- (BOOL)shouldAutorotate{return NO;}
@end


@interface WDReportPhotosVC () <UIImagePickerControllerDelegate>

@end

@implementation WDReportPhotosVC
@synthesize toolbarLabel;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _imageDict = [[NSMutableDictionary alloc]initWithCapacity:3];
    if(!USING_IPAD){
        CGRect pageContrFrame;
        pageContrFrame.size = CGSizeMake(100, 15);
        pageContrFrame.origin = CGPointMake(self.view.center.x-pageContrFrame.size.width/2, 10);
        _pageControl = [[StyledPageControl alloc] initWithFrame:pageContrFrame] ;
        [_pageControl setPageControlStyle: PageControlStyleThumb] ;
        [_pageControl setDiameter: 15] ;
        [_pageControl setGapWidth: 25] ;
        _pageControl.numberOfPages = WD_NUMBER_OF_PHOTOVIEWS;
        [_pageControl setThumbImage:[UIImage imageNamed:@"dot"]];
        [_pageControl setSelectedThumbImage:[UIImage imageNamed:@"dot_act"]];
        _pageControl.userInteractionEnabled = FALSE;
        [self.view addSubview: _pageControl] ;
    }else{
        self.view.layer.borderColor = [UIColor whiteColor].CGColor;
        self.view.layer.borderWidth = .6;
        CALayer *leftBorder = [CALayer layer];
        leftBorder.borderColor = [UIColor lightGrayColor].CGColor;
        leftBorder.borderWidth = .6;
        leftBorder.frame = CGRectMake(1, -1, self.view.frame.size.width, self.view.frame.size.height+2);
        
        [self.view.layer addSublayer:leftBorder];
    }
    self.title =@"Report";
    self.titleLabel.text = self.title;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];

    UIImage *processBackground = [[UIImage imageNamed:@"but_blue"]
                                  resizableImageWithCapInsets:UIEdgeInsetsMake(22, 12, 22, 12)];
    [_processButton setBackgroundImage:processBackground forState:UIControlStateNormal];
    
    UIImage *processBackgroundAct = [[UIImage imageNamed:@"but_blue_act"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(22, 12, 22, 12)];
    [_processButton setBackgroundImage:processBackgroundAct forState:UIControlStateHighlighted];
    
    UIImage *deleteBackground = [[UIImage imageNamed:@"but_grey"]
                                 resizableImageWithCapInsets:UIEdgeInsetsMake(22, 12, 22, 12)];
    [_deleteButton setBackgroundImage:deleteBackground forState:UIControlStateNormal];
    
    UIImage *deleteBackgroundAct = [[UIImage imageNamed:@"but_grey_act"]
                                    resizableImageWithCapInsets:UIEdgeInsetsMake(22, 12, 22, 12)];
    [_deleteButton setBackgroundImage:deleteBackgroundAct forState:UIControlStateHighlighted];
    
    UIImage *backButtonImage = [[UIImage imageNamed:@"but_header"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(22, 12, 22, 12)];
    [_backButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    [_backButton setFrame:CGRectMake(0, 0, 50, 27)];
    [_backButton setTitle:@"Back" forState:UIControlStateNormal];
    
    UIImage *toolbarImage = [[UIImage imageNamed:@"bg_header"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 0, 480, 32)];
    [self.toolbar setBackgroundImage:toolbarImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    toolbarLabel.backgroundColor = [UIColor clearColor];
    toolbarLabel.opaque = NO;
    toolbarLabel.textColor = [UIColor whiteColor];
    toolbarLabel.font = [UIFont boldSystemFontOfSize:17];
    toolbarLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    toolbarLabel.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    
    if(DELEGATE.imageDict.count>0){
        self.imageDict = DELEGATE.imageDict;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self reloadViews];

}

#pragma mark - operations with views

-(void)reloadViews{
    int startCount = 0;
    UIView *contentView = USING_IPAD?_contentView:_scrollView;

    for (UIView* v in contentView.subviews) {
        [v removeFromSuperview];
    }
    
    if(contentView.subviews.count == startCount){
        for(int index=0;index<WD_NUMBER_OF_PHOTOVIEWS;index++){
            UIImageView *v;
            if([ _imageDict objectForKey:[NSString stringWithFormat:@"%i",index]]){//self.imageDict && self.imageDict.count >index ){
                v = [self blankImageViewForIndex:index];
                v.image = [ _imageDict objectForKey:[NSString stringWithFormat:@"%i",index]];
            }else{
                v = [self standartImageViewForIndex:index];

            }
            [contentView addSubview:v];

            if(USING_IPAD){
            
                UIImage *deleteBackground = [[UIImage imageNamed:@"but_grey"]
                                             resizableImageWithCapInsets:UIEdgeInsetsMake(22, 12, 22, 12)];
                UIImage *deleteBackgroundAct = [[UIImage imageNamed:@"but_grey_act"]
                                                resizableImageWithCapInsets:UIEdgeInsetsMake(22, 12, 22, 12)];
                UIButton *deleteBut = [UIButton buttonWithType:UIButtonTypeCustom];
                deleteBut.frame= CGRectMake(v.frame.origin.x, v.frame.origin.y+WD_SDRT_PHOTO_SIZE.height+60, WD_SDRT_PHOTO_SIZE.width-20, 31);
                [deleteBut setBackgroundImage:deleteBackground forState:UIControlStateNormal];
                [deleteBut setBackgroundImage:deleteBackgroundAct forState:UIControlStateHighlighted];
                [deleteBut addTarget:self action:@selector(deleteTapped:) forControlEvents:UIControlEventTouchUpInside];
                deleteBut.tag = index;
                [deleteBut setTitle:@"Delete" forState:UIControlStateNormal];
                [deleteBut setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                deleteBut.titleLabel.font = [UIFont systemFontOfSize:14];
                [self.view addSubview:deleteBut];
                if(index==1){
                    UIImage *processBackground = [[UIImage imageNamed:@"but_blue"]
                                                 resizableImageWithCapInsets:UIEdgeInsetsMake(22, 12, 22, 12)];
                    UIImage *processBackgroundAct = [[UIImage imageNamed:@"but_blue_act"]
                                                    resizableImageWithCapInsets:UIEdgeInsetsMake(22, 12, 22, 12)];
                    UIButton *processBut = [UIButton buttonWithType:UIButtonTypeCustom];
                    processBut.frame= CGRectMake(v.frame.origin.x, v.frame.origin.y+WD_SDRT_PHOTO_SIZE.height+111, WD_SDRT_PHOTO_SIZE.width-20, 31);
                    [processBut setBackgroundImage:processBackground forState:UIControlStateNormal];
                    [processBut setBackgroundImage:processBackgroundAct forState:UIControlStateHighlighted];
                    [processBut addTarget:self action:@selector(processTapped) forControlEvents:UIControlEventTouchUpInside];
                    processBut.tag = index;
                    [processBut setTitle:@"Process" forState:UIControlStateNormal];
                    processBut.titleLabel.font = [UIFont systemFontOfSize:14];
                    [self.view addSubview:processBut];
                }
                
            }
        }
        CGSize pageSize = _scrollView.frame.size;
        _scrollView.contentSize = CGSizeMake((pageSize.width)  * WD_NUMBER_OF_PHOTOVIEWS, pageSize.height);
    }
    
}

-(UIImageView*)standartImageViewForIndex:(NSInteger)index{
    
    int y = USING_IPAD?20:0;
    
    CGRect viewFrame = CGRectMake(0, y, WD_SDRT_PHOTO_SIZE.width-20, WD_SDRT_PHOTO_SIZE.height);

    UIImageView *v = [[UIImageView alloc]initWithFrame:viewFrame];
    v.userInteractionEnabled = TRUE;
//    v.backgroundColor = [UIColor whiteColor];
    v.clipsToBounds = YES;
    v.layer.cornerRadius = 20;
    v.tag = index;
    
    CGRect newFrame = v.frame;
    newFrame.origin.x = (WD_SDRT_PHOTO_SIZE.width ) * index +10;
    v.frame = newFrame;
    
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped:)];
    [v addGestureRecognizer:tapGest];

    UIImage *backgrIm = [[UIImage imageNamed:@"text_input"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(19, 19, 19, 19)];
    v.image = backgrIm;
    CGRect cameraFrame;
    cameraFrame.size = CGSizeMake(95, 70);
    cameraFrame.origin = CGPointMake(v.frame.size.width/2-cameraFrame.size.width/2, v.frame.size.height/2-cameraFrame.size.height/2-45);
    UIImageView *cameraImg = [[UIImageView alloc]initWithFrame:cameraFrame];
    cameraImg.image = [UIImage imageNamed:@"photo"];
    [v addSubview:cameraImg];
    
    CGRect labelFrame;
    labelFrame.size = CGSizeMake(115, 55);
    labelFrame.origin = CGPointMake(v.frame.size.width/2-labelFrame.size.width/2, v.frame.size.height/2-labelFrame.size.height/2+35);
    UILabel *textLabel = [[UILabel alloc]initWithFrame:labelFrame];
    textLabel.font = [UIFont systemFontOfSize:20];
    textLabel.textColor = [UIColor lightGrayColor];
    textLabel.text = NSLocalizedString(@"Tap to make a picture", nil);
    textLabel.numberOfLines = 2;
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textAlignment = UITextAlignmentCenter;
    [v addSubview:textLabel];
    
    return v;
}

-(UIImageView*)blankImageViewForIndex:(NSInteger)index{
    
    int y = USING_IPAD?20:0;
    
    CGRect viewFrame = CGRectMake(0, y, WD_SDRT_PHOTO_SIZE.width-20, WD_SDRT_PHOTO_SIZE.height);
    
    UIImageView *v = [[UIImageView alloc]initWithFrame:viewFrame];
    v.userInteractionEnabled = TRUE;
    //    v.backgroundColor = [UIColor whiteColor];
    v.clipsToBounds = YES;
    v.layer.cornerRadius = 20;
    v.tag = index;
    v.layer.borderWidth =1;
    v.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    CGRect newFrame = v.frame;
    newFrame.origin.x = (WD_SDRT_PHOTO_SIZE.width ) * index +10;
    v.frame = newFrame;
    
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped:)];
    [v addGestureRecognizer:tapGest];
    return v;
}

-(void)viewTapped:(UITapGestureRecognizer*)gesRecogn{
//    NSLog(@"tapped!! tag=%i",gesRecogn.view.tag);
    self.tappedView = (UIImageView*)gesRecogn.view;
    UIImagePickerController *poc = [[NonRotatingUIImagePickerController alloc] init];
    [poc setTitle:@"Take a photo."];
    [poc setDelegate:self];
    
#if TARGET_IPHONE_SIMULATOR
    [poc setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
#elif TARGET_OS_IPHONE
    [poc setSourceType:UIImagePickerControllerSourceTypeCamera];
    //    poc.showsCameraControls = NO;
#else
#endif
    
    
    if(USING_IPAD){
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:poc];
        [popover presentPopoverFromRect:self.view.bounds inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        self.popover = popover;

    }else{
        [self presentViewController:poc animated:YES completion:nil];

    }
    
}

#pragma mark - imagePicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if (USING_IPAD) {
        [self.popover dismissPopoverAnimated:YES];
    } else {
        [picker dismissModalViewControllerAnimated:YES];
    }
    
    UIImage *chosenImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];

    [_imageDict setObject:chosenImage forKey:[NSString stringWithFormat:@"%i",_tappedView.tag]];
    DELEGATE.imageDict = _imageDict;
    
    UIView *contentView;
    int viewIndex=0;
    if (USING_IPAD) {
        contentView = self.view;
        viewIndex=1;
    }

//    UIImageView *imView = _tappedView;//[contentView.subviews objectAtIndex:_pageControl.currentPage];
//    [imView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//	imView.image = chosenImage;
//    imView.layer.borderWidth =1;
//    imView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    _tappedView=nil;
//
    [self reloadViews];
}

#pragma mark - scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setProcessButton:nil];
    [self setDeleteButton:nil];
    [self setBackButton:nil];
    [self setTappedView:nil];
    [self setTitleLabel:nil];
    [self setContentView:nil];
    [self setToolbar:nil];
    [self setToolbarLabel:nil];
    [super viewDidUnload];
}
#pragma mark  - ibactions

- (IBAction)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)processTapped {
    WDAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    
    if ([delegate.createdRequest isHaveEmptyRows]) {
        UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"REPORT" message:@"All fields must be filled." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        return;
    }

    
    if ([_imageDict count] <= 0) {
        UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"NEW REPORT" message:[NSString stringWithFormat:@"Need to add at least one picture to the report."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [av show];
        return;
    }
    
    [[WDLoadingVC sharedLoadingVC] showInController:self.parentViewController withText:@"Creating new request..."];
    
    delegate.createdRequest.sys_new = @YES;
    [delegate.managedObjectContext insertObject:delegate.createdRequest];
    
    NSError *error = nil;
    if (![delegate.managedObjectContext save:&error]) {
        NSLog(@"Error: %@", error);
    }
    
    for (int i = 0;  i < [_imageDict count]; i++) {
        UIImage* img = [_imageDict objectForKey:[NSString stringWithFormat:@"%i",i]];
        NSData *dataObj = UIImageJPEGRepresentation(img, 0.9);
        [dataObj writeToFile:[delegate.createdRequest pathForImage:i] atomically:YES];

        NSLog(@"Image size w:%f h:%f : %f", img.size.width, img.size.height,[dataObj length] / 1024.0f);
        
        img = nil;
        dataObj = nil;
    }
    
    
    [_imageDict removeAllObjects];
    [DELEGATE.imageDict removeAllObjects];
    
    [WDRequest syncNewObjects:^(BOOL succes) {
        if (succes != YES) {
            UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"NEW REPORT" message:[NSString stringWithFormat:@"Can't push new request to server. It's will be automaticaly pushed when server will be available."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [av show];
        } else {
            UIApplicationState applicationState = [UIApplication sharedApplication].applicationState;
            if (applicationState != UIApplicationStateBackground) {
                UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"NEW REPORT" message:[NSString stringWithFormat:@"Report successfully created."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [av show];
            }
        }
        
        //WDAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
        //appDelegate.needCreateNewRequest = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"need_create_new_request" object:self];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        [[WDLoadingVC sharedLoadingVC] hide];
        
        [self reloadViews];
    }];
}


- (IBAction)deleteTapped:(UIButton*)sender {
    
    NSInteger curPage;
    UIImageView *currentImView;//[_scrollView.subviews objectAtIndex:curPage];
    UIImage *currentImage;

    if(USING_IPAD){
        curPage = ((UIButton*)sender).tag;
        currentImView = [_contentView.subviews objectAtIndex:curPage];
        currentImage = currentImView.image;
        [currentImView removeFromSuperview];
        [_contentView insertSubview:[self standartImageViewForIndex:curPage] atIndex:curPage];
        
    }else{
        curPage = _pageControl.currentPage;
        currentImView = [_scrollView.subviews objectAtIndex:curPage];
        currentImage = currentImView.image;
        [currentImView removeFromSuperview];
        [_scrollView insertSubview:[self standartImageViewForIndex:curPage] atIndex:curPage];
    }
    [_imageDict removeObjectForKey:[NSString stringWithFormat:@"%i",curPage]];
//    NSLog(@"_imageArray=%@",_imageArray);
    DELEGATE.imageDict = _imageDict;
    
}
@end
