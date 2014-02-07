//
//  DatabaseManagerTests.m
//  Assignment2
//
//  Created by Alexandre on 07/02/14.
//  Copyright (c) 2014 Avenue Code. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DatabaseManager.h"

@interface DatabaseManagerTests : XCTestCase

@end

@implementation DatabaseManagerTests

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

- (void)testSingletonInstance
{
    XCTAssertNotNil([DatabaseManager sharedManager], @"Singleton instance should be allocated");
    XCTAssertNotNil([[DatabaseManager sharedManager] dbContext], @"dbContext should be allocated");
}

@end
