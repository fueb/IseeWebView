//
//  IseeSearchView.h
//  IseeWebView
//
//  Created by 点芯在线 on 2020/9/2.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IseeSearchViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface IseeSearchView : UIView
@property (nonatomic,assign)IseeSearchViewController *mDelegate;
@property (nonatomic,strong) void (^cancelClick)();
- (void)setModel:(NSMutableArray *)model;
- (void)getTable;
- (void)removeTable;
- (void)reloadTable;
- (void)setFieldPlace:(NSString *)place;
@end

NS_ASSUME_NONNULL_END
