//
//  CoreAnimationViewController.m
//  CA_Builder
//
//  Created by fly on 2020/3/27.
//  Copyright © 2020 JJWOW. All rights reserved.
//

#import "CoreAnimationViewController.h"
#import <QuartzCore/QuartzCore.h>
#define Screen_Height [UIScreen mainScreen].bounds.size.height
#define Screen_Width [UIScreen mainScreen].bounds.size.WIdth
@interface CoreAnimationViewController ()

@end

@implementation CoreAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    switch (self.type) {
        case 0:
            [self setBaseCALayer];
            break;
         case 1:
            [self setContents];
            break;
        default:
            break;
    }
    
}

/*
 使用CALayer绘制简单图层
*/
- (void)setBaseCALayer{
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    [self.view.layer addSublayer:blueLayer];
}

/*
 使用CALayer寄宿图
*/
- (void)setContents{
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(50.0f, 50.0f, 200.0f, 200.0f);
    UIImage *img = [UIImage imageNamed:@"team.png"];
    blueLayer.contents = (__bridge id)img.CGImage;
    
    //设置内容的显示方式为适应
    blueLayer.contentsGravity = kCAGravityResizeAspect;
    
    //设置内容的显示方式为居中
//    blueLayer.contentsGravity = kCAGravityCenter;
    
    //适配Retina设备
//    blueLayer.contentsScale = [UIScreen mainScreen].scale;
    
    //不显示超出边界的内容，同UIView的clipsToBounds
//    blueLayer.masksToBounds = YES;
    
    //将img切成四张
    [self contentsRectSubView:img withContentRect:CGRectMake(0, 0, 0.5, 0.5) toLayerFrame:CGRectMake(0, Screen_Height - 300, 100, 100)];
    [self contentsRectSubView:img withContentRect:CGRectMake(0.5, 0, 0.5, 0.5) toLayerFrame:CGRectMake(200, Screen_Height - 300, 100, 100)];
    [self contentsRectSubView:img withContentRect:CGRectMake(0, 0.5, 0.5, 0.5) toLayerFrame:CGRectMake(0, Screen_Height - 100, 100, 100)];
    [self contentsRectSubView:img withContentRect:CGRectMake(0.5, 0.5, 0.5, 0.5) toLayerFrame:CGRectMake(200, Screen_Height - 100, 100, 100)];
    [self.view.layer addSublayer:blueLayer];
}

/*
 剪切image部分内容
 contentsRect不是按点来计算的，它使用了单位坐标，单位坐标指定在0到1之间，是一个相对值（像素和点就是绝对值）。所以他们是相对与寄宿图的尺寸的。
*/
- (void)contentsRectSubView:(UIImage *)img withContentRect:(CGRect)rect toLayerFrame:(CGRect)frame{
    CALayer *layer = [CALayer layer];
    layer.frame = frame;
    [self.view.layer addSublayer:layer];
    layer.contents = (__bridge id)img.CGImage;
    layer.contentsGravity = kCAGravityResizeAspect;
    layer.contentsRect = rect;
}

@end
