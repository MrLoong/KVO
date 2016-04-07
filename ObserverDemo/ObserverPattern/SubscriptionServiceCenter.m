//
//  SubscriptionServiceCenter.m
//  ObserverPattern
//
//  Created by YouXianMing on 15/8/9.
//  Copyright (c) 2015年 YouXianMing. All rights reserved.
//

#import "SubscriptionServiceCenter.h"

static NSMutableDictionary *_subscriptionDictionary = nil;

@implementation SubscriptionServiceCenter

+ (void)initialize {
    
    NSLog(@"ok");
    
    if (self == [SubscriptionServiceCenter class]) {
        
        _subscriptionDictionary = [NSMutableDictionary dictionary];
    }
}

+ (void)createSubscriptionNumber:(NSString *)subscriptionNumber {

    NSParameterAssert(subscriptionNumber);
    
    NSHashTable *hashTable = [self existSubscriptionNumber:subscriptionNumber];
    if (hashTable == nil) {
        
        hashTable = [NSHashTable weakObjectsHashTable];
        [_subscriptionDictionary setObject:hashTable forKey:subscriptionNumber];
    }
}

+ (void)removeSubscriptionNumber:(NSString *)subscriptionNumber {

    NSParameterAssert(subscriptionNumber);
    
    NSHashTable *hashTable = [self existSubscriptionNumber:subscriptionNumber];
    if (hashTable) {
        
        [_subscriptionDictionary removeObjectForKey:subscriptionNumber];
    }
}

+ (void)addCustomer:(id <SubscriptionServiceCenterProtocol>)customer withSubscriptionNumber:(NSString *)subscriptionNumber {

    NSParameterAssert(customer);
    NSParameterAssert(subscriptionNumber);
    
    NSHashTable *hashTable = [self existSubscriptionNumber:subscriptionNumber];
    [hashTable addObject:customer];
}

+ (void)removeCustomer:(id <SubscriptionServiceCenterProtocol>)customer withSubscriptionNumber:(NSString *)subscriptionNumber {

    NSParameterAssert(subscriptionNumber);
    
    NSHashTable *hashTable = [self existSubscriptionNumber:subscriptionNumber];
    [hashTable removeObject:customer];
}

+ (void)sendMessage:(id)message toSubscriptionNumber:(NSString *)subscriptionNumber {

    NSParameterAssert(subscriptionNumber);
    
    NSHashTable *hashTable = [self existSubscriptionNumber:subscriptionNumber];
    if (hashTable) {
        
        NSEnumerator *enumerator = [hashTable objectEnumerator];
        id <SubscriptionServiceCenterProtocol> object = nil;
        while (object = [enumerator nextObject]) {
            
            if ([object respondsToSelector:@selector(subscriptionMessage:subscriptionNumber:)]) {

                [object subscriptionMessage:message subscriptionNumber:subscriptionNumber];
            }
        }
    }
}


#pragma mark - 私有方法
+ (NSHashTable *)existSubscriptionNumber:(NSString *)subscriptionNumber {

    return [_subscriptionDictionary objectForKey:subscriptionNumber];
}

@end
