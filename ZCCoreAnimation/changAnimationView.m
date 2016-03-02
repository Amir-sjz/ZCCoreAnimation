//
//  changAnimationView.m
//  ZCCoreAnimation
//
//  Created by 张程 on 16/3/2.
//  Copyright © 2016年 张程. All rights reserved.
//

#import "changAnimationView.h"

static const CGFloat rate = 0.2;

static const CGFloat Raduis = 50.0f;
static const CGFloat lineWidth = 50.0f;
static const CGFloat lineGapHeight = 10.0f;
static const CGFloat lineHeight = 8.0f;

static const CGFloat kStep1Duration = 0.5*rate;
static const CGFloat kStep2Duration = 0.5*rate;
static const CGFloat kStep3Duration = 5.0*rate;
static const CGFloat kStep4Duration = 5.0*rate;

#define  kAnimationKey      @"animationName"
#define  kAnimationKeyStep1 @"animationStep1"
#define  kAnimationKeyStep2 @"animationStep2"
#define  kAnimationKeyStep3 @"animationStep3"
#define  kAnimationKeyStep4 @"animationStep4"

#define kTopY       Raduis - lineGapHeight
#define kCenterY    kTopY + lineGapHeight + lineHeight
#define kBottomY    kCenterY + lineGapHeight + lineHeight
#define Radians(x)  (M_PI * (x) / 180.0)

@interface changAnimationView ()
{
    CGFloat self_width;
    CGFloat self_hight;
}

@property (nonatomic, strong) CAShapeLayer *topLayer;
@property (nonatomic, strong) CAShapeLayer *changeLayer;
@property (nonatomic, strong) CAShapeLayer *bottomLayer;

@end

@implementation changAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        
        self_width = frame.size.width;
        self_hight = frame.size.height;
        
        self.backgroundColor = [UIColor orangeColor];
    }
    return self;
}

- (void)start
{
    [_topLayer removeFromSuperlayer];
    [_bottomLayer removeFromSuperlayer];
    [_changeLayer removeAllAnimations];
    [_changeLayer removeFromSuperlayer];
    
    
    [self initLayers];
    
    [self animationStep1];
}

- (void)initLayers
{
    _topLayer = [CAShapeLayer layer];
    _bottomLayer = [CAShapeLayer layer];
    _changeLayer = [CAShapeLayer layer];
    
    CAShapeLayer *top = [CAShapeLayer layer];
    top.frame = CGRectMake((self.bounds.size.width + lineWidth)/2, kTopY,lineWidth, lineHeight);
    [top addSublayer:_topLayer];
    
    CAShapeLayer *bottom = [CAShapeLayer layer];
    bottom.frame = CGRectMake((self.bounds.size.width + lineWidth)/2, kBottomY,lineWidth, lineHeight);
    [bottom addSublayer:_bottomLayer];
    
    [self.layer addSublayer:top];
    [self.layer addSublayer:bottom];
    [self.layer addSublayer:_changeLayer];
    
    [self setlineLayer:_topLayer];
    [self setlineLayer:_bottomLayer];
    [self setlineLayer:_changeLayer];
    
    _topLayer.path = [self linePath];
    _bottomLayer.path = [self linePath];
    
    
    CGFloat startOriginX = self.center.x - lineWidth /2.0;
    CGFloat endOriginX = self.center.x + lineWidth /2.0;
    [self changeLayerPath:_changeLayer Start:startOriginX End:endOriginX];
    
}

- (void)setlineLayer:(CAShapeLayer *)layer
{
    [layer setStrokeColor:[UIColor whiteColor].CGColor];
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.lineWidth = lineHeight;
    layer.lineCap = kCALineCapRound;
    layer.position = CGPointMake(0, 0);
    
    
}

- (CGPathRef)linePath
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(-lineWidth, 0)];
    return path.CGPath;
}

- (void)changeLayerPath:(CAShapeLayer *)layer Start:(CGFloat)startOriginX End:(CGFloat)endOriginX
{
    CGMutablePathRef solidChangedLinePath =  CGPathCreateMutable();
    //被改变的layer实线
    CGPathMoveToPoint(solidChangedLinePath, NULL, startOriginX, kCenterY);
    CGPathAddLineToPoint(solidChangedLinePath, NULL, endOriginX, kCenterY);
    [layer setPath:solidChangedLinePath];
    CGPathRelease(solidChangedLinePath);
}




- (void)stop
{
    
}

- (void)cancel
{
    [self cancelAnimation];
}

#pragma mark - delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([[anim valueForKey:kAnimationKey] isEqualToString:kAnimationKeyStep1]) {
        [self animationStep2];
    }
    else if ([[anim valueForKey:kAnimationKey] isEqualToString:kAnimationKeyStep2]) {
        [_changeLayer removeFromSuperlayer];
        [self animationStep3];
    }
    else if ([[anim valueForKey:kAnimationKey] isEqualToString:kAnimationKeyStep3]) {
//        [self cancelAnimation];
    }
    else if ([[anim valueForKey:kAnimationKey] isEqualToString:kAnimationKeyStep4]) {
        
    }
}

//-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
//{
//    
//    if ([[anim valueForKey:@"animationName"] isEqualToString:@"animationStep1"]) {
//        
//        [self animationStep2];
//        
//    }
//    else if([[anim valueForKey:@"animationName"] isEqualToString:@"animationStep2"]){
//        [_changeLayer removeFromSuperlayer];
//        [self animationStep3];
//    }
//    else if ([[anim valueForKey:@"animationName"] isEqualToString:@"animationStep3"]){
//        [self cancelAnimation];
//    }
//    else if ([[anim valueForKey:@"animationName"] isEqualToString:@"animationStep4"]){
//        
//        _changeLayer.affineTransform = CGAffineTransformMakeTranslation(5, 0);
//        //平移x
//        CABasicAnimation *translationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
//        translationAnimation.fromValue = [NSNumber numberWithFloat:0];
//        translationAnimation.toValue = [NSNumber numberWithFloat:5];
//        
//        translationAnimation.duration = 0.5;
//        translationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        [_changeLayer addAnimation:translationAnimation forKey:nil];
//    }
//}

#pragma mark - step

#pragma mark 向左移动 并缩短
- (void) animationStep1{
    
    _changeLayer.strokeEnd = 0.4;
    
    CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeAnimation.fromValue = @1.0;
    strokeAnimation.toValue = @0.4;
    
    CABasicAnimation *patchAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    patchAnimation.fromValue = @0.0;
    patchAnimation.toValue = @-10;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[strokeAnimation, patchAnimation];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animationGroup.duration = kStep1Duration;
    animationGroup.delegate = self;
    animationGroup.removedOnCompletion = YES;
    [animationGroup setValue:@"animationStep1" forKey:kAnimationKey];
    [_changeLayer addAnimation:animationGroup forKey:nil];
}

#pragma mark  向右 变长
-(void)animationStep2
{
    CABasicAnimation *translationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    translationAnimation.fromValue = [NSNumber numberWithFloat:-10];
    //strokeEnd:0.8 剩余的距离toValue = lineWidth * (1 - 0.8);
    translationAnimation.toValue = [NSNumber numberWithFloat:0.2 * lineWidth];
    
    
    _changeLayer.strokeEnd = 0.8;
    CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeAnimation.fromValue = [NSNumber numberWithFloat:0.4f];
    strokeAnimation.toValue = [NSNumber numberWithFloat:0.8f];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects:strokeAnimation,translationAnimation, nil];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animationGroup.duration = kStep2Duration;
    animationGroup.delegate = self;
    animationGroup.removedOnCompletion = YES;
    [animationGroup setValue:@"animationStep2" forKey:kAnimationKey];
    [_changeLayer addAnimation:animationGroup forKey:nil];
}

#pragma mark  画圆
-(void)animationStep3{
    
    _changeLayer = [CAShapeLayer layer];
    _changeLayer.fillColor = [UIColor clearColor].CGColor;
    _changeLayer.strokeColor = [UIColor whiteColor].CGColor;
    _changeLayer.contentsScale = [UIScreen mainScreen].scale;
    _changeLayer.lineWidth = lineHeight ;
    _changeLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:_changeLayer];
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // 画贝塞尔曲线 圆弧
    [path moveToPoint:CGPointMake(self.center.x +  lineWidth/2.0 , kCenterY)];
    
    //30度,经过反复测试，效果最好
    CGFloat angle = Radians(30);
    
    CGFloat endPointX = self.center.x + Raduis * cos(angle);
    CGFloat endPointY = kCenterY - Raduis * sin(angle);
    
    CGFloat startPointX = self.center.x + lineWidth/2.0;
    CGFloat startPointY = kCenterY;
    
    CGFloat controlPointX = self.center.x + Raduis *acos(angle);
    CGFloat controlPointY = kCenterY;
    
    //三点曲线
    [path addCurveToPoint:CGPointMake(endPointX, endPointY)
            controlPoint1:CGPointMake(startPointX , startPointY)
            controlPoint2:CGPointMake(controlPointX , controlPointY)];
    
    //组合path 路径
    UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x,kCenterY)
                                                         radius:Raduis
                                                     startAngle:2 * M_PI - angle
                                                       endAngle:M_PI + angle
                                                      clockwise:NO];
    [path appendPath:path1];
    
    UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x,kCenterY)
                                                         radius:Raduis
                                                     startAngle:M_PI *3/2 - (M_PI_2 -angle)
                                                       endAngle:-M_PI_2 - (M_PI_2 -angle)
                                                      clockwise:NO];
    
    
    [path appendPath:path2];
    
    _changeLayer.path = path.CGPath;
    
    
    
    //平移量
    CGFloat toValue = lineWidth *(1- cos(M_PI_4)) /2.0;
    //finished 最终状态
    CGAffineTransform transform1 = CGAffineTransformMakeRotation(-M_PI_4);
    CGAffineTransform transform2 = CGAffineTransformMakeTranslation(-toValue, 0);
    CGAffineTransform transform3 = CGAffineTransformMakeRotation(M_PI_4);
    
    CGAffineTransform transform = CGAffineTransformConcat(transform1, transform2);
    _topLayer.affineTransform = transform;
    transform = CGAffineTransformConcat(transform3, transform2);
    _bottomLayer.affineTransform = transform;
    
    
    
    CGFloat orignPercent = [self calculateCurveLength] / [self calculateTotalLength];
    CGFloat endPercent =([self calculateCurveLength] + Radians(120) *Raduis ) / [self calculateTotalLength];
    
    _changeLayer.strokeStart = endPercent;
    
    CAKeyframeAnimation *startAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
    startAnimation.values = @[@0.0,@(endPercent)];
    
    CAKeyframeAnimation *EndAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    EndAnimation.values = @[@(orignPercent),@1.0];
    
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects:startAnimation,EndAnimation, nil];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animationGroup.duration = kStep3Duration;
    animationGroup.delegate = self;
    animationGroup.removedOnCompletion = YES;
    [animationGroup setValue:@"animationStep3" forKey:kAnimationKey];
    [_changeLayer addAnimation:animationGroup forKey:nil];
    
    //平移x
    CABasicAnimation *translationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    translationAnimation.fromValue = [NSNumber numberWithFloat:0];
    translationAnimation.toValue = [NSNumber numberWithFloat:-toValue];
    
    //角度关键帧 上横线的关键帧 0 - 10° - (-55°) - (-45°)
    CAKeyframeAnimation *rotationAnimation1 = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation1.values = @[[NSNumber numberWithFloat:0],
                                  [NSNumber numberWithFloat:Radians(10) ],
                                  [NSNumber numberWithFloat:Radians(-10) - M_PI_4 ],
                                  [NSNumber numberWithFloat:- M_PI_4 ]
                                  ];
    
    
    CAAnimationGroup *transformGroup1 = [CAAnimationGroup animation];
    transformGroup1.animations = [NSArray arrayWithObjects:rotationAnimation1,translationAnimation, nil];
    transformGroup1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transformGroup1.duration = kStep3Duration;
    transformGroup1.removedOnCompletion = YES;
    [_topLayer addAnimation:transformGroup1 forKey:nil];
    
    //角度关键帧 下横线的关键帧 0 - （-10°） - (55°) - (45°)
    CAKeyframeAnimation *rotationAnimation2 = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation2.values = @[[NSNumber numberWithFloat:0],
                                  [NSNumber numberWithFloat:Radians(-10) ],
                                  [NSNumber numberWithFloat:Radians(10) + M_PI_4 ],
                                  [NSNumber numberWithFloat: M_PI_4 ]
                                  ];
    
    
    CAAnimationGroup *transformGroup2 = [CAAnimationGroup animation];
    transformGroup2.animations = [NSArray arrayWithObjects:rotationAnimation2,translationAnimation, nil];
    transformGroup2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transformGroup2.duration = kStep3Duration ;
    transformGroup2.delegate = self;
    transformGroup2.removedOnCompletion = YES;
    [_bottomLayer addAnimation:transformGroup2 forKey:nil];
    
}

#pragma mark - 按原路返回
-(void)cancelAnimation
{
    //最关键是path路径
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    //30度,经过反复测试，效果最好
    CGFloat angle = Radians(30);
    
    CGFloat startPointX = self.center.x + Raduis * cos(angle);
    CGFloat startPointY = kCenterY - Raduis * sin(angle);
    
    CGFloat controlPointX = self.center.x + Raduis *acos(angle);
    CGFloat controlPointY = kCenterY;
    
    CGFloat endPointX = self.center.x + lineWidth /2;
    CGFloat endPointY = kCenterY;
    
    //组合path 路径 起点 -150° 顺时针的圆
    path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x,kCenterY)
                                          radius:Raduis
                                      startAngle:-M_PI + angle
                                        endAngle:M_PI + angle
                                       clockwise:YES];
    
    //起点为 180°-> (360°-30°)
    UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x,kCenterY)
                                                         radius:Raduis
                                                     startAngle:M_PI + angle
                                                       endAngle:2 * M_PI - angle
                                                      clockwise:YES];
    [path appendPath:path1];
    
    //三点曲线
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    
    [path2 moveToPoint:CGPointMake(startPointX, startPointY)];
    
    [path2 addCurveToPoint:CGPointMake(endPointX,endPointY)
             controlPoint1:CGPointMake(startPointX, startPointY)
             controlPoint2:CGPointMake(controlPointX, controlPointY)];
    
    [path appendPath:path2];
    
    //比原始状态向左偏移5个像素
    UIBezierPath *path3 = [UIBezierPath bezierPath];
    [path3 moveToPoint:CGPointMake(endPointX,endPointY)];
    [path3 addLineToPoint:CGPointMake(self.center.x - lineWidth/2 -5,endPointY)];
    [path appendPath:path3];
    
    _changeLayer.path = path.CGPath;
    
    //平移量
    CGFloat toValue = lineWidth *(1- cos(M_PI_4)) /2.0;
    //finished 最终状态
    CGAffineTransform transform1 = CGAffineTransformMakeRotation(0);
    CGAffineTransform transform2 = CGAffineTransformMakeTranslation(0, 0);
    CGAffineTransform transform3 = CGAffineTransformMakeRotation(0);
    
    CGAffineTransform transform = CGAffineTransformConcat(transform1, transform2);
    _topLayer.affineTransform = transform;
    transform = CGAffineTransformConcat(transform3, transform2);
    _bottomLayer.affineTransform = transform;
    
    //一个圆的长度比
    CGFloat endPercent = 2* M_PI *Raduis / ([self calculateTotalLength] + lineWidth);
    
    
    //横线占总path的长度比
    CGFloat percent = lineWidth / ([self calculateTotalLength] + lineWidth);
    
    _changeLayer.strokeStart = 1.0 -percent;
    
    CAKeyframeAnimation *startAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
    startAnimation.values = @[@0.0,@0.3,@(1.0 -percent)];
    
    //在π+ angle
    CAKeyframeAnimation *EndAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    EndAnimation.values = @[@(endPercent),@(endPercent),@1.0];
    
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects:startAnimation,EndAnimation, nil];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationGroup.duration = kStep4Duration;
    animationGroup.delegate = self;
    animationGroup.removedOnCompletion = YES;
    [animationGroup setValue:kAnimationKeyStep4 forKey:kAnimationKey];
    [_changeLayer addAnimation:animationGroup forKey:nil];
    
    //平移x
    CABasicAnimation *translationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    translationAnimation.fromValue = [NSNumber numberWithFloat:-toValue];
    translationAnimation.toValue = [NSNumber numberWithFloat:0];
    
    //角度关键帧 上横线的关键帧  (-45°) -> (-55°)-> 10° -> 0
    CAKeyframeAnimation *rotationAnimation1 = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation1.values = @[[NSNumber numberWithFloat:- M_PI_4 ],
                                  [NSNumber numberWithFloat:- Radians(10) - M_PI_4 ],
                                  [NSNumber numberWithFloat:Radians(10) ],
                                  [NSNumber numberWithFloat:0]
                                  ];
    
    
    CAAnimationGroup *transformGroup1 = [CAAnimationGroup animation];
    transformGroup1.animations = [NSArray arrayWithObjects:rotationAnimation1,translationAnimation, nil];
    transformGroup1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transformGroup1.duration = kStep4Duration;
    transformGroup1.removedOnCompletion = YES;
    [_topLayer addAnimation:transformGroup1 forKey:nil];
    
    //角度关键帧 下横线的关键帧  (45°)-> (55°)- >（-10°）-> 0
    CAKeyframeAnimation *rotationAnimation2 = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation2.values = @[[NSNumber numberWithFloat: M_PI_4 ],
                                  [NSNumber numberWithFloat:Radians(10) + M_PI_4 ],
                                  [NSNumber numberWithFloat:-Radians(10) ],
                                  [NSNumber numberWithFloat:0]
                                  ];
    
    CAAnimationGroup *transformGroup2 = [CAAnimationGroup animation];
    transformGroup2.animations = [NSArray arrayWithObjects:rotationAnimation2,translationAnimation, nil];
    transformGroup2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transformGroup2.duration = kStep4Duration;
    transformGroup2.delegate = self;
    transformGroup2.removedOnCompletion = YES;
    [_bottomLayer addAnimation:transformGroup2 forKey:nil];
    
    
    
    _changeLayer.affineTransform = CGAffineTransformMakeTranslation(5, 0);
    //平移x
    CABasicAnimation *translationAnimation1 = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    translationAnimation1.fromValue = [NSNumber numberWithFloat:0];
    translationAnimation1.toValue = [NSNumber numberWithFloat:5];
    
    translationAnimation1.duration = 0.5;
    translationAnimation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_changeLayer addAnimation:translationAnimation1 forKey:nil];
    
}

#pragma mark -
-(CGFloat)calculateTotalLength
{
    
    CGFloat curveLength = [self calculateCurveLength];
    
    //一个圆 + 120度弧长的 总长度
    CGFloat length = (Radians(120) + 2 * M_PI) * Raduis;
    CGFloat totalLength = curveLength + length;
    
    return totalLength;
}

-(CGFloat)calculateCurveLength{
    
    CGFloat angle = Radians(30);
    
    CGFloat endPointX = self.center.x + Raduis * cos(angle);
    CGFloat endPointY = kCenterY - Raduis * sin(angle);
    
    CGFloat startPointX = self.center.x + lineWidth/2.0;
    CGFloat startPointY = kCenterY;
    
    CGFloat controlPointX = self.center.x + Raduis *acos(angle);
    CGFloat controlPointY = kCenterY;
    
    CGFloat curveLength = [self bezierCurveLengthFromStartPoint:CGPointMake(startPointX, startPointY)
                                                     toEndPoint:CGPointMake(endPointX,endPointY)
                                               withControlPoint:CGPointMake(controlPointX, controlPointY)];
    
    return curveLength;
}
//求贝塞尔曲线长度
-(CGFloat) bezierCurveLengthFromStartPoint:(CGPoint)start toEndPoint:(CGPoint) end withControlPoint:(CGPoint) control
{
    const int kSubdivisions = 50;
    const float step = 1.0f/(float)kSubdivisions;
    
    float totalLength = 0.0f;
    CGPoint prevPoint = start;
    
    // starting from i = 1, since for i = 0 calulated point is equal to start point
    for (int i = 1; i <= kSubdivisions; i++)
    {
        float t = i*step;
        
        float x = (1.0 - t)*(1.0 - t)*start.x + 2.0*(1.0 - t)*t*control.x + t*t*end.x;
        float y = (1.0 - t)*(1.0 - t)*start.y + 2.0*(1.0 - t)*t*control.y + t*t*end.y;
        
        CGPoint diff = CGPointMake(x - prevPoint.x, y - prevPoint.y);
        
        totalLength += sqrtf(diff.x*diff.x + diff.y*diff.y); // Pythagorean
        
        prevPoint = CGPointMake(x, y);
    }
    
    return totalLength;
}

@end
