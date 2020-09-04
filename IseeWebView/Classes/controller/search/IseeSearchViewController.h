//
//  IseeSearchViewController.h
//  IseeWebView
//
//  Created by 点芯在线 on 2020/9/2.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IseeSearchViewController : UIViewController
@property (nonatomic,strong)NSString *mLoginName;
@property (nonatomic,strong)NSString *mCompanyId;
@property (nonatomic,strong)NSString *latnId;
@property (nonatomic,strong)NSString *mSession;
@property (nonatomic,strong)NSString *mUserId;
@property (nonatomic,strong)NSString *mSaleNum;
@property (nonatomic,strong)NSString *areaId;
@property (nonatomic,strong)NSString *mManagerId;
@property (nonatomic)NSInteger searchInt;
@end

NS_ASSUME_NONNULL_END
