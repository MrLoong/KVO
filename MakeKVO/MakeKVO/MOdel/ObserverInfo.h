//
//  ObserverInfo.h
//  MakeKVO
//
//  Created by LastDays on 16/4/7.
//  Copyright © 2016年 LastDays. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LYBlock)(id observedObject, NSString *observedKey, id oldValue, id newValue);
@interface ObserverInfo : NSObject

@property(nonatomic,weak) NSObject *observer;
@property(nonatomic,copy) NSString *key;
@property(nonatomic,copy) LYBlock lyBlock;


- (instancetype)initWithObserver:(NSObject *)observer Key:(NSString *)key lyBlock:(LYBlock)lyBlock;

@end
