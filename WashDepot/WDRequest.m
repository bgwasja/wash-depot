//
//  WDRequest.m
//  WashDepot
//
//  Created by Vova Musiienko on 17.06.13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import "WDRequest.h"
#import "WDAppDelegate.h"
#import "WDAPIClient.h"

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
@dynamic sys_modified;
@dynamic sys_new;
@dynamic user_name;


+ (WDRequest*) findByID:(NSString*) _id {
    WDAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"WDRequest"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creation_date" ascending:YES]];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier = %@", _id];
    [fetchRequest setPredicate:predicate];
    
    NSFetchedResultsController* fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:appDelegate.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
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


+ (WDRequest*) newRequestWithoutMOC {
    WDAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    
    WDRequest* r = (WDRequest*)[[WDRequest alloc] initWithEntity:[NSEntityDescription entityForName:@"WDRequest" inManagedObjectContext:appDelegate.managedObjectContext] insertIntoManagedObjectContext:nil];
    
    return r;
}


- (void) updateFromDict:(NSDictionary*) dic {
    self.identifier = [NSString stringWithFormat:@"%i", [[dic objectForKey:@"id"] intValue]];
    self.importance = [dic objectForKey:@"importance"];
    self.location_name = [dic objectForKey:@"location"];
    self.current_status = [dic objectForKey:@"status"];

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //1972-10-23T13:55:47Z
    [df setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    
    if ([dic objectForKey:@"last_reviewed"] == nil || [[dic objectForKey:@"last_reviewed"] isKindOfClass:[NSNull class]] || [[dic objectForKey:@"last_reviewed"] isEqualToString:@""]) {
        self.last_review = nil;
    } else {
        self.last_review = @([[df dateFromString: [dic objectForKey:@"last_reviewed"]] timeIntervalSince1970]);
    }
    
    self.creation_date = [df dateFromString: [dic objectForKey:@"creation_date"]];
    
    self.problem_area = [dic objectForKey:@"problem_area"];
    self.desc = [dic objectForKey:@"desc"];
    
    if ([dic objectForKey:@"picture1"] != nil && ![[dic objectForKey:@"picture1"] isKindOfClass:[NSNull class]] && ![[dic objectForKey:@"picture1"] isEqualToString:@""]) {
        self.image1 = [dic objectForKey:@"picture1"];
    }

    if ([dic objectForKey:@"picture2"] != nil && ![[dic objectForKey:@"picture2"] isKindOfClass:[NSNull class]] &&![[dic objectForKey:@"picture2"] isEqualToString:@""]) {
        self.image2 = [dic objectForKey:@"picture2"];
    }
    
    if ([dic objectForKey:@"picture3"] != nil && ![[dic objectForKey:@"picture3"] isKindOfClass:[NSNull class]] && ![[dic objectForKey:@"picture3"] isEqualToString:@""]) {
        self.image3 = [dic objectForKey:@"picture3"];
    }

    if ([dic objectForKey:@"user"] != nil && ![[dic objectForKey:@"user"] isKindOfClass:[NSNull class]] && ![[dic objectForKey:@"user"] isEqualToString:@""]) {
        self.user_name = [dic objectForKey:@"user"];
    } else {
        self.user_name = @"Unknown";
    }

}


+ (NSArray*) modifiedObjectsList {
    WDAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"WDRequest"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creation_date" ascending:YES]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sys_modified = YES AND sys_new = NO"];
    [fetchRequest setPredicate:predicate];
    
    NSFetchedResultsController* fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:appDelegate.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    NSError *error = nil;
    [fetchedResultsController performFetch:&error];
    
    if (error){
        NSLog(@"error: %@",error);
    }
    
    if ([[fetchedResultsController fetchedObjects] count] >= 1) {
        return [fetchedResultsController fetchedObjects];
    }
    
    return nil;
}


- (NSDictionary*) modificationsDictionaryPresentation {
    NSMutableDictionary* dic = [NSMutableDictionary new];
    [dic setObject:self.identifier forKey:@"request_id"];

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //1972-10-23T13:55:47Z
    [df setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    NSString* formatedDate = [df stringFromDate:[NSDate dateWithTimeIntervalSince1970:[self.last_review doubleValue]]];
    [dic setObject:formatedDate forKey:@"last_reviewed"];
    [dic setObject:self.current_status forKey:@"current_status"];
    [dic setObject:self.completed forKey:@"completed"];
    return dic;
}


+ (void) syncModifiedObjects {
    WDAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    NSArray* modifiedObjects = [WDRequest modifiedObjectsList];
    dispatch_queue_t myQueue = dispatch_queue_create("modified_queue",NULL);
    
    __block BOOL success = YES;
    __block int operationsInProgress = 0;
    
    NSOperationQueue* oq = [NSOperationQueue new];
    
    NSMutableArray* operations = [NSMutableArray new];
    for (WDRequest* modifiedRequest in modifiedObjects) {
        
        NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
        NSString *path = [NSString stringWithFormat:@"api/update_request?auth_token=%@", aToken];
        NSMutableURLRequest *request = [[WDAPIClient sharedClient] requestWithMethod:@"POST" path:path parameters:nil];
        NSError *error = nil;
        NSData *json = [NSJSONSerialization dataWithJSONObject:[modifiedRequest modificationsDictionaryPresentation] options:0 error:&error];
        [request setHTTPBody:json];
        
        NSString* s = [NSString stringWithUTF8String:[json bytes]];
        NSLog(@"REQUEST URL: %@\n REQUEST BODY: %@", path, s);
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            modifiedRequest.sys_modified = @NO;
            operationsInProgress --;
        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSString* errMsg = nil;
            if (JSON != nil) {
                errMsg = [JSON  objectForKey:@"info"];
            } else {
                errMsg = [error localizedDescription];
            }
            NSLog(@"ERROR SYNC EDIT OBJECT: %@", errMsg);
            success = NO;
            operationsInProgress --;
        }];
        
        [operations addObject:operation];
    }
    
    operationsInProgress = [operations count];
    
    dispatch_async(myQueue, ^{
        
        [oq addOperations:operations waitUntilFinished:NO];
        
        while (operationsInProgress > 0) {
            sleep(1);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            NSError* error = nil;
            [appDelegate.managedObjectContext save:&error];
            if (error != nil) {
                NSLog(@"%@", error);
            }
        });
    }); 
}


+ (void) removeMissingObjects:(NSArray*) presentedObjects {
    WDAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"WDRequest"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creation_date" ascending:YES]];
    [fetchRequest setIncludesPropertyValues:NO];
    
    NSString* pred = @"";
    for (NSString* _id in presentedObjects) {
        pred = [pred stringByAppendingFormat:@"identifier != %@", _id];
        if (_id != [presentedObjects lastObject]) {
            pred = [pred stringByAppendingFormat:@" AND "];
        }
    }
    
    NSPredicate *predicate = nil;
    if ([presentedObjects count] > 0) {
        predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"sys_new = NO AND (%@)", pred]];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"sys_new = NO"];
    }
    
    [fetchRequest setPredicate:predicate];
    
    NSFetchedResultsController* fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:appDelegate.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    NSError *error = nil;
    [fetchedResultsController performFetch:&error];
    
    if (error){
        NSLog(@"error: %@",error);
    }
    
    for (NSManagedObject * req in [fetchedResultsController fetchedObjects]) {
        [appDelegate.managedObjectContext deleteObject:req];
    }
}


+ (NSArray*) newObjectsList {
    WDAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"WDRequest"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creation_date" ascending:YES]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sys_new = YES"];
    [fetchRequest setPredicate:predicate];
    
    NSFetchedResultsController* fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:appDelegate.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    NSError *error = nil;
    [fetchedResultsController performFetch:&error];
    
    if (error){
        NSLog(@"error: %@",error);
    }
    
    if ([[fetchedResultsController fetchedObjects] count] >= 1) {
        return [fetchedResultsController fetchedObjects];
    }
    
    return nil;
}


- (NSDictionary*) dictionaryRepresentaion {
    NSMutableDictionary* dic = (NSMutableDictionary*)[self dictionaryWithValuesForKeys:[self.entity.attributesByName allKeys]];
    
    NSMutableDictionary* mdic = [dic mutableCopy];
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSDate class]]) {
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            //1972-10-23T13:55:47Z
            [df setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
            NSString* formatedDate = [df stringFromDate:obj];
            [mdic setObject:formatedDate forKey:key];
        }
    }];
    return mdic;
}


+ (void) syncNewObjects:(void (^)(BOOL success))completed {
    WDAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    NSArray* newObjects = [WDRequest newObjectsList];
    dispatch_queue_t myQueue = dispatch_queue_create("insert_new_queue",NULL);
    
    __block BOOL success = YES;
    __block int operationsInProgress = 0;
    
    NSOperationQueue* oq = [NSOperationQueue new];
    
    NSMutableArray* operations = [NSMutableArray new];
    for (WDRequest* newRequest in newObjects) {
        
        NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
        NSString *path = [NSString stringWithFormat:@"api/create_request?auth_token=%@", aToken];
        NSMutableURLRequest *request = [[WDAPIClient sharedClient] requestWithMethod:@"POST" path:path parameters:nil];
        NSError *error = nil;
        NSData *json = [NSJSONSerialization dataWithJSONObject:[newRequest dictionaryRepresentaion] options:0 error:&error];
        [request setHTTPBody:json];
        
        NSString* s = [NSString stringWithUTF8String:[json bytes]];
        NSLog(@"REQUEST URL: %@\n REQUEST BODY: %@", path, s);
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            NSString* _id = [NSString stringWithFormat:@"%i", [[JSON objectForKey:@"id"] intValue]];
            newRequest.identifier = _id;
            newRequest.sys_new = @NO;
            
            operationsInProgress --;
        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSString* errMsg = nil;
            if (JSON != nil) {
                errMsg = [JSON  objectForKey:@"info"];
            } else {
                errMsg = [error localizedDescription];
            }
            NSLog(@"ERROR SYNC NEW OBJECT: %@", errMsg);
            success = NO;
            operationsInProgress --;
        }];
        
        [operations addObject:operation];
    }

    operationsInProgress = [operations count];

    dispatch_async(myQueue, ^{

        [oq addOperations:operations waitUntilFinished:NO];
        
        while (operationsInProgress > 0) {
            sleep(1);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            NSError* error = nil;
            [appDelegate.managedObjectContext save:&error];
            if (error != nil) {
                NSLog(@"%@", error);
            }
            
            completed(success);
        });
    }); 
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
