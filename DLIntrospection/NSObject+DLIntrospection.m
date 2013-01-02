//
//  NSObject+DLIntrospection.m
//  DLIntrospection
//
//  Created by Denis Lebedev on 12/27/12.
//  Copyright (c) 2012 Denis Lebedev. All rights reserved.
//

#import "NSObject+DLIntrospection.h"
#import <objc/runtime.h>

@interface NSString (DLIntrospection)

+ (NSString *)decodeType:(const char *)cString;

@end

@implementation NSString (DLIntrospection)

//https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
+ (NSString *)decodeType:(const char *)cString {
    if (!strcmp(cString, @encode(id))) return @"id";
    if (!strcmp(cString, @encode(void))) return @"void";
    if (!strcmp(cString, @encode(float))) return @"float";
    if (!strcmp(cString, @encode(int))) return @"int";
    if (!strcmp(cString, @encode(BOOL))) return @"BOOL";
    if (!strcmp(cString, @encode(char *))) return @"char *";
    if (!strcmp(cString, @encode(double))) return @"double";
    if (!strcmp(cString, @encode(Class))) return @"class";
    if (!strcmp(cString, @encode(SEL))) return @"SEL";
    if (!strcmp(cString, @encode(unsigned int))) return @"unsigned int";

//@TODO: do handle bitmasks
    NSString *result = [NSString stringWithCString:cString encoding:NSUTF8StringEncoding];
    if ([[result substringToIndex:1] isEqualToString:@"@"]) {
        result = [result substringWithRange:NSMakeRange(2, result.length - 3)];
    }
    if ([[result substringToIndex:1] isEqualToString:@"^"]) {
        result = [NSString stringWithFormat:@"%@ *",
                   [NSString decodeType:[[result substringFromIndex:1] cStringUsingEncoding:NSUTF8StringEncoding]]];
    }
    return result;
}

@end

static void getSuper(Class class, NSMutableString *result) {
    [result appendFormat:@" -> %@", NSStringFromClass(class)];
    if ([class superclass]) { getSuper([class superclass], result); }
}

@implementation NSObject (DLIntrospection)

+ (NSArray *)classMethods {
    return [self methodsForClass:object_getClass([self class]) typeFormat:@"+"];
}

+ (NSArray *)instanceMethods {
    return [self methodsForClass:[self class] typeFormat:@"-"];
}

+ (NSArray *)properties {
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < outCount; i++) {
        unsigned int attrCount;
        objc_property_attribute_t *attrs = property_copyAttributeList(properties[i], &attrCount);
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        for (int idx = 0; idx < attrCount; idx++) {
            NSString *name = [NSString stringWithCString:attrs[idx].name encoding:NSUTF8StringEncoding];
            NSString *value = [NSString stringWithCString:attrs[idx].value encoding:NSUTF8StringEncoding];
            [attributes setObject:value forKey:name];
        }
        free(attrs);
        NSMutableString *property = [NSMutableString stringWithFormat:@"@property "];
        NSMutableArray *attrsArray = [NSMutableArray array];

//https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html#//apple_ref/doc/uid/TP40008048-CH101-SW5
        [attrsArray addObject:[attributes objectForKey:@"N"] ? @"nonatomic" : @"atomic"];
        
        if ([attributes objectForKey:@"&"]) {
            [attrsArray addObject:@"strong"];
        } else if ([attributes objectForKey:@"C"]) {
            [attrsArray addObject:@"copy"];
        } else if ([attributes objectForKey:@"W"]) {
            [attrsArray addObject:@"weak"];
        } else {
            [attrsArray addObject:@"assign"];
        }
        if ([attributes objectForKey:@"R"]) {[attrsArray addObject:@"readonly"];}
        if ([attributes objectForKey:@"G"]) {
            [attrsArray addObject:[NSString stringWithFormat:@"getter=%@", [attributes objectForKey:@"G"]]];
        }
        if ([attributes objectForKey:@"S"]) {
            [attrsArray addObject:[NSString stringWithFormat:@"setter=%@", [attributes objectForKey:@"G"]]];
        }
        
        [property appendFormat:@"(%@) %@ %@",
         [attrsArray componentsJoinedByString:@", "],
         [NSString decodeType:[[attributes objectForKey:@"T"] cStringUsingEncoding:NSUTF8StringEncoding]],
         [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding]];
        
        [result addObject:property];
    }
    free(properties);
    return result.count ? [result copy] : nil;
}

+ (NSArray *)ivars {
    unsigned int outCount;
    Ivar *ivars = class_copyIvarList([self class], &outCount);
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < outCount; i++) {
        NSString *type = [NSString decodeType:ivar_getTypeEncoding(ivars[i])];
        NSString *name = [NSString stringWithCString:ivar_getName(ivars[i]) encoding:NSUTF8StringEncoding];
        NSString *ivarDescription = [NSString stringWithFormat:@"%@ %@", type, name];
        [result addObject:ivarDescription];
    }
    free((void *)(*ivars));
    return result.count ? [result copy] : nil;
}

+ (NSArray *)protocols {
    unsigned int outCount;
    Protocol * const *protocols = class_copyProtocolList([self class], &outCount);

    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < outCount; i++) {
        unsigned int adoptedCount;
        Protocol * const *adotedProtocols = protocol_copyProtocolList(protocols[i], &adoptedCount);
        NSString *protocolName = [NSString stringWithCString:protocol_getName(protocols[i]) encoding:NSUTF8StringEncoding];

        NSMutableArray *adoptedProtocolNames = [NSMutableArray array];
        for (int idx = 0; idx < adoptedCount; idx++) {
            [adoptedProtocolNames addObject:[NSString stringWithCString:protocol_getName(adotedProtocols[idx]) encoding:NSUTF8StringEncoding]];
        }
        NSString *protocolDescription = protocolName;
        
        if (adoptedProtocolNames.count) {
            protocolDescription = [NSString stringWithFormat:@"%@ <%@>", protocolName, [adoptedProtocolNames componentsJoinedByString:@", "]];
        }
        [result addObject:protocolDescription];
        free((__bridge void *)(*adotedProtocols));
    }
    free((__bridge void *)(*protocols));
    //protocol_copyMethodDescriptionList
    return result.count ? [result copy] : nil;
}

+ (NSString *)parentClassHierarchy {
    NSMutableString *result = [NSMutableString string];
    getSuper([self class], result);
    return result;
}

#pragma mark - Private

+ (NSArray *)methodsForClass:(Class)class typeFormat:(NSString *)type {
    unsigned int outCount;
    Method *methods = class_copyMethodList(class, &outCount);
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < outCount; i++) {
        NSString *methodDescription = [NSString stringWithFormat:@"%@ (%@)%@",
                                       type,
                                       [NSString decodeType:method_copyReturnType(methods[i])],
                                       NSStringFromSelector(method_getName(methods[i]))];
        
        NSInteger args = method_getNumberOfArguments(methods[i]);
        NSMutableArray *selParts = [[methodDescription componentsSeparatedByString:@":"] mutableCopy];
        NSInteger offset = 2; //1-st arg is object (@), 2-nd is SEL (:)
        
        for (int idx = offset; idx < args; idx++) {
            NSString *returnType = [NSString decodeType:method_copyArgumentType(methods[i], idx)];
            selParts[idx - offset] = [NSString stringWithFormat:@"%@:(%@)arg%d",
                                      selParts[idx - offset],
                                      returnType,
                                      idx - 2];
        }
        [result addObject:[selParts componentsJoinedByString:@" "]];
    }
    free((void *)(*methods));
    return result.count ? [result copy] : nil;
}

@end
