//
//  IseeChoiceRoleViewController.h
//  IseeWebView
//
//  Created by 余友良 on 2020/11/20.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IseeHomeRequestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IseeChoiceRoleViewController : UIViewController
/***
 * errorStr: contype为0时提示错误信息
 * regionJson : 包区返回内容
 * conType :
 * 0失败提示错误信息不挑战，
 * 1跳转包区选择页面IseeChoiceRegionViewController，
 * 2跳转首页IseeWebHomeTabBar
 */
@property (nonatomic,strong) void (^returnRole)(IseeHomeRequestModel *regionJson,NSInteger conType,NSString *errorStr);
- (instancetype)initWithLoginName:(NSString *)loginName withCompanyId:(NSString *)comanyId withSession:(NSString *)session withUserId:(NSString *)userId withSaleNum:(NSString *)saleNum;
- (void)getRole;
@end

NS_ASSUME_NONNULL_END
