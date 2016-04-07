//
//  ObserverInfo.m
//  MakeKVO
//
//  Created by LastDays on 16/4/7.
//  Copyright © 2016年 LastDays. All rights reserved.
//

#import "ObserverInfo.h"

@implementation ObserverInfo

- (instancetype)initWithObserver:(NSObject *)observer Key:(NSString *)key lyBlock:(LYBlock)lyBlock
{
    self = [super init];
    if (self) {
        _observer = observer;
        _key = key;
        _lyBlock = lyBlock;
    }
    return self;
}

@end
