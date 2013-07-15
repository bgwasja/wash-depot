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
#import "NSData+Base64.h"


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


- (NSString*) safeString:(NSString*) source defaultValue:(NSString*) v {
    if (source == nil || [source isKindOfClass:[NSNull class]] || [source isEqualToString:@""]) {
        return v;
    }
    return source;
}


- (void) updateFromDict:(NSDictionary*) dic {
    self.identifier = [NSString stringWithFormat:@"%i", [[dic objectForKey:@"id"] intValue]];
    self.importance = [self safeString:[dic objectForKey:@"importance"] defaultValue:@"Undefined Imporance"];
    self.location_name = [self safeString:[dic objectForKey:@"location"] defaultValue:@"Undefined Location"];
    self.current_status = [dic objectForKey:@"status"];

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //1972-10-23T13:55:47Z
    [df setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    
    if ([dic objectForKey:@"last_reviewed"] == nil || [[dic objectForKey:@"last_reviewed"] isKindOfClass:[NSNull class]] || [[dic objectForKey:@"last_reviewed"] isEqualToString:@""]) {
        self.last_review = nil;
    } else {
        self.last_review = @([[df dateFromString: [dic objectForKey:@"last_reviewed"]] timeIntervalSince1970]);
    }
    
    if ([dic objectForKey:@"creation_date"] != nil && ![[dic objectForKey:@"creation_date"] isKindOfClass:[NSNull class]]) {
        self.creation_date = [df dateFromString: [dic objectForKey:@"creation_date"]];
    }
    
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
    __block int succedSyncs = 0;
    
    NSOperationQueue* oq = [NSOperationQueue new];
    oq.maxConcurrentOperationCount = 1;
    
    NSMutableArray* operations = [NSMutableArray new];
    for (WDRequest* newRequest in newObjects) {
        
        NSError *error = nil;
        NSData *json = [NSJSONSerialization dataWithJSONObject:[newRequest dictionaryRepresentaion] options:0 error:&error];
        
        NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
        NSString *path = [NSString stringWithFormat:@"api/create_request?auth_token=%@", aToken];
        NSMutableURLRequest *request =
        [[WDAPIClient sharedClient] multipartFormRequestWithMethod:@"POST" path:path parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
            
            for (int i = 0; i < 3; i++) {
                NSData* imgData = [NSData dataWithContentsOfFile:[newRequest pathForImage:i]];
                if (imgData != nil) {
                    [formData appendPartWithFileData:imgData name:[NSString stringWithFormat:@"image%i", i+1] fileName:@"image.jpeg" mimeType:@"image/jpeg"];
                }
            }
            //[formData appendPartWithFileData:json name:@"json_body" fileName:@"json.txt" mimeType:@"application/json"];
            NSString* s = [[[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"ESCAPED JSON: %@", s);
            [formData appendPartWithFormData:[s dataUsingEncoding:NSUTF8StringEncoding]  name:@"json_body"];
        }];
        
        NSLog(@"Sending new requests... size %f kb", [[request HTTPBody] length] / 1024.0f);
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            if ([JSON objectForKey:@"id"] != nil && ![[JSON objectForKey:@"id"] isKindOfClass:[NSNull class]]) {
                NSString* _id = [NSString stringWithFormat:@"%i", [[JSON objectForKey:@"id"] intValue]];
                newRequest.identifier = _id;
                newRequest.sys_new = @NO;
                succedSyncs ++;
            }
            
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
            
            if (succedSyncs>0) {
                UILocalNotification* localNotification = [[UILocalNotification alloc] init];
                localNotification.alertBody = [NSString stringWithFormat:@"%i report(s) pushed to the server.", succedSyncs];
                [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
            }
        });
    }); 
}


+ (NSArray*) availableStatuses {
    NSArray* list = [[NSUserDefaults standardUserDefaults] objectForKey:@"statuses_list"];
    if (list == nil) {
        list = @[@"Queued", @"Parts Ordered", @"Scheduled", @"Under Review"];
        [[NSUserDefaults standardUserDefaults] setObject:list forKey:@"statuses_list"];
    }
    return list;
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
    [dateFormat setDateFormat:@"MM/dd/yy"];
    NSString* dateStr = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:[self.last_review doubleValue]]];
    return dateStr;
}


+ (NSArray*) locationsList {
    NSArray* list = [[NSUserDefaults standardUserDefaults] objectForKey:@"locations_list"];
    if (list == nil) {
        list = [NSArray arrayWithObjects:@"Location 001",@"Location 002",@"Location 003",@"Location 004", nil];
        [[NSUserDefaults standardUserDefaults] setObject:list forKey:@"locations_list"];
    }
    return list;
}


+ (NSArray*) problemsAreaList {
    NSArray* list = [[NSUserDefaults standardUserDefaults] objectForKey:@"problem_area_list"];
    if (list == nil) {
        list = [NSArray arrayWithObjects:@"Conveyor Chain", @"Electrical Equip Room", @"Mitter Curtain", @"Wheel Blasters", @"Plumbing Water", @"POS System", nil];
        [[NSUserDefaults standardUserDefaults] setObject:list forKey:@"problem_area_list"];
    }
    return list;
}


+ (NSArray*) prioritiesList {
    NSArray* list = [[NSUserDefaults standardUserDefaults] objectForKey:@"priority_list"];
    if (list == nil) {
        list = @[@"Low", @"Normal", @"Urgent"];
        [[NSUserDefaults standardUserDefaults] setObject:list forKey:@"priority_list"];
    }
    return list;
}


+ (void) updateLists:(void (^)())completedCallback {
    NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSString *path = [NSString stringWithFormat:@"api/get_lists?auth_token=%@", aToken];
    NSMutableURLRequest *request = [[WDAPIClient sharedClient] requestWithMethod:@"GET" path:path parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        if ([JSON objectForKey:@"locations"] != nil && ![[JSON objectForKey:@"locations"] isKindOfClass:[NSNull class]]) {
            [[NSUserDefaults standardUserDefaults] setObject:[JSON objectForKey:@"locations"] forKey:@"locations_list"];
        }
        
        if ([JSON objectForKey:@"problem_areas"] != nil && ![[JSON objectForKey:@"problem_areas"] isKindOfClass:[NSNull class]]) {
            [[NSUserDefaults standardUserDefaults] setObject:[JSON objectForKey:@"problem_areas"] forKey:@"problem_area_list"];
        }
        
        if ([JSON objectForKey:@"statuses"] != nil && ![[JSON objectForKey:@"statuses"] isKindOfClass:[NSNull class]]) {
            [[NSUserDefaults standardUserDefaults] setObject:[JSON objectForKey:@"statuses"] forKey:@"statuses_list"];
        }
        
        if ([JSON objectForKey:@"importances"] != nil && ![[JSON objectForKey:@"importances"] isKindOfClass:[NSNull class]]) {
            [[NSUserDefaults standardUserDefaults] setObject:[JSON objectForKey:@"importances"] forKey:@"priority_list"];
        }
        
        
        
        completedCallback();
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSString* errMsg = nil;
        if (JSON != nil) {
            errMsg = [JSON  objectForKey:@"info"];
        } else {
            errMsg = [error localizedDescription];
        }
        NSLog(@"ERROR UPDATE LISTS: %@", errMsg);
    }];
    
    [operation start];
}


- (NSString*) pathForImage:(int)imageNum {
    WDAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSString* cdID = self.objectID.URIRepresentation.absoluteString;
    
    cdID = [[cdID dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
    
    NSString* path = [[[appDelegate applicationDocumentsDirectory] path] stringByAppendingPathComponent:[NSString stringWithFormat:@"img_%@_%i.png", cdID, imageNum]];
    return path;
}


+ (NSDateFormatter*) displayDateFormatter {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    return dateFormatter;
}


- (BOOL) isHaveEmptyRows {
    if (   [self.location_name isEqualToString:@""]
        || [self.importance isEqualToString:@""]
        || [self.problem_area isEqualToString:@""]
        || [self.desc isEqualToString:@""]
        || self.creation_date == nil
        || [self.creation_date isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return NO;
}


@end
