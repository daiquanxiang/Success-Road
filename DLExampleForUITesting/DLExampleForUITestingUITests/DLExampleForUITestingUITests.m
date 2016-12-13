//
//  DLExampleForUITestingUITests.m
//  DLExampleForUITestingUITests
//
//  Created by David on 15/9/20.
//  Copyright © 2015年 David. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface DLExampleForUITestingUITests : XCTestCase
{
    float f1;
    float f2;
}
@end

@implementation DLExampleForUITestingUITests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.

//    XCUIElementQuery *query = [[XCUIElementQuery alloc] init];
//    XCUIElement *myButton = [query elementMatchingType: XCUIElementTypeButton  identifier:@"myButton"];
//    [myButton tap];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *mybuttonButton = app.buttons[@"myButton"];
    [mybuttonButton tap];
    
    XCUIElement *okButton = app.alerts[@"warn"].collectionViews.buttons[@"OK"];
    [okButton tap];

    
    XCUIElement *writeSomethingTextField = app.textFields[@"write something"];
    [writeSomethingTextField tap];
    [writeSomethingTextField typeText:@"Chg"];
    [app typeText:@"\n"];
    [mybuttonButton tap];
    [okButton tap];
    [app.switches[@"mySwitch"] tap];
    [mybuttonButton tap];
    
}

-(void)newTestExample{
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *myswitchSwitch = app.switches[@"mySwitch"];
    [myswitchSwitch tap];
    
    XCUIElement *mybuttonButton = app.buttons[@"myButton"];
    [mybuttonButton tap];
    
    XCUIElement *backButton = app.buttons[@"back"];
    [backButton tap];
    [myswitchSwitch tap];
    [mybuttonButton tap];
    [backButton tap];
    [myswitchSwitch doubleTap];
    XCUIElement *myButton = app.buttons[@"myButton"];
    [myButton tap];
    
}

@end
