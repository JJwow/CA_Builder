//
//  CoreAnimationViewController.m
//  CA_Builder
//
//  Created by fly on 2020/3/27.
//  Copyright © 2020 JJWOW. All rights reserved.
//

#import "CoreAnimationViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <GLKit/GLKit.h>
#define Screen_Height [UIScreen mainScreen].bounds.size.height
#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define LIGHT_DIRECTION 0, 1, -0.5
#define AMBIENT_LIGHT 0.5
@interface CoreAnimationViewController ()<CALayerDelegate>
{
    CALayer *solidLayer3;//固体第三个面的图层
}
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
        case 12:
            [self setShouldRasterize];
        break;
        case 13:
            [self affineTransform];
        break;
        case 14:
            [self transform3D];
        break;
        case 15:
            [self transform3DWithAnchorPoint];
        break;
        case 16:
            [self transform3DInSuperLayerAndSubLayer];
        break;
        case 17:
            [self transform3DInSolid];
        break;
        case 18:
            [self setCAShapeLayer];
        break;
        case 19:
            [self setCustomCornerRadii];
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

/*
 *组透明
 *当你显示一个50%透明度的图层时，图层的每个像素都会一半显示自己的颜色，另一半显示图层下面的颜色。这是正常的透明度的表现。但是如果图层包含一个同样显示50%透明的子图层时，你所看到的视图，50%来自子视图，25%来了图层本身的颜色，另外的25%则来自背景色。
 *
 *你可以通过设置Info.plist文件中的UIViewGroupOpacity为YES来达到这个效果，但是这个设置会影响到这个应用，整个app可能会受到不良影响。
 *当shouldRasterize和UIViewGroupOpacity一起的时候，会出现性能问题
 */
#warning 现在版本中默认实现了组透明
- (void)setShouldRasterize{
    /*
     *如果你使用了shouldRasterize属性，你就要确保你设置了rasterizationScale属性去匹配屏幕，以防止出现Retina屏幕像素化的问题
     */
    self.view.layer.backgroundColor = [UIColor redColor].CGColor;
    CALayer *bottomLayer1 = [CALayer layer];
    bottomLayer1.frame = CGRectMake(50, 50, 100, 100);
    bottomLayer1.backgroundColor = [UIColor greenColor].CGColor;
    [self.view.layer addSublayer:bottomLayer1];
    CALayer *topLayer1 = [CALayer layer];
    topLayer1.frame = CGRectMake(25, 25, 50, 50);
    topLayer1.backgroundColor = [UIColor greenColor].CGColor;
    topLayer1.opacity = 0.5;
    [bottomLayer1 addSublayer:topLayer1];
    bottomLayer1.opacity = 0.5;
    topLayer1.opacity = 0.5;
//    bottomLayer1.shouldRasterize = YES;
    
    CALayer *bottomLayer2 = [CALayer layer];
    bottomLayer2.frame = CGRectMake(200, 50, 100, 100);
    bottomLayer2.backgroundColor = [UIColor greenColor].CGColor;
    [self.view.layer addSublayer:bottomLayer2];
    CALayer *topLayer2 = [CALayer layer];
    topLayer2.frame = CGRectMake(25, 25, 50, 50);
    topLayer2.backgroundColor = [UIColor greenColor].CGColor;
    [bottomLayer2 addSublayer:topLayer2];
    bottomLayer2.opacity = 0.5;
    
}

/*
 *仿射变换
 */
- (void)affineTransform{
    UIImage *img = [UIImage imageNamed:@"team.png"];
    CALayer *layer = [CALayer layer];
    layer.contents = (__bridge id)img.CGImage;
    layer.frame = CGRectMake(50, 50, 100, 100);
    [self.view.layer addSublayer:layer];
    /*
     *单种仿射变换
     *CGAffineTransformMakeRotation(CGFloat angle) 旋转
     *CGAffineTransformMakeScale(CGFloat sx, CGFloat sy) 缩放
     *CGAffineTransformMakeTranslation(CGFloat tx, CGFloat ty) 位移
     */
//    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_4);
//    layer.affineTransform = transform;
    
    /*
     *混合仿射变换
     *图片向右边发生了平移，但并没有指定距离那么远（200像素），另外它还有点向下发生了平移。原因在于当你按顺序做了变换，上一个变换的结果将会影响之后的变换，所以200像素的向右平移同样也被旋转了30度，缩小了50%，所以它实际上是斜向移动了100像素。
     */
//    CGAffineTransform transform = CGAffineTransformIdentity;
//    transform = CGAffineTransformScale(transform, 0.5, 0.5);
//    transform = CGAffineTransformRotate(transform, M_PI_4);
//    transform = CGAffineTransformTranslate(transform, 200, 0);
//    layer.affineTransform = transform;
    
    /*
     *斜切变换
     */
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform.c = -1;//将图片向右倾斜45度，可以通过更改a\b\c\d进行不同的变换
    layer.affineTransform = transform;
}

/*
 *3D变换
 *和CGAffineTransform矩阵类似，Core Animation提供了一系列的方法用来创建和组合CATransform3D类型的矩阵，和Core Graphics的函数类似，但是3D的平移和旋转多处了一个z参数，并且旋转函数除了angle之外多出了x,y,z三个参数，分别决定了每个坐标轴方向上的旋转
 */
- (void)transform3D{
    UIImage *img = [UIImage imageNamed:@"team.png"];
    CALayer *layer = [CALayer layer];
    layer.contents = (__bridge id)img.CGImage;
    layer.frame = CGRectMake(50, 50, 100, 100);
    [self.view.layer addSublayer:layer];
    CATransform3D transform = CATransform3DIdentity;
    /*
     *CATransform3D的m34元素，用来做透视
     *m34的默认值是0，我们可以通过设置m34为-1.0 / d来应用透视效果，d代表了想象中视角相机和屏幕之间的距离，以像素为单位
     *通常500-1000就已经很好了,减少距离的值会增强透视效果
     *一个非常微小的值会让它看起来更加失真，然而一个非常大的值会让它基本失去透视效果
     */
#warning transform.m34调用要在transform = CATransform3DRotate之前
    transform.m34 = -1.0/500.0;
    transform = CATransform3DRotate(transform, M_PI_4, 0, 1, 0);
    layer.transform = transform;
}

/*
 *灭点：当在透视角度绘图的时候，远离相机视角的物体将会变小变远，当远离到一个极限距离，它们可能就缩成了一个点，于是所有的物体最后都汇聚消失在同一个点。
 *Core Animation定义了这个点位于变换图层的anchorPoint
 *当改变一个图层的position，你也改变了它的灭点，做3D变换的时候要时刻记住这一点，当你视图通过调整m34来让它更加有3D效果，应该首先把它放置于屏幕中央，然后通过平移来把它移动到指定位置（而不是直接改变它的position），这样所有的3D图层都共享一个灭点。
 *如果有多个视图或者图层，每个都做3D变换，那就需要分别设置相同的m34值，并且确保在变换之前都在屏幕中央共享同一个position
 *sublayerTransform 是CATransform3D类型 它影响到所有的子图层。这意味着你可以一次性对包含这些图层的容器做变换，于是所有的子图层都自动继承了这个变换方法。
 */
#warning 使用sublayerTransform在进行3D变换时可以不用将其放在中心灭点,且能统一设置穿透数值
- (void)transform3DWithAnchorPoint{
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0/500.0;
    self.view.layer.sublayerTransform = perspective;
    UIImage *img = [UIImage imageNamed:@"team.png"];
    CALayer *layer1 = [CALayer layer];
    layer1.contents = (__bridge id)img.CGImage;
    layer1.frame = CGRectMake(50, 50, 100, 100);
    /*
     *doubleSided控制图层的背面是否要被绘制。这是一个BOOL类型，默认为YES，如果设置为NO，那么当图层正面从相机视角消失的时候，它将不会被绘制。
     *z旋转180度时可以观察layer的背面
     */
//    layer1.doubleSided = NO;
    
    CATransform3D transform1 = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    layer1.transform = transform1;
    [self.view.layer addSublayer:layer1];
    CALayer *layer2= [CALayer layer];
    layer2.contents = (__bridge id)img.CGImage;
    layer2.frame = CGRectMake(200, 50, 100, 100);
    CATransform3D transform2 = CATransform3DMakeRotation(-M_PI_4, 0, 1, 0);
    layer2.transform = transform2;
    [self.view.layer addSublayer:layer2];
}

/*
 *扁平化图层
 *对包含已经做过变换的图层的图层做反方向的变换
 *子Layer的3D变换都是在父Layer的平面中
 *只有改变Z坐标轴时，两次改变才能抵消，因为Z轴是正面我们观察视角
 *当我们设置了m34视角穿透后，由于平面和观察视角为非垂直，所以视觉上子layer没有被修正
 */

- (void)transform3DInSuperLayerAndSubLayer{
    CALayer *supLayer = [CALayer layer];
    supLayer.frame = CGRectMake(50, 50, 100, 100);
    supLayer.backgroundColor = [UIColor greenColor].CGColor;
    [self.view.layer addSublayer:supLayer];
    CALayer *subLayer = [CALayer layer];
    subLayer.frame = CGRectMake(25, 25, 50, 50);
    subLayer.backgroundColor = [UIColor redColor].CGColor;
    [supLayer addSublayer:subLayer];
    CATransform3D transform1 = CATransform3DIdentity;
    transform1.m34 = -1.0/500.0;
    transform1 = CATransform3DRotate(transform1, M_PI_4, 0, 0, 1);
    CATransform3D transform2 = CATransform3DIdentity;
    transform2.m34 = -1.0/500.0;
    transform2 = CATransform3DRotate(transform2, -M_PI_4, 0, 0, 1);
    supLayer.transform = transform1;
    subLayer.transform = transform2;
}

/*
 *x建立一个六面体
 */
- (void)transform3DInSolid{
    CATransform3D perspective = CATransform3DIdentity;
    //透视的程度
    perspective.m34 = -1.0/500.0;
    //相机调度、或者子layer共享的3D变换角度
    perspective = CATransform3DRotate(perspective, -M_PI_4, 1, 0, 0);
    perspective = CATransform3DRotate(perspective, -M_PI_4, 0, 1, 0);
    //使子layert共享透视角度
    self.view.layer.sublayerTransform = perspective;
    //Z轴增加50
    CATransform3D transform = CATransform3DMakeTranslation(0, 0, 50);
    [self configLayer:0 transform:transform];
    //X轴增加50，并沿着Y轴旋转90度
    transform = CATransform3DMakeTranslation(50, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    [self configLayer:1 transform:transform];
    //Y轴减少50，并沿着X轴旋转90度
    transform = CATransform3DMakeTranslation(0, -50, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 1, 0, 0);
    solidLayer3 = [self configLayer:2 transform:transform];
    //Y轴增加50，并沿着X轴反向旋转90度
    transform = CATransform3DMakeTranslation(0, 50, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);
    [self configLayer:3 transform:transform];
    //X轴减少50，并沿着Y轴反向旋转90度
    transform = CATransform3DMakeTranslation(-50, 0, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 0, 1, 0);
    [self configLayer:4 transform:transform];
    //Z轴减少50，并沿着Y轴旋转90度
    transform = CATransform3DMakeTranslation(0, 0, -50);
    transform = CATransform3DRotate(transform, M_PI, 0, 1, 0);
    [self configLayer:5 transform:transform];
    
    
}
- (CALayer *)configLayer:(NSInteger)index transform:(CATransform3D)transform{
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(100, 100, 100, 100);
    UIImage *img = [UIImage imageNamed:@"team.png"];
    layer.contents = (__bridge id)img.CGImage;
    [self.view.layer addSublayer:layer];
    layer.transform = transform;
    /*
     *可以使用OpenGL为每个面增加光影
     *Core Animation可以用3D显示图层，但是它对光线并没有概念。如果想让立方体看起来更加真实，需要自己做一个阴影效果。
     *如果需要动态地创建光线效果，你可以根据每个视图的方向应用不同的alpha值做出半透明的阴影图层，但为了计算阴影图层的不透明度，你需要得到每个面的正太向量（垂直于表面的向量），然后根据一个想象的光源计算出两个向量叉乘结果。叉乘代表了光源和图层之间的角度，从而决定了它有多大程度上的光亮。
     *我们用GLKit框架来做向量的计算（你需要引入GLKit库来运行代码），每个面的CATransform3D都被转换成GLKMatrix4，然后通过GLKMatrix4GetMatrix3函数得出一个3×3的旋转矩阵。这个旋转矩阵指定了图层的方向，然后可以用它来得到正太向量的值。
     */
    //GLKMatrix4和CATransform3D内存结构一致，但坐标类型有长度区别，所以理论上应该做一次float到CGFloat的转换
//    CALayer *shadowLayer = [CALayer layer];
//    shadowLayer.frame = layer.bounds;
//    [layer addSublayer:shadowLayer];
//    GLKMatrix4 matrix4 = *(GLKMatrix4 *)&transform;
//    GLKMatrix3 matrix3 = GLKMatrix4GetMatrix3(matrix4);
//    //get face normal
//    GLKVector3 normal = GLKVector3Make(0, 0, 1);
//    normal = GLKMatrix3MultiplyVector3(matrix3, normal);
//    normal = GLKVector3Normalize(normal);
//    //get dot product with light direction
//    GLKVector3 light = GLKVector3Normalize(GLKVector3Make(LIGHT_DIRECTION));
//    float dotProduct = GLKVector3DotProduct(light, normal);
//    //set lighting layer opacity
//    CGFloat shadow = 1 + dotProduct - AMBIENT_LIGHT;
//    UIColor *color = [UIColor colorWithWhite:0 alpha:shadow];
//    shadowLayer.backgroundColor = color.CGColor;
    return layer;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    /*
     *判断d响应事件的对象
     */
    CGPoint point = [[touches anyObject] locationInView:self.view];
    CALayer *layer = [self.view.layer hitTest:point];
    if (layer == solidLayer3) {
        NSLog(@"点击了固体图层的上面图层");
    }
}

/*
 *使用CAShapeLayer绘制一个火柴人
 *CAShapeLayer优点：
 *渲染快速。CAShapeLayer使用了硬件加速，绘制同一图形会比用Core Graphics快很多
 *高效使用内存。一个CAShapeLayer不需要像普通CALayer一样创建一个寄宿图形，所以无论有多大，都不会占用太多的内存
 *不会被图层边界剪裁掉。一个CAShapeLayer可以在边界之外绘制。你的图层路径不会像在使用Core Graphics的普通CALayer一样被剪裁掉
 *不会出现像素化。当你给CAShapeLayer做3D变换时，它不像一个有寄宿图的普通图层一样变得像素化
 */
- (void)setCAShapeLayer{
    UIBezierPath *path = [[UIBezierPath alloc]init];
    [path moveToPoint:CGPointMake(175, 100)];
    [path addArcWithCenter:CGPointMake(150, 100) radius:25 startAngle:0 endAngle:2*M_PI clockwise:YES];
    [path moveToPoint:CGPointMake(150, 125)];
    [path addLineToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(125, 225)];
    [path moveToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(175, 225)];
    [path moveToPoint:CGPointMake(100, 150)];
    [path addLineToPoint:CGPointMake(200, 150)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor whiteColor].CGColor;
    shapeLayer.lineWidth = 5;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.path = path.CGPath;
    [self.view.layer addSublayer:shapeLayer];
}

/*
 *为layer自定义绘制四个圆角
 */
- (void)setCustomCornerRadii{
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(100, 100, 100, 100);
    UIImage *img = [UIImage imageNamed:@"team.png"];
    layer.contents = (__bridge id)img.CGImage;
    [self.view.layer addSublayer:layer];
    UIRectCorner corners = UIRectCornerTopLeft|UIRectCornerTopRight;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:layer.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    layer.mask = shapeLayer;
    
}
@end
