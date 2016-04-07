//
//  SubscriptionServiceCenterProtocol.h
//  ObserverPattern
//
//  Created by YouXianMing on 15/8/9.
//  Copyright (c) 2015年 YouXianMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SubscriptionServiceCenterProtocol <NSObject>

@required
- (void)subscriptionMessage:(id)message subscriptionNumber:(NSString *)subscriptionNumber;

@end
