//
//  NumberClockViewController.m
//  CA_Builder
//
//  Created by fly on 2020/3/28.
//  Copyright © 2020 JJWOW. All rights reserved.
//

#import "NumberClockViewController.h"

@interface NumberClockViewController ()
{
    NSTimer *timer;
    NSMutableArray *arr;
}
@end

@implementation NumberClockViewController

/*
 *拉伸过滤minificationFilter、magnificationFilter默认的过滤器都是kCAFilterLinear
 *kCAFilterLinear这个过滤器采用双线性滤波算法，它在大多数情况下都表现良好。双线性滤波算法通过对多个像素取样最终生成新的值，得到一个平滑的表现不错的拉伸。但是当放大倍数比较大的时候图片就模糊不清了。
 *kCAFilterTrilinear和kCAFilterLinear非常相似，大部分情况下二者都看不出来有什么差别。但是，较双线性滤波算法而言，三线性滤波算法存储了多个大小情况下的图片（也叫多重贴图），并三维取样，同时结合大图和小图的存储进而得到最后的结果。
 *kCAFilterNearest最近过滤 就是取样最近的单像素点而不管其他的颜色。这样做非常快，也不会使图片模糊。但是，最明显的效果就是，会使得压缩图片更糟，图片放大之后也显得块状或是马赛克严重。
 
 
 *对于比较小的图或者是差异特别明显，极少斜线的大图，最近过滤算法会保留这种差异明显的特质以呈现更好的结果。但是对于大多数的图尤其是有很多斜线或是曲线轮廓的图片来说，最近过滤算法会导致更差的结果。
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.backgroundColor = [UIColor whiteColor].CGColor;
    UIImage *image = [UIImage imageNamed:@"number.png"];
    arr = [NSMutableArray array];
    for (int i = 0; i < 6; i++) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(i * 50 + 5, 50, 50, 50);
        layer.contentsGravity = kCAGravityResizeAspect;
        layer.contents = (__bridge id)image.CGImage;
        layer.contentsRect = CGRectMake(0, 0, 0.1, 1);
        layer.minificationFilter = kCAFilterLinear;
        [arr addObject:layer];
        [self.view.layer addSublayer:layer];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    [self tick];
}

- (void)tick{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSUInteger units = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
    [self setDigit:components.hour / 10 forLayer:arr[0]];
    [self setDigit:components.hour % 10 forLayer:arr[1]];
    [self setDigit:components.minute / 10 forLayer:arr[2]];
    [self setDigit:components.minute % 10 forLayer:arr[3]];
    [self setDigit:components.second / 10 forLayer:arr[4]];
    [self setDigit:components.second % 10 forLayer:arr[5]];
}

- (void)setDigit:(NSInteger)digit forLayer:(CALayer *)layer{
    layer.contentsRect = CGRectMake(digit * 0.1, 0, 0.1, 1);
}

@end
