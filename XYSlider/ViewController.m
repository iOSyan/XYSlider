//
//  ViewController.m
//  XYSlider
//
//  Created by yan on 16/6/8.
//  Copyright © 2016年 yan. All rights reserved.
//

#import "ViewController.h"
#import "XYSlider.h"

@interface ViewController ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    XYSlider *slider = [[XYSlider alloc] initWithFrame:CGRectMake(30, 150, 320, 50)];
    slider.sliderHeight = 40;
    slider.arr = [NSMutableArray arrayWithObjects:@"a", @"bb", @"ccc", @"ddd", @"eee", @"fff", nil];
    [slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(50, 250, 300, 40)];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.label];
}

#pragma mark - 点击事件
- (void)sliderValueChange:(XYSlider *)slider
{
    //    NSLog(@"%@", [NSString stringWithFormat:@"%zd ~ %zd", slider.leftValue, slider.rightValue]);
    self.label.text = [NSString stringWithFormat:@"%zd ~ %zd", slider.leftValue, slider.rightValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
