//
//  WDReportsListVC.h
//  WashDepot
//
//  Created by Vova Musiienko on 17.06.13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WDRequest;
@interface WDReportsListVC : UIViewController<UIPopoverControllerDelegate>

@property (nonatomic, strong) IBOutlet UITableView* reportsTable;
@property (nonatomic, strong) IBOutlet UIView* searchView;
@property (nonatomic, strong) IBOutlet UITextField* searchTextField;
@property (strong, nonatomic) IBOutlet UIView *locationsListView;
@property (nonatomic,strong)NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) IBOutlet UIButton *logoutBut;
@property (strong, nonatomic) IBOutlet UIButton *filterButton;
@property (strong, nonatomic) IBOutlet UIToolbar *leftToolbar;
@property (strong, nonatomic) IBOutlet UIToolbar *rightToolbar;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;

- (void) updateData;

-(IBAction)logoutTapped:(id)sender;
-(IBAction)settingsTapped:(id)sender;
-(IBAction)updateSearchResults:(id)sender;

- (void) editStatusTappedFor:(WDRequest*)r ;
@end
