//
//  WDRequest.m
//  WashDepot
//
//  Created by Vova Musiienko on 17.06.13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import "WDRequest.h"


@implementation WDRequest

@dynamic date;
@dynamic desc;
@dynamic priority;
@dynamic problem_area;
@dynamic current_status;
@dynamic location_name;


- (NSString*) priorityString {
    switch ([self.priority intValue]) {
        case 0:
            return @"Low";
        case 1:
            return @"Normal";
        case 2:
            return @"Urgent";
    }
    return @"Undefined Importance";
}


+ (NSArray*) availableStatuses {
    return @[@"Queued", @"Parts Ordered", @"Scheduled", @"Under Review"];
}


@end
