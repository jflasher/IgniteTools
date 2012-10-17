//
//  AppDelegate_Shared.h
//  IgniteTools
//
//  Created by Joseph Flasher on 6/2/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "UAPush.h"
#import "UAirship.h"

/**
 *	The Application Delegate which takes care of most Core Data functions.
 */
@interface AppDelegate_Shared : NSObject <UIApplicationDelegate> {
    IBOutlet UIWindow *window;
    
@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

/**
 *	Main window of the app.
 */
@property (nonatomic, retain) IBOutlet UIWindow *window;

/**
 *	The Core Data NSManagedObjectContext.
 */
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

/**
 *	The Core Data NSManagedObjectModel.
 */
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;

/**
 *	The Core Data NSPersistenStoreCoordinator.
 */
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/**
 *	Get the user's documents directory.
 *	@return NSURL of user's documents directory.
 */
- (NSURL *)applicationDocumentsDirectory;

/**
 *	Save the Core Data context.
 */
- (void)saveContext;

@end

