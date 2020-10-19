//
//  IseeChoicePeopleView.m
//  IseeWebView
//
//  Created by 余友良 on 2020/10/16.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import "IseeChoicePeopleView.h"
#import <Masonry.h>
#import "IseeNaviBarView.h"
#import "IseeConfig.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "IseeAFNetRequest.h"

@interface IseeChoicePeopleView()<UITextFieldDelegate>
{
    UIImageView *downImg;
}

/** 导航条 */
@property(nonatomic, strong)IseeNaviBarView *topNavBar;
@property(nonatomic, strong)UIView * shadowBgView;
@property(nonatomic, strong)UIView * selectBgView;


@end

@implementation IseeChoicePeopleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        [self layout];
    }
    return self;
}

#pragma mark - view

- (void)layout
{
    [self drawTopNaviBar:@"人员选择" withTitleBg:[IseeConfig stringTOColor:@"#FFFFFF"] withBarBg:[IseeConfig stringTOColor:@"#1B82D2"]];
    
    [self addSubview:self.searchBgView];
    [self addSubview:self.tableView];
    [_searchBgView addSubview:self.searchField];
    [_searchBgView addSubview:self.searchBtn];
    [_searchBgView addSubview:self.downImg];
    __weak IseeChoicePeopleView *wkSelf = self;
    
    [_searchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(wkSelf);
        make.height.mas_equalTo(60);
        make.top.mas_equalTo(_topNavBar.mas_bottom);
    }];
    
    [_searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_searchBgView.mas_top).with.offset(10);
        make.left.mas_equalTo(_searchBgView.mas_left).with.offset(20);
        make.right.mas_equalTo(_searchBtn.mas_left).with.offset(-10);
        make.height.mas_equalTo(40);
    }];
    
    [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(downImg.mas_left).with.offset(4);
        make.height.top.mas_equalTo(_searchField);
        make.width.mas_equalTo(100);
    }];
    
    [downImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(wkSelf).with.offset(-4);
        make.top.mas_equalTo(_searchField).with.offset(12);
        make.width.height.mas_equalTo(16);
    }];
    
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_searchBgView.mas_bottom).offset(5);
        make.left.right.bottom.equalTo(wkSelf);
    }];
    
    [self choiceArea];
}

-(void)choiceArea
{
    [self addSubview:self.areaBgView];
    [_areaBgView addSubview:self.shadowBgView];
    [_areaBgView addSubview:self.selectBgView];
    [_selectBgView addSubview:self.cancelBtn];
    [_selectBgView addSubview:self.sureBtn];
    [_selectBgView addSubview:self.areaSeg];
    [_selectBgView addSubview:self.areaTableView];
    __weak typeof(self) wkSelf = self;
    [_areaBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topNavBar.mas_bottom);
        make.left.right.bottom.mas_equalTo(wkSelf);
    }];
    [_shadowBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(_areaBgView);
        make.bottom.mas_equalTo(_selectBgView.mas_top);
    }];
    
    [_selectBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(_areaBgView);
        make.height.mas_equalTo(500);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(_selectBgView);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(100);
    }];
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(_selectBgView);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(100);
    }];
    [_areaSeg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_selectBgView);
        make.top.mas_equalTo(_sureBtn.mas_bottom).with.offset(10);
        make.height.mas_equalTo(40);
    }];
    [_areaTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(_selectBgView);
        make.top.mas_equalTo(_areaSeg.mas_bottom);
    }];
}

#pragma mark - method

/// 在旋转界面时重新构造导航条
- (void)drawTopNaviBar:(NSString *)titleName withTitleBg:(UIColor *)titlebg withBarBg:(UIColor *)barBg {
    if (_topNavBar) {
        [_topNavBar removeFromSuperview];
    }
    // 添加自定义的导航条
    IseeNaviBarView *naviBar = [[IseeNaviBarView alloc] initWithController:self];
    [self addSubview:naviBar];
    self.topNavBar = naviBar;

//    [_topNavBar addBackBtn];

    [_topNavBar setNavigationTitle:titleName];
    [_topNavBar setNavigationBarClolor:barBg];
    [_topNavBar setTitleColor:titlebg];

}

/**
 *  给UITextField设置左侧的图片
 *
 *  @param textField UITextField
 *  @param imageName 图片名称
 */
-(void)setLeftViewWithTextField:(UITextField *)textField imageName:(NSString *)imageName{
    
    UIView *left = [[UIView alloc] init];
    //    reght.backgroundColor = [UIColor redColor];
    [left setBounds:CGRectMake(0, 0, 40, 40)];
    
    UIImageView *leftView = [[UIImageView alloc]init];
    leftView.image = [IseeConfig imageNamed:imageName size:CGSizeMake(20, 20)];
    [leftView setFrame:CGRectMake(10, 10, 20, 20)];
    [left addSubview:leftView];
//    leftView.contentMode = UIViewContentModeCenter;
    textField.leftView = left;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
}

- (void)endRefresh{
    [_tableView.mj_footer endRefreshing];
}

#pragma mark - control

- (UIImageView *)downImg
{
    if (!downImg) {
        downImg = [[UIImageView alloc] init];
        downImg.image = [IseeConfig imageNamed:@"arrowDown.svg" size:CGSizeMake(16, 16)];
    }
    return downImg;;
}

- (IseeSegmentHeaderView *)areaSeg{
    if (!_areaSeg){
        _areaSeg = [[IseeSegmentHeaderView alloc] initWithFrame:CGRectMake(0, 200, self.frame.size.width, 44) titles:@[]];
        _areaSeg.underLineColor = [IseeConfig stringTOColor:@"#39A0FF"];
        _areaSeg.selectIndex = 1;
        _areaSeg.isShowUnderLine = YES;
        _areaSeg.backgroundColor = [UIColor whiteColor];
    }
    return _areaSeg;
}

- (UIView *)shadowBgView
{
    if (!_shadowBgView) {
        _shadowBgView = [[UIView alloc] init];
        _shadowBgView.backgroundColor = [UIColor blackColor];
        _shadowBgView.alpha = 0.3;
    }
    return _shadowBgView;
}
- (UITableView *)areaTableView
{
    if (!_areaTableView) {
        _areaTableView = [[UITableView alloc] init];
        _areaTableView.rowHeight = 40;
        _areaTableView.tag = 2;
        _areaTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _areaTableView;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
         
        [_cancelBtn setTitleColor:[IseeConfig stringTOColor:@"#888A9D"] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC" size:14];
        _cancelBtn.selected = YES;
        
    }
    return _cancelBtn;
}

- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
         
        [_sureBtn setTitleColor:[IseeConfig stringTOColor:@"#63A4FF"] forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC" size:14];
        _sureBtn.selected = YES;
        
    }
    return _sureBtn;
}

- (UIView *)selectBgView
{
    if (!_selectBgView) {
        _selectBgView = [[UIView alloc] init];
        _selectBgView.backgroundColor = [UIColor whiteColor];
    }
    return _selectBgView;
}

- (UIView *)areaBgView
{
    if (!_areaBgView) {
        _areaBgView = [[UIView alloc] init];
        _areaBgView.backgroundColor = [UIColor clearColor];

    }
    return _areaBgView;
}

- (UIView *)searchBgView
{
    if (!_searchBgView) {
        _searchBgView = [[UIView alloc] init];
    }
    return _searchBgView;
}

- (UITextField *)searchField
{
    if (!_searchField) {
        _searchField = [[UITextField alloc] init];
        _searchField.backgroundColor = [UIColor whiteColor];
        _searchField.returnKeyType = UIReturnKeyGo;
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请输入人员名称" attributes:@{NSForegroundColorAttributeName : [IseeConfig stringTOColor:@"#aaaaaa"]}];
        _searchField.textColor = [IseeConfig stringTOColor:@"#1B82D2"];
        _searchField.attributedPlaceholder = placeholderString;
        [self setLeftViewWithTextField:_searchField imageName:@"queryIcon"];
        _searchField.layer.borderWidth = 1;
        _searchField.layer.borderColor = [[IseeConfig stringTOColor:@"#dddddd"] CGColor];
        [_searchField.layer setCornerRadius:20];
        _searchField.layer.masksToBounds = YES;
    }
    return _searchField;
}

- (UIButton *)searchBtn
{
    if (!_searchBtn) {
        _searchBtn = [[UIButton alloc] init];
        [_searchBtn setTitle:@"浙江" forState:UIControlStateNormal];
        [_searchBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC" size:14]];
        [_searchBtn setTitleColor:[IseeConfig stringTOColor:@"#0085FF"] forState:UIControlStateNormal];
        _searchBtn.selected = YES;
        
    }
    return _searchBtn;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.rowHeight = 50;
        _tableView.tag = 1;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        WS(weakSelf);
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            if (weakSelf.isPullUp_refresh)
            {
                
                if (weakSelf.tableLoad) {
                    weakSelf.tableLoad();
                }
            }
            else
            {
                [weakSelf.tableView.mj_footer endRefreshing];
                NSLog(@"加载更多1");
                [IseeAFNetRequest showHUD:weakSelf withText:@"已全部加载完毕"];
            }
        }];
    }
    return _tableView;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
@end
