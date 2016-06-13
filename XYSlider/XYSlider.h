//
//  XYSlider.h
//  
//
//  Created by yan on 15/10/20.
//
//

#import <UIKit/UIKit.h>

@interface XYSlider : UIControl

// 滑条
@property (nonatomic, strong) UIImageView *sliderImgView;
// 滑条高度
@property (nonatomic, assign) NSInteger sliderHeight;
// 滑块
@property (nonatomic, strong) UIImageView *containerImgView;
@property (nonatomic, strong) UIImageView *containerImgView2;
// 跟着滑块的view
@property (nonatomic, strong) UIImageView *coverImgView;
@property (nonatomic, strong) UIImageView *coverImgView2;

// 值
@property (nonatomic, assign) NSInteger leftValue;
@property (nonatomic, assign) NSInteger rightValue;

// label text数组
@property (nonatomic, strong) NSMutableArray *arr;

@end
