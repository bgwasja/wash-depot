//
//  WDReportPhotosVC.m
//  WashDepot
//
//  Created by Eugene on 18.06.13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import "WDReportPhotosVC.h"
#import <QuartzCore/QuartzCore.h>

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
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title =@"Report";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
//    NSLog(@"_viewArray=%@",_viewArray);
    [self reloadViews];
        
    UIImage *buttonBackground = [[UIImage imageNamed:@"but_blue"]
                                 resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [_processButton setBackgroundImage:buttonBackground forState:UIControlStateNormal];


}

#pragma mark - operatins with views

-(void)loadViews{
    CGRect viewFrame = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height-45);
    UIView *firstView = [[UIView alloc]initWithFrame:viewFrame];
    firstView.backgroundColor = [UIColor blueColor];
   
    
    UIView *secondView = [[UIView alloc]initWithFrame:viewFrame];
    secondView.backgroundColor = [UIColor yellowColor];
       
    UIView *thirdView = [[UIView alloc]initWithFrame:viewFrame];
    thirdView.backgroundColor = [UIColor purpleColor];
    
    [_viewArray addObjectsFromArray:@[firstView,secondView,thirdView]];
    
}

-(void)reloadViews{
    [self customizeViews];
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for(UIView *v in _viewArray){
        [_scrollView addSubview:v];
    }
    _pageControl.numberOfPages = _viewArray.count;
    CGSize pageSize = _scrollView.frame.size;
    _scrollView.contentSize = CGSizeMake((pageSize.width - 60)  * [_viewArray count], pageSize.height);

}

-(void)customizeViews{
    for(UIView *v in _viewArray){
        int viewNumber = [_viewArray indexOfObject:v];
        CGRect newFrame = v.frame;
        newFrame.origin.x = (_scrollView.frame.size.width )* viewNumber ;
        if(viewNumber>0) newFrame.origin.x += 30;
        v.frame = newFrame;
        v.layer.cornerRadius = 20;
        v.tag = viewNumber;
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
    if(_viewArray.count>0){
        [_viewArray removeObjectAtIndex:_pageControl.currentPage];
        [self reloadViews];
    }
    
}
@end
