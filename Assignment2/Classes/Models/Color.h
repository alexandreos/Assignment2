//
//  Color.h
//  Assignment2
//
//  Created by Alexandre on 07/02/14.
//  Copyright (c) 2014 Avenue Code. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Color : NSObject

// Primary key
@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSNumber *productId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *argbValue;

/**
 @return A `NSDictionary` instance containg the keys and values to be persisted.
 */
- (NSDictionary *) persistenceDictionary;

/**
 @return An `UIColor` instance based on the current value of `argbValue`.
 */
- (UIColor *) uiColor;

@end
