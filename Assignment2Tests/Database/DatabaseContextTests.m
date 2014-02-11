//
//  ProductTests.m
//  Assignment2
//
//  Created by Alexandre on 07/02/14.
//  Copyright (c) 2014 Avenue Code. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DatabaseContext.h"
#import "DatabaseManager.h"
#import "NSObject+OSReflectionKit.h"

static NSString * const kTestingDBFileName = @"tests.sqlite";

@interface DatabaseContextTests : XCTestCase

@property (nonatomic, strong) DatabaseManager *dbManager;

@end

@implementation DatabaseContextTests

#pragma mark - Helper Methods

- (Product *) mockProduct
{
    return [Product objectFromDictionary:@{@"name":@"test",
                                    @"productDescription":@"This is just mocked data...",
                                    @"regularPrice":@(19999),
                                    @"salePrice":@(14999),
                                    @"photoName":@"ps3",
                                    @"stores":@{@"name":@"testing", @"count":@(10)},
                                    @"colors" : @[@{@"name":@"White", @"argbValue":@4294967295},@{@"name":@"Black", @"argbValue":@4278190080}]}];
}

- (Product *) insertMockProduct
{
    Product *product = [self mockProduct];
    [self.dbManager.dbContext insertProduct:product error:nil];
    
    return product;
}

#pragma mark - Test Lifecycle

- (void)setUp
{
    [super setUp];
    
    self.dbManager = [[DatabaseManager alloc] initWithFileName:kTestingDBFileName];
}

- (void)tearDown
{
    // Clear the database by deleting the database file
    NSString *filePath = [DatabaseManager dbFilePathWithFileName:kTestingDBFileName];
    
    NSError *error = nil;
    if(![[NSFileManager defaultManager] removeItemAtPath:filePath error:&error]) {
        NSLog(@"Failed removing DB test file: %@", [error localizedDescription]);
    }
    
    [super tearDown];
}

#pragma mark - Test Cases

- (void) testInsertProduct
{
    Product *product = [self mockProduct];

    XCTAssertNil(product.identifier, @"Product identifier should be nil before inserting into the database.");
    
    XCTAssertTrue([self.dbManager.dbContext insertProduct:product error:nil], @"Product should be inserted into the database.");
    
    XCTAssertNotNil(product.identifier, @"Product identifier should be set after inserting into the database.");
}

- (void) testReadAllProducts
{
    for (int i=0; i<5; i++) {
        [self insertMockProduct];
    }
    
    NSArray *products = [self.dbManager.dbContext readAllProductsWithError:nil];

    XCTAssertTrue([products count] == 5, @"Products array should contain 5 products from the database.");
    XCTAssertTrue([products[0] isKindOfClass:[Product class]], @"Products in the returned array should be of the type Product.");
    XCTAssertNotNil(((Product *)products[0]).identifier, @"Product identifier should not be nil after reading from the database.");
}

- (void) testReadProductWithId
{
    Product *mockProduct = [self insertMockProduct];
    Product *readProduct = [self.dbManager.dbContext readProduct:mockProduct.identifier errror:nil];
    
    XCTAssertTrue([readProduct isKindOfClass:[Product class]], @"Product read should be of the type Product.");
    XCTAssertNotNil(readProduct.identifier, @"Product identifier should not be nil after reading from the database.");
}

- (void) testUpdateProduct
{
    Product *mockProduct = [self insertMockProduct];
    mockProduct.name = @"Product updated";
    mockProduct.productDescription = @"This product was updated";
    
    XCTAssertTrue([self.dbManager.dbContext updateProduct:mockProduct error:nil], @"Product should be updated into the database.");
    
    Product *readProduct = [self.dbManager.dbContext readProduct:mockProduct.identifier errror:nil];
    XCTAssertTrue([readProduct.name isEqualToString:mockProduct.name], @"Product name should be updated.");
    XCTAssertTrue([readProduct.productDescription isEqualToString:mockProduct.productDescription], @"Product productDescription should be updated.");
}

- (void) testDeleteProduct
{
    Product *product = [self insertMockProduct];
    
    XCTAssertNotNil(product.identifier, @"Product identifier should be set after inserting into the database.");
    
    XCTAssertTrue([self.dbManager.dbContext deleteProduct:product error:nil], @"Product should be deleted from the database.");

    XCTAssertNil(product.identifier, @"Product identifier should be nil after deletion.");
}

- (void) testReadAllColorsForProduct
{
    Product *mockProduct = [self insertMockProduct];
    
    NSArray *colors = [self.dbManager.dbContext readAllColorsForProductId:mockProduct.identifier error:nil];
    
    XCTAssertTrue([colors count] == 2, @"Colors array should contain 2 colors from the database.");
    XCTAssertTrue([colors[0] isKindOfClass:[Color class]], @"Products in the returned array should be of the type Product.");
    XCTAssertNotNil(((Color *)colors[0]).identifier, @"Color identifier should not be nil after reading from the database.");
}

@end
