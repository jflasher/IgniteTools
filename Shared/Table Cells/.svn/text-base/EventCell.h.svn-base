//
//  EventCell.h
//  IgniteTools
//
//  Created by Joseph Flasher on 6/21/11.
//  Copyright 2011 Ars Sollertia. All rights reserved.
//

#import <UIKit/UIKit.h>

#define EVENT_CELL_IDENTIFIER @"Event Cell Identifier"

/**
 *	The specialized Event cell for the table.
 */
@interface EventCell : UITableViewCell {
	IBOutlet UILabel *nameLabel;
	IBOutlet UILabel *dateLabel;
	IBOutlet UILabel *locationLabel;
	IBOutlet UILabel *detailLabel;
}

/**
 *  Event name.
 */
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;

/**
 *  Date of event.
 */
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;

/**
 *  Location.
 */
@property (nonatomic, retain) IBOutlet UILabel *locationLabel;

/**
 *  Detail info.
 */
@property (nonatomic, retain) IBOutlet UILabel *detailLabel;

/**
 *	Returns the string ID.
 */
+ (NSString *)reuseIdentifier;

@end
