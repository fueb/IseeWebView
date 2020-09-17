//
//  IseeLoadingView.h
//  IseeWebView
//
//  Created by 余友良 on 2020/9/17.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IseeLoadingView : UIView
+ (instancetype)showHUDAddedTo:(UIView *)view animated:(BOOL)animated;
- (id)initWithView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
