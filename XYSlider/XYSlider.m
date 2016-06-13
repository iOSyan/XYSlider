//
//  XYSlider.m
//  
//
//  Created by yan on 15/10/20.
//
//

#import "XYSlider.h"

//颜色获取
#define kGetColorFromRGB(x,y,z,a) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:a]

// frame
#define VIEW_X(view) (view.frame.origin.x)
#define VIEW_Y(view) (view.frame.origin.y)
#define VIEW_Weight(view)  (view.frame.size.width)
#define VIEW_Height(view)  (view.frame.size.height)

// 左边滑块最大位置
#define kContainerMaxRating self.frame.size.width - self.containerImgView.frame.size.width
// 右边滑块最大位置
#define kContainerMaxRating2 self.frame.size.width - self.containerImgView2.frame.size.width
// 右边滑块往左滑的最大值
#define kContainerOriginX self.containerImgView.frame.origin.x + self.containerImgView.frame.size.width
// 左边滑块往右滑的最大值
#define kContainerOriginX2 self.containerImgView2.frame.origin.x - self.containerImgView.frame.size.width

// 滑块的宽度
#define kContainerImgViewWeight 25

@interface XYSlider ()

// 每个刻度间隔多少
@property (nonatomic, assign) CGFloat eachSpaceBetweenNum;
// 有多少个刻度
@property (nonatomic, assign) NSInteger totalNum;

@end

@implementation XYSlider

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // control
//        self.backgroundColor = [UIColor lightGrayColor];
        
        // 滑条
        self.sliderImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, VIEW_Weight(self), 20)];
        CGPoint sliderImgViewPoint = self.sliderImgView.center;
        sliderImgViewPoint.y = VIEW_Height(self)/2;
        self.sliderImgView.center = sliderImgViewPoint;
        self.sliderImgView.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.sliderImgView];
        
        // 滑块1
        self.containerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kContainerImgViewWeight, VIEW_Height(self))];
        self.containerImgView.backgroundColor = [UIColor redColor];
        [self addSubview:self.containerImgView];
        
        // 滑块2
        self.containerImgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kContainerImgViewWeight, VIEW_Height(self))];
        self.containerImgView2.frame = CGRectMake(kContainerMaxRating2, 0, VIEW_Weight(self.containerImgView2), VIEW_Height(self.containerImgView2));
        self.containerImgView2.backgroundColor = [UIColor redColor];
        [self addSubview:self.containerImgView2];
        
        // cover1
        self.coverImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, VIEW_Y(self.containerImgView), 0, VIEW_Height(self.sliderImgView))];
        self.coverImgView.backgroundColor = [UIColor purpleColor];
        [self.sliderImgView addSubview:self.coverImgView];
        
        // cover2
        self.coverImgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(VIEW_X(self.containerImgView2) - VIEW_Weight(self.containerImgView2), VIEW_Y(self.containerImgView2), 0, VIEW_Height(self.sliderImgView))];
        self.coverImgView2.backgroundColor = [UIColor purpleColor];
        [self.sliderImgView addSubview:self.coverImgView2];
        
        // 重新定义sliderImgView的宽度
        self.sliderImgView.frame = CGRectMake(VIEW_Weight(self.containerImgView), VIEW_Y(self.sliderImgView), VIEW_Weight(self.sliderImgView) - 2 *VIEW_Weight(self.containerImgView), VIEW_Height(self.sliderImgView));
        
        // 加移动手势1
        self.containerImgView.userInteractionEnabled = YES;
        UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        //        panRecognizer.minimumNumberOfTouches = 1;
        [self.containerImgView addGestureRecognizer:panRecognizer];
//        [self bringSubviewToFront:self.containerImgView];
        
        // 加移动手势2
        self.containerImgView2.userInteractionEnabled = YES;
        UIPanGestureRecognizer* panRecognizer2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self.containerImgView2 addGestureRecognizer:panRecognizer2];
//        [self bringSubviewToFront:self.containerImgView2];
        
        // 在sliderImgView上添加点击手势
        self.sliderImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//        singleTap.delegate = self;
        [self.sliderImgView addGestureRecognizer:singleTap];
    }
    
    return self;
}

#pragma mark - setter
#pragma mark setSliderImgView的高度
- (void)setSliderHeight:(NSInteger)sliderHeight {
    if (_sliderHeight != sliderHeight) {
        _sliderHeight = sliderHeight;
        self.sliderImgView.frame = CGRectMake(VIEW_X(self.sliderImgView), (VIEW_Height(self) - _sliderHeight)/2, VIEW_Weight(self.sliderImgView), _sliderHeight);
        self.coverImgView.frame = CGRectMake(VIEW_X(self.coverImgView), VIEW_Y(self.coverImgView), VIEW_Weight(self.coverImgView), _sliderHeight);
        self.coverImgView2.frame = CGRectMake(VIEW_X(self.coverImgView2), VIEW_Y(self.coverImgView2), VIEW_Weight(self.coverImgView2), _sliderHeight);
    }
}

- (void)setTotalNum:(NSInteger)totalNum {
    if (_totalNum != totalNum) {
        _totalNum = totalNum;
        self.eachSpaceBetweenNum = VIEW_Weight(self.sliderImgView) / totalNum;
        self.rightValue = _totalNum - 1;
    }
}

- (void)setArr:(NSMutableArray *)arr {
    if (_arr != arr) {
        _arr = arr;
        self.totalNum = arr.count;
        // 刻度label
        for (int i = 0; i < _totalNum; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.eachSpaceBetweenNum * i, 0, self.eachSpaceBetweenNum, VIEW_Height(self.sliderImgView))];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = [NSString stringWithFormat:@"%@", _arr[i]];
            label.tag = 1000 + i;
            //            label.backgroundColor = kGetColorFromRGB(142.0, i* 45.0, i * 32.0, 1.0);
            [self.sliderImgView addSubview:label];

        }
    }
}

#pragma mark - 手势滑动
// 点击滑条移动滑块
- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    NSInteger i = 0;
    CGPoint tapPoint = [recognizer locationInView:self.sliderImgView];
    
    // 点击滑条左边 && 如果不是靠近左边滑块的第一个space
    if (tapPoint.x < VIEW_X(self.containerImgView2) && tapPoint.x  && !((tapPoint.x > VIEW_X(self.containerImgView)) && ((tapPoint.x < VIEW_X(self.containerImgView) + self.eachSpaceBetweenNum)))) {
        CGRect containerFrame = self.containerImgView.frame;
        for (UILabel *label in self.sliderImgView.subviews) {
            if ([label isKindOfClass:[UILabel class]]) {
                if (tapPoint.x >= VIEW_X(label) && tapPoint.x <= VIEW_X(label) + VIEW_Weight(label)) {
                    containerFrame.origin.x = VIEW_X(label);
                    i = label.tag-1000;
                }
            }
        }
        
        __weak typeof(self) weakSelf = self;
        
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.containerImgView.frame = containerFrame;
            // 左边的cover
            weakSelf.coverImgView.frame = CGRectMake(0, VIEW_Y(weakSelf.coverImgView), containerFrame.origin.x, VIEW_Height(weakSelf.coverImgView));
        } completion:^(BOOL finished) {
            if (finished) {
                weakSelf.leftValue = i;
                [weakSelf sendActionsForControlEvents:UIControlEventValueChanged];
            }
        }];
        
        // 点击滑条右边 || 如果是靠近左边滑块的第一个space
    } else if (tapPoint.x > VIEW_X(self.containerImgView2) || ((tapPoint.x > VIEW_X(self.containerImgView)) && ((tapPoint.x < VIEW_X(self.containerImgView) + self.eachSpaceBetweenNum)))) {
        i = self.totalNum-1;
        CGRect containerFrame = self.containerImgView2.frame;
        for (UILabel *label in self.sliderImgView.subviews) {
            if ([label isKindOfClass:[UILabel class]]) {
                if (tapPoint.x >= VIEW_X(label) && tapPoint.x <= VIEW_X(label) + VIEW_Weight(label)) {
                    containerFrame.origin.x = VIEW_X(label)+VIEW_Weight(label)+VIEW_Weight(self.containerImgView2);
                    i = label.tag-1000;
                }
            }
        }
        
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.containerImgView2.frame = containerFrame;
            // 右边的cover
            weakSelf.coverImgView2.frame = CGRectMake(VIEW_X(weakSelf.containerImgView2) - VIEW_Weight(weakSelf.containerImgView2), VIEW_Y(weakSelf.coverImgView2), VIEW_Weight(weakSelf) - VIEW_X(self.containerImgView2) - VIEW_Weight(weakSelf.containerImgView2), VIEW_Height(weakSelf.coverImgView2));
            
        } completion:^(BOOL finished) {
            if (finished) {
                weakSelf.rightValue = i;
                [weakSelf sendActionsForControlEvents:UIControlEventValueChanged];
            }
        }];
    }
}

// 移动滑块
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint translation = [recognizer translationInView:self];
    CGFloat newX = MIN(VIEW_X(recognizer.view) + translation.x, VIEW_Weight(self) - VIEW_Weight(recognizer.view));
    
    // 左边滑块
    if (recognizer.view == self.containerImgView) {
        if (newX < 0 ) {
            newX = 0;
        } else if (newX > kContainerOriginX2) {
            newX = kContainerOriginX2;
        }
        // 左边cover的位置
        self.coverImgView.frame = CGRectMake(0, VIEW_Y(self.coverImgView), VIEW_X(recognizer.view)-10, VIEW_Height(self.coverImgView));
        // 右边滑块
    } else if (recognizer.view == self.containerImgView2) {
        if (newX < kContainerOriginX ) {
            newX = kContainerOriginX;
        } else if (newX >= kContainerMaxRating) {
            newX = kContainerMaxRating;
        }
        // 右边cover的位置
        self.coverImgView2.frame = CGRectMake(VIEW_X(self.containerImgView2) - VIEW_Weight(self.containerImgView2) + 10, VIEW_Y(self.coverImgView2), VIEW_Weight(self) - VIEW_X(recognizer.view) - VIEW_Weight(recognizer.view) - 10, VIEW_Height(self.coverImgView2));
    }
    
    CGRect newFrame = CGRectMake(newX, VIEW_Y(recognizer.view), VIEW_Weight(recognizer.view), VIEW_Height(recognizer.view));
    
    recognizer.view.frame = newFrame;
    [recognizer setTranslation:CGPointZero inView:self];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self FixedPositionForView:recognizer.view];
    }
}

// 自动修正
- (void)FixedPositionForView:(UIView *)view{
    
    float selectorViewX = VIEW_X(view);
    float newX;
    NSInteger i; // value值
    
    // 左边的滑块
    if (view == self.containerImgView) {
        i = (selectorViewX + self.eachSpaceBetweenNum/2)/self.eachSpaceBetweenNum;
        newX = i * self.eachSpaceBetweenNum;
        if (newX < 0) {
            newX = 0;
        } else if (newX >= kContainerOriginX2) {
            newX = (i - 1) * self.eachSpaceBetweenNum;
            i -= 1;
        }
        
        self.leftValue = i;
        
        // 右边的滑块
    } else if (view == self.containerImgView2) {
        i = (selectorViewX + self.eachSpaceBetweenNum/2)/self.eachSpaceBetweenNum;
        newX = i * self.eachSpaceBetweenNum + VIEW_Weight(self.containerImgView2);
        // 如果间隔比滑块小
        if (self.eachSpaceBetweenNum < kContainerImgViewWeight) {
            newX = (i-1) * self.eachSpaceBetweenNum + VIEW_Weight(self.containerImgView2);
            if (i != self.leftValue + 1) {
                i -= 2;
            } else {
                i -= 1;
            }
        } else {
            i = (selectorViewX)/self.eachSpaceBetweenNum;
            newX = i * self.eachSpaceBetweenNum + VIEW_Weight(self.containerImgView2);
            if (i != self.leftValue) {
                i -= 1;
            }
        }
        
        if (newX == kContainerOriginX) {
            newX += self.eachSpaceBetweenNum;
        } else if (newX > kContainerMaxRating2) {
            newX = kContainerMaxRating2;
            i -= 1;
        }
        
        self.rightValue = i;
    }
    
    CGRect newFrame = CGRectMake(newX, VIEW_Y(view), VIEW_Weight(view), VIEW_Height(view));
    
    [UIView animateWithDuration:0.3 animations:^{
        view.frame = newFrame;
        
        // 左边的cover
        if (view == self.containerImgView) {
            self.coverImgView.frame = CGRectMake(0, VIEW_Y(self.coverImgView), newFrame.origin.x, VIEW_Height(self.coverImgView));
            
            // 右边的cover
        } else if (view == self.containerImgView2) {
            self.coverImgView2.frame = CGRectMake(VIEW_X(self.containerImgView2) - VIEW_Weight(self.containerImgView2), VIEW_Y(self.coverImgView2), VIEW_Weight(self) - VIEW_X(self.containerImgView2) - VIEW_Weight(self.containerImgView2), VIEW_Height(self.coverImgView2));
        }
    }];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
