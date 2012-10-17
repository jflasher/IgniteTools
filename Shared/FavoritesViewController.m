//
//  FavoritesViewController.m
//  IgniteTools
//
//  Created by Joseph Flasher on 6/4/11.
//  Copyright 2011 Ars Sollertia. All rights reserved.
//

#import "FavoritesViewController.h"
#import "Presenter.h"
#import "Spark.h"
#import "SparkDetailViewController.h"

@implementation FavoritesViewController

@synthesize managedObjectContext, fetchedResultsController;

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
	
	self.title = NSLocalizedString(@"Favorites", @"FavoritesView_Title");
	
	self.managedObjectContext = [(AppDelegate_Shared *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		DLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
}

- (void)viewWillAppear:(BOOL)animated {
    // Force the results controller to update
    fetchedResultsController = nil;
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		DLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}    
    [self.tableView reloadData];

    [super viewWillAppear:animated];
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Spark" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Create the sort descriptors array.
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
	
	// Set isFavorite predicate
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFavorite == %@", [NSNumber numberWithBool:YES]];
    [fetchRequest setPredicate:predicate];
	
    // Create and initialize the fetch results controller.
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:@"uppercaseFirstLetter" cacheName:nil];
    self.fetchedResultsController = aFetchedResultsController;
    fetchedResultsController.delegate = self;
    
    // Memory management.
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
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

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	Spark *spark = [fetchedResultsController objectAtIndexPath:indexPath];
	
	Presenter *presenter = [spark presenter];
    [[cell textLabel] setText:[spark name]];
    [[cell textLabel] setNumberOfLines:0];
    [[cell textLabel] setFont:[UIFont fontWithName:@"Helvetica" size:17.0]];
    [[cell textLabel] setLineBreakMode:UILineBreakModeWordWrap];       
	[[cell detailTextLabel] setText:[presenter name]];
    return cell;
	
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

