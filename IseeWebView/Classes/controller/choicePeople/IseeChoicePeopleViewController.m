//
//  IseeChoicePeopleViewController.m
//  IseeWebView
//
//  Created by 余友良 on 2020/10/16.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import "IseeChoicePeopleViewController.h"
#import "IseeWebHomeTabBar.h"
#import "IseeChoicePeopleView.h"
#import "IseeChoicePeopleViewModel.h"
#import "IseeNaviBarView.h"
#import "IseeConfig.h"
#import "IseeHomeRequestModel.h"
#import "IseeLoadingView.h"
#import "IseeHomeTabBarModel.h"
#import "IseeAreaModel.h"

@interface IseeChoicePeopleViewController ()
{
    
    IseeHomeRequestModel *requestModel;
    IseeHomeTabBarModel   *iseeHomeTabBarModel;
    NSInteger pageNum;
    NSInteger pageSize;
    BOOL isLoading;
    
    IseeLoadingView *loading;
}
@property(nonatomic, strong) IseeChoicePeopleView *iseeChoicePeopleV;
@property(nonatomic, strong) IseeChoicePeopleViewModel *iseeChoicePeopleVM;

@end

@implementation IseeChoicePeopleViewController

- (instancetype)initWithModel:(IseeHomeRequestModel *)model
{
    self.model = model;
    requestModel = model;
    self = [super init];
    if (self != nil)
    {
        self.model = model;
        requestModel = model;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    pageSize = 15;
    pageNum = 1;
    __weak typeof(self) wkSelf = self;
    
    [self.iseeChoicePeopleVM setFieldGo:^(NSString * _Nonnull text) {
        [wkSelf getPeople:text];
    }];
    [self.view addSubview:self.dataView];
    [self ssoLogin];
    
    [self.iseeChoicePeopleVM setPeopleView:self.dataView];
    
    wkSelf.iseeChoicePeopleV.areaBgView.hidden = YES;
    
    [self setAction];
    _iseeChoicePeopleV.isPullUp_refresh = YES;
    wkSelf.iseeChoicePeopleVM.peopleModel.selectAreaId = requestModel.mCompanyId;
    // Do any additional setup after loading the view.
}

#pragma mark - action

- (void)setAction{
    __weak typeof(self) wkSelf = self;
    [self.iseeChoicePeopleVM setAreaCancel:^{
        wkSelf.iseeChoicePeopleV.areaBgView.hidden = YES;
    }];
    
    [self.iseeChoicePeopleVM setAreaSure:^(NSString * _Nonnull ids) {
        
        [wkSelf.iseeChoicePeopleVM.peopleModel.staffList removeAllObjects];
        [wkSelf.iseeChoicePeopleV.tableView reloadData];
        [wkSelf getPeople:@""];
    }];
    
    [self.iseeChoicePeopleVM setChoiceArea:^{
         [wkSelf getArea:@"id"];
    }];
    
    [self.iseeChoicePeopleVM setSelectPeople:^(IseePeopleModel * _Nonnull people) {
        [wkSelf goHome:people];
    }];
    [self setLoadMore];
}

/// 进入首页
/// @param model <#model description#>
- (void)goHome:(IseePeopleModel *)model
{
    __weak typeof(self) wkSelf = self;
    requestModel.latnId = model.latnId;
    requestModel.mLoginName = model.relaMobile;
    requestModel.mStaffCode = model.staffCode;
    requestModel.mManagerId = model.managerId;
    requestModel.mCompanyId = model.areaId;
    requestModel.areaId = model.areaId;
    IseeWebHomeTabBar *homeTabBar = [[IseeWebHomeTabBar alloc]initWithModel:requestModel];
    
    homeTabBar.modalPresentationStyle = UIModalPresentationFullScreen;
    [wkSelf presentViewController:homeTabBar animated:YES completion:nil];
}


/// tableview加载更多
- (void)setLoadMore{
    __weak typeof(self) wkSelf = self;
    
    [self.iseeChoicePeopleV setTableLoad:^{
        if (wkSelf.iseeChoicePeopleV.searchField.text.length<=0 && [wkSelf.iseeChoicePeopleVM.peopleModel.selectAreaId isEqualToString:requestModel.mCompanyId]) {
            [wkSelf.iseeChoicePeopleV endRefresh];
            return;
        }
        pageNum++;
        [wkSelf getPeople:wkSelf.iseeChoicePeopleV.searchField.text];
    }];
}

#pragma mark - requeset
- (void)ssoLogin{
    [self showLoading];
    
    __weak typeof(self) wkSelf = self;
    [self.iseeHomeTabBarModel isee_ssoLoginWith:requestModel.mLoginName withCompanyId:requestModel.mCompanyId withStaffCode:requestModel.mStaffCode withManagerId:requestModel.mManagerId
    withManagerTypeId:@"210"  Success:^(id  _Nonnull result) {
        NSLog(@"%@", result);
        [wkSelf removeLoading];
        if ([result[@"code"] integerValue] == 200)
        {
//            NSDictionary *data = result[@"data"];
//            NSDictionary *currentManagerTm = data[@"currentManagerTm"];
//            long tempLatnId = [currentManagerTm[@"latnId"] longValue];
//
//            NSString *latnId = [NSString stringWithFormat:@"%ld",tempLatnId];
//            self->requestModel.latnId = latnId;

            [wkSelf getArea:@"initId"];
        }
        else
        {
             IseeAlert(result[@"msg"],NULL);
        }
    } failure:^{
        [wkSelf removeLoading];
    }];
    
}

- (void)getArea:(NSString *)key
{
    __weak typeof(self) wkSelf = self;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *value = requestModel.mCompanyId;
    if ([key isEqualToString:@"id"]) {
        value = wkSelf.iseeChoicePeopleVM.peopleModel.selectAreaId;
    }
    [dict setObject:value forKey:key];

    [self showLoading];
    [self.iseeChoicePeopleVM isee_findAreaWithParam:dict WithSuccess:^(id  _Nonnull result) {

        [wkSelf removeLoading];
        NSLog(@"%@",result);
    } failure:^{
        [wkSelf removeLoading];
    }];
}
- (void)getPeople:(NSString *)staffName
{
    WS(wkSelf);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)pageSize] forKey:@"pageSize"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)pageNum] forKey:@"pageNum"];
    [dict setObject:wkSelf.iseeChoicePeopleVM.peopleModel.selectAreaId forKey:@"areaId"];
    [dict setObject:@"true" forKey:@"configureManager"];
    [dict setObject:@"220" forKey:@"managerTypeId"];
    [dict setObject:@"true" forKey:@"showChild"];
    [dict setObject:@"A" forKey:@"state"];
    if (staffName.length > 0) {
        [dict setObject:staffName forKey:@"staffName"];
    }
    
    [wkSelf showLoading];
    [wkSelf.iseeChoicePeopleVM isee_findPeopleWithParam:dict WithSuccess:^(id  _Nonnull result) {
        [wkSelf removeLoading];
        [wkSelf.iseeChoicePeopleV endRefresh];
        if ([result[@"code"] integerValue] == 200)
        {
            [wkSelf.iseeChoicePeopleV.tableView reloadData];
        }
        else
        {
             IseeAlert(result[@"msg"],NULL);
        }
    } failure:^{
        [wkSelf removeLoading];
        [wkSelf.iseeChoicePeopleV endRefresh];
    }];
    
    
}

#pragma mark - loding
- (void)showLoading{
    [loading removeFromSuperview];
    loading = nil;
    loading = [[IseeLoadingView alloc] initWithView:self.view];
    [self.view addSubview:loading];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        sleep(50);
        dispatch_async(dispatch_get_main_queue(), ^{
            [loading setHidden:YES];
        });
    });
}

- (void)removeLoading{
    [loading removeFromSuperview];
    loading = nil;
}

#pragma mark - init
- (IseeHomeTabBarModel *)iseeHomeTabBarModel
{
    if (!iseeHomeTabBarModel)
    {
        iseeHomeTabBarModel = [[IseeHomeTabBarModel alloc]init];
    }
    return iseeHomeTabBarModel;
}

- (IseeChoicePeopleViewModel *)iseeChoicePeopleVM
{
    if (!_iseeChoicePeopleVM) {
        _iseeChoicePeopleVM = [[IseeChoicePeopleViewModel alloc] init];
    }
    return _iseeChoicePeopleVM;
}

- (IseeChoicePeopleView *)dataView
{
    if (!_iseeChoicePeopleV) {
        _iseeChoicePeopleV = [[IseeChoicePeopleView alloc] initWithFrame:self.view.frame];
        
        _iseeChoicePeopleV.tableView.dataSource = self.iseeChoicePeopleVM;
        _iseeChoicePeopleV.tableView.delegate = self.iseeChoicePeopleVM;
        _iseeChoicePeopleV.areaTableView.dataSource = self.iseeChoicePeopleVM;
        _iseeChoicePeopleV.areaTableView.delegate = self.iseeChoicePeopleVM;
        _iseeChoicePeopleV.searchField.delegate = self.iseeChoicePeopleVM;
        [_iseeChoicePeopleV.searchBtn addTarget:self.iseeChoicePeopleVM action:@selector(choiceArea:) forControlEvents:UIControlEventTouchUpInside];

        [_iseeChoicePeopleV.cancelBtn addTarget:self.iseeChoicePeopleVM action:@selector(areaCancel:) forControlEvents:UIControlEventTouchUpInside];
        
        [_iseeChoicePeopleV.sureBtn addTarget:self.iseeChoicePeopleVM action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_iseeChoicePeopleV.tableView registerClass:[MLDataCell class] forCellReuseIdentifier:NSStringFromClass([MLDataCell class])];
    }
    return _iseeChoicePeopleV;
}

@end
