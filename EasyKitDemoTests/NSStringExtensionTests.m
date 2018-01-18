//
//  NSStringExtensionTests.m
//  EasyKitDemoTests
//
//  Created by John TSai on 2018/1/18.
//  Copyright © 2018年 EK. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+EKExtension.h"

@interface NSStringExtensionTests : XCTestCase

@end

@implementation NSStringExtensionTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testEmptyString {
    NSString *string = @"This is a string";
    XCTAssertTrue(string.ek_isNotEmptyString, "string check failured");
    string = @"😊";
    XCTAssertTrue(string.ek_isNotEmptyString, "string check failured");
    
    string = @"";
    XCTAssertFalse(string.ek_isNotEmptyString, "string check failured");
    string = nil;
    XCTAssertFalse(string.ek_isNotEmptyString, "string check failured");
    string = @"  ";
    XCTAssertFalse(string.ek_isNotEmptyString, "space string should be empty");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
