//
//  SparksTableViewController.h
//  IgniteTools
//
//  Created by Joseph Flasher on 6/3/11.
//  Copyright 2011 Ars Sollertia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Event.h"
#import "Presenter.h"

/**
 *	UITableViewController that shows all sparks or a subset if sparksList is set.
 */
@interface SparksTableViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	Event *event;
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
}

/**
 *	NSFetchedResultsController that contains all sparks.
 */
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

/**
 *	Session NSManagedObjectContext.
 */
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

/**
 *	The event of which to show the sparks.
 */
@property (nonatomic, retain) Event *event;

/**
 *	Initializer table showing only Sparks for an Event.
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil event:(Event *)forEvent;

@end
