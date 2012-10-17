//
//  Spark.h
//  IgniteTools
//
//  Created by Joseph Flasher on 6/2/11.
//  Copyright 2011 Ars Sollertia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Event.h"
#import "Presenter.h"

/**
 *	The class that corresponds to the Spark Core Data entity. Contains info about a presentation.
 */
@interface Spark : NSManagedObject {
}

/**
 *	Name of the spark.
 */
@property (nonatomic, retain) NSString *name;

/**
 *	URL link to a youtube video.
 */
@property (nonatomic, retain) NSString *videoURL;

/**
 *	The Event at which this spark was presented.
 */
@property (nonatomic, retain) Event *event;

/**
 *	The Presenter of this spark.
 */
@property (nonatomic, retain) Presenter *presenter;

/**
 *	Is this Spark a favorite?
 */
@property (nonatomic, retain) NSNumber *isFavorite;

/**
 *	The first letter of spark.
 */
@property (nonatomic, retain) NSString *uppercaseFirstLetter;

@end
