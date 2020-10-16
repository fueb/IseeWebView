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
@property (nonatomic,assign)BOOL isPullUp_refresh;    //是否可上来加载更多
@property (nonatomic,assign)IseeSearchViewController *mDelegate;
@property (nonatomic,strong) void (^cancelClick)(void);
@property (nonatomic,strong) void (^tableLoad)(void);

- (void)setModel:(NSMutableArray *)model;
- (void)getTable;
- (void)removeTable;
- (void)reloadTable;
- (void)setFieldPlace:(NSString *)place;
- (void)endRefresh;
- (NSString *)getFieldText;
@end

NS_ASSUME_NONNULL_END
