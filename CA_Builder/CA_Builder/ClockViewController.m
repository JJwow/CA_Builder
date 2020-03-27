//
//  ClockViewController.m
//  CA_Builder
//
//  Created by fly on 2020/3/27.
//  Copyright © 2020 JJWOW. All rights reserved.
//

#import "ClockViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface ClockViewController ()<CALayerDelegate>
{
    CALayer *hourLayer, *minLayer, *secondLayer, *clockLayer;
}
@property (nonatomic, weak) NSTimer *timer;
@end

@implementation ClockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建表盘
    clockLayer = [CALayer layer];
    clockLayer.contents = (__bridge id)[UIImage imageNamed:@"biaopan.png"].CGImage;
    clockLayer.frame = CGRectMake(50, 50, 200, 200);
    [self.view.layer addSublayer:clockLayer];
    //创建时针
    hourLayer = [self createLayer:CGRectMake(148, 135, 4, 30)];
    hourLayer.anchorPoint = CGPointMake(0.5, 0.95);
    [self.view.layer addSublayer:hourLayer];
    //创建分针
    minLayer = [self createLayer:CGRectMake(148, 130, 4, 40)];
    minLayer.anchorPoint = CGPointMake(0.5, 0.95);
    [self.view.layer addSublayer:minLayer];
    //创建秒针
    secondLayer = [self createLayer:CGRectMake(148, 125, 4, 50)];
    secondLayer.anchorPoint = CGPointMake(0.5, 0.95);
    [self.view.layer addSublayer:secondLayer];
    //创建定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    [self tick];

}

- (void)tick
{
    //convert time to hours, minutes and seconds
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger units = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
    //时针需要走的角度
    CGFloat hoursAngle = (components.hour / 12.0) * M_PI * 2.0;
    //分针需要走的角度
    CGFloat minsAngle = (components.minute / 60.0) * M_PI * 2.0;
    //i秒针需要走的角度
    CGFloat secsAngle = (components.second / 60.0) * M_PI * 2.0;
    hourLayer.affineTransform = CGAffineTransformMakeRotation(hoursAngle);
    minLayer.affineTransform = CGAffineTransformMakeRotation(minsAngle);
    secondLayer.affineTransform = CGAffineTransformMakeRotation(secsAngle);
}

- (CALayer *)createLayer:(CGRect)rect{
    CALayer *layer = [CALayer layer];
    layer.frame = rect;
    layer.delegate = self;
    layer.contentsScale = [UIScreen mainScreen].scale;
    [layer display];
    return layer;
}

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    //画笔宽度
    CGContextSetLineWidth(ctx, 4.0f);
    //画笔颜色
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1].CGColor);
    //起始点
    CGContextMoveToPoint(ctx, 0, 0);
    //终点
    CGContextAddLineToPoint(ctx, 0, 50);
    //动笔
//    CGContextDrawPath(ctx, kCGPathFillStroke);
    CGContextStrokePath(ctx);
}

@end
