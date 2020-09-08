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
@property (nonatomic,strong)IseeHomeRequestModel *requesetModel;
@property (nonatomic,strong)NSString *mLoginName;
@property (nonatomic,strong)NSString *mCompanyId;
@property (nonatomic,strong)NSString *mManagerId;
@property (nonatomic,strong)NSString *mStaffCode;
@property (nonatomic,strong)NSString *areaId;
@property (nonatomic,strong)NSString *latnId;
@property (nonatomic,strong)NSString *statId;
@property (nonatomic,strong)NSString *mSession;
@property (nonatomic,strong)NSString *mUserId;
@property (nonatomic,strong)NSString *mSaleNum;
@end

NS_ASSUME_NONNULL_END
