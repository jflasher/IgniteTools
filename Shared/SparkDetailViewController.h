//
//  SparkDetailViewController.h
//  IgniteTools
//
//  Created by Joseph Flasher on 6/5/11.
//  Copyright 2011 Ars Sollertia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Spark.h"
#import "AvatarDownload.h"

/**
 *	Shows a view with deatails of an individual Spark.
 */
@interface SparkDetailViewController : UIViewController <AvatarDownloadDelegate> {
	Spark *spark;
	IBOutlet UILabel *nameLabel;
	IBOutlet UILabel *presenterLabel;
	IBOutlet UIImageView *presenterAvatar;
	IBOutlet UILabel *eventNameLabel;
	IBOutlet UILabel *eventLocationLabel;
	IBOutlet UILabel *eventDateLabel;
	IBOutlet UIButton *favoritesButton;
	IBOutlet UIButton *videoButton;
	IBOutlet UIActivityIndicatorView *loadingSpinner;
	AvatarDownload *avatarDownload;
}

/**
 *	The Spark we are currently viewing.
 */
@property (nonatomic, retain) Spark *spark;

/**
 *	The name of the spark.
 */
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;

/**
 *	The name of the presenter.
 */
@property (nonatomic, retain) IBOutlet UILabel *presenterLabel;

/**
 *	The avatar of the presenter.
 */
@property (nonatomic, retain) IBOutlet UIImageView *presenterAvatar;

/**
 *	The name of the event for the spark.
 */
@property (nonatomic, retain) IBOutlet UILabel *eventNameLabel;

/**
 *	The location of the event.
 */
@property (nonatomic, retain) IBOutlet UILabel *eventLocationLabel;

/**
 *	The date of the event.
 */
@property (nonatomic, retain) IBOutlet UILabel *eventDateLabel;

/**
 *	The favorites button.
 */
@property (nonatomic, retain) IBOutlet UIButton *favoritesButton;

/**
 *	The button to watch a video.
 */
@property (nonatomic, retain) IBOutlet UIButton *videoButton;

/**
 *	Is this Spark a favorite?
 */
@property BOOL isFavorite;

/**
 *	The avatar download object.
 */
@property (nonatomic, retain) AvatarDownload *avatarDownload;

/**
 *	Loading spinner for avatar.
 */
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingSpinner;

/**
 *	Init with a specific Spark to view.
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil spark:(Spark *)forSpark;

/**
 *	Favorites button has been pressed. Flip the favorites state and save the update to the database.
 *	@param sender The UIButton object.
 */
- (IBAction)favoritesButtonPressed:(id)sender;

/**
 *	Load the webview and watch the YouTube video.
 *	@param sender UIButton object
 */
- (IBAction)videoButtonPressed:(id)sender;

/**
 *	Show the PresenterDetailView
 *	@param sender UIButton object
 */
- (IBAction)presenterButtonPressed:(id)sender;

@end
