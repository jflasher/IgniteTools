//
//  EventsTableViewController.h
//  IgniteTools
//
//  Created by Joseph Flasher on 6/3/11.
//  Copyright 2011 Ars Sollertia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "EventCell.h"

/**
 *	UITableViewController that shows all the Event entries.
 */
@interface EventsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	IBOutlet EventCell *eventCell;
}

/**
 *	NSFetchedResultsController that contains all the events.
 */
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

/**
 *	The NSManagedObjectContext for the session.
 */
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

/**
 *	The Event cell.
 */
@property (nonatomic, retain) IBOutlet EventCell *eventCell;

@end
