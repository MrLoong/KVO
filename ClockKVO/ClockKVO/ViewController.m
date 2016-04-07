//
//  ViewController.m
//  ClockKVO
//
//  Created by LastDays on 16/4/4.
//  Copyright © 2016年 LastDays. All rights reserved.
//

#import "ViewController.h"
#import "TimeDate.h"
#import "RNTimer.h"
#import "Observer.h"
#import "DDClock.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *showTime;
@property (nonatomic,strong) TimeDate *time;
@property (readwrite, strong) RNTimer *timer;
@property (nonatomic, strong) id observeToken;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.time == nil) {
        self.time = [[TimeDate alloc] init];
    }
    
    id weakSelf = self;
    self.timer = [RNTimer repeatingTimerWithTimeInterval:1
                                      block:^{
                                          [weakSelf updateTime];
                                      }];
    // Do any additional setup after loading the view, typically from a nib.
    
    DDClock *clock2 = [[DDClock alloc] initWithTheme:DDClockThemeDark frame:CGRectMake(50, 160, 220, 220)];
    [[self view] addSubview:clock2];
}

-(void)setTime:(TimeDate *)time{
    
    _time = time;
    self.observeToken = [Observer observeObject:self.time keyPath:@"now" target:self selector:@selector(timeDidChange) options:NSKeyValueObservingOptionInitial];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateTime{
    self.time.now = [NSDate new];
}

-(void)timeDidChange{
    self.showTime.text = [self.time.now description];
}
@end
