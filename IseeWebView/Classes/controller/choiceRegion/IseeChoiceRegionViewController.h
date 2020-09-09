//
//  IseeChoiceRegionViewController.h
//  IseeWebView
//
//  Created by 点芯在线 on 2020/9/8.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IseeChoiceRegionViewController : UIViewController
- (instancetype)initWithLoginName:(NSString *)loginName withCompanyId:(NSString *)comanyId withSession:(NSString *)session withUserId:(NSString *)userId withSaleNum:(NSString *)saleNum;
- (void)goBack;
@end

NS_ASSUME_NONNULL_END
