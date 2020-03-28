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
#define Screen_Width [UIScreen mainScreen].bounds.size.width
@interface CoreAnimationViewController ()<CALayerDelegate>

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
        case 2:
            [self contentsRectImage];
        break;
        case 3:
            [self stretchableImage];
        break;
        case 4:
            [self createContentsByCoreGraphics];
        break;
        case 7:
            [self setCornerRadius];
        break;
        default:
            break;
    }
    
}

/*
 *使用CALayer绘制简单图层
 */
- (void)setBaseCALayer{
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    [self.view.layer addSublayer:blueLayer];
}

/*
 *使用CALayer寄宿图
 */
- (void)setContents{
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(Screen_Width/2 - 100.0f, 50.0f, 200.0f, 200.0f);
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
        
    [self.view.layer addSublayer:blueLayer];
}

/*
 *剪切image
 */
- (void)contentsRectImage{
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(Screen_Width/2 - 100.0f, 50.0f, 200.0f, 200.0f);
    UIImage *img = [UIImage imageNamed:@"team.png"];
    blueLayer.contents = (__bridge id)img.CGImage;
    
    //设置内容的显示方式为适应
    blueLayer.contentsGravity = kCAGravityResizeAspect;
    
    //将img切成四张
    [self contentsRectSubView:img withContentRect:CGRectMake(0, 0, 0.5, 0.5) toLayerFrame:CGRectMake(50, 300, 100, 100)];
    [self contentsRectSubView:img withContentRect:CGRectMake(0.5, 0, 0.5, 0.5) toLayerFrame:CGRectMake(200, 300, 100, 100)];
    [self contentsRectSubView:img withContentRect:CGRectMake(0, 0.5, 0.5, 0.5) toLayerFrame:CGRectMake(50, 450, 100, 100)];
    [self contentsRectSubView:img withContentRect:CGRectMake(0.5, 0.5, 0.5, 0.5) toLayerFrame:CGRectMake(200, 450, 100, 100)];
    
    [self.view.layer addSublayer:blueLayer];
}

/*
 *剪切image部分内容
 *contentsRect不是按点来计算的，它使用了单位坐标，单位坐标指定在0到1之间，是一个相对值（像素和点就是绝对值）。所以他们是相对与寄宿图的尺寸的。
 */
- (void)contentsRectSubView:(UIImage *)img withContentRect:(CGRect)rect toLayerFrame:(CGRect)frame{
    CALayer *layer = [CALayer layer];
    layer.frame = frame;
    [self.view.layer addSublayer:layer];
    layer.contents = (__bridge id)img.CGImage;
    layer.contentsGravity = kCAGravityResizeAspect;
    layer.contentsRect = rect;
}


/*
 *拉伸图片
 */
- (void)stretchableImage{
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(Screen_Width/2 - 100.0f, 50.0f, 200.0f, 200.0f);
    UIImage *img = [UIImage imageNamed:@"team.png"];
    blueLayer.contents = (__bridge id)img.CGImage;
    
    //设置内容的显示方式为适应
    blueLayer.contentsGravity = kCAGravityResizeAspect;
    
    [self.view.layer addSublayer:blueLayer];
    
    //尽量保留左边2个张伟
    [self stretchableImageSubView:img withContentRect:CGRectMake(0.3, 0, 1, 1) toLayerFrame:CGRectMake(Screen_Width/2 - 100.0f, 300.0f, 100, 100)];
    //尽量保留右边2个张伟
    [self stretchableImageSubView:img withContentRect:CGRectMake(0, 0, 0.7, 1) toLayerFrame:CGRectMake(Screen_Width/2 - 100.0f, 450.0f, 100, 100)];
}

/*
 拉伸image内容
*/
- (void)stretchableImageSubView:(UIImage *)img withContentRect:(CGRect)rect toLayerFrame:(CGRect)frame{
    CALayer *layer = [CALayer layer];
    layer.frame = frame;
    [self.view.layer addSublayer:layer];
    layer.contents = (__bridge id)img.CGImage;
    layer.contentsCenter = rect;
}

/*
 *使用Core Graphics绘制寄宿图
 我们在blueLayer上显式地调用了-display。不同于UIView，当图层显示在屏幕上时，CALayer不会自动重绘它的内容。它把重绘的决定权交给了开发者
 尽管我们没有用masksToBounds属性，绘制的那个圆仍然沿边界被裁剪了。这是因为当你使用CALayerDelegate绘制寄宿图的时候，并没有对超出边界外的内容提供绘制支持。
 */
- (void)createContentsByCoreGraphics{
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(Screen_Width/2 - 100.0f, 50.0f, 200.0f, 200.0f);
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    blueLayer.delegate = self;
    blueLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:blueLayer];
    [blueLayer display];
}

/*
 *在调用这个方法之前，CALayer创建了一个合适尺寸的空寄宿图（尺寸由bounds和contentsScale决定）和一个Core Graphics的绘制上下文环境，为绘制寄宿图做准备，他作为ctx参数传入
 */
-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    CGContextSetLineWidth(ctx, 10.0f);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, layer.bounds);
}

/*
 *圆角、边框
 *边框并不会把寄宿图或子图层的形状计算进来，如果图层的子图层超过了边界，或者是寄宿图在透明区域有一个透明蒙板，边框仍然会沿着图层的边界绘制出来
 */
- (void)setCornerRadius{
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(50, 50, 100, 100);
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    blueLayer.contents = (__bridge id)[UIImage imageNamed:@"team.png"].CGImage;
    blueLayer.contentsGravity = kCAGravityCenter;
    blueLayer.cornerRadius = 20;
//    blueLayer.masksToBounds = YES;
    blueLayer.borderWidth = 5;
    blueLayer.borderColor = [UIColor yellowColor].CGColor;
    [self.view.layer addSublayer:blueLayer];
    CALayer *redLayer = [CALayer layer];
    redLayer.frame = CGRectMake(50, 50, 100, 100);
    redLayer.backgroundColor = [UIColor redColor].CGColor;
    [blueLayer addSublayer:redLayer];
}


@end
