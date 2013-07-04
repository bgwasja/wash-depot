//
//  WDRequest.m
//  WashDepot
//
//  Created by Vova Musiienko on 17.06.13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import "WDRequest.h"
#import "WDAppDelegate.h"

@implementation WDRequest

@dynamic creation_date;
@dynamic desc;
@dynamic importance;
@dynamic problem_area;
@dynamic current_status;
@dynamic location_name;
@dynamic completed;
@dynamic last_review;
@dynamic identifier;
@dynamic image1;
@dynamic image2;
@dynamic image3;


+ (WDRequest*) findByID:(NSString*) _id {
    WDAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"WDRequest"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creation_date" ascending:YES]];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier = %@", _id];
    [fetchRequest setPredicate:predicate];
    
    NSFetchedResultsController* fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:appDelegate.managedObjectContext sectionNameKeyPath:nil cacheName:@"find_by_id_cache"];
    
    NSError *error = nil;
    [fetchedResultsController performFetch:&error];
    
    if (error){
        NSLog(@"error: %@",error);
    }
    
    if ([[fetchedResultsController fetchedObjects] count] >= 1) {
        return [[fetchedResultsController fetchedObjects] objectAtIndex:0];
    }
    
    return nil;
}


+ (WDRequest*) newRequest {
    WDAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];

    WDRequest* r = (WDRequest*)[[WDRequest alloc] initWithEntity:[NSEntityDescription entityForName:@"WDRequest" inManagedObjectContext:appDelegate.managedObjectContext] insertIntoManagedObjectContext:appDelegate.managedObjectContext];
    
    return r;
}


- (void) updateFromDict:(NSDictionary*) dic {
    self.identifier = [NSString stringWithFormat:@"%i", [[dic objectForKey:@"id"] intValue]];
    self.importance = [dic objectForKey:@"priority"];
    self.location_name = [dic objectForKey:@"location"];
    self.current_status = [dic objectForKey:@"status"];
    
    if ([[dic objectForKey:@"last_review"] isEqualToString:@""]) {
        self.last_review = nil;
    } else {
        self.last_review = [NSNumber numberWithDouble:[[dic objectForKey:@"last_review"] doubleValue]];
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //1972-10-23T13:55:47Z
    [df setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    self.creation_date = [df dateFromString: [dic objectForKey:@"creation_date"]];
    
    self.problem_area = [dic objectForKey:@"problem_area"];
    self.desc = [dic objectForKey:@"desc"];
    
    if ([dic objectForKey:@"image1"] != nil && ![[dic objectForKey:@"image1"] isEqualToString:@""]) {
        self.image1 = [dic objectForKey:@"image1"];
    }

    if ([dic objectForKey:@"image2"] != nil && ![[dic objectForKey:@"image2"] isEqualToString:@""]) {
        self.image2 = [dic objectForKey:@"image2"];
    }
    
    if ([dic objectForKey:@"image3"] != nil && ![[dic objectForKey:@"image3"] isEqualToString:@""]) {
        self.image3 = [dic objectForKey:@"image3"];
    }
}


- (NSString*) priorityString {
    switch ([self.importance intValue]) {
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
