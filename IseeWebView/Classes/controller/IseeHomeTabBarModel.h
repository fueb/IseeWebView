//
//  IseeHomeTabBarModel.h
//  IseeWebView
//
//  Created by 点芯在线 on 2020/8/12.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IseeHomeTabBarModel : NSObject
- (void)isee_loginWith:(NSString *)managerId
         withStaffCode:(NSString *)staffCode
               Success:(void (^)(id result))success
               failure:(void (^)(void))failed;
- (void)isee_ssoLoginWith:(NSString *)loginName
            withCompanyId:(NSString *)companyId
                  Success:(void (^)(id result))success
                  failure:(void (^)(void))failed;
@end

NS_ASSUME_NONNULL_END
