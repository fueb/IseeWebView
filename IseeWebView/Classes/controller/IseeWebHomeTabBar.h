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
@property (nonatomic,strong)NSString *mSession;
@property (nonatomic,strong)NSString *mUserId;
@property (nonatomic,strong)NSString *mSaleNum;
- (instancetype)initWithLoginName:(NSString *)loginName withCompanyId:(NSString *)comanyId  withSession:(NSString *)session withUserId:(NSString *)userId withSaleNum:(NSString *)saleNum;
@end


NS_ASSUME_NONNULL_END
