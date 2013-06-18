#import "AFIncrementalStore.h"
#import "AFRestClient.h"

@interface WDAPIClient : AFRESTClient <AFIncrementalStoreHTTPClient>

+ (WDAPIClient *)sharedClient;

@end
