//
//  LastdaysObserver.m
//  KVO
//
//  Created by LastDays on 16/4/4.
//  Copyright © 2016年 LastDays. All rights reserved.
//

#import "LastdaysObserver.h"

@implementation LastdaysObserver

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                     change:(NSDictionary<NSString *,id> *)change
                      context:(void *)context{
    NSLog(@"old = %@",[change objectForKey:NSKeyValueChangeOldKey]);
    NSLog(@"new = %@",[change objectForKey:NSKeyValueChangeNewKey]);
    NSLog(@"context:%@",context);

}

@end
