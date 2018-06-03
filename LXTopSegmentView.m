//
//  LXTopSegmentView.m
//  TestMainRecomandView
//
//  Created by 徐远翔 on 16/12/29.
//  Copyright © 2016年 iNo.QY. All rights reserved.
//

#import "LXTopSegmentView.h"
//#import "LXNewsViewController.h"

@interface LXTopSegmentView ()

@property (nonatomic, weak) id parentVC;

@end

static const int blueBackHeight = 2;

//蓝条状底线占平分width的宽度  0.2
static const float blueBackItemWidth = 0.4;

@implementation LXTopSegmentView
{
    //所需要完成的元素标题数组
    NSArray *titleArray;
    //初始化时候给的Frame
    CGRect frame;
    //用来保存生成的Item的mutable数组
    NSMutableArray *buttonItemArray;
    //地下的一个蓝色的小阴影状态条目
    UIView *blueStripView;
    
    //***当前选中的index
    int currentSelectedIndex;
    
    int buttonWidth;
    int buttonHeight;
    int buttonOriginY;
    
}

- (instancetype)initWithItemArray:(NSArray *)itemTitleArr
                            frame:(CGRect)frames
                      selectIndex:(int)index
                         parentVC:(id)parent
{
    self = [super init];
    if (self) {
        titleArray = itemTitleArr;
        frame = frames;
        currentSelectedIndex = index;
        _parentVC = parent;
        [self justLoadView];
    }
    return self;
}

- (void)justLoadView
{
    [self setFrame:frame];
    if (!titleArray) {
        return;
    }
    buttonWidth = CGRectGetWidth(frame)/titleArray.count;
    buttonHeight = CGRectGetHeight(frame);
    buttonOriginY = buttonHeight - blueBackHeight;
    buttonItemArray = [NSMutableArray arrayWithCapacity:titleArray.count];
    
    for (int i = 0; i < titleArray.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*buttonWidth, 0, buttonWidth, buttonHeight)];
        button.tag = 100+i;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
#warning TODO 颜色
        
//        [button setTitleColor:kColorTitleLight forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
//        [button setTitleColor:[UIColor redColor]forState:UIControlStateNormal];
        
        
        [button addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        if (i == currentSelectedIndex) {
            button.alpha = 1;
        }else
        {
            button.alpha = 0.5;
        }
        [buttonItemArray addObject:button];
    }

    blueStripView = [[UIView alloc] initWithFrame:CGRectMake(buttonWidth*((1-blueBackItemWidth)/2.0) + currentSelectedIndex*buttonWidth, CGRectGetHeight(frame) - blueBackHeight, buttonWidth*blueBackItemWidth, blueBackHeight)];
    blueStripView.layer.cornerRadius = blueBackHeight/2;
    blueStripView.backgroundColor = [UIColor orangeColor];
    [self addSubview:blueStripView];
    
}

- (void)buttonTouched:(UIButton *)button
{
    
    int tag = (int)button.tag - 100;
    
    for (UIButton *button in buttonItemArray) {
        button.alpha = 0.5;
    }
    button.alpha = 1;
    
    [UIView animateWithDuration:.2 animations:^{
        [blueStripView setFrame:CGRectMake(buttonWidth*((1-blueBackItemWidth)/2.0) + tag*buttonWidth, buttonHeight - blueBackHeight, buttonWidth*blueBackItemWidth, blueBackHeight)];
    }];
    if (self.parentVC) {
//        [self.parentVC segementDidSelectAtIndex:tag];
    }
    
}

+ (LXTopSegmentView *)getViewWithItemArray:(NSArray *)itemTitleArr
                                     frame:(CGRect)frame
                               selectIndex:(int)index
                                  parentVC:(id)parentVC
{
    return [[[self class] alloc] initWithItemArray:itemTitleArr frame:frame selectIndex:index parentVC:parentVC];
}

- (void)didScrollAtOffsetX:(int)x maxOffSetWidth:(int)width
{

    int averageWidth = width/titleArray.count;  //每一份所占的宽度,width是整个scrollview的ContentSize的width
    int index = x/averageWidth;                 //目前的选择是在第几个index
    int offsetX = x % averageWidth;             //在这个index中的偏移量
    
    float rate = offsetX/(float)averageWidth;
    
    //底部滑动的动画小view的宽度
    int blueStripViewWidth = buttonWidth*blueBackItemWidth;
    
    
    if (x == averageWidth) {
        return;
    }
    
    if (rate < 0.5 && rate > 0 ) {
        [blueStripView setFrame:CGRectMake(buttonWidth*((1-blueBackItemWidth)/2.0) + index*buttonWidth,
                                           buttonOriginY,
                                           blueStripViewWidth + 2*(offsetX/(float)averageWidth)*buttonWidth,
                                           blueBackHeight)];
        UIButton *button = buttonItemArray[index];
        button.alpha = 1-0.5;
    }else if (rate > 0.5 && rate < 1)
    {
        [blueStripView setFrame:CGRectMake(buttonWidth*((1-blueBackItemWidth)/2.0) + index*buttonWidth + 2*(offsetX/(float)averageWidth - 0.5)*buttonWidth,
                                          buttonOriginY,
                                          2*(1- offsetX/(float)averageWidth)*buttonWidth + blueStripViewWidth,
                                           blueBackHeight)];
        UIButton *button = buttonItemArray[index+1];
        button.alpha = rate;
    }
    
    int firstIndex = (blueStripView.center.x - (buttonWidth*0.5))/(float)buttonWidth;
    int nextIndex = firstIndex + 1;
    UIButton *button = buttonItemArray[firstIndex];
    button.alpha = 1 - (blueStripView.center.x - button.center.x)/(float)buttonWidth/2;
    if (nextIndex < buttonItemArray.count) {
        UIButton *button2 = buttonItemArray[nextIndex];
        button2.alpha =  0.5 + (blueStripView.center.x - button.center.x)/(float)buttonWidth/2;
    }
    
    
    
}


@end
