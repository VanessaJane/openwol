//
//  openwolAppDelegate.h
//  openwol
//
//  Created by iceboundrock on 09-12-28.
//  Copyright Lychee Studio 2009. All rights reserved.
//
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface openwolAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    
	IBOutlet UINavigationController* _navController;
	
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	
}

@property (nonatomic, retain) UINavigationController* navController;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) IBOutlet UIWindow *window;

- (NSString *)applicationDocumentsDirectory;

@end

