#import "WDAPIClient.h"
#import "AFJSONRequestOperation.h"
#import "WDRequest.h"

static NSString * const kToDoAPIBaseURLString = @"http://65.213.67.126/";

@implementation WDAPIClient

+ (WDAPIClient *)sharedClient {
    static WDAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kToDoAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    [self setDefaultHeader:@"Content-Type" value:@"application/json"];
    [self setParameterEncoding:AFJSONParameterEncoding];
    
    return self;
}

#pragma mark - AFIncrementalStore

- (id)representationOrArrayOfRepresentationsFromResponseObject:(id)responseObject {
    return responseObject;
}

- (NSDictionary *)attributesForRepresentation:(NSDictionary *)representation
                                     ofEntity:(NSEntityDescription *)entity 
                                 fromResponse:(NSHTTPURLResponse *)response 
{
    
    NSDictionary* corrected_representation = nil;
    if ([representation objectForKey:@"request"] != nil) {
        corrected_representation = [representation objectForKey:@"request"];
    } else {
        corrected_representation = representation;
    }
    
    
    NSMutableDictionary *mutablePropertyValues = [[super attributesForRepresentation:corrected_representation ofEntity:entity fromResponse:response] mutableCopy];
    
    //[mutablePropertyValues setObject:[corrected_representation objectForKey:@"description"] forKey:@"desc"];
    //NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:[[corrected_representation objectForKey:@"creation_date"] doubleValue]];
    //[mutablePropertyValues setObject:myDate forKey:@"creation_date"];

    NSString* identifier = [NSString stringWithFormat:@"%i", [[corrected_representation objectForKey:@"id"] intValue]];
    [mutablePropertyValues setObject:identifier forKey:@"identifier"];
    
    
    [mutablePropertyValues setObject:[corrected_representation objectForKey:@"priority"] forKey:@"importance"];

    
    [mutablePropertyValues setObject:[corrected_representation objectForKey:@"location"] forKey:@"location_name"];

    [mutablePropertyValues setObject:[corrected_representation objectForKey:@"status"] forKey:@"current_status"];

    
    //[mutablePropertyValues setObject:[NSNumber numberWithInt:[[representation objectForKey:@"completed"] intValue]] forKey:@"completed"];
    if ([[corrected_representation objectForKey:@"last_review"] isEqualToString:@""]) {
        [mutablePropertyValues setObject:[NSNull null] forKey:@"last_review"];
    } else {
        [mutablePropertyValues setObject:[NSNumber numberWithDouble:[[corrected_representation objectForKey:@"last_review"] doubleValue]] forKey:@"last_review"];
    }
    
    
    
    // Customize the response object to fit the expected attribute keys and values  
    return mutablePropertyValues;
}

- (BOOL)shouldFetchRemoteAttributeValuesForObjectWithID:(NSManagedObjectID *)objectID
                                 inManagedObjectContext:(NSManagedObjectContext *)context
{
    return NO;
}

- (BOOL)shouldFetchRemoteValuesForRelationship:(NSRelationshipDescription *)relationship
                               forObjectWithID:(NSManagedObjectID *)objectID
                        inManagedObjectContext:(NSManagedObjectContext *)context
{
    return NO;
}


- (NSMutableURLRequest *)requestForFetchRequest:(NSFetchRequest *)fetchRequest
                                    withContext:(NSManagedObjectContext *)context {
    if ([fetchRequest.entityName isEqualToString:@"WDRequest"]) {
        NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
        NSString *path = [NSString stringWithFormat:@"api/get_requests_list?auth_token=%@", aToken];
        NSMutableURLRequest *request = [[WDAPIClient sharedClient] requestWithMethod:@"POST" path:path parameters:nil];
        [request setHTTPShouldHandleCookies:YES];
        return request;
    }
    return nil;
}

- (NSMutableURLRequest *)requestForUpdatedObject:(NSManagedObject *)updatedObject {
    NSMutableURLRequest* r = [super requestForUpdatedObject:updatedObject];
    NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSString *path = [NSString stringWithFormat:@"api/requests/%@/?auth_token=%@", ((WDRequest*)updatedObject).identifier,aToken];
    [r setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [[WDAPIClient sharedClient].baseURL absoluteString], path]]];
    
    //NSString* s = [NSString stringWithUTF8String:[[r HTTPBody] bytes]];
    //return nil;
    return r;
}


- (NSMutableURLRequest *)requestForInsertedObject:(NSManagedObject *)insertedObject {
    NSMutableURLRequest* r = [super requestForInsertedObject:insertedObject];

    NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSString *path = [NSString stringWithFormat:@"api/create_request?auth_token=%@", aToken];
    [r setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [[WDAPIClient sharedClient].baseURL absoluteString], path]]];
    
    NSString* s = [NSString stringWithUTF8String:[[r HTTPBody] bytes]];
    //return nil;
    return r;
    
}


- (NSMutableURLRequest *)requestForDeletedObject:(NSManagedObject *)deletedObject {
    NSMutableURLRequest* r = [super requestForDeletedObject:deletedObject];
    NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSString *path = [NSString stringWithFormat:@"/api/remove_request?auth_token=%@", aToken];
    [r setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [[WDAPIClient sharedClient].baseURL absoluteString], path]]];
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:((WDRequest*)deletedObject).identifier forKey:@"request_id"];
    NSError* error = nil;
    NSData *json = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];

    [r setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [r setHTTPBody:json];
    [r setHTTPShouldHandleCookies:NO];
    //NSString* s = [NSString stringWithUTF8String:[[r HTTPBody] bytes]];
    //return nil;
    return r;
}



@end
