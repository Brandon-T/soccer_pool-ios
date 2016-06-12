//
//  NSObject+Serializable.h
//  SoccerPool
//
//  Created by Brandon Thomas on 2016-06-05.
//  Copyright © 2016 XIO. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Serializeable <NSObject>
@end

@protocol NonSerializeable <NSObject>
@end


@interface NSObject (Serializable)

- (NSString *)propertyForName:(NSString *)name;

+ (instancetype)fromJSON:(NSDictionary *)json;
+ (NSArray<Serializeable> *)fromJSONArray:(NSArray<NSDictionary<NSString *, id> *> *)json;
- (NSDictionary *)toJSON;
@end
