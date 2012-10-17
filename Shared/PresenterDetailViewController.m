    //
//  PresenterDetailViewController.m
//  IgniteTools
//
//  Created by Joseph Flasher on 6/5/11.
//  Copyright 2011 Ars Sollertia. All rights reserved.
//

#import "PresenterDetailViewController.h"
#import "WebViewController.h"
#import "Spark.h"
#import "SparkDetailViewController.h"

@implementation PresenterDetailViewController

@synthesize presenter, nameLabel, twitterButton, websiteButton, avatarImageView, sparksTableView, loadingSpinner;
@synthesize managedObjectContext, fetchedResultsController, avatarDownload;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil presenter:(Presenter *)forPresenter {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.presenter = forPresenter;
    }
    return self;
}

- (void)dealloc {
	[presenter release];
	[nameLabel release];
	[twitterButton release];
	[websiteButton release];
	[avatarImageView release];
	[sparksTableView release];
	[loadingSpinner release];
	[managedObjectContext release];
	[fetchedResultsController release];
    [super dealloc];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Set name label
	[nameLabel setText:[presenter name]];
	
	// Enable button if we have ID
	if ([presenter twitterID] == nil || [[presenter twitterID] isEqualToString:@""])
		[twitterButton setEnabled:NO];
	else
		[twitterButton setEnabled:YES];
	
	// Enable button if we have a website URL
	if ([presenter websiteURL] == nil || [[presenter websiteURL] length] == 0)
		[websiteButton setEnabled:NO];
	else
		[websiteButton setEnabled:YES];
	
	// Get the avatar image if we have Twitter info
	if ([presenter twitterID] != nil && ![[presenter twitterID] isEqualToString:@""]) {
		[loadingSpinner startAnimating];
		avatarDownload = [[AvatarDownload alloc] init];
		[avatarDownload setTwitterID:[presenter twitterID]];
		UIImage *image = [avatarDownload image];
		if (!image) {
			[loadingSpinner startAnimating];
			[avatarDownload setDelegate:self];
		}
		else
			[loadingSpinner stopAnimating];
	}
	
	// Load the sparks table view
	self.managedObjectContext = [(AppDelegate_Shared *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		DLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
}

- (void)viewWillAppear:(BOOL)animated {
	// Show nav bar
	[self.navigationController setNavigationBarHidden:NO];
	
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	// Fade out table selection
	[sparksTableView deselectRowAtIndexPath:[sparksTableView indexPathForSelectedRow] animated:YES];
	
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[avatarDownload setDelegate:nil];
}

#pragma mark -
#pragma mark Class Methods

- (IBAction)websiteButtonPressed:(id)sender {
	if ([presenter websiteURL] == nil || [[presenter websiteURL] length] == 0)
		return;
	
	NSURL *url = [NSURL URLWithString:[presenter websiteURL]];
	WebViewController *vc = [[WebViewController alloc] initWithNibName:@"WebView" bundle:nil loadURL:url];
	[self.navigationController pushViewController:vc animated:YES];
	[vc release];
}

- (IBAction)twitterButtonPressed:(id)sender {
	if ([presenter twitterID] == nil || [[presenter twitterID] length] == 0)
		return;
	
	NSString *twitterID = [[presenter twitterID] stringByReplacingOccurrencesOfString:@"@" withString:@""];
	NSString *string = [NSString stringWithFormat:@"http://twitter.com/%@", twitterID];
	NSURL *url = [NSURL URLWithString:string];
	WebViewController *vc = [[WebViewController alloc] initWithNibName:@"WebView" bundle:nil loadURL:url];
	[self.navigationController pushViewController:vc animated:YES];
	[vc release];
}
	
#pragma mark -
#pragma mark Avatar Download Delegate Methods
- (void)downloadDidFinishDownloading:(AvatarDownload *)aDownload {
	[avatarImageView setImage:[aDownload image]];
	[loadingSpinner stopAnimating];
	[aDownload setDelegate:nil];
}

- (void)download:(AvatarDownload *)download didFailWithError:(NSError *)error {
	DLog(@"Error: %@", [error localizedDescription]);
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
	
	// Create a predicate
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"presenter == %@", presenter];
	[fetchRequest setPredicate:predicate];
	
	aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];		

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
	UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:20.0];
	CGSize constraintSize = CGSizeMake(size, MAXFLOAT);
	CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
	
	// Add a buffer
	return labelSize.height + 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
	return [sectionInfo numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [[[fetchedResultsController sections] objectAtIndex:section] name];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	Spark *spark = [fetchedResultsController objectAtIndexPath:indexPath];
    [[cell textLabel] setText:[spark name]];
    [[cell textLabel] setNumberOfLines:0];
    [[cell textLabel] setFont:[UIFont fontWithName:@"Helvetica" size:20.0]];
    [[cell textLabel] setLineBreakMode:UILineBreakModeWordWrap];
    [[cell textLabel] setTextAlignment:UITextAlignmentCenter];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];

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
