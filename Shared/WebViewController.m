    //
//  WebViewController.m
//  IgniteTools
//
//  Created by Joseph Flasher on 6/9/11.
//  Copyright 2011 Ars Sollertia. All rights reserved.
//

#import "WebViewController.h"


@implementation WebViewController

@synthesize url, webView, webBackButton, webForwardButton, webActionButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil loadURL:(NSURL *)loadURL {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.url = loadURL;
    }
    return self;
}

- (void)dealloc {
	[url release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[self.webView loadRequest:request];	
}

- (void)setButtonState {
	// Set the forward and back button enabled or disabled based on state
	if ([self.webView canGoForward])
		[self.webForwardButton setEnabled:YES];
	else
		[self.webForwardButton setEnabled:NO];
	
	if ([self.webView canGoBack])
		[self.webBackButton setEnabled:YES];
	else
		[self.webBackButton setEnabled:NO];
	
	// Change between stop/reload depending on our webView state
	NSString *filePath;
	if ([self.webView isLoading]) 
		filePath = [[NSBundle mainBundle] pathForResource:@"11-x" ofType:@"png"];
	else
		filePath = [[NSBundle mainBundle] pathForResource:@"12-o" ofType:@"png"];
	
	[self.webActionButton setBackgroundImage:[UIImage imageWithContentsOfFile:filePath] forState:UIControlStateNormal];
}

- (IBAction)actionButtonPressed:(id)sender {
	// Perform either a stop or reload depending on page state
	if ([self.webView isLoading])
		[self.webView stopLoading];
	else
		[self.webView reload];
}

- (IBAction)backButtonPressed:(id)sender {
	// Pop off this view
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	// Set button states
	[self setButtonState];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	// Set button states
	[self setButtonState];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	// Set button states
	[self setButtonState];
}

- (void)viewDidDisappear:(BOOL)animated {
	// Make sure we get no more callbacks from the webView
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[webView setDelegate:nil];
	
	[super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
	[self.navigationController setNavigationBarHidden:YES];
	[webView setDelegate:self];
	 
	[super viewWillAppear:animated];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


@end
