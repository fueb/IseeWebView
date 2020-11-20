//
//  IseeChoiceRoleViewController.h
//  IseeWebView
//
//  Created by 余友良 on 2020/11/20.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface IseeChoiceRoleViewController : UIViewController
- (instancetype)initWithLoginName:(NSString *)loginName withCompanyId:(NSString *)comanyId withSession:(NSString *)session withUserId:(NSString *)userId withSaleNum:(NSString *)saleNum;
@end

NS_ASSUME_NONNULL_END
