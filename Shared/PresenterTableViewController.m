//
//  PresenterTableViewController.m
//  IgniteTools
//
//  Created by Joseph Flasher on 6/5/11.
//  Copyright 2011 Ars Sollertia. All rights reserved.
//

#import "PresenterTableViewController.h"
#import "Presenter.h"
#import "PresenterDetailViewController.h"

@implementation PresenterTableViewController

@synthesize fetchedResultsController, managedObjectContext, avatars;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = NSLocalizedString(@"Presenters", @"PresenterTableView_Title");
	
	self.managedObjectContext = [(AppDelegate_Shared *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	
	NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        DLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    
    [self createAvatarsArray];
}

- (void)viewWillAppear {
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Class methods
- (void)createAvatarsArray {
    self.avatars = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [[self.fetchedResultsController fetchedObjects] count]; i++) {
        AvatarDownload *avatarDownload = [[AvatarDownload alloc] init];
        [self.avatars addObject:avatarDownload];
        [avatarDownload release];  
    }
}

- (int)indexForIndexPath:(NSIndexPath *)indexPath {
    int index = 0;
    
    for (int i = 0; i < [indexPath section]; i++) {
        index += [[[self.fetchedResultsController sections] objectAtIndex:i] numberOfObjects];
    }
    
    index += [indexPath row];
    
    //DLog(@"%i, %i, %i", indexPath.row, indexPath.section, index);
    
    return index;
}

- (NSIndexPath *)indexPathForIndex:(int)index {
    int row = 0;
    int section = 0;
    int testIndex = -1;
    
    for (int i = 0; i <= [[self.fetchedResultsController sections] count]; i++) {
        section = i;
        testIndex += [[[self.fetchedResultsController sections] objectAtIndex:i] numberOfObjects];
        if (index <= testIndex) {
            break;
        }
    }
    
    row = index - [self indexForIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    
    //DLog(@"%i, %i, %i", row, section, index);
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}

#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
    // Release any properties that are loaded in viewDidLoad or can be recreated lazily.
    self.fetchedResultsController = nil;
}


- (void)dealloc {
    [avatars release];
	[managedObjectContext release];
	[fetchedResultsController release];
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
    
    // Create and configure a fetch request with the Book entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Presenter" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Create the sort descriptors array.
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Create and initialize the fetch results controller.
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:@"uppercaseFirstLetter" cacheName:@"AllPresenters"];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
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
	Presenter *presenter = [fetchedResultsController objectAtIndexPath:indexPath];
	
    [[cell textLabel] setText:[presenter name]];
    [[cell textLabel] setFont:[UIFont fontWithName:@"Helvetica" size:17.0]];
	
	// If we can, get the twitter avatar
	if ([presenter twitterID] != nil && ![[presenter twitterID] isEqualToString:@""]) {
		AvatarDownload *avatarDownload = [self.avatars objectAtIndex:[self indexForIndexPath:indexPath]];
        if (![avatarDownload twitterID]) {
            [avatarDownload setTwitterID:[presenter twitterID]];
        }
		UIImage *image = [avatarDownload image];
		if (!image) {
            [[cell imageView] setImage:[UIImage imageNamed:@"defaultAvatar.png"]];
			[avatarDownload setDelegate:self];
		} else {
            [[cell imageView] setImage:image];
        }
	} else {
        [[cell imageView] setImage:[UIImage imageNamed:@"defaultAvatar.png"]];
    }
	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	Presenter *presenter = [fetchedResultsController objectAtIndexPath:indexPath];
	
    PresenterDetailViewController *vc = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        vc = [[PresenterDetailViewController alloc] initWithNibName:@"PresenterDetailView_iPhone" bundle:nil presenter:presenter];
    } else {
        vc = [[PresenterDetailViewController alloc] initWithNibName:@"PresenterDetailView_iPad" bundle:nil presenter:presenter];
    }    
	[self.navigationController pushViewController:vc animated:YES];
	[vc release];
}

#pragma mark -
#pragma mark Avatar Download Delegate Methods
- (void)downloadDidFinishDownloading:(AvatarDownload *)aDownload {
	NSIndexPath *indexPath = [self indexPathForIndex:[self.avatars indexOfObject:aDownload]];
	[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	[aDownload setDelegate:nil];
}

- (void)download:(AvatarDownload *)download didFailWithError:(NSError *)error {
	DLog(@"Error: %@", [error localizedDescription]);
}

@end

