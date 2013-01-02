//
//  NSObject+DLIntrospection.h
//  DLIntrospection
//
//  Created by Denis Lebedev on 12/27/12.
//  Copyright (c) 2012 Denis Lebedev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DLIntrospection)

+ (NSArray *)properties;
+ (NSArray *)ivars;
+ (NSArray *)classMethods;
+ (NSArray *)instanceMethods;

+ (NSArray *)protocols;

+ (NSString *)parentClassHierarchy;
@end
