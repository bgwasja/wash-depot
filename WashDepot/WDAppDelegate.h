//
//  WDAppDelegate.h
//  WashDepot
//
//  Created by Balazh Vasyl on 6/10/13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDIncrementalStore.h"
#import "Reachability.h"

@interface WDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (assign, nonatomic) NetworkStatus netStatus;
@property (strong, nonatomic) Reachability  *hostReach;
@property (nonatomic, strong) NSMutableDictionary *imageDict;

- (void)updateInterfaceWithReachability: (Reachability*) curReach;

@property (nonatomic, strong) NSTimer* syncTimer;
@property (nonatomic, assign) BOOL needCreateNewRequest;

- (void) createSyncTimer;

@end
