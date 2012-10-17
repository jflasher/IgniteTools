//
//  FavoritesViewController.h
//  IgniteTools
//
//  Created by Joseph Flasher on 6/4/11.
//  Copyright 2011 Ars Sollertia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

/**
 *	A table view to display any sparks which have been marked as favorites.
 */
@interface FavoritesViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
}

/**
 *	NSFetchedResultsController that contains the favorite sparks.
 */
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

/**
 *	The NSManagedObjectContext for the session.
 */
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
