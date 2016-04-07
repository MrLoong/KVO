//
//  ViewController.m
//  KVO
//
//  Created by LastDays on 16/4/4.
//  Copyright © 2016年 LastDays. All rights reserved.
//

#import "ViewController.h"
#import "LastDays.h"
#import "LastdaysObserver.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self test];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)test{
    LastdaysObserver *lastdaysObserver = [[LastdaysObserver alloc] init];
    LastDays *lastdays = [[LastDays alloc] init];
    
    NSString *name =@"lastdays";
    lastdays.name = name;
    
    //添加观察者
    [lastdays addObserver:lastdaysObserver
               forKeyPath:@"name"
                  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                  context:(void*)self];
    
    
    lastdays.name = @"test";
    
    lastdays.chineseName = @"小猪";
    


    
    //移除观察者观察的对应属性
    [lastdays removeObserver:lastdaysObserver forKeyPath:@"name"];
}




@end
