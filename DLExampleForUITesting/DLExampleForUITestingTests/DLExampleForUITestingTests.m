//
//  DLExampleForUITestingTests.m
//  DLExampleForUITestingTests
//
//  Created by David on 15/9/20.
//  Copyright © 2015年 David. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"

@interface DLExampleForUITestingTests : XCTestCase
{
    UIApplication *app;
}

@property (nonatomic,strong) ViewController *myViewController;
@end

@implementation DLExampleForUITestingTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _myViewController = [[ViewController alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void) testSwitchButton
{
}
@end
