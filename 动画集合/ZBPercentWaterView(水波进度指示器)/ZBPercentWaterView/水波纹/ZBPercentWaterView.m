//
//  PercentView.m
//  hyb
//
//  Created by xzb on 16/8/4.
//  Copyright © 2016年 hyb. All rights reserved.
//

#import "ZBPercentWaterView.h"
#import "Masonry.h"

@interface ZBPercentWaterView ()
{
    float _horizontal ;
    float _horizontal2 ;
}
@property (assign, nonatomic) CGFloat percent; /** value 0~1 */

//圆环
@property (strong, nonatomic) CAShapeLayer *topShapeLayer;
@property (strong, nonatomic) CAShapeLayer *grayShapeLayer;
@property (strong, nonatomic) UIBezierPath *circlePath;

//水波纹+文字
@property (strong,nonatomic) UILabel *topLabel;
@property (strong, nonatomic) UILabel *bottomLabel;
@property (strong, nonatomic) UIView *waterView;

//计时器
@property (strong, nonatomic) GCDTimer *waterTimer;
@end

@implementation ZBPercentWaterView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self configureView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureView];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self configureView];
    }
    return self;
}
- (void)configureView
{
    self.backgroundColor = [UIColor clearColor];
    [self.waterTimer start];
}
#pragma mark - 生命周期
- (void)layoutSubviews
{
    [self setShape:self.circlePath.CGPath];
    
    [self sendSubviewToBack:self.bottomLabel];
}
- (void)drawRect:(CGRect)rect
{
    //弧度＝角度＊3.14再除以180
    if (!self.circlePath)
    {
        CGPoint pCenter = CGPointMake(rect.size.width * 0.5, rect.size.height * 0.5);
        CGFloat radius = MIN(rect.size.width, rect.size.height);
        radius = radius - self.topLineWidth;
        UIBezierPath *circlePath = [UIBezierPath bezierPath];
        [circlePath addArcWithCenter:pCenter radius:radius * 0.5 startAngle:270 * M_PI / 180 endAngle:269 * M_PI / 180 clockwise:YES];
        [circlePath closePath];
        self.circlePath = circlePath;
    }
    
    if (!self.grayShapeLayer)
    {
        CAShapeLayer *grayShapeLayer = [CAShapeLayer layer];
        grayShapeLayer.frame = rect;
        
        grayShapeLayer.path = self.circlePath.CGPath;
        grayShapeLayer.fillColor = [UIColor clearColor].CGColor;
        grayShapeLayer.lineWidth = self.lineWidth;
        grayShapeLayer.strokeColor = [UIColor colorWithWhite:0.886 alpha:1.000].CGColor;
        grayShapeLayer.lineCap = kCALineCapRound;
        [self.layer addSublayer:grayShapeLayer];
        self.grayShapeLayer = grayShapeLayer;
    }
    if (!self.topShapeLayer)
    {
        self.topShapeLayer = [CAShapeLayer layer];
        self.topShapeLayer.frame = rect;
        self.topShapeLayer.path = self.circlePath.CGPath;
        self.topShapeLayer.fillColor = [UIColor clearColor].CGColor;
        self.topShapeLayer.lineWidth = self.topLineWidth;
        self.topShapeLayer.strokeColor = [UIColor colorWithRed:0.906 green:0.769 blue:0.125 alpha:1.000].CGColor;
        self.topShapeLayer.lineCap = kCALineCapRound;
        [self.layer addSublayer:self.topShapeLayer];
    }
    
    [self startAnimationValue:self.percent];
}
#pragma mark - api
- (void)setupProgressLabelText:(NSString *)text
{
    self.bottomLabel.text = text;
    self.topLabel.text = text;
}
- (void)setupProgress:(CGFloat)progress
{
    if (progress >= 0 || progress <= 1)
    {
        [self setupProgressLabelText:[NSString stringWithFormat:@"%.0f%%",progress*100]];
        
        [self.waterView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.top.offset(kWaterViewMaxHeight * (1 - progress) -20);
        }];
        [self setNeedsDisplay];
    }
    else
    {
        NSLog(@"progress value is error");
    }
}
+ (instancetype)percentWaterView
{
    ZBPercentWaterView *myView = [[ZBPercentWaterView alloc] init];
    return myView;
}
- (void)startAnimationValue:(CGFloat)value
{
    CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnima.duration = 1.0f;
    pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnima.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnima.toValue = [NSNumber numberWithFloat:value];
    pathAnima.fillMode = kCAFillModeForwards;
    pathAnima.removedOnCompletion = NO;
    [self.topShapeLayer addAnimation:pathAnima forKey:@"strokeEndAnimation"];
}

#pragma mark - getter / setter
- (GCDTimer *)waterTimer
{
    if (!_waterTimer)
    {
        _waterTimer= [[GCDTimer alloc] initInQueue:[GCDQueue mainQueue]];
        
        [_waterTimer event:^{
            {
                CGMutablePathRef wavePath = CGPathCreateMutable();
                CGPathMoveToPoint(wavePath, nil, 0,-kWaterViewMaxHeight*0.5);
                float y = 0;
                _horizontal += 0.2;
                for (float x = 0; x <= self.frame.size.width; x++) {
                    //峰高* sin(x * M_PI / self.frame.size.width * 峰的数量 + 移动速度)
                    y = 5* sin(x * M_PI / self.frame.size.width * 5.5 + _horizontal) ;
                    CGPathAddLineToPoint(wavePath, nil, x, y+20);
                }
                CGPathAddLineToPoint(wavePath, nil, self.frame.size.width , -kWaterViewMaxHeight*0.5);
                CGPathAddLineToPoint(wavePath, nil, self.frame.size.width, kWaterViewMaxHeight+20);
                CGPathAddLineToPoint(wavePath, nil, 0, kWaterViewMaxHeight+20);
                [self.waterView setShape:wavePath];
                CFRelease(wavePath);
            }
            
        } timeInterval:NSEC_PER_SEC * 0.01];
    }
    return _waterTimer;
}
- (void)setPercent:(CGFloat)percent
{
    _percent = percent;
    [self setNeedsDisplay];
}
- (UILabel *)topLabel
{
    if (!_topLabel)
    {
        _topLabel = [[UILabel alloc] init];
        [self.waterView addSubview:_topLabel];
        [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.height.offset(kShowLaberFont);
            make.bottom.offset(-(kWaterViewMaxHeight/2 - kShowLaberFont/2));
        }];
        _topLabel.font = [UIFont systemFontOfSize:kShowLaberFont];
        _topLabel.textColor = [UIColor whiteColor];
        _topLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _topLabel;
}
- (UILabel *)bottomLabel
{
    if (!_bottomLabel)
    {
        _bottomLabel = [[UILabel alloc] init];
        [self addSubview:_bottomLabel];
        [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.height.offset(kShowLaberFont);
            make.bottom.offset(-(kWaterViewMaxHeight/2 - kShowLaberFont/2));
        }];
        _bottomLabel.font = [UIFont systemFontOfSize:kShowLaberFont];
        _bottomLabel.textColor = [UIColor greenColor];
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomLabel;
}
- (UIView *)waterView
{
    if (!_waterView)
    {
        _waterView = [[UIView alloc] init];
        [self addSubview:_waterView];
        [_waterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.top.offset(0);
        }];
        _waterView.backgroundColor = [UIColor redColor];
        _waterView.layer.masksToBounds = YES;
    }
    return _waterView;
}

#pragma mark - model event

#pragma mark - view event

#pragma mark - private

#pragma mark - delegete

#pragma mark - notification

#pragma mark - kvo
@end
