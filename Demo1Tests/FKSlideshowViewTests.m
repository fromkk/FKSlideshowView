//
//  FKSlideshowViewTests.m
//  Demo1
//
//  Created by Kazuya Ueoka on 2015/11/10.
//  Copyright © 2015年 TImers Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FKSlideshowView.h"

@interface FKSlideshowViewTests : XCTestCase
{
    FKSlideshowView *slideshowView;
}

@end

@implementation FKSlideshowViewTests

- (void)setUp {
    [super setUp];
    
    NSArray *images = @[];
    slideshowView = [[FKSlideshowView alloc] initWithImages:images];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitialize
{
    XCTAssert(slideshowView.duration == FKSlideshowDefaultDuration, @"default duration");
    XCTAssert(slideshowView.fade == FKSlideshowDefaultFade, @"default fade");
    XCTAssert(slideshowView.type == FKSlideshowDefaultType, @"defualt type");
}

- (void)testPlay
{
    [slideshowView play];
    XCTAssertTrue(slideshowView.playing, @"is playing");
}

- (void)testPause
{
    [slideshowView pause];
    XCTAssertFalse(slideshowView.playing, @"is pause");
}

@end
