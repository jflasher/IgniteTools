//
//  Event.h
//  IgniteTools
//
//  Created by Joseph Flasher on 6/2/11.
//  Copyright 2011 Ars Sollertia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 *	The class that matches the Core Data Event entity. This contains info about one event.
 */
@interface Event : NSManagedObject {
}

/**
 *	Name of the event.
 */
@property (nonatomic, retain) NSString *name;

/**
 *	Date of the event.
 */
@property (nonatomic, retain) NSDate *date;

/**
 *	Location of the event.
 */
@property (nonatomic, retain) NSString *location;

/**
 *	Set of Spark objects that happened at this event.
 */
@property (nonatomic, retain) NSSet *sparks;

/**
 *	The list of Presenter objects who presented at this event.
 */
@property (nonatomic, retain) NSSet *presenters;

@end
