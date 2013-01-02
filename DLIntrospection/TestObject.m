//
//  DLIntrospection.m
//  DLIntrospection
//
//  Created by Denis Lebedev on 12/27/12.
//  Copyright (c) 2012 Denis Lebedev. All rights reserved.
//

#import "TestObject.h"

#import <objc/runtime.h>

@implementation TestObject

@synthesize firstProperty = _myCustomIvarName;

- (void)method1 {
    ;
}

- (void)method2 {
    
}
- (id)init
{
    self = [super init];
    if (self) {
        int numClasses;
        Class * classes = NULL;
        
        classes = NULL;
        numClasses = objc_getClassList(NULL, 0);
        
        if (numClasses > 0 )
        {
            classes = (Class*)malloc(sizeof(Class) * numClasses);
            numClasses = objc_getClassList(classes, numClasses);
        }
        
        for (int i = 0 ; i < numClasses; i++) {
            //NSLog(@"%@", NSStringFromClass(classes[i]));
        }
        
        free(classes);

    }
    return self;
}

- (NSArray *)method3 {
    
}
@end
