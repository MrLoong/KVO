//
//  LastDays.m
//  KVO
//
//  Created by LastDays on 16/4/4.
//  Copyright © 2016年 LastDays. All rights reserved.
//

#import "LastDays.h"

@implementation LastDays

+(NSSet *)keyPathsForValuesAffectingName{
    
    NSSet *set = [NSSet setWithObjects:@"chineseName", nil];
    
    return set;
}

@end
