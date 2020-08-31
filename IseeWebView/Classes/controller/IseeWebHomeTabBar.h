//
//  IseeWebHomeTabBar.h
//  IseeWebView
//
//  Created by 点芯在线 on 2020/8/6.
//  Copyright © 2020 dxzx. All rights reserved.
//




#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface IseeWebHomeTabBar : UITabBarController
@property (nonatomic,strong)NSString *mLoginName;
@property (nonatomic,strong)NSString *mCompanyId;
@property (nonatomic,strong)NSString *mStaffCode;
- (instancetype)initWithLoginName:(NSString *)loginName withCompanyId:(NSString *)comanyId withStaffCode:(NSString *)staffCode;
@end


NS_ASSUME_NONNULL_END
