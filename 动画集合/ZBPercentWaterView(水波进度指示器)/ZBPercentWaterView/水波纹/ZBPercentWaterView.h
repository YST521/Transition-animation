//
//  PercentView.h
//  hyb
//
//  Created by xzb on 16/8/4.
//  Copyright © 2016年 hyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCD.h"
#import "UIView+Shape.h"

static  CGFloat kWaterViewMaxHeight = 200;
static  CGFloat kShowLaberFont = 72;

@interface ZBPercentWaterView : UIView


@property (assign, nonatomic) CGFloat lineWidth;
@property (assign, nonatomic) CGFloat topLineWidth;

+ (instancetype)percentWaterView;
/** progress 0.00~1.00 */
- (void)setupProgress:(CGFloat)progress;

@end
