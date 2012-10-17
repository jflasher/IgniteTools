//
//  EventsTableViewController.m
//  IgniteTools
//
//  Created by Joseph Flasher on 6/3/11.
//  Copyright 2011 Ars Sollertia. All rights reserved.
//

#import "EventsTableViewController.h"
#import "Event.h"
#import "SparksTableViewController.h"

@implementation EventsTableViewController

@synthesize fetchedResultsController, managedObjectContext, eventCell;

#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
    // Release any properties that are loaded in viewDidLoad or can be recreated lazily.
    self.fetchedResultsController = nil;
}


- (void)dealloc {
	[fetchedResultsController release];
	[managedObjectContext release];
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = NSLocalizedString(@"Events", @"EventsTableView_Title");
	
	self.managedObjectContext = [(AppDelegate_Shared *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
	 // TODO: Update to handle the error appropriately.
	 DLog(@"Unresolved error %@, %@", error, [error userInfo]);
	 exit(-1);  // Fail
	}
}

- (void)viewWillAppear {
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Fetched results controller

/**
 Returns the fetched results controller. Creates and configures the controller if necessary.
 */
- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
    // Create and configure a fetch request with the Book entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Create the sort descriptors array.
    NSSortDescriptor *dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:dateDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Create and initialize the fetch results controller.
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"AllEvents"];
    self.fetchedResultsController = aFetchedResultsController;
    fetchedResultsController.delegate = self;
    
    // Memory management.
    [aFetchedResultsController release];
    [fetchRequest release];
    [dateDescriptor release];
    [sortDescriptors release];
    
    return fetchedResultsController;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventCell *cell = (EventCell *)[tableView dequeueReusableCellWithIdentifier:[EventCell reuseIdentifier]];
    if (cell == nil) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [[NSBundle mainBundle] loadNibNamed:@"EventCell_iPhone" owner:self options:nil];
        } else {
            [[NSBundle mainBundle] loadNibNamed:@"EventCell_iPad" owner:self options:nil];
        }
		cell = eventCell;
		self.eventCell = nil;
    }
    
    // Configure the cell...
    Event *event = [fetchedResultsController objectAtIndexPath:indexPath];
	cell.nameLabel.text = [event name];
	NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"MMMM d, yyyy"];
	NSString *dateString = [dateFormatter stringFromDate:[event date]];		
	cell.dateLabel.text = dateString;
	cell.locationLabel.text = [event location];
	cell.detailLabel.text = [NSString stringWithFormat:@"%i speakers", [[event sparks] count]];
	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	SparksTableViewController *vc = [[SparksTableViewController alloc] initWithNibName:@"SparksTableView_iPhone" bundle:nil 
																				 event:[fetchedResultsController objectAtIndexPath:indexPath]];
	[self.navigationController pushViewController:vc animated:YES];
	[vc release]; 
}


@end

