//
//  Presenter.h
//  IgniteTools
//
//  Created by Joseph Flasher on 6/2/11.
//  Copyright 2011 Ars Sollertia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 *	The class corresponding to the Presenter Core Data entity.
 */
@interface Presenter : NSManagedObject {
}

/**
 *	Name of the presenter.
 */
@property (nonatomic, retain) NSString *name;

/**
 *	An avatar (probably from Twitter) of the presenter.
 */
@property (nonatomic, retain) NSData *portrait;

/**
 *	The twitter ID (including @) of the presenter.
 */
@property (nonatomic, retain) NSString *twitterID;

/**
 *	URL of presenter's website.
 */
@property (nonatomic, retain) NSString *websiteURL;

/**
 *	Set of Event objects at which the presenter has spoken.
 */
@property (nonatomic, retain) NSSet *events;

/**
 *	Set of Spark objects which the presenter has given.
 */
@property (nonatomic, retain) NSSet *sparks;

/**
 *	The first letter of spark.
 */
@property (nonatomic, retain) NSString *uppercaseFirstLetter;

@end
