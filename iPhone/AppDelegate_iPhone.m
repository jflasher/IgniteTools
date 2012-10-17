//
//  AppDelegate_iPhone.m
//  IgniteTools
//
//  Created by Joseph Flasher on 6/2/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "AppDelegate_iPhone.h"
#import "UpdateViewController.h"

#define kUpdateView 1

@implementation AppDelegate_iPhone

@synthesize tabBarController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Add update view
	UpdateViewController *vc = [[UpdateViewController alloc] initWithNibName:@"UpdateView_iPhone" bundle:nil];
	[vc.view setTag:kUpdateView];
	[self.window addSubview:vc.view];
	// TODO: Clean up release here
	//[vc release];
	
    [self.window makeKeyAndVisible];
	
	// Register for update complete notification
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateComplete:) name:@"UpdateComplete" object:nil];
    
    //Init Airship launch options
    NSMutableDictionary *takeOffOptions = [[[NSMutableDictionary alloc] init] autorelease];
    [takeOffOptions setValue:launchOptions forKey:UAirshipTakeOffOptionsLaunchOptionsKey];
    
    // Create Airship singleton that's used to talk to Urban Airship servers.
    // Please replace these with your info from http://go.urbanairship.com
    [UAirship takeOff:takeOffOptions];
    
    [[UAPush shared] enableAutobadge:YES];
    [[UAPush shared] resetBadge];//zero badge on startup
    
    // Register for notifications through UAPush for notification type tracking
    [[UAPush shared] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                         UIRemoteNotificationTypeAlert)];
    
    return YES;
}

- (void)updateComplete:(id)sender {
    // Add tab bar view and remove loading view
    [self.window addSubview:tabBarController.view];	
	[[self.window viewWithTag:kUpdateView] removeFromSuperview];
}

#pragma mark -
#pragma mark Memory management
- (void)dealloc {
	[tabBarController release];
	[super dealloc];
}


@end

