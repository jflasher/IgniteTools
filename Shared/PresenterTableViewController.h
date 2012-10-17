//
//  PresenterTableViewController.h
//  IgniteTools
//
//  Created by Joseph Flasher on 6/5/11.
//  Copyright 2011 Ars Sollertia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "AvatarDownload.h"

/**
 *	UITableViewController which shows all presenters or presenters for an event depending on if Event variable
 *	is set on load.
 */
@interface PresenterTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, AvatarDownloadDelegate> {
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
    NSMutableArray *avatars;
}

/**
 *	NSFetchedResultsController that contains all presenters.
 */
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

/**
 *	Session NSManagedObjectContext.
 */
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

/**
 *  The array of avatars.
 */
@property (nonatomic, retain) NSMutableArray *avatars;

/**
 *  Create the avatars array
 */
- (void)createAvatarsArray;

@end
