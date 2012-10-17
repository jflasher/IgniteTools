//
//  ConnectViewController.h
//  IgniteTools
//
//  Created by Joseph Flasher on 6/4/11.
//  Copyright 2011 Ars Sollertia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFOpenFlowView.h"

/**
 *	UIViewController that contains a OpenFlowView to selected between different services we can view.
 */
@interface ConnectViewController : UIViewController <AFOpenFlowViewDelegate, AFOpenFlowViewDataSource> {
	IBOutlet AFOpenFlowView *openFlowView;
	NSArray *connections;
	IBOutlet UILabel *nameLabel;
}

/**
 *	The AFOpenFlowView which simulates a CoverFlow view.
 */
@property (nonatomic, retain) IBOutlet AFOpenFlowView *openFlowView;

/**
 *	The conenctions to display. Each element is a NSDictionary with connection info.
 */
@property (nonatomic, retain) NSArray *connections;

/**
 *	The name label.
 */
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;

@end
