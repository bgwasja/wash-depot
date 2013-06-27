//
//  WDListOptionsVC.m
//  WashDepot
//
//  Created by Vova Musiienko on 27.06.13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import "WDListOptionsVC.h"

@interface WDListOptionsVC ()

@end

@implementation WDListOptionsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.rowHeight;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Filter Tasks";
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"regular_cell"];
            switch (indexPath.row) {
                case 0: {
                    cell.textLabel.text = @"Completed for last 30 days";
                    break;
                }
                case 1: {
                    cell.textLabel.text = @"Completed for last 60-90 days";
                    break;
                }
                case 2: {
                    cell.textLabel.text = @"No filter";
                    break;
                }
            }
            break;
        }
        case 1: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"checkbox_cell"];
            
            break;
        }
    }
    
    int activeOption = [[[NSUserDefaults standardUserDefaults] objectForKey:@"filter_option"] intValue];
    if (indexPath.row == activeOption) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return indexPath;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:indexPath.row] forKey:@"filter_option"];

    [tableView reloadData];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
