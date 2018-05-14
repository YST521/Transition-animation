//
//  ViewController.m
//  HUD
//
//  Created by youxin on 2018/5/10.
//  Copyright © 2018年 yst. All rights reserved.
//

#import "ViewController.h"
#import "SCCatWaitingHUD.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor =[UIColor cyanColor];
    
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(![SCCatWaitingHUD sharedInstance].isAnimating)
    {
        [[SCCatWaitingHUD sharedInstance] animateWithInteractionEnabled:YES];
    }
    else
    {
        [[SCCatWaitingHUD sharedInstance] stop];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
