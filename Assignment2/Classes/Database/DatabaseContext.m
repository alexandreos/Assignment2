//
//  ProductsRepository.m
//  Assignment2
//
//  Created by Alexandre on 07/02/14.
//  Copyright (c) 2014 Avenue Code. All rights reserved.
//

#import "DatabaseContext.h"
#import "DatabaseManager.h"
#import "NSObject+OSReflectionKit.h"

#define AssertObjectClass(object, klazz) NSAssert([object isKindOfClass:klazz], @"Expected object of class '%@', but received instance of '%@' at %s", NSStringFromClass(klazz), NSStringFromClass([object class]), __PRETTY_FUNCTION__)

NSString * const kDatabaseContextDidSaveProductNotification = @"DatabaseContextDidSaveProductNotification";
NSString * const kDatabaseContextDidDeleteProductNotification = @"DatabaseContextDidSaveProductNotification";

@interface DatabaseContext ()

@property (nonatomic, weak, readwrite) SQDBManager *dbManager;

@end

@implementation DatabaseContext

#pragma mark - Object Instantiation

- (instancetype) initWithDatabaseManager:(SQDBManager *)dbManager
{
    self = [super init];
    
    if(self)
    {
        self.dbManager = dbManager;
    }
    
    return self;
}

- (BOOL)insertProduct:(Product *) product error:(NSError **)error {
    AssertObjectClass(product, [Product class]);
    
    __block BOOL success = NO;
    
    [self.dbManager.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {

        NSDictionary *dict = [product persistenceDictionary];
        NSString *query = [self queryStringFoInsertingTable:@"Product" dictionary:dict];
        success = [db executeUpdate:query withParameterDictionary:dict];
        
        if(success == NO) {
            // Rollback in case of failure
            *rollback = YES;
            if(error) {
                *error = [db lastError];
            }
            return;
        }
        else {
            product.identifier = @([db lastInsertRowId]);
        }
        
        for (Color *color in product.colors) {
            color.productId = product.identifier;
            NSDictionary *colorDict = [color persistenceDictionary];
            NSString *query = [self queryStringFoInsertingTable:@"Color" dictionary:colorDict];
            success = [db executeUpdate:query withParameterDictionary:colorDict];
            
            if (!success) {
                *rollback = YES;
                if(error) {
                    *error = [db lastError];
                }
                return;
            }
            else {
                color.identifier = @([db lastInsertRowId]);
            }
        }
    }];
    
    if(success) {
        // Notify observers about the event
        [[NSNotificationCenter defaultCenter] postNotificationName:kDatabaseContextDidSaveProductNotification object:product];
    }
    
    return success;
}

- (NSArray *) readAllColorsForProductId:(NSNumber *) productId error:(NSError **) error {
    
    __block NSArray *objects = nil;
    [self.dbManager.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = nil;
        
        rs = [db executeQuery:@"SELECT id, name, productId, argbValue FROM Color WHERE productId = ?", productId];
        if(rs == nil) {
            if(error) {
                *error = [db lastError];
            }
            return;
        }
        
        objects = [self fetchObjectsInResultSet:rs forClass:[Color class]];
    }];
    
    return objects;
}

- (NSArray *) readAllProductsWithError:(NSError **) error {
    
    __block NSArray *objects = nil;
    [self.dbManager.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = nil;
        
        rs = [db executeQuery:@"SELECT id, name, productDescription, regularPrice, salePrice, photoName, stores FROM Product"];
        if(rs == nil) {
            if(error) {
                *error = [db lastError];
            }
            return;
        }
        
        objects = [self fetchObjectsInResultSet:rs forClass:[Product class]];
    }];
    
    return objects;
}

- (Product *) readProduct:(NSNumber *) identifier errror:(NSError **) error {
    __block NSArray *objects = nil;
    [self.dbManager.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = nil;
        
        rs = [db executeQuery:@"SELECT id, name, productDescription, regularPrice, salePrice, photoName, stores FROM Product WHERE id=? LIMIT 1", identifier];
        if(rs == nil) {
            if(error) {
                *error = [db lastError];
            }
            return;
        }
        objects = [self fetchObjectsInResultSet:rs forClass:[Product class]];
    }];
    
    Product *product = [objects count] > 0 ? objects[0] : nil;
    
    if(product) {
        product.colors = [self readAllColorsForProductId:product.identifier error:error];
    }
    
    return product;
}

- (BOOL) updateProduct:(Product *) product error:(NSError **) error {
    AssertObjectClass(product, [Product class]);
    __block BOOL success = NO;
    
    [self.dbManager.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSDictionary *dict = [product persistenceDictionary];
        NSString *query = [self queryStringForUpdatingTable:@"Product" dictionary:dict where:@"WHERE id = :id"];
        success = [db executeUpdate:query withParameterDictionary:dict];
        
        if(success == NO) {
            // Rollback in case of failure
            *rollback = YES;
            if(error) {
                *error = [db lastError];
            }
            return;
        }
        
        // MARK: For this demo, the colors array will not be editable.. but it's possible to implement in the future
//        for (Color *color in product.colors) {
//        }
    }];
    
    if(success) {
        // Notify observers about the event
        [[NSNotificationCenter defaultCenter] postNotificationName:kDatabaseContextDidSaveProductNotification object:product];
    }
    
    return success;
}


- (BOOL) deleteProduct:(Product *) product error:(NSError **) error {
    AssertObjectClass(product, [Product class]);
    __block BOOL success = NO;
    
    if(product.identifier)
    {
        [self.dbManager.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            

            if([product.colors count] > 0) {
                // Delete all related colors
                success = [db executeUpdate:@"DELETE FROM Color WHERE productId = ?", product.identifier];
                
                if(success == NO) {
                    // Rollback in case of failure
                    *rollback = YES;
                    return;
                }
                else {
                    product.colors = nil;
                }
            }
            
            success = [db executeUpdate:@"DELETE FROM Product WHERE id = ?", product.identifier];
            
            if(success) {
                // Clear the object's product identifier
                product.identifier = nil;
            }
            
            // Rollback in case of failure
            *rollback = !success;
        }];
    }
    
    if(success) {
        // Notify observers about the event
        [[NSNotificationCenter defaultCenter] postNotificationName:kDatabaseContextDidDeleteProductNotification object:product];
    }
    
    return success;
}

#pragma mark - Private Instance Methods

- (NSArray *) fetchObjectsInResultSet:(FMResultSet *) rs forClass:(Class) objectClass
{
    NSMutableArray *_objects = [NSMutableArray array];
    while ([rs next])
    {
        // Cria o array de objetos
        NSDictionary *tupleDictionary = [rs resultDictionary];
        
        NSArray *dicKeys = [tupleDictionary allKeys];
        
        NSDictionary *objectDictionary = [tupleDictionary dictionaryWithValuesForKeys:dicKeys];
        
        NSObject *_object = [objectClass objectFromDictionary:objectDictionary];
        
        if(_object)
        {
            [_objects addObject:_object];
        }
    }
    
    [rs close];
    
    if([_objects count] > 0)
        return [NSArray arrayWithArray:_objects];
    
    return nil;
}


- (NSString *) queryStringFoInsertingTable:(NSString *) tableName dictionary:(NSDictionary *) dict
{
    NSMutableString *query = nil;
    
    if([dict count] > 0)
    {
        query = [NSMutableString stringWithFormat:@"INSERT INTO %@ ", tableName];
        
        NSArray *fields = [dict allKeys];
        
        NSString *fieldsString = [fields componentsJoinedByString:@","];
        [query appendFormat:@"(%@) VALUES (", fieldsString];
        
        for (NSString *field in fields) {
            id obj = dict[field];
            if(obj && ![obj isKindOfClass:[NSNull class]]) {
                [query appendFormat:@":%@,", field];
            }
        }

        // Remove the last comma
        [query deleteCharactersInRange:NSMakeRange([query length]-1, 1)];
        [query appendString:@")"];
    }
    
    return [query copy];
}

- (NSString *) queryStringForUpdatingTable:(NSString *) tableName dictionary:(NSDictionary *) dict where:(NSString *) where
{
    NSMutableString *query = nil;
    
    if([dict count] > 0)
    {
        query = [NSMutableString stringWithFormat:@"UPDATE %@ SET ", tableName];
        [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if(obj && ![obj isKindOfClass:[NSNull class]]) {
                [query appendFormat:@"%@ = :%@,", key, key];
            }
        }];
        
        // Remove the last comma
        [query deleteCharactersInRange:NSMakeRange([query length]-1, 1)];
        
        if(where) {
            [query appendFormat:@" %@", where];
        }
    }
    
    return [query copy];
}

@end
