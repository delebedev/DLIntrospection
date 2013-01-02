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
    NSLog(@"%@", [TestObject properties]);
}
- (void)testProtocols {
    NSArray *protocols = [TestObject protocols];
    
   // STAssertEquals([protocols count], 1, @"");
    NSLog(@"%@", [TestObject protocols]);
}

- (void)testInstanceMethods {
    
}

- (void)testProtocolDescription {
    NSLog(@"%@", [NSObject descriptionForProtocol:@protocol(MyProtocol)]);
}

@end
