//
//  IseeSearchView.m
//  IseeWebView
//
//  Created by 点芯在线 on 2020/9/2.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import "IseeSearchView.h"
#import "IseeConfig.h"
#import <Masonry.h>

@interface IseeSearchView()
@property(nonatomic,copy) UIView *searchBgView;
@property(nonatomic,copy) UITextField *searchField;
@property(nonatomic,copy) UIButton *searchBtn;
@property (nonatomic, strong) UITableView *searchTable;
@property (nonatomic, strong) UIView      *tableBgView;
@end

@implementation IseeSearchView
{
    UIView *tableBgView;
    UITableView *searchTable;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    return self;
}

- (void)setModel:(NSMutableArray *)model
{
   
    [self searchView];
    [self getTable];
}


- (void)searchView{
    

    __weak typeof(self) wkSelf = self;
   _searchBgView = [[UIView alloc] init];
   [_searchBgView setBackgroundColor:[IseeConfig stringTOColor:@"#1B82D2"]];
   
   [self addSubview:_searchBgView];

    _searchField = [[UITextField alloc] init];
    _searchField.delegate = _mDelegate;
    _searchField.returnKeyType = UIReturnKeyGo;
//    searchField.placeholder = @"请输入企业名称";
    
    NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请输入..." attributes:@{NSForegroundColorAttributeName : [IseeConfig stringTOColor:@"#87C0F8"]}];
    _searchField.textColor = [IseeConfig stringTOColor:@"#5FA9F7"];
    _searchField.attributedPlaceholder = placeholderString;

//    [self setRightViewWithTextField:searchField imageName:@"camerIcon" withImg:@"micIcon"];
    [self setLeftViewWithTextField:_searchField imageName:@"queryIcon"];
    [_searchField setBackgroundColor:[IseeConfig stringTOColor:@"#CAE1F9"]];
    [_searchField.layer setCornerRadius:10];
    _searchField.layer.masksToBounds = YES;
    [_searchBgView addSubview:_searchField];
    
    _searchBtn = [[UIButton alloc] init];
    [_searchBtn setTitle:@"取消" forState:UIControlStateNormal];
    
   [_searchBtn setTitleColor:[IseeConfig stringTOColor:@"#FFFFFF"] forState:UIControlStateNormal];
   _searchBtn.selected = YES;
   [_searchBtn addTarget:self action:@selector(cancelEvent:) forControlEvents:UIControlEventTouchUpInside];
   [_searchBgView addSubview:_searchBtn];
    
    [_searchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wkSelf.mas_top);
        make.height.equalTo(@(94));
        make.left.right.equalTo(wkSelf);
    }];
    
    [_searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(_searchBgView.mas_left).with.offset(15);
        make.right.mas_equalTo(_searchBtn.mas_left).with.offset(-5);
        make.top.mas_equalTo(_searchBgView.mas_top).with.offset(44);
    }];
    
    [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(_searchField);
        make.right.mas_equalTo(_searchBgView.mas_right).with.offset(-5);
        make.width.mas_equalTo(50);
    }];
   
}

- (void)getTable{
    __weak typeof(self) wkSelf = self;
    [self addSubview:self.tableBgView];
    [tableBgView addSubview:self.searchTable];
    
    [tableBgView mas_makeConstraints:^(MASConstraintMaker *make) {
         
        make.top.equalTo(_searchField.mas_bottom).offset(5);
        make.left.right.bottom.equalTo(wkSelf);
    }];
    [searchTable mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.bottom.top.right.mas_equalTo(tableBgView);
    }];
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
    leftView.image = [IseeConfig imageNamed:imageName];
    [leftView setFrame:CGRectMake(0, 0, 40, 40)];
    [left addSubview:leftView];
//    leftView.contentMode = UIViewContentModeCenter;
    textField.leftView = left;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
}

- (void)removeTable{
    [tableBgView removeFromSuperview];
}

- (void)reloadTable{
    [searchTable reloadData];
}

#pragma mark - event

- (void)cancelEvent:(UIButton *)btn
{
    if (_cancelClick) {
        _cancelClick();
    }
    NSLog(@"123123");
}



- (UITableView *)searchTable
{
    if (searchTable == nil)
    {
        searchTable = [[UITableView alloc] init];
        searchTable.backgroundColor = [UIColor whiteColor];
        searchTable.delegate = _mDelegate;
        searchTable.dataSource = _mDelegate;
    }
    return searchTable;
}

- (UIView *)tableBgView
{
    if (tableBgView == nil) {
        UIView *av = [[UIView alloc] init];
        [av setBackgroundColor:[UIColor clearColor]];

        tableBgView = av;
    }
    return tableBgView;
}
@end
