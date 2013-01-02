//
//  DLIntrospectionTests.m
//  DLIntrospectionTests
//
//  Created by Denis Lebedev on 12/27/12.
//  Copyright (c) 2012 Denis Lebedev. All rights reserved.
//

#import "DLIntrospectionTests.h"
#import "DLIntrospection.h"
#import "NSObject+DLIntrospection.h"

@implementation DLIntrospectionTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testExample {
    NSLog(@"%@",[DLIntrospection properties]);
    
    //NSLog(@"%@",[NSObject protocols]);
    //NSLog(@"%@", [NSClassFromString(@"UIView") methods]);
    //NSLog(@"%@", [NSObject instanceMethods]);
    //NSLog(@"%@", [NSObject classMethods]);


    //NSLog(@"%@", [NSClassFromString(@"UIViewController") parentClassHierarchy]);
    //NSLog(@"%@", [NSClassFromString(@"UIView") ivars]);
    
    //рекурсивное дерево классов, например
}

@end
