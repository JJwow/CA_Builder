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
        case 8:
            [self setShadow];
        case 9:
            [self setShadowPath];
        break;
        case 10:
            [self setMask];
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

/*
 *阴影添加
 */
- (void)setShadow{
    CALayer *grayLayer = [CALayer layer];
    grayLayer.frame = CGRectMake(50, 50, 200, 200);
    grayLayer.backgroundColor = [UIColor grayColor].CGColor;
    [self.view.layer addSublayer:grayLayer];
    CALayer *whiteLayer = [CALayer layer];
    whiteLayer.frame = CGRectMake(50, 50, 100, 100);
    whiteLayer.backgroundColor = [UIColor whiteColor].CGColor;
    /*
     *shadowOffset属性控制着阴影的方向和距离。它是一个CGSize的值，宽度控制这阴影横向的位移，高度控制着纵向的位移。shadowOffset的默认值是 {0, -3}，意即阴影相对于Y轴有3个点的向上位移。
     */
    whiteLayer.shadowOffset = CGSizeMake(0, 10);
    /*
     *shadowRadius属性控制着阴影的模糊度，当它的值是0的时候，阴影就和视图一样有一个非常确定的边界线。当值越来越大的时候，边界线看上去就会越来越模糊和自然
     */
    whiteLayer.shadowRadius = 10;
    /*
     *给shadowOpacity属性一个大于默认值（也就是0）的值，阴影就可以显示在任意图层之下。shadowOpacity是一个必须在0.0（不可见）和1.0（完全不透明）之间的浮点数。如果设置为1.0，将会显示一个有轻微模糊的黑色阴影稍微在图层之上。
     */
    whiteLayer.shadowOpacity = 1;
    whiteLayer.shadowColor = [UIColor redColor].CGColor;
    [grayLayer addSublayer:whiteLayer];
    /*
     *和图层边框不同，图层的阴影继承自内容的外形，而不是根据边界和角半径来确定。为了计算出阴影的形状，Core Animation会将寄宿图（包括子视图，如果有的话）考虑在内，然后通过这些来完美搭配图层形状从而创建一个阴影
     */
    CALayer *whiteLayer1 = [CALayer layer];
    whiteLayer1.frame = CGRectMake(-25, 25, 150, 50);
    whiteLayer1.backgroundColor = [UIColor whiteColor].CGColor;
    [whiteLayer addSublayer:whiteLayer1];
}

/*
 *图层阴影并不总是方的，而是从图层内容的形状继承而来。
 *实时计算阴影也是一个非常消耗资源的，尤其是图层有多个子图层，每个图层还有一个有透明效果的寄宿图的时候。
 *如果你事先知道你的阴影形状会是什么样子的，你可以通过指定一个shadowPath来提高性能。
 *
 *但是如果是更加复杂一点的图形，UIBezierPath类会更合适，它是一个由UIKit提供的在CGPath基础上的Objective-C包装类
 */
- (void)setShadowPath{
    CALayer *grayLayer = [CALayer layer];
    grayLayer.frame = CGRectMake(50, 50, 200, 200);
    grayLayer.backgroundColor = [UIColor grayColor].CGColor;
    [self.view.layer addSublayer:grayLayer];
    CALayer *whiteLayer = [CALayer layer];
    whiteLayer.frame = CGRectMake(50, 50, 100, 100);
    whiteLayer.backgroundColor = [UIColor whiteColor].CGColor;
    whiteLayer.shadowOpacity = 1;
    whiteLayer.shadowColor = [UIColor redColor].CGColor;
    [grayLayer addSublayer:whiteLayer];
    /*
    *CGPath是一个Core Graphics对象，用来指定任意的一个矢量图形。我们可以通过这个属性单独于图层形状之外指定阴影的形状。
    */
    CGMutablePathRef squarepath = CGPathCreateMutable();
    /*
     *添加layer范围的阴影
     */
//    CGPathAddRect(squarepath, NULL, whiteLayer.bounds);
    /*
     *添加以layer为直径的阴影
     */
    CGPathAddEllipseInRect(squarepath, NULL, whiteLayer.bounds);
    whiteLayer.shadowPath = squarepath;
}

/*
 *图层模版
 *使用一个32位有alpha通道的png图片通常是创建一个无矩形视图最方便的方法
 *通过masksToBounds属性，我们可以沿边界裁剪图形；
 *通过cornerRadius属性，我们还可以设定一个圆角。但是有时候你希望展现的内容不是在一个矩形或圆角矩形。
 *mask本身就是个CALayer类型，有和其他图层一样的绘制和布局属性。
 *它类似于一个子图层，相对于父图层（即拥有该属性的图层）布局，但是它却不是一个普通的子图层。
 *mask图层定义了父图层的部分可见区域。
 */
- (void)setMask{
    CALayer *grayLayer = [CALayer layer];
    grayLayer.frame = CGRectMake(50, 50, 200, 200);
    grayLayer.backgroundColor = [UIColor grayColor].CGColor;
    [self.view.layer addSublayer:grayLayer];
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = grayLayer.bounds;
    maskLayer.contents = (__bridge id)[UIImage imageNamed:@"icn_i"].CGImage;
    grayLayer.mask = maskLayer;
}
@end
