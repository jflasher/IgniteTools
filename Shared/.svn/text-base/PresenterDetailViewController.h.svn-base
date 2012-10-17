//
//  PresenterDetailViewController.h
//  IgniteTools
//
//  Created by Joseph Flasher on 6/5/11.
//  Copyright 2011 Ars Sollertia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Presenter.h"
#import "AvatarDownload.h"

/**
 *	Shows details for a presenter.
 */
@interface PresenterDetailViewController : UIViewController <AvatarDownloadDelegate, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate> {
	Presenter *presenter;
	IBOutlet UILabel *nameLabel;
	IBOutlet UIButton *twitterButton;
	IBOutlet UIButton *websiteButton;
	IBOutlet UIImageView *avatarImageView;
	IBOutlet UITableView *sparksTableView;
	IBOutlet UIActivityIndicatorView *loadingSpinner;
	NSManagedObjectContext *managedObjectContext;
	NSFetchedResultsController *fetchedResultsController;
	AvatarDownload *avatarDownload;
}

/**
 *	The Presenter object from which to get the display data.
 */
@property (nonatomic, retain) Presenter *presenter;

/**
 *	The name of the presenter.
 */
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;

/**
 *	The button to go to Twitter.
 */
@property (nonatomic, retain) IBOutlet UIButton *twitterButton;

/**
 *	The button to load user's website.
 */
@property (nonatomic, retain) IBOutlet UIButton *websiteButton;

/**
 *	Image view of the user's Twitter picture.
 */
@property (nonatomic, retain) IBOutlet UIImageView *avatarImageView;

/**
 *	The table view showing the user's sparks.
 */
@property (nonatomic, retain) IBOutlet UITableView *sparksTableView;

/**
 *	Indicator that the image is loading.
 */
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingSpinner;

/**
 *	Fetched results controller for the sparks.
 */
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

/**
 *	Session managed object context.
 */
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

/**
 *	The avatar download object.
 */
@property (nonatomic, retain) AvatarDownload *avatarDownload;

/**
 *	Init for a given Presenter.
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil presenter:(Presenter *)forPresenter;

/**
 *	Load the web view with user's Twitter page.
 *	@param sender UIButton object.
 */
- (IBAction)twitterButtonPressed:(id)sender;

/**
 *	Loading the web view with the user's website.
 *	@param sender UIButton object.
 */
- (IBAction)websiteButtonPressed:(id)sender;

@end
