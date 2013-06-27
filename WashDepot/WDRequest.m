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
@dynamic completed;
@dynamic last_review;
@dynamic identifier;

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


+ (NSArray*) availableCompletedNames {
    return @[@"Pending", @"Done"];
}

- (NSString*) completedString {
    return [[[self class] availableCompletedNames] objectAtIndex: [self.completed intValue]];
}


- (void) setCompletedFromString:(NSString*)newCompleted {
    int newValue = 0;
    NSArray* names = [[self class] availableCompletedNames];
    for (int i = 0; i < [names count]; i++) {
        if ([newCompleted isEqualToString:[names objectAtIndex:i]]) {
            newValue = i;
            break;
        }
    }
    self.completed = [NSNumber numberWithInt:newValue];
}

- (NSString*) lastReviewString {
    if (self.last_review == nil || [self.last_review isKindOfClass:[NSNull class]] || [self.last_review intValue] == 0) {
        return @"Not reviewed";
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yy/MM/dd"];
    NSString* dateStr = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:[self.last_review doubleValue]]];
    return dateStr;
}



@end
