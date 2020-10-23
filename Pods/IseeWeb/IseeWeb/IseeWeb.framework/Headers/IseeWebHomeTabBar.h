//
//  IseeWebHomeTabBar.h
//  IseeWebView
//
//  Created by 点芯在线 on 2020/8/6.
//  Copyright © 2020 dxzx. All rights reserved.
//




#import <UIKit/UIKit.h>
#import "IseeHomeRequestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IseeWebHomeTabBar : UITabBarController
/***
 * 请求参数
 */
@property(nonatomic, strong)IseeHomeRequestModel *model;
/**
 *初始化
 *
 */
- (instancetype)initWithModel:(IseeHomeRequestModel *)model;
@end


NS_ASSUME_NONNULL_END
