//
//  IseeWebModel.h
//  IseeWebView
//
//  Created by 余友良 on 2020/11/20.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IseeWebModel : NSObject
- (void)isee_addRecordWithParam:(NSMutableDictionary *)param
                    WithSuccess:(void (^)(id result))success
                        failure:(void (^)(void))failed;
@end

NS_ASSUME_NONNULL_END
