//
//  Spark.m
//  IgniteTools
//
//  Created by Joseph Flasher on 6/2/11.
//  Copyright 2011 Ars Sollertia. All rights reserved.
//

#import "Spark.h"


@implementation Spark

@dynamic name, videoURL, event, presenter, isFavorite, uppercaseFirstLetter;

- (NSString *)uppercaseFirstLetter {
    [self willAccessValueForKey:@"uppercaseFirstLetter"];
    NSString *aString = [[self valueForKey:@"name"] uppercaseString];
    
    // support UTF-16:
    NSString *stringToReturn = [aString substringWithRange:[aString rangeOfComposedCharacterSequenceAtIndex:0]];
    
    // OR no UTF-16 support:
    //NSString *stringToReturn = [aString substringToIndex:1];
    
    [self didAccessValueForKey:@"uppercaseFirstLetter"];
    return stringToReturn;
}

@end
