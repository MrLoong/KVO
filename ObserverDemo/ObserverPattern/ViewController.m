//
//  ViewController.m
//  ObserverPattern
//
//  Created by YouXianMing on 15/8/9.
//  Copyright (c) 2015年 YouXianMing. All rights reserved.
//

#import "ViewController.h"
#import "SubscriptionServiceCenter.h"

static NSString *SCIENCE = @"SCIENCE";

@interface ViewController () <SubscriptionServiceCenterProtocol>

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    // 创建订阅号
    [SubscriptionServiceCenter createSubscriptionNumber:SCIENCE];
    
    // 添加订阅的用户到指定的刊物
    [SubscriptionServiceCenter addCustomer:self
                    withSubscriptionNumber:SCIENCE];
    
    // 发行机构发送消息
    [SubscriptionServiceCenter sendMessage:@"V2.0" toSubscriptionNumber:SCIENCE];
}

- (void)subscriptionMessage:(id)message subscriptionNumber:(NSString *)subscriptionNumber {

    NSLog(@"%@  %@", message, subscriptionNumber);
}

@end
