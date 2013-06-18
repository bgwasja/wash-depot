#import "WDAPIClient.h"
#import "AFJSONRequestOperation.h"

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


@end