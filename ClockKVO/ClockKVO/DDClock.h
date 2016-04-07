//
//  DDClock.h
//  Created by David on 15/1/26.
//  博客：http://www.cnblogs.com/daiweilai/
//  github：https://github.com/daiweilai/
//  Copyright (c) 2015年 DavidDay. All rights reserved.
// 

#import <UIKit/UIKit.h>
#import "TimeDate.h"
#import "Observer.h"
#import "RNTimer.h"
#define DDClockSize 200 //默认时钟的长宽都为200
#if ! __has_feature(objc_arc)
#error "需要开启ARC"
#endif



@interface DDClock : UIView

typedef NS_ENUM(NSUInteger, DDClockTheme) { //弄一个枚举类型用来更改主题
    DDClockThemeDefault = 0,
    DDClockThemeDark,
    DDClockThemeModerm
};


//声明timeModel

@property(nonatomic,copy)TimeDate *time;
@property (nonatomic, strong) id observeToken;
@property (readwrite, strong) RNTimer *timer;


///DDClock的构造方法
-(instancetype)initWithTheme:(DDClockTheme)theme frame:(CGRect)frame;



@end
