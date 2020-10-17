//
//  IseeSegmentHeaderView.h
//  IseeWebView
//
//  Created by 余友良 on 2020/10/16.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol segmentHeaderViewDelegate<NSObject>
/**
 获得点击下标
 */
- (void)hl_didSelectWithIndex:(NSInteger)index withIsClick:(BOOL)isClick;

@end

@interface IseeSegmentHeaderView : UIView

/**根据角标，选中对应的*/
@property (nonatomic, assign) NSInteger selectIndex;
/** 标题数组 */
@property (nonatomic, strong) NSArray * titles;
/** 是否显示下划线 */
@property (nonatomic, assign) BOOL isShowUnderLine;
/**下划线颜色*/
@property (nonatomic, strong) UIColor *underLineColor;

@property (nonatomic, weak) id<segmentHeaderViewDelegate> delegate;
/** 滚动页面 */
@property (strong, nonatomic)UIScrollView *myScrollView;



- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;
@end

NS_ASSUME_NONNULL_END
