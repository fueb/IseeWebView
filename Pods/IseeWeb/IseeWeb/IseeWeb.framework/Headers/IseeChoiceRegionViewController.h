//
//  IseeChoiceRegionViewController.h
//  IseeWebView
//
//  Created by 点芯在线 on 2020/9/8.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IseeHomeRequestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IseeChoiceRegionViewController : UIViewController
/***
 * errorStr: contype为0时提示错误信息
 * regionJson : 包区返回内容
 * conType :
 * 0失败提示错误信息不挑战，
 * 1跳转包区选择页面IseeChoiceRegionViewController，
 * 2跳转首页IseeWebHomeTabBar
 */
@property (nonatomic,strong) void (^returnRegion)(IseeHomeRequestModel *regionJson,NSInteger conType,NSString *errorStr);
- (instancetype)initWithLoginName:(NSString *)loginName withCompanyId:(NSString *)comanyId withSession:(NSString *)session withUserId:(NSString *)userId withSaleNum:(NSString *)saleNum;
- (void)goBack;
- (void)getRegion;
@end

NS_ASSUME_NONNULL_END
