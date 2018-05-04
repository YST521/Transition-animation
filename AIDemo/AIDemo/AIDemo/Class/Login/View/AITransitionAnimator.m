//
//  AITransitionAnimator.m
//  AIDemo
//
//  Created by yst on 16/9/14.
//  Copyright © 2016年 yst. All rights reserved.
//

#import "AITransitionAnimator.h"
#import "AILoginViewController.h"
#import "MCLeftSlideViewController.h"
@interface AITransitionAnimator ()<UIViewControllerAnimatedTransitioning,CAAnimationDelegate>
@property (weak, nonatomic) id transitionContext;
@end
@implementation AITransitionAnimator



// This is used for percent driven interactive transitions, as well as for container controllers that have companion animations that might need to
// synchronize with the main animation.
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.5;
}
// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    self.transitionContext = transitionContext;
    
    UIView *containerView = [transitionContext containerView];
    AILoginViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    KeepNewFeatrueView *keepView = fromVC.keepView;
    
    MCLeftSlideViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //得到登录按钮
    UIButton *btn = keepView.loginButton;
    
    [containerView addSubview:toVC.view];
    
    UIBezierPath *originPath = [UIBezierPath bezierPathWithOvalInRect:btn.frame];
    
    //动画起始点
//    UIBezierPath *originPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(100, 200, 50, 50)];
//     UIBezierPath *originPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(containerView.frame.size.width/2-20, containerView.frame.size.height/2-20, 40, 40)];
    
//     UIBezierPath *originPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 40, 40)];
    
   CGPoint extremePoint = CGPointMake(btn.center.x - 0, btn.center.y );//- CGRectGetHeight(toVC.view.bounds));
//
    //CGPoint extremePoint = CGPointMake(200,200 );//- CGRectGetHeight(toVC.view.bounds));
    
    float radius = sqrtf(extremePoint.x * extremePoint.x + extremePoint.y * extremePoint.y);
    UIBezierPath *finalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(btn.frame, -radius, -radius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = finalPath.CGPath;
    toVC.view.layer.mask = maskLayer;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.fromValue = (__bridge id _Nullable)(originPath.CGPath);
    animation.toValue = (__bridge id _Nullable)(finalPath.CGPath);
    animation.duration = [self transitionDuration:transitionContext];
    animation.delegate = self;
    [maskLayer addAnimation:animation forKey:@"path"];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
}

@end
