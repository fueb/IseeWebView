//
//  IseeChoiceRegionViewController.m
//  IseeWebView
//
//  Created by 点芯在线 on 2020/9/8.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import "IseeChoiceRegionViewController.h"
#import <objc/message.h>
#import "IseeChoiceRegionView.h"
#import "IseeConfig.h"
#import "IseeChoiceRegionModel.h"
#import "IseeAFNetRequest.h"
#import "IseeRegionModel.h"
#import "IseeRegionCell.h"
#import "IseeWebHomeTabBar.h"
#import "IseeHomeRequestModel.h"
#import "IseeLoadingView.h"

@interface IseeChoiceRegionViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation IseeChoiceRegionViewController
{
    IseeChoiceRegionView *choice;
    NSMutableArray *regionAry;
    IseeChoiceRegionModel *regionModel;
    IseeHomeRequestModel *requestModel;
    IseeLoadingView *loading;
}

- (instancetype)initWithLoginName:(NSString *)loginName withCompanyId:(NSString *)comanyId withSession:(NSString *)session withUserId:(NSString *)userId withSaleNum:(NSString *)saleNum
{
    requestModel = [[IseeHomeRequestModel alloc] init];
    requestModel.areaId = comanyId;
    requestModel.mLoginName = loginName;
    requestModel.mSession   = session;
    requestModel.mSaleNum   = saleNum;
    requestModel.mUserId    = userId;
    requestModel.mCompanyId = comanyId;
    self = [super init];
    if (self != nil)
    {
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
    regionAry = [NSMutableArray array];
    CGFloat safeBottom = 0;
    if ([IseeConfig isNotchScreen]) {
        safeBottom = 34;
    }
    choice = [[IseeChoiceRegionView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
    
    choice.mDelegate = self;
    
    [self.view addSubview:choice];
    [choice setModel:nil];
//    [self getRegion];
    // Do any additional setup after loading the view.
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
//    [param setObject:requestModel.mCompanyId forKey:@"areaId"];
    [param setObject:@"210,220" forKey:@"managerTypeIds"];
//    [IseeAFNetRequest showHUD:self.view];
    [self showLoading];
    
    __weak typeof(self) wkSelf = self;
    
    [self.regionModel isee_findRegionWithParam:param WithSuccess:^(id  _Nonnull result)
    {
        [wkSelf removeLoading];
        NSLog(@"%@", result);
        NSInteger type = 1;//0:错误没有包区，1：多个包区进入包区选择页面，2：1个包区直接进入首页，3：管理员进入人员选择页面
        NSString *errorStr = @"成功";
        
        if ([result[@"code"] integerValue] == 200)
        {
            NSMutableArray *data = result[@"data"];
            
            for (int i = 0;i < data.count;i++)
            {
                NSDictionary *dict = data[i];
                IseeRegionModel *model = [[IseeRegionModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [regionAry addObject:model];
                
            }
            [choice reloadTable];
            if (regionAry.count == 1) {
                type = 2;
                IseeRegionModel *model     = regionAry[0];
                
                requestModel.latnId = [NSString stringWithFormat:@"%lld",[model.latnId longLongValue]];
                requestModel.mStaffCode = model.staffCode;
                requestModel.mManagerId = [NSString stringWithFormat:@"%lld",[model.managerId longLongValue]];
                requestModel.mCompanyId = [NSString stringWithFormat:@"%lld",[model.areaId longLongValue]];
                requestModel.areaId = [NSString stringWithFormat:@"%lld",[model.areaId longLongValue]];
//                [self goHome:model];
//                return;
                requestModel.mManagerTypeId = [NSString stringWithFormat:@"%lld",[model.managerTypeId longLongValue]];
            }
            if (regionAry.count == 0) {
                type = 0;
                errorStr = @"没有包区信息";
            }
            
           
        }
        else
        {
            type = 0;
            errorStr = result[@"msg"];
//            IseeAlert(errorStr, nil);
            [IseeAFNetRequest showHUD:[IseeConfig mainWindow] withText:errorStr];
            [wkSelf openIsee];
        }
        if (_returnRegion) {
            _returnRegion(requestModel,type,errorStr);
        }
    } failure:^{
        [wkSelf removeLoading];
        if (_returnRegion) {
            _returnRegion(nil,0,@"获取包区信息失败");
        }
        
    }];
        
}

-(void)openIsee{
    
    UIViewController *vc        = [[NSClassFromString(@"ChangeRoleController") alloc]init];
    SEL runAction = NSSelectorFromString(@"goToTheNormalHomePage");
    
    if([vc respondsToSelector:runAction]){

        objc_msgSend(vc, runAction);
    }
    

}

#pragma mark - event
- (void)goBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - tableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
    return regionAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!regionAry.count)
    {
       return [UITableViewCell new];
    }
    IseeRegionCell *cell = [[IseeRegionCell alloc]init];
    cell.selectedBackgroundView=[[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor=[IseeConfig stringTOColor:@"#F4F6FB"];
    cell.model     = regionAry[indexPath.row];
    return cell;
    
}
- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath {

   [cell setSeparatorInset:UIEdgeInsetsZero];

    [cell setLayoutMargins:UIEdgeInsetsZero];

    cell.preservesSuperviewLayoutMargins = NO;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IseeRegionModel *model     = regionAry[indexPath.row];
    [self goHome:model];
}

- (void)goHome:(IseeRegionModel *)model
{
    requestModel.latnId = model.latnId;
    requestModel.mStaffCode = model.staffCode;
    requestModel.mManagerId = model.managerId;
    requestModel.mCompanyId = model.areaId;
    requestModel.areaId = model.areaId;
    IseeWebHomeTabBar *homeTabBar = [[IseeWebHomeTabBar alloc]initWithModel:requestModel];
    
    homeTabBar.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:homeTabBar animated:YES completion:nil];
}
        
- (IseeChoiceRegionModel *)regionModel
{
    if (!regionModel)
    {
        regionModel = [[IseeChoiceRegionModel alloc]init];
    }
    return regionModel;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
