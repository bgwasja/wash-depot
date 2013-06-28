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
    
    self.title =@"Report";
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

#pragma mark - operatins with views

-(void)reloadViews{
    if(_scrollView.subviews.count == 0){
        for(int index=0;index<WD_NUMBER_OF_PHOTOVIEWS;index++){
            UIImageView *v = [self standartImageViewForIndex:index];
            [_scrollView addSubview:v];
        }
        CGSize pageSize = _scrollView.frame.size;
        _scrollView.contentSize = CGSizeMake((pageSize.width)  * WD_NUMBER_OF_PHOTOVIEWS, pageSize.height);
    }
    
}

-(UIImageView*)standartImageViewForIndex:(NSInteger)index{
    
    CGRect viewFrame = CGRectMake(0, 0, _scrollView.frame.size.width-20, _scrollView.frame.size.height);

    UIImageView *v = [[UIImageView alloc]initWithFrame:viewFrame];
    v.userInteractionEnabled = TRUE;
//    v.backgroundColor = [UIColor whiteColor];
    v.clipsToBounds = YES;
    v.layer.cornerRadius = 20;
    v.tag = index;
    
    CGRect newFrame = v.frame;
    newFrame.origin.x = (_scrollView.frame.size.width ) * index +10;
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
    UIImagePickerController *poc = [[UIImagePickerController alloc] init];
    [poc setTitle:@"Take a photo."];
    [poc setDelegate:self];
    [poc setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
//    poc.showsCameraControls = NO;
    [self presentViewController:poc animated:YES completion:nil];
}

#pragma mark - imagePicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissModalViewControllerAnimated:YES];
    UIImage *chosenImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//    [_imageArray insertObject:chosenImage atIndex:_pageControl.currentPage];

    [_imageArray addObject:chosenImage];
    UIImageView *imView = [_scrollView.subviews objectAtIndex:_pageControl.currentPage];
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


- (IBAction)deleteTapped {
    
    NSInteger curPage = _pageControl.currentPage;
    UIImageView *currentImView = [_scrollView.subviews objectAtIndex:curPage];
    UIImage *currentImage = currentImView.image;
    [_imageArray removeObject:currentImage];
    [[_scrollView.subviews objectAtIndex:curPage]removeFromSuperview];
    [_scrollView insertSubview:[self standartImageViewForIndex:curPage] atIndex:curPage];
}
@end
