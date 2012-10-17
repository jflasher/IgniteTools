    //
//  SparkDetailViewController.m
//  IgniteTools
//
//  Created by Joseph Flasher on 6/5/11.
//  Copyright 2011 Ars Sollertia. All rights reserved.
//

#import "SparkDetailViewController.h"
#import "Spark.h"
#import "Presenter.h"
#import "Event.h"
#import "PresenterDetailViewController.h"
#import "WebViewController.h"

@implementation SparkDetailViewController

@synthesize spark, nameLabel, presenterLabel, presenterAvatar, eventNameLabel, eventLocationLabel;
@synthesize eventDateLabel, favoritesButton, videoButton, isFavorite, loadingSpinner, avatarDownload;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil spark:(Spark *)forSpark {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.spark = forSpark;
    }
    return self;
}

- (void)viewDidLoad {
	[nameLabel setText:[spark name]];
	
	if ([[spark videoURL] isEqualToString:@""])
		[videoButton setEnabled:NO];
	else
		[videoButton setEnabled:YES];
	
	self.isFavorite = [[spark isFavorite] boolValue];
	NSString *imageName = isFavorite ? @"favoriteDelete.png" : @"favoriteAdd.png";
	[favoritesButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
	
	Presenter *presenter = [spark presenter];
	[presenterLabel setText:[presenter name]];
	
	[eventNameLabel setText:[[spark event] name]];
	[eventLocationLabel setText:[[spark event] location]];
	NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"MMMM d, yyyy"];
	NSString *dateString = [dateFormatter stringFromDate:[[spark event] date]];		
	[eventDateLabel setText:dateString];
	
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
}

- (void)viewWillAppear:(BOOL)animated {
	[self.navigationController setNavigationBarHidden:NO];
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[avatarDownload setDelegate:nil];
}

#pragma mark -
#pragma mark Class Methods

- (IBAction)favoritesButtonPressed:(id)sender {
	NSManagedObjectContext *managedObjectContext = [(AppDelegate_Shared *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Spark" inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self == %@", spark];
	[request setPredicate:predicate];
	
	NSError *error = nil;
	NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
	
	if (array == nil) {
		// Deal with error
		return;
	}
	
	// Switch favorite state
	isFavorite = isFavorite ? NO : YES;
	
	Spark *fetchedSpark = [array objectAtIndex:0];
	[fetchedSpark setIsFavorite:[NSNumber numberWithBool:isFavorite]];
	
	if (![managedObjectContext save:&error]) {
		// Handle the error.
		DLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}

	// Update button image
	NSString *imageName = isFavorite ? @"favoriteDelete.png" : @"favoriteAdd.png";
	[favoritesButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (IBAction)presenterButtonPressed:(id)sender {
    PresenterDetailViewController *vc = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        vc = [[PresenterDetailViewController alloc] initWithNibName:@"PresenterDetailView_iPhone" bundle:nil presenter:[spark presenter]];
    } else {
        vc = [[PresenterDetailViewController alloc] initWithNibName:@"PresenterDetailView_iPad" bundle:nil presenter:[spark presenter]];
    }  
	[self.navigationController pushViewController:vc animated:YES];
	[vc release];
}

- (IBAction)videoButtonPressed:(id)sender {
	if ([spark videoURL] == nil || [[spark videoURL] length] == 0)
		return;
	
	NSURL *url = [NSURL URLWithString:[spark videoURL]];
	WebViewController *vc = [[WebViewController alloc] initWithNibName:@"WebView" bundle:nil loadURL:url];
	[self.navigationController pushViewController:vc animated:YES];
	[vc release];	
}

#pragma mark -
#pragma mark Avatar Download Delegate Methods
- (void)downloadDidFinishDownloading:(AvatarDownload *)aDownload {
	[presenterAvatar setImage:[aDownload image]];
	[loadingSpinner stopAnimating];
	aDownload.delegate = nil;
}

- (void)download:(AvatarDownload *)download didFailWithError:(NSError *)error {
	DLog(@"Error: %@", [error localizedDescription]);
}

- (void)dealloc {
	[spark release];
	[nameLabel release];
	[presenterLabel release];
	[presenterAvatar release];
	[eventNameLabel release];
	[eventLocationLabel release];
	[eventDateLabel release];
	[favoritesButton release];
	[videoButton release];
	[loadingSpinner release];
    [super dealloc];
}


@end
