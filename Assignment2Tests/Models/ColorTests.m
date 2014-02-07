//
//  ColorTests.m
//  Assignment2
//
//  Created by Alexandre on 07/02/14.
//  Copyright (c) 2014 Avenue Code. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Color.h"
#import <NSObject+OSReflectionKit.h>

@interface ColorTests : XCTestCase

@end

@implementation ColorTests

#pragma mark - Helper Methods

- (NSString *) mockColorJSONString
{
    return @"{\"id\":10,\"productId\":5,\"name\":\"Yellow\", \"argbValue\":4294967040}";
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
    NSDictionary *reflectionMap = [Color reflectionMapping];
    XCTAssertNotNil(reflectionMap, @"Color should return a reflectionMap dictionary at +reflectionMapping");
    XCTAssertTrue([reflectionMap[@"id"] isEqualToString:@"identifier"], @"Color should map 'id' colunm to 'identifier' property at +reflectionMapping");
}

- (void) testJSONSerialization
{
    Color *color = [Color objectFromJSON:[self mockColorJSONString]];
    XCTAssertEqualObjects(color.name, @"Yellow", @"name property should be equal 'Yellow'");
    XCTAssertEqualObjects(color.argbValue, @4294967040, @"argbValue property should be equal '4294967040' number");
    XCTAssertEqualObjects(color.identifier, @10, @"identifier property should be equal '10' number");
    XCTAssertEqualObjects(color.productId, @5, @"productId property should be equal '5' number");
}

- (void) testPersistenceDictionary
{
    Color *color = [Color objectFromJSON:[self mockColorJSONString]];
    NSDictionary *persistenceDictionary = [color persistenceDictionary];
    
    XCTAssertEqualObjects(color.name, persistenceDictionary[@"name"], @"name property should be equal name contained in the persistenceDictionary");
    XCTAssertEqualObjects(color.argbValue, persistenceDictionary[@"argbValue"], @"argbValue property should be equal number contained in the persistenceDictionary");
    XCTAssertEqualObjects(color.productId, persistenceDictionary[@"productId"], @"productId property should be equal number contained in the persistenceDictionary");
}

@end
