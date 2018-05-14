//
//  ViewController.m
//  ZBPercentWaterView
//
//  Created by xzb on 2016/12/29.
//  Copyright © 2016年 xzb. All rights reserved.
//

#import "ViewController.h"
#import "ZBPercentWaterView.h"
@interface ViewController ()
@property (strong, nonatomic) ZBPercentWaterView *percentView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.percentView = [[ZBPercentWaterView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    [self.view addSubview:self.percentView];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setupProgress];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self setupProgress];
}
- (void)setupProgress
{
    [self.percentView setupProgress:(arc4random()%100)/100.00];
}


@end
