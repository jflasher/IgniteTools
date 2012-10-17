//
//  SparksTableViewController.m
//  IgniteTools
//
//  Created by Joseph Flasher on 6/3/11.
//  Copyright 2011 Ars Sollertia. All rights reserved.
//

#import "SparksTableViewController.h"
#import "Spark.h"
#import "SparkDetailViewController.h"

@implementation SparksTableViewController

@synthesize event, fetchedResultsController, managedObjectContext;

#pragma mark -
#pragma mark Initializers

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil event:(Event *)forEvent {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.event = forEvent;
    }
    return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = NSLocalizedString(@"Sparks", @"SparksTableView_Title");
	
	self.managedObjectContext = [(AppDelegate_Shared *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		DLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
}

- (void)viewWillAppear {
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
    // Release any properties that are loaded in viewDidLoad or can be recreated lazily.
    self.fetchedResultsController = nil;
}


- (void)dealloc {
	[managedObjectContext release];
	[fetchedResultsController release];
	[event release];
    [super dealloc];
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
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSFetchedResultsController *aFetchedResultsController = nil;
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Spark" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Create the sort descriptors array.
	NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];	
	
	// Build up the fetch request based on what information we've been given
	if (event) {
		// Create a predicate
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"event == %@", event];
		[fetchRequest setPredicate:predicate];
		
		aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:@"uppercaseFirstLetter" cacheName:nil];		
	}
	else {
		// Create and initialize the fetch results controller.
		aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:@"uppercaseFirstLetter" cacheName:@"AllSparks"];
	}
	
	self.fetchedResultsController = aFetchedResultsController;
	fetchedResultsController.delegate = self;
	
	[aFetchedResultsController release];
	[fetchRequest release];
	[nameDescriptor release];
	[sortDescriptors release];	
	
	return fetchedResultsController;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return [[fetchedResultsController sections] count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [fetchedResultsController sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo name];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
	return [sectionInfo numberOfObjects];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// Make sure text can fit in cell without clipping
	
    Spark *spark = [fetchedResultsController objectAtIndexPath:indexPath];
	
	// Get size
    float size;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        size = 300.0;
    } else {
        size = 748.0;
    }
	NSString *cellText = [spark name];
	UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
	CGSize constraintSize = CGSizeMake(size, MAXFLOAT);
	CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
	
	// Add a buffer
	return labelSize.height + 40;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	Spark *spark = [fetchedResultsController objectAtIndexPath:indexPath];
	
	Presenter *cellPresenter = [spark presenter];
    [[cell textLabel] setText:[spark name]];
	[[cell detailTextLabel] setText:[cellPresenter name]];
    [[cell textLabel] setNumberOfLines:0];
    [[cell textLabel] setFont:[UIFont fontWithName:@"Helvetica" size:17.0]];
    [[cell textLabel] setLineBreakMode:UILineBreakModeWordWrap];
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	Spark *spark = [fetchedResultsController objectAtIndexPath:indexPath];

    SparkDetailViewController *vc = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        vc = [[SparkDetailViewController alloc] initWithNibName:@"SparkDetailView_iPhone" bundle:nil spark:spark];
    } else {
        vc = [[SparkDetailViewController alloc] initWithNibName:@"SparkDetailView_iPad" bundle:nil spark:spark];
    }
	[self.navigationController pushViewController:vc animated:YES];
	[vc release];
}


@end

