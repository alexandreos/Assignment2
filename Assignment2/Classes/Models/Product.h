//
//  Product.h
//  Assignment2
//
//  Created by Alexandre on 07/02/14.
//  Copyright (c) 2014 Avenue Code. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Color.h"

@interface Product : NSObject

// Primary key
@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *productDescription;
@property (nonatomic, strong) NSDecimalNumber *regularPrice;
@property (nonatomic, strong) NSDecimalNumber *salePrice;
@property (nonatomic, strong) NSString *photoName;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSDictionary *stores;

/**
 @return A `NSDictionary` instance containg the keys and values to be persisted.
 */
- (NSDictionary *) persistenceDictionary;

/**
 @return An `UIImage` instance based on the current value of `photoName`.
 */
- (UIImage *) photo;

/**
 @return An `UIImage` instance representing the thumbnail version for the current value of `photoName`.
 */
- (UIImage *) thumbnail;

@end
