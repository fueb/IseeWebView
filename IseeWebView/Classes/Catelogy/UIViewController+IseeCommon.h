//
//  UIViewController+Common.h
//  FXYIM
//
//  Created by strong on 17/4/10.
//  Copyright © 2017年 strong. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIViewController (IseeCommon)
- (void)setBottomLogoView;
- (void)backAction;
- (void)showToast:(NSString *)toast;
- (void)createBarBtnWithType:(NSInteger)type
                       title:(NSString *)title
                       image:(NSString *)image
                 selectImage:(NSString *)selectImage;
- (void)createBarBtnWithType:(NSInteger)type
                       title:(NSString *)title
                       image:(NSString *)image
                 selectImage:(NSString *)selectImage
                        size:(CGSize)size;

@end
