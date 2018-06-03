//
//  LXTopSegmentView.h
//  TestMainRecomandView
//
//  Created by 徐远翔 on 16/12/29.
//  Copyright © 2016年 iNo.QY. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class LXNewsViewController;

@interface LXTopSegmentView : UIView

+ (LXTopSegmentView *)getViewWithItemArray:(NSArray *)itemTitleArr
                                     frame:(CGRect)frame
                               selectIndex:(int)index
                                  parentVC:(id)parentVC;


- (void)didScrollAtOffsetX:(int)x maxOffSetWidth:(int)width;

@end
