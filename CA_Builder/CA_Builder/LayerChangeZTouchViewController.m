//
//  LayerChangeZTouchViewController.m
//  CA_Builder
//
//  Created by fly on 2020/3/28.
//  Copyright © 2020 JJWOW. All rights reserved.
//

#import "LayerChangeZTouchViewController.h"

@interface LayerChangeZTouchViewController ()
{
    CALayer *blueLayer1;
    CALayer *redLayer1;
    CALayer *blueLayer2;
    CALayer *redLayer2;
}
@end

@implementation LayerChangeZTouchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.backgroundColor = [UIColor whiteColor].CGColor;
    [self changeLayerSequenceByZ];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    /*
     *判断d响应事件的对象
     */
    CGPoint point = [[touches anyObject] locationInView:self.view];
    CALayer *layer = [self.view.layer hitTest:point];
    if (layer == blueLayer1) {
        NSLog(@"Inside blueLayer1");
    }
    if (layer == blueLayer2){
        NSLog(@"Inside blueLayer2");
    }
    if (layer == redLayer1) {
        NSLog(@"Inside redLayer1");
    }
    if (layer == redLayer2){
        NSLog(@"Inside redLayer2");
    }
    
    /*
     *判断点击的范围
     */
//    CGPoint point = [[touches anyObject] locationInView:self.view];
//    point = [self.view.layer convertPoint:point fromLayer:self.view.layer];
//    if ([self.view.layer containsPoint:point]) {
//        CGPoint bluePoint1 = [blueLayer1 convertPoint:point fromLayer:self.view.layer];
//        CGPoint bluePoint2 = [blueLayer2 convertPoint:point fromLayer:self.view.layer];
//        CGPoint redPoint1 = [redLayer1 convertPoint:point fromLayer:self.view.layer];
//        CGPoint redPoint2 = [redLayer2 convertPoint:point fromLayer:self.view.layer];
//        if ([blueLayer1 containsPoint:bluePoint1]) {
//            NSLog(@"Inside blueLayer1");
//        }
//        if ([blueLayer2 containsPoint:bluePoint2]){
//            NSLog(@"Inside blueLayer2");
//        }
//        if ([redLayer1 containsPoint:redPoint1]) {
//            NSLog(@"Inside redLayer1");
//        }
//        if ([redLayer2 containsPoint:redPoint2]){
//            NSLog(@"Inside redLayer2");
//        }
//    }
}

/*
 *使用Z坐标轴改变图层的显示顺序
 *警告：改变的是显示顺序不是图层树的顺序
 */
- (void)changeLayerSequenceByZ{
    blueLayer1 = [CALayer layer];
    blueLayer1.frame = CGRectMake(50, 50, 100, 100);
    blueLayer1.backgroundColor = [UIColor blueColor].CGColor;
    [self.view.layer addSublayer:blueLayer1];
    redLayer1 = [CALayer layer];
    redLayer1.frame = CGRectMake(100, 100, 100, 100);
    redLayer1.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:redLayer1];
    
    blueLayer2 = [CALayer layer];
    blueLayer2.frame = CGRectMake(50, 300, 100, 100);
    blueLayer2.backgroundColor = [UIColor blueColor].CGColor;
    //Z坐标轴可以改变图层显示顺序
    blueLayer2.zPosition = 1;
    [self.view.layer addSublayer:blueLayer2];
    redLayer2 = [CALayer layer];
    redLayer2.frame = CGRectMake(100, 350, 100, 100);
    redLayer2.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:redLayer2];
}

@end
