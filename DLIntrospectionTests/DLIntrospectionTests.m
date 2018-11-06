//
//  DLIntrospectionTests.m
//  DLIntrospectionTests
//
//  Created by Denis Lebedev on 12/27/12.
//  Copyright (c) 2012 Denis Lebedev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSObject+DLIntrospection.h"

@interface TestObject : NSObject<NSCopying>

@property (nonatomic, assign) char charProperty;
@property (nonatomic, assign) int intProperty;
@property (nonatomic, assign) short shortProperty;
@property (nonatomic, assign) long longProperty;
@property (nonatomic, assign) long long longLongProperty;

@property (nonatomic, assign) unsigned char unsignedCharProperty;
@property (nonatomic, assign) unsigned int unsignedIntProperty;
@property (nonatomic, assign) unsigned short unsignedShortProperty;
@property (nonatomic, assign) unsigned long unsignedLongProperty;
@property (nonatomic, assign) unsigned long long unsignedLongLongProperty;

@property (nonatomic, assign) float floatProperty;
@property (nonatomic, assign) double doubleProperty;
@property (nonatomic, assign) BOOL boolProperty;
@property (nonatomic, assign) char * charPointerProperty;
@property (nonatomic, strong) id idProperty;
@property (nonatomic, strong) Class classProperty;
@property (nonatomic, assign) SEL selectorProperty;

@end

@implementation TestObject

- (id)copyWithZone:(NSZone *)zone {
    return nil;
}

@end


@interface DLIntrospectionTests : XCTestCase

@end

@implementation DLIntrospectionTests

- (void)testProperties {
    NSArray *propertes = [TestObject properties];
    XCTAssertEqual([propertes count], 17, @"testProperties error");

    NSLog(@"%@", propertes);
    NSLog(@"%@", [NSClassFromString(@"UIViewController") properties]);
    
}

- (void)testIvars {
    NSArray *ivars = [TestObject instanceVariables];
    XCTAssertEqual([ivars count], 17, @"testIvars error");
    NSLog(@"%@", ivars);
}

- (void)testClasses {
    NSArray *classes = [NSObject classes];
    XCTAssertTrue(classes.count > 0, @"testClasses error");
}

- (void)testInstanceMethods {
    NSArray *methods = [TestObject instanceMethods];
    NSLog(@"%@", methods);
    XCTAssertEqual([methods count], (NSUInteger)35, @"testClasses error");
    NSLog(@"%@", methods);
}

- (void)testProtocols {
    NSArray *protocols = [TestObject protocols];
    XCTAssertEqual([protocols count], (NSUInteger)1, @"testProtocols error");
    NSLog(@"%@", [TestObject protocols]);
}

- (void)testProtocolDescription {
    NSLog(@"%@", [NSObject descriptionForProtocol:@protocol(NSObject)]);
}

@end
