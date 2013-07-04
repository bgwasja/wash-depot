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
@property (nonatomic, retain) NSDate * creation_date;
@property (nonatomic, retain) NSNumber * last_review;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * importance;
@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSString * problem_area;
@property (nonatomic, retain) NSString * current_status;
@property (nonatomic, retain) NSString * location_name;
@property (nonatomic, retain) NSString * image1;
@property (nonatomic, retain) NSString * image2;
@property (nonatomic, retain) NSString * image3;
// sync purposes fields
@property (nonatomic, retain) NSNumber * sys_modified;
@property (nonatomic, retain) NSNumber * sys_new;



+ (WDRequest*) findByID:(NSString*) _id;
+ (WDRequest*) newRequest;
- (void) updateFromDict:(NSDictionary*) dic;

+ (void) syncModifiedObjects;
+ (void) syncNewObjects:(void (^)(BOOL success))completed;


- (NSString*) priorityString;
+ (NSArray*) availableStatuses;

+ (NSArray*) availableCompletedNames;
- (NSString*) completedString;
- (void) setCompletedFromString:(NSString*)newCompleted;

- (NSString*) lastReviewString;


@end
