//
//  IseeChoicePeopleViewController.h
//  IseeWebView
//
//  Created by 余友良 on 2020/10/16.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IseeHomeRequestModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface IseeChoicePeopleViewController : UIViewController
/***
 * 请求参数
 */
@property(nonatomic, strong)IseeHomeRequestModel *model;

- (instancetype)initWithModel:(IseeHomeRequestModel *)model;

@end

NS_ASSUME_NONNULL_END
