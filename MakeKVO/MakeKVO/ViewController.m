//
//  ViewController.m
//  MakeKVO
//
//  Created by LastDays on 16/4/5.
//  Copyright © 2016年 LastDays. All rights reserved.
//

#import "ViewController.h"
#import "Model.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    Model *model = [[Model alloc] init];
    [model LY_addObserver:self forKey:@"name" LYBlock:^(id observerInfo,NSString *key,id old,id newValue){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"newValue = %@",newValue);
        });

    }];
    model.name = @"1";
    model.name = @"2";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
