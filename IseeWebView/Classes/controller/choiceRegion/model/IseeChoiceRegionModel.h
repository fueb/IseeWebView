//
//  IseeChoiceRegionModel.h
//  IseeWebView
//
//  Created by 点芯在线 on 2020/9/8.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IseeChoiceRegionModel : NSObject
- (void)isee_findRegionWithParam:(NSMutableDictionary *)param
                     WithSuccess:(void (^)(id result))success
                         failure:(void (^)(void))failed;
@end

NS_ASSUME_NONNULL_END
