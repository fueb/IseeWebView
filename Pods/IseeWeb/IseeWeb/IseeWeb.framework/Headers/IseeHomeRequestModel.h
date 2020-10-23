//
//  IseeHomeRequestModel.h
//  IseeWebView
//
//  Created by 点芯在线 on 2020/9/8.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IseeHomeRequestModel : NSObject
@property (nonatomic,copy)NSString *mLoginName;
@property (nonatomic,copy)NSString *mCompanyId;
@property (nonatomic,copy)NSString *mManagerId;
@property (nonatomic,copy)NSString *mStaffCode;
@property (nonatomic,copy)NSString *areaId;
@property (nonatomic,copy)NSString *latnId;
@property (nonatomic,copy)NSString *statId;
@property (nonatomic,copy)NSString *mSession;
@property (nonatomic,copy)NSString *mUserId;
@property (nonatomic,copy)NSString *mSaleNum;
@property (nonatomic,copy)NSString *mManagerTypeId;
@end

NS_ASSUME_NONNULL_END
