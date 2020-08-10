//
//  IseeHomeModel.h
//  IseeWebView
//
//  Created by 点芯在线 on 2020/8/10.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IseeHomeModel : NSObject
- (void)isee_homeMenuWithSuccess:(void (^)(id result))success
failure:(void (^)(void))failed;
- (void)isee_myTaskWithParam:(NSMutableDictionary *)param
                WithSuccess:(void (^)(id result))success
                     failure:(void (^)(void))failed;
- (void)isee_querySendOrderWithParam:(NSMutableDictionary *)param
                         WithSuccess:(void (^)(id result))success
                             failure:(void (^)(void))failed;
- (void)isee_custInfoWithParam:(NSMutableDictionary *)param
                   WithSuccess:(void (^)(id result))success
                       failure:(void (^)(void))failed;
- (void)isee_managerCustomLostWithParam:(NSMutableDictionary *)param
                            WithSuccess:(void (^)(id result))success
                                failure:(void (^)(void))failed;
- (void)isee_getBlueCustMsgWithParam:(NSMutableDictionary *)param
                         WithSuccess:(void (^)(id result))success
                             failure:(void (^)(void))failed;
@end

NS_ASSUME_NONNULL_END
