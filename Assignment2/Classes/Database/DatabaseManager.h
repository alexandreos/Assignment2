//
//  DatabaseManager.h
//  Assignment2
//
//  Created by Alexandre on 07/02/14.
//  Copyright (c) 2014 Avenue Code. All rights reserved.
//

#import "SQDBManager.h"
#import "DatabaseContext.h"

/**
 This class is responsible for creating and managing the SQLite database.
 */

@interface DatabaseManager : SQDBManager

#pragma mark - Singleton

/**
 The database context responsible for interacting with the managed dabase
 */
@property (nonatomic, strong, readonly) DatabaseContext *dbContext;

/**
 Singleton instance of the manager.
 */
+ (instancetype) sharedManager;


@end
