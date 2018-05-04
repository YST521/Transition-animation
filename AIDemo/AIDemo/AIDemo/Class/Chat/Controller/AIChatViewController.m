//
//  AIChatViewController.m
//  AIDemo
//
//  Created by yst on 16/9/9.
//  Copyright © 2016年 yst. All rights reserved.
//

#import "AIChatViewController.h"
#import "AIChatSingleViewController.h"
@interface AIChatViewController ()

@end

@implementation AIChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    AIChatSingleViewController *vc = [[AIChatSingleViewController alloc] initWithConversationChatter:AI2Account conversationType:EMConversationTypeChat];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
