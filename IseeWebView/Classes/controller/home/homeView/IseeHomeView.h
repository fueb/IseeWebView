//
//  HomeView.h
//  IseeWebView
//
//  Created by 点芯在线 on 2020/8/6.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IseeHomeView : UIView
@property (nonatomic,strong) void (^menuClick)(NSInteger type);
@property (nonatomic,strong) void (^searchItemClick)(NSInteger type);
@property (nonatomic,strong)NSMutableArray *model;
- (instancetype)initWithFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
