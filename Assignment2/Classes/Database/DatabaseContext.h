//
//  ProductsRepository.h
//  Assignment2
//
//  Created by Alexandre on 07/02/14.
//  Copyright (c) 2014 Avenue Code. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"

@class SQDBManager;

@interface DatabaseContext : NSObject

@property (nonatomic, weak, readonly) SQDBManager *dbManager;

#pragma mark - Instantiation Methods
/**
 Instantiate a DatabasContext with the specified database manager.
 @param dbManager The database manager to be associated to the returned instance.
 */
- (instancetype) initWithDatabaseManager:(SQDBManager *) dbManager;

#pragma mark - CRUD Methods

#pragma mark Create Methods

/**
 Insert an instance of product to the database.
 @param product The object instance to be inserted into the database.
 @param error The reference to an error object to be filled in case of failure.
 @return `YES` in case of success and `NO` otherwise.
 */
- (BOOL) insertProduct:(Product *) product error:(NSError **) error;

#pragma mark Read Methods

/**
 Read an Array of products from the database.
 @param error The reference to an error object to be filled in case of failure.
 @return An array containing the products retrieved.
 */
- (NSArray *) readAllProductsWithError:(NSError **) error;

/**
 Read a product from the database.
 @param identifier The identiier of the product to be fetched from the database.
 @param error The reference to an error object to be filled in case of failure.
 @return The product retrieved.
 */
- (Product *) readProduct:(NSNumber *) identifier errror:(NSError **) error;

/**
 Read an Array of colors from the database.
 @param error The reference to an error object to be filled in case of failure.
 @return An array containing the colors retrieved.
 */
- (NSArray *) readAllColorsForProductId:(NSNumber *) productId error:(NSError **) error;

#pragma mark Update Methods

/**
 Update an instance of product to the database.
 @param product The object instance to be updated into the database.
 @param error The reference to an error object to be filled in case of failure.
 @return `YES` in case of success and `NO` otherwise.
 */
- (BOOL) updateProduct:(Product *) object error:(NSError **) error;

#pragma mark Delete Methods

/**
 Delete an instance of product from the database.
 @param product The object instance to be deleted from the database.
 @param error The reference to an error object to be filled in case of failure.
 @return `YES` in case of success and `NO` otherwise.
 */
- (BOOL) deleteProduct:(Product *) object error:(NSError **) error;

@end
