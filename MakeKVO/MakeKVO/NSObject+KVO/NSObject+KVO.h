//
//  NSObject+KVO.h
//  MakeKVO
//
//  Created by LastDays on 16/4/5.
//  Copyright © 2016年 LastDays. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LYBlock)(id observedObject, NSString *observedKey, id oldValue, id newValue);

@interface NSObject (LYKVO)

-(void)LY_addObserver:(NSObject *)observer
               forKey:(NSString *)key
               LYBlock:(LYBlock)lyblock;

- (void)PG_removeObserver:(NSObject *)observer forKey:(NSString *)key;


@end





