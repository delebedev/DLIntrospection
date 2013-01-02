//
//  DLIntrospectionTests.m
//  DLIntrospectionTests
//
//  Created by Denis Lebedev on 12/27/12.
//  Copyright (c) 2012 Denis Lebedev. All rights reserved.
//

#import "DLIntrospectionTests.h"
#import "TestObject.h"
#import "NSObject+DLIntrospection.h"

@implementation DLIntrospectionTests

- (void)testProperties {
    NSArray *propertes = [TestObject properties];
    STAssertEquals([propertes count], (NSUInteger)6, nil);
    NSLog(@"%@", propertes);
    NSLog(@"%@", [NSClassFromString(@"UIViewController") properties]);

}

- (void)testIvars {
    NSArray *ivars = [TestObject instanceVariables];
    STAssertEquals([ivars count], (NSUInteger)9, nil);
    NSLog(@"%@", ivars);
}
- (void)testClasses {
    NSArray *classes = [NSObject classes];
    STAssertTrue(classes.count, nil);
    //NSLog(@"%@", classes);
}

- (void)testInstanceMethods {
    NSArray *methods = [TestObject instanceMethods];
    STAssertEquals([methods count], (NSUInteger)19, nil);
    NSLog(@"%@", methods);
}

- (void)testProtocols {
    NSArray *protocols = [TestObject protocols];
    STAssertEquals([protocols count], (NSUInteger)2, @"");
    NSLog(@"%@", [TestObject protocols]);
}

- (void)testProtocolDescription {
    NSLog(@"%@", [NSObject descriptionForProtocol:@protocol(NSObject)]);
}

@end
