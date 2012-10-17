//
//  WebViewController.h
//  IgniteTools
//
//  Created by Joseph Flasher on 6/9/11.
//  Copyright 2011 Ars Sollertia. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *	The class that will handle the viewing of all web related content.
 */
@interface WebViewController : UIViewController <UIWebViewDelegate> {
	NSURL *url;
	IBOutlet UIWebView *webView;
	IBOutlet UIButton *webBackButton;
	IBOutlet UIButton *webForwardButton;
	IBOutlet UIButton *webActionButton;	
}

/**
 *	The webview.
 */
@property (nonatomic, retain) IBOutlet UIWebView *webView;

/**
 *	Go back. We need this to set enabled/disabled when appropriate.
 */
@property (nonatomic, retain) IBOutlet UIButton *webBackButton;

/**
 *	Go forward.We need this to set enabled/disabled when appropriate.
 */
@property (nonatomic, retain) IBOutlet UIButton *webForwardButton;

/**
 *	The STOP or RELOAD button, depending on state.
 */
@property (nonatomic, retain) IBOutlet UIButton *webActionButton;

/**
 *	URL to load.
 */
@property (nonatomic, retain) NSURL *url;

/**
 *	Go back to previous UIViewController (not web page).
 *	@param sender UIButton object.
 */
- (IBAction)backButtonPressed:(id)sender;

/**
 *	Set all the button states based on web view nav stack.
 */
- (void)setButtonState;

/**
 *	Stop or reload the page depending on loading state.
 *	@param sender UIButton object.
 */
- (IBAction)actionButtonPressed:(id)sender;

/**
 *	Initializer that sets URL at init.
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil loadURL:(NSURL *)loadURL;

@end
