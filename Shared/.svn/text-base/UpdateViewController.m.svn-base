    //
//  UpdateViewController.m
//  IgniteTools
//
//  Created by Joseph Flasher on 6/2/11.
//  Copyright 2011 Ars Sollertia. All rights reserved.
//

#import "UpdateViewController.h"
#import "Reachability.h"
#import "JSON.h"
#import "Event.h"
#import "Spark.h"
#import <CoreData/CoreData.h>

@implementation UpdateViewController

@synthesize loadingSpinner, loadingImageView, loadingLabel, messageDelay, managedObjectContext;

- (void)viewDidLoad {
	messageDelay = 2;
	
	[loadingLabel setText:NSLocalizedString(@"Checking for updates...", @"UpdateView_CheckForUpdates")];
	
	AppDelegate_Shared *delegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
	self.managedObjectContext = [delegate managedObjectContext];
	
	// If we have no data version on the disk, copy over the local file to start with
	NSInteger localVersion = [[[NSUserDefaults standardUserDefaults] objectForKey:@"dataVersion"] integerValue];
	if (localVersion == 0) {
		SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
		NSURL *jsonURL = [[NSBundle mainBundle] URLForResource:@"igniteToolsData" withExtension:@"json"];
		NSString *jsonString = [NSString stringWithContentsOfURL:jsonURL usedEncoding:nil error:nil];
		NSDictionary *jsonDict = [[parser objectWithString:jsonString error:nil] valueForKey:@"IgniteTools"];
		[self saveToCoreData:[jsonDict valueForKey:@"events"] andSpeakers:[jsonDict valueForKey:@"speakers"]];
		[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:1] forKey:@"dataVersion"];
	}
	
	// If we have no connection, error out and send an event
	BOOL isReachable = [[Reachability reachabilityForInternetConnection] isReachable];
	
	if (!isReachable) {
		[loadingSpinner stopAnimating];
		[loadingLabel setText:NSLocalizedString(@"No connection.", @"UpdateView_NoConnection")];
		[self performSelector:@selector(postUpdateCompleteNotification:) withObject:nil afterDelay:messageDelay];
	}
	
	// Check the server version of the data file
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ApplicationInformation" ofType:@"plist"];
	NSDictionary *applicationInformation = [NSDictionary dictionaryWithContentsOfFile:filePath];
	NSURL *url = [NSURL URLWithString:[applicationInformation valueForKey:@"igniteToolsVersionURL"]];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDidFailSelector:@selector(versionRequestDidFail:)];
	[request setDidFinishSelector:@selector(versionRequestDidFinish:)];
	[request setDelegate:self];
	[request startAsynchronous];
}

#pragma mark -
#pragma mark Class methods

- (void)saveToCoreData:(NSArray *)events andSpeakers:(NSArray *)speakers {
	// Get the favorites before we do anything
	NSArray *favorites = [self findFavorites];
	
	// Remove the persistent store coordinator and recreate it
	AppDelegate_Shared *delegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
	NSPersistentStoreCoordinator *storeCoordinator = [delegate persistentStoreCoordinator];
	NSPersistentStore *store = [[storeCoordinator persistentStores] objectAtIndex:0];
	NSURL *storeURL = [store URL];
	[storeCoordinator removePersistentStore:store error:nil];
	[[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
    if (![storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:nil]) {
		// Error message
	}
	
	// Convert events array into Core Data objects
	for (NSDictionary *eventDict in events) {
		Event *event = (Event *)[NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:managedObjectContext];
		[event setName:[eventDict valueForKey:@"name"]];
		[event setLocation:[eventDict valueForKey:@"location"]];
		
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyyMMdd"];
		[event setDate:[dateFormatter dateFromString:[eventDict valueForKey:@"date"]]];
        [dateFormatter release];
		
		NSMutableSet *sparksSet = [NSMutableSet set];
		NSArray *sparks = [eventDict valueForKey:@"sparks"];
		for (NSDictionary *sparkDict in sparks) {
			Spark *spark = (Spark *)[NSEntityDescription insertNewObjectForEntityForName:@"Spark" inManagedObjectContext:managedObjectContext];
			[spark setName:[sparkDict valueForKey:@"name"]];
			[spark setVideoURL:[sparkDict valueForKey:@"videoURL"]];
			
			// Check to see if a Presenter already exits, if not, make a new one
			Presenter *existingPresenter = [self checkForExistingPresenter:[sparkDict valueForKey:@"presenter"]];
			if (existingPresenter) {
				[spark setPresenter:existingPresenter];
			}
			else {
				Presenter *presenter = (Presenter *)[NSEntityDescription insertNewObjectForEntityForName:@"Presenter" inManagedObjectContext:managedObjectContext];
				[presenter setName:[sparkDict valueForKey:@"presenter"]];
				[spark setPresenter:presenter];
			}
			
			// Check to see if this spark was a favorite
			if ([favorites containsObject:[spark name]])
				[spark setIsFavorite:[NSNumber numberWithBool:YES]];
			
			// Add to set
			[sparksSet addObject:spark];
		}
		
		// Add sparks to event
		[event setSparks:[NSSet setWithSet:sparksSet]];
	}
	
	// Add speaker info to already existing speaker objects
	for (NSDictionary *speakerDict in speakers) {
		Presenter *existingPresenter = [self checkForExistingPresenter:[speakerDict valueForKey:@"name"]];
		if (existingPresenter) {
			[existingPresenter setTwitterID:[speakerDict valueForKey:@"twitterID"]];
			[existingPresenter setWebsiteURL:[speakerDict valueForKey:@"websiteURL"]];
		}
	}
	
	// Commit the changes
	NSError *error;
	if (![managedObjectContext save:&error]) {
		// Handle the error.
		DLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
}
			 
- (Presenter *)checkForExistingPresenter:(NSString *)name {
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Presenter" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
 
	[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name == %@", name]];
 
	NSError *error = nil;
	NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
	if (fetchedObjects == nil) {
	 // Handle the error
	}

	[fetchRequest release];

	if ([fetchedObjects count] == 0)
		return nil;
	else
		return [fetchedObjects objectAtIndex:0];
}

- (NSArray *)findFavorites {
	// Get all the Sparks that have isFavorite set to YES
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Spark" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
	
	// Set isFavorite predicate
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFavorite == %@", [NSNumber numberWithBool:YES]];
    [fetchRequest setPredicate:predicate];
	
	NSError *error;
	NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
	
	[fetchRequest release];
	
	if (!results) {
		// Update to handle the error appropriately.
		DLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
	
	NSMutableArray *titles = [NSMutableArray arrayWithCapacity:[results count]];
	
	for (Spark *spark in results)
		[titles addObject:[spark name]];
	
	return titles;
}

#pragma mark -
#pragma mark ASIHTTPRequest methods

- (void)versionRequestDidFail:(ASIHTTPRequest *)request {
	[loadingLabel setText:NSLocalizedString(@"Unable to update.", @"UpdateView_UpdateFail")];
	[self performSelector:@selector(postUpdateCompleteNotification:) withObject:nil afterDelay:messageDelay];	
}

- (void)versionRequestDidFinish:(ASIHTTPRequest *)request {
	SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
	NSInteger serverVersion = [[[parser objectWithString:[request responseString] error:nil] valueForKey:@"version"] integerValue];
	
	// Get the local data file version
	NSInteger localVersion = [[[NSUserDefaults standardUserDefaults] objectForKey:@"dataVersion"] integerValue];
	DLog(@"Server version is: %i. Local version is: %i.", serverVersion, localVersion);
	if (serverVersion > localVersion) {
		[loadingLabel setText:NSLocalizedString(@"Downloading update.", @"UpdateView_Downloading")];
		
		// Get the URL
		NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ApplicationInformation" ofType:@"plist"];
		NSDictionary *applicationInformation = [NSDictionary dictionaryWithContentsOfFile:filePath];
		NSURL *url = [NSURL URLWithString:[applicationInformation valueForKey:@"igniteToolsDataURL"]];
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
		[request setDidFailSelector:@selector(dataRequestDidFail:)];
		[request setDidFinishSelector:@selector(dataRequestDidFinish:)];
		[request setUserInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:serverVersion] forKey:@"dataVersion"]];
		[request setDelegate:self];
		[request startAsynchronous];		
	}
	else {
		[loadingLabel setText:NSLocalizedString(@"No updates available.", @"UpdateView_NoUpdates")];
		[self performSelector:@selector(postUpdateCompleteNotification:) withObject:nil afterDelay:messageDelay];		
	}
}

- (void)dataRequestDidFail:(ASIHTTPRequest *)request {
	[loadingLabel setText:NSLocalizedString(@"Unable to update.", @"UpdateView_UpdateFail")];
	[self performSelector:@selector(postUpdateCompleteNotification:) withObject:nil afterDelay:messageDelay];
}

- (void)dataRequestDidFinish:(ASIHTTPRequest *)request {
	// Get the requested data
	SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
	NSDictionary *jsonDict = [[parser objectWithString:[request responseString] error:nil] valueForKey:@"IgniteTools"];
	
	// Save new data to Core Data
	[self saveToCoreData:[jsonDict valueForKey:@"events"] andSpeakers:[jsonDict valueForKey:@"speakers"]];
	
	// Update local version number
	NSNumber *serverVersion = [[request userInfo] valueForKey:@"dataVersion"];
	[[NSUserDefaults standardUserDefaults] setValue:serverVersion forKey:@"dataVersion"];
	
	[loadingLabel setText:NSLocalizedString(@"Update complete.", @"UpdateView_UpdateComplete")];
	[self performSelector:@selector(postUpdateCompleteNotification:) withObject:nil afterDelay:messageDelay];
}

- (void)postUpdateCompleteNotification:(id)sender {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateComplete" object:nil];
}
	 
- (void)dealloc {
	[loadingSpinner release];
	[loadingImageView release];
	[loadingLabel release];
	[managedObjectContext release];
    [super dealloc];
}

@end
