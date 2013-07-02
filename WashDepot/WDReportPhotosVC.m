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

@interface WDReportPhotosVC ()

@end

@implementation WDReportPhotosVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _imageArray = [[NSMutableArray alloc]initWithCapacity:3];
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

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self reloadViews];

}

#pragma mark - operations with views

-(void)reloadViews{
    int startCount = 0;
    UIView *contentView = _scrollView;
    if(USING_IPAD){
        startCount = 2;
        contentView = self.view;
    }
    if(contentView.subviews.count == startCount){
        for(int index=0;index<WD_NUMBER_OF_PHOTOVIEWS;index++){
            UIImageView *v = [self standartImageViewForIndex:index];
            if(!USING_IPAD){
                [contentView addSubview:v];
            }else{
                [contentView addSubview:v];
                UIImage *deleteBackground = [[UIImage imageNamed:@"but_grey"]
                                             resizableImageWithCapInsets:UIEdgeInsetsMake(22, 12, 22, 12)];
                UIImage *deleteBackgroundAct = [[UIImage imageNamed:@"but_grey_act"]
                                                resizableImageWithCapInsets:UIEdgeInsetsMake(22, 12, 22, 12)];
                UIButton *deleteBut = [UIButton buttonWithType:UIButtonTypeCustom];
                deleteBut.frame= CGRectMake(v.frame.origin.x, v.frame.origin.y+WD_SDRT_PHOTO_SIZE.height+20, WD_SDRT_PHOTO_SIZE.width-20, 31);
                [deleteBut setBackgroundImage:deleteBackground forState:UIControlStateNormal];
                [deleteBut setBackgroundImage:deleteBackgroundAct forState:UIControlStateHighlighted];
                [deleteBut addTarget:self action:@selector(deleteTapped:) forControlEvents:UIControlEventTouchUpInside];
                deleteBut.tag = index;
                [deleteBut setTitle:@"Delete" forState:UIControlStateNormal];
                [deleteBut setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                deleteBut.titleLabel.font = [UIFont systemFontOfSize:14];
                [contentView addSubview:deleteBut];
                if(index==1){
                    UIImage *processBackground = [[UIImage imageNamed:@"but_blue"]
                                                 resizableImageWithCapInsets:UIEdgeInsetsMake(22, 12, 22, 12)];
                    UIImage *processBackgroundAct = [[UIImage imageNamed:@"but_blue_act"]
                                                    resizableImageWithCapInsets:UIEdgeInsetsMake(22, 12, 22, 12)];
                    UIButton *processBut = [UIButton buttonWithType:UIButtonTypeCustom];
                    processBut.frame= CGRectMake(v.frame.origin.x, v.frame.origin.y+WD_SDRT_PHOTO_SIZE.height+71, WD_SDRT_PHOTO_SIZE.width-20, 31);
                    [processBut setBackgroundImage:processBackground forState:UIControlStateNormal];
                    [processBut setBackgroundImage:processBackgroundAct forState:UIControlStateHighlighted];
                    [processBut addTarget:self action:@selector(processTapped) forControlEvents:UIControlEventTouchUpInside];
                    processBut.tag = index;
                    [processBut setTitle:@"Process" forState:UIControlStateNormal];
                    processBut.titleLabel.font = [UIFont systemFontOfSize:14];
                    [contentView addSubview:processBut];
                }
                
            }
        }
        CGSize pageSize = _scrollView.frame.size;
        _scrollView.contentSize = CGSizeMake((pageSize.width)  * WD_NUMBER_OF_PHOTOVIEWS, pageSize.height);
    }
    
}

-(UIImageView*)standartImageViewForIndex:(NSInteger)index{
    
    int y = USING_IPAD?60:0;
    
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

-(void)viewTapped:(UITapGestureRecognizer*)gesRecogn{
//    NSLog(@"tapped!! tag=%i",gesRecogn.view.tag);
    self.tappedView = (UIImageView*)gesRecogn.view;
    UIImagePickerController *poc = [[UIImagePickerController alloc] init];
    [poc setTitle:@"Take a photo."];
    [poc setDelegate:self];
    [poc setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
//    poc.showsCameraControls = NO;
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
	[picker dismissModalViewControllerAnimated:YES];
    UIImage *chosenImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//    [_imageArray insertObject:chosenImage atIndex:_pageControl.currentPage];

    [_imageArray addObject:chosenImage];
    UIView *contentView;
    int viewIndex=0;
    if (USING_IPAD) {
        contentView = self.view;
        viewIndex=1;
    }

    UIImageView *imView = _tappedView;//[contentView.subviews objectAtIndex:_pageControl.currentPage];
    [imView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	imView.image = chosenImage;
    
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
    [super viewDidUnload];
}
#pragma mark  - ibactions

- (IBAction)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)processTapped {
    WDAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    
    NSError *error = nil;
    if (![delegate.managedObjectContext save:&error]) {
        NSLog(@"Error: %@", error);
    }
}


- (IBAction)deleteTapped:(UIButton*)sender {
    
    NSInteger curPage;
    UIImageView *currentImView = _tappedView;//[_scrollView.subviews objectAtIndex:curPage];
    UIImage *currentImage = currentImView.image;
    [_imageArray removeObject:currentImage];
    if(USING_IPAD){
        curPage = ((UIButton*)sender).tag;
//        [currentImView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [currentImView removeFromSuperview];
        [self.view addSubview:[self standartImageViewForIndex:curPage]];
        
    }else{
        curPage = _pageControl.currentPage;
        currentImView = [self standartImageViewForIndex:curPage];
        [[_scrollView.subviews objectAtIndex:curPage]removeFromSuperview];
        [_scrollView insertSubview:[self standartImageViewForIndex:curPage] atIndex:curPage];
    }
    
}
@end
