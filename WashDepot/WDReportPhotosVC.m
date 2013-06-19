//
//  WDReportPhotosVC.m
//  WashDepot
//
//  Created by Eugene on 18.06.13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import "WDReportPhotosVC.h"
#import <QuartzCore/QuartzCore.h>
#import "WDPageControl.h"

@interface WDReportPhotosVC ()

@end

@implementation WDReportPhotosVC

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
    _viewArray = [[NSMutableArray alloc]initWithCapacity:1];
    [self loadViews];
    [self customizeViews];
    _pageControl.numberOfPages = _viewArray.count;
    [_pageControl setImageCurrent:[UIImage imageNamed:@"dot_act"]];
    [_pageControl setImageNormal:[UIImage imageNamed:@"dot"]];
    
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
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //    NSLog(@"_viewArray=%@",_viewArray);
    [self reloadViews];



}

#pragma mark - operatins with views

-(void)loadViews{
    CGRect viewFrame = CGRectMake(0, 0, _scrollView.frame.size.width-20, _scrollView.frame.size.height-45);
    
    for(int index=0;index<WD_NUMBER_OF_PHOTOVIEWS;index++){
        UIImageView *v = [[UIImageView alloc]initWithFrame:viewFrame];
        v.image = [UIImage imageNamed:@"shadow"];
        v.backgroundColor = [UIColor whiteColor];
        v.clipsToBounds = YES;
        v.layer.cornerRadius = 20;
        v.tag = index;
        
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
        textLabel.textAlignment = UITextAlignmentCenter;
        [v addSubview:textLabel];
        
        [_viewArray addObject:v];
    }
    
}

-(void)reloadViews{
    [self customizeViews];
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for(UIView *v in _viewArray){
        [_scrollView addSubview:v];
    }
    _pageControl.numberOfPages = _viewArray.count;
    CGSize pageSize = _scrollView.frame.size;
    _scrollView.contentSize = CGSizeMake((pageSize.width)  * [_viewArray count], pageSize.height);

}

-(void)customizeViews{
    for(int index=0;index<_viewArray.count;index++){
        UIView *v = [_viewArray objectAtIndex:index];
        CGRect newFrame = v.frame;
        newFrame.origin.x = (_scrollView.frame.size.width ) * index +10;

        v.frame = newFrame;
        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped:)];
        [v addGestureRecognizer:tapGest];
    }
}


-(void)viewTapped:(UITapGestureRecognizer*)gesRecogn{
    NSLog(@"tapped!! tag=%i",gesRecogn.view.tag);
//    UIImagePickerController *poc = [[UIImagePickerController alloc] init];
//    [poc setTitle:@"Take a photo."];
//    [poc setDelegate:self];
//    [poc setSourceType:UIImagePickerControllerSourceTypeCamera];
//    poc.showsCameraControls = NO;
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
    [super viewDidUnload];
}
#pragma mark  - ibactions

- (IBAction)processTapped {
}

- (IBAction)deleteTapped {
    UIImageView *imView = (UIImageView*)[_viewArray objectAtIndex:_pageControl.currentPage];
//    imView.image = 
    
    
}
@end
