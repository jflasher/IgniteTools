//
//  UpdateViewController.h
//  IgniteTools
//
//  Created by Joseph Flasher on 6/2/11.
//  Copyright 2011 Ars Sollertia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "Presenter.h"

/**
 *	UIViewController in charge of providing an image to show while checking online for any updates. 
 *	Will send out a notification when an update has completed or failed so we can remove the image and
 *	show the tab bar view.
 */
@interface UpdateViewController : UIViewController <ASIHTTPRequestDelegate> {
	IBOutlet UIImageView *loadingImageView;
	IBOutlet UIActivityIndicatorView *loadingSpinner;
	IBOutlet UILabel *loadingLabel;
	NSInteger messageDelay;
	NSManagedObjectContext *managedObjectContext;
}

/**
 *	The image view of the loading image. I THINK WE CAN REMOVE THIS.
 */
@property (nonatomic, retain) IBOutlet UIImageView *loadingImageView;

/**
 *	Spinner to indicate loading. Will start spinning on view load.
 */
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingSpinner;

/**
 *	The label that will display loading text messages.
 */
@property (nonatomic, retain) IBOutlet UILabel *loadingLabel;

/**
 *	The number of seconds to display the loading messages before the view goes away.
 */
@property NSInteger messageDelay;

/**
 *	The managedObjectContext
 */
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

/**
 *	Given an array of speakers and events, overwrite the current Core Data file with the new values.
 *	@param events NSArray of Event objects.
 *	@param speakers NSArray of Presenter objects.
 */
- (void)saveToCoreData:(NSArray *)events andSpeakers:(NSArray *)speakers;

/**
 *	The request to get the server version of the data file failed.
 *	@param request The ASIHTTPRequest object.
 */
- (void)versionRequestDidFail:(ASIHTTPRequest *)request;

/**
 *	The request to get the server version of the data file finished.
 *	@param request The ASIHTTPRequest object.
 */
- (void)versionRequestDidFinish:(ASIHTTPRequest *)request;

/**
 *	The request to download the data file failed.
 *	@param request The ASIHTTPRequest object.
 */
- (void)dataRequestDidFail:(ASIHTTPRequest *)request;

/**
 *	The request to download the data file finished.
 *	@param request The ASIHTTPRequest object.
 */
- (void)dataRequestDidFinish:(ASIHTTPRequest *)request;

/**
 *	Check the current context for a presenter of the given name and return the entity if it exists.
 *	@param name The name of the presenter to search for.
 *	@return Will return a Presenter object if one exists or nil if one is not found.
 */
- (Presenter *)checkForExistingPresenter:(NSString *)name;

/**
 *	Find all the favorites in data and return their title.
 */
- (NSArray *)findFavorites;

@end
