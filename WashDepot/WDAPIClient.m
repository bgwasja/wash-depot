#import "WDAPIClient.h"
#import "AFJSONRequestOperation.h"
#import "WDRequest.h"

static NSString * const kToDoAPIBaseURLString = @"http://wash-depot.herokuapp.com/";

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
    NSMutableDictionary *mutablePropertyValues = [[super attributesForRepresentation:representation ofEntity:entity fromResponse:response] mutableCopy];
    
    [mutablePropertyValues setObject:[representation objectForKey:@"description"] forKey:@"desc"];
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:[[representation objectForKey:@"creation_date"] doubleValue]];
    [mutablePropertyValues setObject:myDate forKey:@"date"];
        
    //[mutablePropertyValues setObject:[NSNumber numberWithInt:[[representation objectForKey:@"completed"] intValue]] forKey:@"completed"];
    if ([[representation objectForKey:@"last_review"] isEqualToString:@""]) {
        [mutablePropertyValues setObject:[NSNull null] forKey:@"last_review"];
    } else {
        [mutablePropertyValues setObject:[NSNumber numberWithDouble:[[representation objectForKey:@"last_review"] doubleValue]] forKey:@"last_review"];
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
        NSString *path = [NSString stringWithFormat:@"api/requests?auth_token=%@", aToken];
        NSMutableURLRequest *request = [[WDAPIClient sharedClient] requestWithMethod:@"GET" path:path parameters:nil];
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




@end
