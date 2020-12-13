//
//  IseeChoiceRoleViewController.m
//  IseeWebView
//
//  Created by 余友良 on 2020/11/20.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import "IseeChoiceRoleViewController.h"
#import <objc/message.h>
#import "IseeChoiceRoleModel.h"
#import "IseeChoiceRoleView.h"
#import "IseeConfig.h"
#import "IseeLoadingView.h"
#import "IseeChoiceRegionModel.h"
#import "IseeHomeRequestModel.h"
#import "IseeRoleCell.h"
#import "IseeAFNetRequest.h"
#import "IseeWebHomeTabBar.h"
#import "IseeChoicePeopleViewController.h"

@interface IseeChoiceRoleViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    IseeChoiceRoleView *roleView;
    IseeChoiceRoleModel *roleModel;
    NSMutableArray *roleAry;
    IseeChoiceRegionModel *regionModel;
    IseeHomeRequestModel *requestModel;
    IseeLoadingView *loading;
}

@end

@implementation IseeChoiceRoleViewController

- (instancetype)initWithLoginName:(NSString *)loginName withCompanyId:(NSString *)comanyId withSession:(NSString *)session withUserId:(NSString *)userId withSaleNum:(NSString *)saleNum
{
    
    self = [super init];
    if (self != nil)
    {
        requestModel = [[IseeHomeRequestModel alloc] init];
        requestModel.areaId = comanyId;
        requestModel.mLoginName = loginName;
        requestModel.mSession   = session;
        requestModel.mSaleNum   = saleNum;
        requestModel.mUserId    = userId;
        requestModel.mCompanyId = comanyId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    roleAry = [NSMutableArray array];
    roleView = [[IseeChoiceRoleView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
    
    roleView.mDelegate = self;
    
    [self.view addSubview:roleView];
    [roleView setModel:nil];
    [self getRegion];
}

- (void)showLoading{
    [loading removeFromSuperview];
    loading = nil;
    loading = [[IseeLoadingView alloc] initWithView:self.view withImgName:@"iseeLoading.gif" titleHave:NO];
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

- (void)getRegion{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:requestModel.mLoginName forKey:@"mobile"];
    [param setObject:@"210,220" forKey:@"managerTypeIds"];
    [self showLoading];
    
    __weak typeof(self) wkSelf = self;
    
    [self.regionModel isee_findRegionWithParam:param WithSuccess:^(id  _Nonnull result)
    {
        __strong typeof(self) stSelf = wkSelf;
        [stSelf removeLoading];
        NSLog(@"%@", result);
        NSInteger type = 1;//0:错误没有包区，1：多个包区进入包区选择页面，2：1个包区直接进入首页，3：管理员进入人员选择页面
        NSString *errorStr = @"成功";
        
        if ([result[@"code"] integerValue] == 200)
        {
            NSMutableArray *data = result[@"data"];
            
            
            
            for (int i = 0;i < data.count;i++)
            {
                NSDictionary *dict = data[i];
                IseeRoleModel *model = [[IseeRoleModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [stSelf->roleAry addObject:model];
                
            }
            [stSelf->roleView reloadTable];
            
            if (data.count <= 0) {
                dispatch_after(DISPATCH_TIME_NOW+1, dispatch_get_main_queue(), ^{
                    [stSelf openIsee];
                });
            }
           
        }
        else
        {
            type = 0;
            errorStr = result[@"msg"];
            [IseeAFNetRequest showHUD:[IseeConfig mainWindow] withText:errorStr];
            dispatch_after(DISPATCH_TIME_NOW+1, dispatch_get_main_queue(), ^{
                [stSelf openIsee];
            });
        }
        
    } failure:^{
        [wkSelf removeLoading];
        
        
    }];
        
}

#pragma mark - tableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
    return roleAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!roleAry.count)
    {
       return [UITableViewCell new];
    }
    IseeRoleCell *cell = [[IseeRoleCell alloc]init];
    cell.selectedBackgroundView=[[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor=[IseeConfig stringTOColor:@"#F4F6FB"];
    cell.model     = roleAry[indexPath.row];
    return cell;
    
}
- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath {

   [cell setSeparatorInset:UIEdgeInsetsZero];

    [cell setLayoutMargins:UIEdgeInsetsZero];

    cell.preservesSuperviewLayoutMargins = NO;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IseeRoleModel *model     = roleAry[indexPath.row];
    [self goVcWithModel:model];
    
}
- (void)goVcWithModel:(IseeRoleModel *)model
{
    requestModel.latnId = [NSString stringWithFormat:@"%lld",[model.latnId longLongValue]];
    requestModel.mStaffCode = model.staffCode;
    requestModel.mManagerId = [NSString stringWithFormat:@"%lld",[model.managerId longLongValue]];
    requestModel.mCompanyId = [NSString stringWithFormat:@"%lld",[model.areaId longLongValue]];
    requestModel.areaId = [NSString stringWithFormat:@"%lld",[model.areaId longLongValue]];
    requestModel.mManagerTypeId = [NSString stringWithFormat:@"%lld",[model.managerTypeId longLongValue]];
    if ([requestModel.mManagerTypeId isEqualToString:@"210"]) {
        IseeChoicePeopleViewController *vc = [[IseeChoicePeopleViewController alloc] initWithModel:requestModel];
        //
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }
    else if ([requestModel.mManagerTypeId isEqualToString:@"220"])
    {
        IseeWebHomeTabBar *homeTabBar = [[IseeWebHomeTabBar alloc]initWithModel:requestModel];
        
        homeTabBar.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:homeTabBar animated:YES completion:nil];
    }
    
}


- (IseeChoiceRoleView *)roleView
{
    return roleView;
}
 - (IseeChoiceRegionModel *)regionModel
 {
     if (!regionModel)
     {
         regionModel = [[IseeChoiceRegionModel alloc]init];
     }
     return regionModel;
 }


#pragma mark - isee
-(void)openIsee{
    
    UIViewController *vc        = [[NSClassFromString(@"ChangeRoleController") alloc]init];
    SEL runAction = NSSelectorFromString(@"goToTheNormalHomePage");
    
    if([vc respondsToSelector:runAction]){

        ((void (*)(id ,SEL))(void *)objc_msgSend)(vc, runAction);
    }
    

}
@end
