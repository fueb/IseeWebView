//
//  IseeHomeViewController.h
//  IseeWebView
//
//  Created by 点芯在线 on 2020/8/6.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IseeHomeRequestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IseeHomeViewController : UIViewController
@property (nonatomic,strong)IseeHomeRequestModel *requesetModel;//请求model
@property (nonatomic,strong)NSString *mLoginName;//登陆手机
@property (nonatomic,strong)NSString *mCompanyId;//地区id
@property (nonatomic,strong)NSString *mManagerId;//客户经理
@property (nonatomic,strong)NSString *mStaffCode;//用户
@property (nonatomic,strong)NSString *areaId;//地区id
@property (nonatomic,strong)NSString *latnId;//区域id
@property (nonatomic,strong)NSString *statId;
@property (nonatomic,strong)NSString *mSession;//session
@property (nonatomic,strong)NSString *mUserId;
@property (nonatomic,strong)NSString *mSaleNum;
@end

NS_ASSUME_NONNULL_END
