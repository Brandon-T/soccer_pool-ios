//
//  NSObject+Serializable.m
//  SoccerPool
//
//  Created by Brandon Thomas on 2016-06-05.
//  Copyright © 2016 XIO. All rights reserved.
//

#import "NSObject+Serializable.h"
#import <objc/runtime.h>

@implementation NSObject (Serializable)
+ (instancetype)fromJSON:(NSDictionary *)json {
    id instance = [[[self class] alloc] init];
    if ([json count]) {
        [instance deserialize:json];
    }
    return instance;
}

+ (NSArray<Serializeable> *)fromJSONArray:(NSArray<NSDictionary *> *)json {
    NSMutableArray<Serializeable> *instances = [[NSMutableArray<Serializeable> alloc] init];
    for (NSDictionary *js in json) {
        id instance = [[[self class] alloc] init];
        if ([js count]) {
            [instance deserialize:js];
        }
        [instances addObject:instance];
    }
    return instances;
}

- (NSDictionary *)toJSON {
    return [self serialize];
}


- (Class)classForProperty:(NSString *)property {
    return [self classOfPropertyNamed:property];
}

- (NSString *)propertyForName:(NSString *)name {
    return name;
}

- (NSDictionary *)enumForProperty:(NSString *)property {
    return nil;
}

- (NSDateFormatter *)dateFormatterForProperty:(NSString *)property {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    return formatter;
}


#pragma mark Helpers

- (NSArray<NSString *> *)propertiesToIgnore {
    static NSArray *properties = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        properties = [NSObject properties];
    });
    return properties;
}

- (NSArray *)properties {
    unsigned int size = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &size);
    NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:size];
    for (unsigned int i = 0; i < size; ++i) {
        const char *name = property_getName(properties[i]);
        if (name) {
            [data addObject:[NSString stringWithUTF8String:name]];
        }
    }
    free(properties);
    return data;
}

- (NSDictionary *)propertiesAttributes {
    unsigned int size = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &size);
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithCapacity:size];
    for (unsigned int i = 0; i < size; ++i) {
        const char *name = property_getName(properties[i]);
        const char *attr = property_getAttributes(properties[i]);
        if (name && attr) {
            if ([[NSString stringWithUTF8String:attr] rangeOfString:@",W"].location == NSNotFound) {
                [data setObject:[NSString stringWithUTF8String:attr] forKey:[NSString stringWithUTF8String:name]];
            }
        }
    }
    free(properties);
    return data;
}

- (NSString *)attributesForProperty:(NSString *)propertyName {
    objc_property_t property = class_getProperty([self class], [propertyName UTF8String]);
    return [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
}

- (NSArray<NSString *> *)protocolsForPropertyAttributes:(NSString *)attributes {
    NSScanner *scanner = [[NSScanner alloc] initWithString:attributes];
    [scanner scanUpToString:@"T" intoString:nil];
    [scanner scanString:@"T" intoString:nil];
    if ([scanner scanString:@"@\"" intoString:&attributes]) {
        [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\"<"] intoString:&attributes];
        
        NSMutableArray *protocols = [[NSMutableArray alloc] init];
        
        while ([scanner scanString:@"<" intoString:nil]) {
            NSString* protocol = nil;
            [scanner scanUpToString:@">" intoString:&protocol];
            [scanner scanString:@">" intoString:nil];
            
            if (protocol.length) {
                [protocols addObject:protocol];
            }
        }
        return protocols.count ? protocols : nil;
    }
    return nil;
}

- (Class)classOfPropertyNamed:(NSString *)propertyName {
    Class propertyClass = nil;
    objc_property_t property = class_getProperty([self class], [propertyName UTF8String]);
    NSString *propertyAttributes = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
    NSArray *splitPropertyAttributes = [propertyAttributes componentsSeparatedByString:@","];
    if (splitPropertyAttributes.count > 0) {
        NSString *encodeType = splitPropertyAttributes[0];
        NSArray *splitEncodeType = [encodeType componentsSeparatedByString:@"\""];
        NSString *className = splitEncodeType[1];
        propertyClass = NSClassFromString(className);
    }
    return propertyClass;
}

- (bool)isSerializeable {
    return [self conformsToProtocol:@protocol(Serializeable)];
}

- (bool)isNonSerializeable {
    return [self conformsToProtocol:@protocol(NonSerializeable)];
}


#pragma mark Serialization

- (NSDictionary *)serialize {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    Class cls = [self class];
    
    do {
        NSDictionary *propertyAttributes = [self propertiesAttributes];
        NSArray<NSString *> *propertiesToIgnore = [self propertiesToIgnore];
        
        for (NSString *key in [propertyAttributes allKeys]) {
            if (![propertiesToIgnore containsObject:key]) {
                NSDictionary *value = [self serialize:key withAttribute:[propertyAttributes objectForKey:key]];
                if (value && [value count]) {
                    NSString *propertyKey = [self propertyForName:key];
                    if (propertyKey && [propertyKey length]) {
                        [result setObject:value[key] forKey:[self propertyForName:key]];
                    }
                }
            }
        }
        
        cls = class_getSuperclass(cls);
    }
    while (cls != [NSObject class]);
    
    return [result count] > 0 ? result : nil;
}

+ (NSArray *)serializeArray:(id)property {
    NSMutableArray *result = [NSMutableArray array];
    
    for (id value in property) {
        if ([value isSerializeable]) {
            NSDictionary *serialized = [value serialize];
            if (serialized) {
                [result addObject:serialized];
            }
        }
        else {
            [result addObject:value];
        }
    }
    return result;
}

+ (NSSet *)serializeSet:(id)property {
    NSMutableSet *result = [NSMutableSet set];
    
    for (id value in property) {
        if ([value isSerializeable]) {
            NSDictionary *serialized = [value serialize];
            if (serialized) {
                [result addObject:serialized];
            }
        }
        else {
            [result addObject:value];
        }
    }
    return result;
}

+ (NSDictionary *)serializeDictionary:(id)property {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    for (NSString *key in property) {
        id value = property[key];
        
        if ([value isSerializeable]) {
            result[key] = [value serialize];
        }
        else {
            result[key] = value;
        }
    }
    return result;
}

+ (id)serializeClass:(id)property {
    if ([property isKindOfClass:[NSArray class]]) {
        return [NSObject serializeArray:property];
    }
    else if ([property isKindOfClass:[NSSet class]]) {
        return [NSObject serializeSet:property];
    }
    else if ([property isKindOfClass:[NSDictionary class]]) {
        return [NSObject serializeDictionary:property];
    }
    
    return property;
}

- (id)serialize:(NSString *)key withAttribute:(NSString *)attribute {
    if ([[self protocolsForPropertyAttributes:attribute] containsObject:NSStringFromProtocol(@protocol(NonSerializeable))]) {
        return nil;
    }
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    id value = [self valueForKey:key];
    id serialized = nil;
    
    if ([value isSerializeable]) {
        id superDictionary = [value serialize];
        if (superDictionary) {
            serialized = superDictionary;
        }
    }
    else if ([value isKindOfClass:[NSArray class]]) {
        serialized = [NSObject serializeClass:value];
    }
    else if ([value isKindOfClass:[NSSet class]]) {
        serialized = [NSObject serializeClass:value];
    }
    else if ([value isKindOfClass:[NSDictionary class]]) {
        serialized = [NSObject serializeClass:value];
    }
    else if ([value isKindOfClass:[NSDate class]]) {
        serialized = [[self dateFormatterForProperty:key] stringFromDate:value];
    }
    else if ([value isKindOfClass:[NSNumber class]] && [self enumForProperty:key]) {
        serialized = [self enumForProperty:key][value];
    }
    else if ([value isKindOfClass:[NSNumber class]]) {
        if ([value class] == [@(YES) class]) {
            serialized = [value boolValue] ? @"true" : @"false";
        }
        else {
            serialized = [value stringValue];
        }
    }
    else if (value) {
        serialized = value;
    }
    
    if (serialized) {
        result[key] = serialized;
    }
    return result;
}


#pragma DeSerialization

- (void)deserialize:(NSDictionary *)json {
    Class cls = [self class];
    
    do {
        NSDictionary *propertyAttributes = [self propertiesAttributes];
        NSArray<NSString *> *propertiesToIgnore = [self propertiesToIgnore];
        
        for (NSString *key in [propertyAttributes allKeys]) {
            NSString *realKey = [self propertyForName:key];
            
            if (![propertiesToIgnore containsObject:realKey]) {
                [self deserialize:key withValue:[json objectForKey:realKey] withAttribute:[propertyAttributes objectForKey:key]];
            }
        }
        
        cls = class_getSuperclass(cls);
    }
    while (cls != [NSObject class]);
}

- (id)deserializeArray:(id)value withProperty:(NSString *)property withClass:(Class)cls {
    Class propertyClass = [self classForProperty:property];
    
    if ([propertyClass isSerializeable]) {
        NSMutableArray *map = [NSMutableArray arrayWithArray:value];
        
        for (NSUInteger i = 0; i < [map count]; ++i) {
            id instance = [[propertyClass alloc] init];
            [instance deserialize:map[i]];
            map[i] = instance;
        }
        return [cls isSubclassOfClass:[NSArray class]] ? map : ([cls isSubclassOfClass:[NSSet class]] ? [NSMutableSet setWithArray:map] : map);
    }
    return value;
}

- (id)deserializeSet:(id)value withProperty:(NSString *)property withClass:(Class)cls {
    Class propertyClass = [self classForProperty:property];
    
    if ([propertyClass isSerializeable]) {
        NSMutableArray *map = [NSMutableArray arrayWithArray:[value allObjects]];
        
        for (NSUInteger i = 0; i < [map count]; ++i) {
            id instance = [[propertyClass alloc] init];
            [instance deserialize:map[i]];
            map[i] = instance;
        }
        return [cls isSubclassOfClass:[NSSet class]] ? [NSMutableSet setWithArray:map] : ([cls isSubclassOfClass:[NSArray class]] ? map : [NSMutableSet setWithArray:map]);
    }
    return value;
}

- (id)deserializeDictionary:(id)value withProperty:(NSString *)property withClass:(Class)cls {
    Class propertyClass = [self classForProperty:property];
    
    if ([propertyClass isSerializeable]) {
        NSMutableDictionary *classMap = [NSMutableDictionary dictionaryWithDictionary:value];
        NSArray *keys = [classMap allKeys];
        
        for (NSString *key in keys) {
            id instance = [[propertyClass alloc] init];
            [instance deserialize:classMap[key]];
            classMap[key] = instance;
        }
        return classMap;
    }
    return value;
}

- (id)deserializeClass:(id)value withProperty:(NSString *)property withClass:(Class)cls {
    if ([value isKindOfClass:[NSArray class]]) {
        return [self deserializeArray:value withProperty:property withClass:cls];
    }
    else if ([value isKindOfClass:[NSSet class]]) {
        return [self deserializeSet:value withProperty:property withClass:cls];
    }
    else if ([value isKindOfClass:[NSDictionary class]]) {
        return [self deserializeDictionary:value withProperty:property withClass:cls];
    }
    
    return value;
}

- (void)deserialize:(NSString *)key withValue:(id)value withAttribute:(NSString *)attribute {
    if ([[self protocolsForPropertyAttributes:attribute] containsObject:NSStringFromProtocol(@protocol(NonSerializeable))]) {
        return;
    }
    
    if ([attribute characterAtIndex:1] == _C_ID) { //class
        NSArray *components = [attribute componentsSeparatedByString:@"\""];
        if ([components count] > 1) {
            
            id deserialized = nil;
            NSString *className = components[1];
            Class propertyClass = NSClassFromString(className);
            
            if ([value isKindOfClass:[NSArray class]]) {
                deserialized = [self deserializeClass:value withProperty:key withClass:propertyClass];
            }
            else if ([value isKindOfClass:[NSSet class]]) {
                deserialized = [self deserializeClass:value withProperty:key withClass:propertyClass];
            }
            else if ([value isKindOfClass:[NSDictionary class]]) {
                if ([propertyClass isSerializeable]) {
                    id instance = [[propertyClass alloc] init];
                    [instance deserialize:value];
                    deserialized = instance;
                }
                else {
                    deserialized = [self deserializeClass:value withProperty:key withClass:propertyClass];
                }
            }
            else if ([propertyClass isSubclassOfClass:[NSDate class]] && [value isKindOfClass:[NSNumber class]]) {
                deserialized = [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
            }
            else if ([propertyClass isSubclassOfClass:[NSDate class]] && [value isKindOfClass:[NSString class]]) {
                deserialized = [[self dateFormatterForProperty:key] dateFromString:value];
            }
            else {
                deserialized = value;
            }
            
            if ([deserialized isKindOfClass:propertyClass]) {
                [self setValue:deserialized forKey:key];
            }
            else if (deserialized && ![deserialized isKindOfClass:[NSNull class]]) {
                if ([propertyClass isSubclassOfClass:[NSNumber class]] && [deserialized isKindOfClass:[NSString class]]) {
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
                    NSNumber *number = [formatter numberFromString:deserialized];
                    
                    if (number) {
                        [self setValue:number forKey:key];
                    }
                    else {
                        NSLog(@"Cannot Set Property %@ of Type: %@ With A Value of Type: %@", key, className, NSStringFromClass([value class]));
                    }
                }
                else if ([propertyClass isSubclassOfClass:[NSString class]] && [deserialized isKindOfClass:[NSNumber class]]) {
                    NSString *string = [deserialized stringValue];
                    if (string) {
                        [self setValue:string forKey:key];
                    }
                    else {
                        NSLog(@"Cannot Set Property %@ of Type: %@ With A Value of Type: %@", key, className, NSStringFromClass([value class]));
                    }
                }
                else {
                    NSLog(@"Cannot Set Property %@ of Type: %@ With A Value of Type: %@", key, className, NSStringFromClass([value class]));
                    
                    if ([propertyClass isSerializeable]) {
                        [self setValue:[[propertyClass alloc] init] forKey:key];
                    }
                }
            }
        }
    }
    else if ([attribute characterAtIndex:1] != _C_STRUCT_B) { //Enum
        if ([value isKindOfClass:[NSString class]]) {
            NSDictionary *map = [self enumForProperty:key];
            if (map) {
                [self setValue:[[map allKeysForObject:value] lastObject] forKey:key];
            }
            else {
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
                [self setValue:[formatter numberFromString:value] forKey:key];
            }
        }
        else if ([value isKindOfClass:[NSNumber class]]) {
            [self setValue:value forKey:key];
        }
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", [self toJSON]];
}
@end
