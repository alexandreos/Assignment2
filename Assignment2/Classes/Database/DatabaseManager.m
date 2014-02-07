//
//  DatabaseManager.m
//  Assignment2
//
//  Created by Alexandre on 07/02/14.
//  Copyright (c) 2014 Avenue Code. All rights reserved.
//

#import "DatabaseManager.h"

@interface DatabaseManager ()

@end

@implementation DatabaseManager
@synthesize dbContext = _dbContext;

+ (instancetype) sharedManager
{
    static DatabaseManager *_dbManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dbManager = [[self alloc] initWithFileName:@"products.sqlite"];
    });
    
    return _dbManager;
}

- (id)initWithFileName:(NSString *)fileName
{
    self = [super initWithFileName:fileName];
    
    if(self) {
        NSError *error = nil;
        if(![self createTableStructure:&error]) {
            DLog(@"Failed creating table structure: %@", [error localizedDescription]);
        }
    }
    
    return self;
}

#pragma mark - Properties

- (DatabaseContext *)dbContext
{
    if(_dbContext == nil) {
        _dbContext = [[DatabaseContext alloc] initWithDatabaseManager:self];
    }
    
    return _dbContext;
}

#pragma mark - Private Instance Methods

- (BOOL) createTableStructure:(NSError **) error {
    BOOL _success = NO;
    
    _success = [self runScriptFromResourceFile:@"createTables.sql" error:error];
    
    return _success;
}

@end
