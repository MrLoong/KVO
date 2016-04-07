//
//  RNTimer.m
//  ClockKVO
//
//  Created by LastDays on 16/4/4.
//  Copyright © 2016年 LastDays. All rights reserved.
//

#import "RNTimer.h"


@interface RNTimer ()
@property (nonatomic, readwrite, copy) void (^block)();
@property (nonatomic, readwrite, strong) dispatch_source_t source;
@end


@implementation RNTimer

@synthesize block = _block;
@synthesize source = _source;

+ (RNTimer *)repeatingTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(void))block
{
    NSParameterAssert(seconds);
    NSParameterAssert(block);
    
    RNTimer *timer = [[self alloc] init];
    timer.block = block;
    timer.source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,
                                          dispatch_get_main_queue());
    uint64_t nsec = (uint64_t)(seconds * NSEC_PER_SEC);
    dispatch_source_set_timer(timer.source, dispatch_time(DISPATCH_TIME_NOW, nsec),
                              nsec, 0);
    dispatch_source_set_event_handler(timer.source, block);
    dispatch_resume(timer.source);
    return timer;
}

- (void)invalidate
{
    if (self.source) {
        dispatch_source_cancel(self.source);
        self.source = nil;
    }
    self.block = nil;
}

- (void)dealloc
{
    [self invalidate];
}

- (void)fire
{
    self.block();
}



@end
