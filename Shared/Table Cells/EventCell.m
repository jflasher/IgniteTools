//
//  EventCell.m
//  IgniteTools
//
//  Created by Joseph Flasher on 6/21/11.
//  Copyright 2011 Ars Sollertia. All rights reserved.
//

#import "EventCell.h"


@implementation EventCell

@synthesize nameLabel, dateLabel, locationLabel, detailLabel;

+ (NSString *)reuseIdentifier
{
    return (NSString *)EVENT_CELL_IDENTIFIER;
}

- (NSString *)reuseIdentifier
{
    return [[self class] reuseIdentifier];
}

- (void)dealloc {
    [super dealloc];
}


@end
