//
//  DLIntrospection.h
//  DLIntrospection
//
//  Created by Denis Lebedev on 12/27/12.
//  Copyright (c) 2012 Denis Lebedev. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MyBaseProtocol <NSObject>

@end

@protocol MyProtocol <MyBaseProtocol>

@end

@interface TestObject : NSObject <MyProtocol, MyBaseProtocol>

@property (nonatomic, strong) NSObject *firstProperty;
@property (atomic, copy) id secondProperty;

@property (atomic, assign) char *charProperty;
@property (atomic, assign) int *ptrProperty;

@property (atomic, assign, getter = isThirdProperty) BOOL thirdProperty;

- (void)method1;
- (void)method2;
- (NSArray *)method3;

@end
