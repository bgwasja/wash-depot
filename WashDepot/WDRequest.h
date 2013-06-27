//
//  WDRequest.h
//  WashDepot
//
//  Created by Vova Musiienko on 17.06.13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WDRequest : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * last_review;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * priority;
@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSString * problem_area;
@property (nonatomic, retain) NSString * current_status;
@property (nonatomic, retain) NSString * location_name;

- (NSString*) priorityString;
+ (NSArray*) availableStatuses;

+ (NSArray*) availableCompletedNames;
- (NSString*) completedString;
- (void) setCompletedFromString:(NSString*)newCompleted;

- (NSString*) lastReviewString;


@end
