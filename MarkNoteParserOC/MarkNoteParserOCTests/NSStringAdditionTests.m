//
//  NSStringAdditionTests.m
//  MarkNoteParserOC
//
//  Created by bill on 4/10/15.
//  Copyright © 2015 marknote. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+Addition.h"

@interface NSStringAdditionTests : XCTestCase

@end

@implementation NSStringAdditionTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void) testTrim{
    NSString* string = @" this text has spaces before and after ";
    NSString* actual = [string trim];
    XCTAssertEqualObjects(@"this text has spaces before and after", actual);
    
}

-(void) testSplitEmptyLiens{
    NSArray* expectedArr = @[@"1",@"",@"3"];
    XCTAssertEqualObjects(expectedArr,[@"1\n\n3" componentsSeparatedByString:@"\n"]);
    expectedArr = @[@"A bulleted list:",@"- a",@"- b",@"- c",@""];
    XCTAssertEqualObjects(expectedArr,[@"A bulleted list:\n- a\n- b\n- c\n" componentsSeparatedByString:@"\n"]);
    
}
-(void) testSplitStringWithMidSpace{
    NSString* input = @"1 2" ;
    NSArray* expectedArr = @[@"1",@"2"];
    NSArray* arr = [input componentsSeparatedByString:@" "];
    XCTAssertEqualObjects(expectedArr,  arr);
}



@end
