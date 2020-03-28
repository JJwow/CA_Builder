//
//  ViewController.m
//  CA_Builder
//
//  Created by fly on 2020/3/27.
//  Copyright © 2020 JJWOW. All rights reserved.
//

#import "ViewController.h"
#import "CoreAnimationViewController.h"
#import "ClockViewController.h"
#import "LayerChangeZTouchViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *arr;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arr =@[@"添加蓝色CALayer",
           @"显示寄宿图",
           @"剪切寄宿图",
           @"局部拉伸寄宿图",
           @"使用Core Graphics绘制寄宿图",
           @"使用一张图制作时钟",
           @"通过Z坐标轴改变图层显示顺序",
           @"设置圆角",
           @"设置阴影",
           @"自定义阴影路径",
           @"蒙层模版"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = arr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 5:
        {
            ClockViewController *vc = [[ClockViewController alloc]initWithNibName:@"ClockViewController" bundle:nil];
            [self presentViewController:vc animated:YES completion:nil];
        }
            break;
        case 6:
        {
            LayerChangeZTouchViewController *vc = [[LayerChangeZTouchViewController alloc]init];
            [self presentViewController:vc animated:YES completion:nil];
        }
            break;
            
        default:
        {
            CoreAnimationViewController *vc = [[CoreAnimationViewController alloc]initWithNibName:@"CoreAnimationViewController" bundle:nil];
            vc.type = indexPath.row;
            [self presentViewController:vc animated:YES completion:nil];
        }
            break;
    }
    
}

@end
