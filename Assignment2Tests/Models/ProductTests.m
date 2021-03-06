//
//  ProductTests.m
//  Assignment2
//
//  Created by Alexandre on 07/02/14.
//  Copyright (c) 2014 Avenue Code. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Product.h"
#import "NSObject+OSReflectionKit.h"
#import "NSDictionary+JSONSerialization.h"

@interface ProductTests : XCTestCase

@end

@implementation ProductTests

#pragma mark - Helper Methods

- (NSString *) mockProductJSONString
{
    return @"{\"productDescription\" : \"This is just mocked data...\",\
        \"name\" : \"test\",\
        \"photoName\" : \"ps3\",\
        \"colors\" : null,\
        \"identifier\" : null,\
        \"salePrice\" : 14999,\
        \"stores\" : {\
            \"count\" : 10,\
            \"name\" : \"testing\"\
        },\
        \"regularPrice\" : 19999\
    }";
}

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

#pragma mark - Test Lifecycle

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

#pragma mark - Test Cases

- (void)testReflectionMapping
{
    NSDictionary *reflectionMap = [Product reflectionMapping];
    XCTAssertNotNil(reflectionMap, @"Product should return a reflectionMap dictionary at +reflectionMapping");
    XCTAssertTrue([reflectionMap[@"id"] isEqualToString:@"identifier"], @"Product should map 'id' colunm to 'identifier' property at +reflectionMapping");
}

- (void)testMappingFromJSON
{
    Product *product = [self mockProduct];
    Product *productFromJSON = [Product objectFromJSON:[self mockProductJSONString]];
    
    XCTAssertTrue([product.name isEqualToString:productFromJSON.name], @"name should be deserialized from JSON string");
    XCTAssertTrue([product.productDescription isEqualToString:productFromJSON.productDescription], @"productDescription should be deserialized from JSON string");
    XCTAssertTrue([product.photoName isEqualToString:productFromJSON.photoName], @"photoName should be deserialized from JSON string");
    XCTAssertTrue([product.regularPrice isEqual:productFromJSON.regularPrice], @"regularPrice should be deserialized from JSON string");
    XCTAssertTrue([product.salePrice isEqual:productFromJSON.salePrice], @"salePrice should be deserialized from JSON string");
    XCTAssertTrue([product.stores isEqual:productFromJSON.stores], @"stores should be deserialized from JSON string");
    XCTAssertNil(productFromJSON.identifier, @"identifier should be nil from JSON string");
    XCTAssertNil(productFromJSON.colors, @"colors should be nil from JSON string");
}

- (void) testPriceTransformations
{
    Product *productFromJSON = [Product objectFromJSON:[self mockProductJSONString]];
    
    XCTAssertTrue([productFromJSON.regularPrice isEqual:[NSDecimalNumber decimalNumberWithMantissa:19999 exponent:-2 isNegative:NO]], @"regularPrice should be converted from integer to decimal");
    XCTAssertTrue([productFromJSON.salePrice isEqual:[NSDecimalNumber decimalNumberWithMantissa:14999 exponent:-2 isNegative:NO]], @"salePrice should be converted from integer to decimal");
    
    NSDictionary *dictionary = [productFromJSON persistenceDictionary];
    
    XCTAssertTrue([dictionary[@"regularPrice"] isEqual:@(19999)], @"regularPrice should be converted from decimal to integer in the parametersDictionary");
    XCTAssertTrue([dictionary[@"salePrice"] isEqual:@(14999)], @"salePrice should be converted from decimal to integer in the parametersDictionary");
    
}

- (void) testPersistenceDictionary
{
    Product *product = [self mockProduct];
    NSDictionary *persistenceDictionary = [product persistenceDictionary];
    
    XCTAssertEqualObjects(product.name, persistenceDictionary[@"name"], @"name property should be equal name contained in the persistenceDictionary");
    XCTAssertEqualObjects(product.productDescription, persistenceDictionary[@"productDescription"], @"productDescription property should be equal name contained in the persistenceDictionary");
    XCTAssertEqualObjects(product.photoName, persistenceDictionary[@"photoName"], @"photoName property should be equal name contained in the persistenceDictionary");
    XCTAssertEqualObjects([product.stores JSON_toString], persistenceDictionary[@"stores"], @"stores property should be equal name contained in the persistenceDictionary");
    XCTAssertNil(persistenceDictionary[@"colors"], @"colors property should not be present in the persistenceDictionary");
}

- (void) testPriceSettersFromString
{
    Product *product = [self mockProduct];
    
    // Valid strings
    XCTAssertTrue([product setRegularPriceFromString:@"231312.3123"], @"Setter should accept the number '231312.3123' from a string");
    XCTAssertTrue([[product.regularPrice stringValue] isEqualToString:@"231312.3123"], @"regularPrice should be '231312.3123' after set from the string '231312.3123'");
    XCTAssertTrue([product setSalePriceFromString:@"231312.3123"], @"Setter should accept the number '231312.3123' from a string");
    XCTAssertTrue([[product.salePrice stringValue] isEqualToString:@"231312.3123"], @"salePrice should be '231312.3123' after set from the string '231312.3123'");
    
    // Invalid strings - Negative values
    XCTAssertFalse([product setRegularPriceFromString:@"-231312.3123"], @"Setter should not accept the number '-231312.3123' from a string");
    XCTAssertFalse([[product.regularPrice stringValue] isEqualToString:@"-231312.3123"], @"regularPrice should not be '-231312.3123' after set from the string");
    XCTAssertFalse([product setSalePriceFromString:@"-231312.3123"], @"Setter should not accept the number '-231312.3123' from a string");
    XCTAssertFalse([[product.salePrice stringValue] isEqualToString:@"-231312.3123"], @"salePrice should not be '-231312.3123' after set from the string");

    // Invalid strings - Alphanumeric
    XCTAssertFalse([product setRegularPriceFromString:@"AFVC231312"], @"Setter should not accept the number 'AFVC231312' from a string");
    XCTAssertFalse([[product.regularPrice stringValue] isEqualToString:@"AFVC231312"], @"regularPrice should not be 'AFVC231312' after set from the string");
    XCTAssertFalse([product setSalePriceFromString:@"AFVC231312"], @"Setter should not accept the number 'AFVC231312' from a string");
    XCTAssertFalse([[product.salePrice stringValue] isEqualToString:@"AFVC231312"], @"salePrice should not be 'AFVC231312' after set from the string");
    
    // Empty strings
    XCTAssertFalse([product setRegularPriceFromString:@""], @"Setter should not accept an empty string");
    XCTAssertFalse([[product.regularPrice stringValue] isEqualToString:@""], @"regularPrice should not be empty after set from an empty string");
    XCTAssertTrue([product setSalePriceFromString:@""], @"Setter should accept an empty string");
    XCTAssertTrue([[product.salePrice stringValue] isEqualToString:@"0"], @"salePrice should be '0' after set from an empty string");
}

@end
