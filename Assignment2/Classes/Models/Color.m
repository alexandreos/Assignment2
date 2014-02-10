//
//  Color.m
//  Assignment2
//
//  Created by Alexandre on 07/02/14.
//  Copyright (c) 2014 Avenue Code. All rights reserved.
//

#import "Color.h"
#import "NSObject+OSReflectionKit.h"
#import "UIColor+ARGB.h"

@implementation Color

#pragma mark - OSReflectionKit

/**
 Overriding to return special key -> property mapping.
 */
+ (NSDictionary *) reflectionMapping
{
    return @{@"id":@"identifier"};
}

#pragma mark - Public Methods

- (NSDictionary *) persistenceDictionary {
    NSMutableDictionary *dict = [[self reverseDictionary] mutableCopy];
    
    // Remove all NSNull objects
    NSArray *keysForNullValues = [dict allKeysForObject:[NSNull null]];
    [dict removeObjectsForKeys:keysForNullValues];
    
    return [dict copy];
}

- (UIColor *) uiColor {
    return [UIColor colorWithARGB:[self.argbValue unsignedIntegerValue]];
}

@end
