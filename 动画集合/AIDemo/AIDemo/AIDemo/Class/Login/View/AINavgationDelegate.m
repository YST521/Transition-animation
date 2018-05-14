//
//  AINavgationDelegate.m
//  AIDemo
//
//  Created by yst on 16/9/17.
//  Copyright © 2016年 yst. All rights reserved.
//

#import "AINavgationDelegate.h"
#import "AITransitionAnimator.h"

@interface AINavgationDelegate ()

@end
@implementation AINavgationDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    
    return (id)[AITransitionAnimator new];
}

//- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
//                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
//    
//    return self.interactionController;
//}
@end
