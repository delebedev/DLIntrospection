//
//  DLIntrospectionTests.m
//  DLIntrospectionTests
//
//  Created by Broccoli on 2018/11/1.
//  Copyright © 2018 Denis Lebedev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSObject+DLIntrospection.h"

@interface TestObject : NSObject<NSCopying>
//
//if (!strcmp(cString, @encode(char))) return @"char";
//if (!strcmp(cString, @encode(int))) return @"int";
//if (!strcmp(cString, @encode(short))) return @"short";
//if (!strcmp(cString, @encode(long))) return @"long";
//if (!strcmp(cString, @encode(long long))) return @"long long";
//
//if (!strcmp(cString, @encode(unsigned char))) return @"unsigned char";
//if (!strcmp(cString, @encode(unsigned int))) return @"unsigned int";
//if (!strcmp(cString, @encode(unsigned short))) return @"unsigned short";
//if (!strcmp(cString, @encode(unsigned long))) return @"unsigned long";
//if (!strcmp(cString, @encode(unsigned long long))) return @"unsigned long long";
//
//if (!strcmp(cString, @encode(float))) return @"float";
//if (!strcmp(cString, @encode(double))) return @"double";
//
//if (!strcmp(cString, @encode(BOOL))) return @"BOOL";
//if (!strcmp(cString, @encode(void))) return @"void";
//if (!strcmp(cString, @encode(char *))) return @"char *";
//if (!strcmp(cString, @encode(id))) return @"id";
//if (!strcmp(cString, @encode(Class))) return @"class";
//if (!strcmp(cString, @encode(SEL))) return @"SEL";

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

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

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
