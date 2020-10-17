//
//  IseeChoicePeopleView.h
//  IseeWebView
//
//  Created by 余友良 on 2020/10/16.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IseeSegmentHeaderView.h"
NS_ASSUME_NONNULL_BEGIN

@interface IseeChoicePeopleView : UIView
@property (nonatomic,assign)BOOL isPullUp_refresh;    //是否可上来加载更多
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic,strong) UITextField *searchField;
@property(nonatomic,strong) UIView *searchBgView;
@property(nonatomic,strong) UIButton *searchBtn;

@property(nonatomic, strong)UIView * areaBgView;
@property(nonatomic,strong) UIButton *cancelBtn;
@property(nonatomic,strong) UIButton *sureBtn;
@property (nonatomic, strong) UITableView *areaTableView;
@property (nonatomic, strong) IseeSegmentHeaderView *areaSeg;

@property (nonatomic,strong) void (^tableLoad)(void);
- (void)endRefresh;
@end

NS_ASSUME_NONNULL_END
