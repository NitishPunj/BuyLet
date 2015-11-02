//
//  SearchTestCase.m
//  BuyOrLet
//
//  Created by TAE on 28/10/2015.
//  Copyright © 2015 TAE. All rights reserved.
//

#import <XCTest/XCTest.h>
//#import "MockTestViewController.h"

@interface SearchTestCase : XCTestCase
//@property(nonatomic) MockTestViewController * mtv;

@end

@implementation SearchTestCase

- (void)setUp {
    [super setUp];
    

    //_svc =[[SearchViewController alloc]init];
    
  
     
     
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
//    NSString * ar = [self randomStringWithLength:8];
//    NSString * ps = [self randomStringWithLength:2];
//    
//    
    

    
    //[self jsonFetch:ar:ps];
    
    
    
    
    
    
    
}




//-(NSString *) randomStringWithLength: (int) len {
//    
//    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
//
//    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
//    
//    for (int i=0; i<len; i++) {
//        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
//    }
//    
//    return randomString;
//}
//


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

@end
