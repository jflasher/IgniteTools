//
//  ConnectViewController.m
//  IgniteTools
//
//  Created by Joseph Flasher on 6/4/11.
//  Copyright 2011 Ars Sollertia. All rights reserved.
//

#import "ConnectViewController.h"
#import "WebViewController.h"

@implementation ConnectViewController

@synthesize openFlowView, connections, nameLabel;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [openFlowView setDataSource:self];
    [openFlowView setViewDelegate:self];
	
	// Determine how many of the connects we have that are valid
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ApplicationInformation" ofType:@"plist"];
	NSMutableArray *allConnections = [[NSDictionary dictionaryWithContentsOfFile:filePath] valueForKey:@"connections"];
	for (NSDictionary *connection in allConnections) {
		NSString *url = [connection valueForKey:@"url"];
		if (url == nil || [url length] == 0) {
			[allConnections removeObject:connection];
		}
	}
	
	self.connections = [NSArray arrayWithArray:allConnections];

    [openFlowView setNumberOfImages:[connections count]];
	[openFlowView setSelectedCover:0];
	[nameLabel setText:[[connections objectAtIndex:0] valueForKey:@"name"]];
}

- (void)viewWillAppear:(BOOL)animated {
	[self.navigationController setNavigationBarHidden:YES];
	
	[super viewWillAppear:animated];
}

#pragma mark -
#pragma mark Memory management


- (void)dealloc {
	[openFlowView release];
	[connections release];
	[nameLabel release];
    [super dealloc];
}


#pragma mark -
#pragma mark AFOpenFlowViewDelegate

- (void)openFlowView:(AFOpenFlowView *)anOpenFlowView selectionDidChange:(int)index {
	[nameLabel setText:[[connections objectAtIndex:index] valueForKey:@"name"]];

}

- (void)openFlowView:(AFOpenFlowView *)anOpenFlowView selectedIndex:(int)index {
	NSString *urlString = [[connections objectAtIndex:index] valueForKey:@"url"];
	if (urlString == nil || [urlString length] == 0)
		return;
	
	NSURL *url = [NSURL URLWithString:urlString];
	WebViewController *vc = [[WebViewController alloc] initWithNibName:@"WebView" bundle:nil loadURL:url];
	[self.navigationController pushViewController:vc animated:YES];
	[vc release];
}

- (void)openFlowView:(AFOpenFlowView *)anOpenFlowView focusDidChange:(int)index {
	[nameLabel setText:[[connections objectAtIndex:index] valueForKey:@"name"]];
}

#pragma mark -
#pragma mark AFOpenFlowViewDataSource

- (void)openFlowView:(AFOpenFlowView *)anOpenFlowView requestImageForIndex:(int)index {
	NSString *type = [[connections objectAtIndex:index] valueForKey:@"type"];
	
	UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", type]];
	if (!image)
		return;
	
	[anOpenFlowView setImage:image forIndex:index];
}

- (UIImage *)defaultImage {
	UIImage *image = [UIImage imageNamed:@"arssollertia.png"];
	return image;
}


@end

