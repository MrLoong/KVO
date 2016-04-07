//
//  RNTimer.h
//  ClockKVO
//
//  Created by LastDays on 16/4/4.
//  Copyright © 2016年 LastDays. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RNTimer : NSObject

/**---------------------------------------------------------------------------------------
 @name Creating a Timer
 -----------------------------------------------------------------------------------------
 */

/** Creates and returns a new repeating RNTimer object and starts running it
 
 After `seconds` seconds have elapsed, the timer fires, executing the block.
 You will generally need to use a weakSelf pointer to avoid a retain loop.
 The timer is attached to the main GCD queue.
 
 @param seconds The number of seconds between firings of the timer. Must be greater than 0.
 @param block Block to execute. Must be non-nil
 
 @return A new RNTimer object, configured according to the specified parameters.
 */
+ (RNTimer *)repeatingTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(void))block;


/**---------------------------------------------------------------------------------------
 @name Firing a Timer
 -----------------------------------------------------------------------------------------
 */

/** Causes the block to be executed.
 
 This does not modify the timer. It will still fire on schedule.
 */
- (void)fire;


/**---------------------------------------------------------------------------------------
 @name Stopping a Timer
 -----------------------------------------------------------------------------------------
 */

/** Stops the receiver from ever firing again
 
 Once invalidated, a timer cannot be reused.
 
 */
- (void)invalidate;

@end
