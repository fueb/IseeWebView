//
//  IseeSearchViewController.m
//  IseeWebView
//
//  Created by 点芯在线 on 2020/9/2.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import "IseeSearchViewController.h"
#import "IseeSearchView.h"
#import "IseeConfig.h"
#import "IseeCustModel.h"
#import "IseeCustCell.h"
#import "IseeProdModel.h"
#import "IseeProdCell.h"
#import "IseeAFNetRequest.h"
#import "IseeHomeModel.h"
#import "IseeWebViewController.h"
#import "IseeLoadingView.h"

@interface IseeSearchViewController ()
{
    IseeSearchView *search;
    IseeHomeModel   *iseeHomeModel;
    NSMutableArray *modelAry;
    
    NSMutableArray *searchCustAry;
    NSMutableArray *searchProdAry;
    NSInteger pageNum;
    NSInteger pageSize;
    BOOL isLoading;
    
    IseeLoadingView *loading;
}
@end

@implementation IseeSearchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    isLoading = NO;
    pageNum = 0;
    pageSize = 15;
    modelAry = [[NSMutableArray alloc] init];
    CGFloat safeBottom = 0;
    if ([IseeConfig isNotchScreen]) {
        safeBottom = 34;
    }
    search = [[IseeSearchView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
    
    search.mDelegate = self;
    search.isPullUp_refresh = YES;
    
    [self.view addSubview:search];
    [search setModel:modelAry];
    [self setClick];
    [self setLoadMore];
    if (_searchInt == 0) {
        [search setFieldPlace:@"请输入企业名称"];
    }
    else if (_searchInt == 1)
    {
        [search setFieldPlace:@"请输入号码"];
    }
    // Do any additional setup after loading the view.
}

- (void)setClick{
    [search setCancelClick:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

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

- (void)setLoadMore{
    __weak typeof(self) wkSelf = self;
    
    [search setTableLoad:^{
        pageNum++;
        [wkSelf searchWIthText:[search getFieldText]];
    }];
}


- (void)searchWIthText:(NSString *)text{
    if (text.length <= 0) {
//        [IseeAFNetRequest showHUD:self.view withText:@"请输入关键字"];
        IseeAlert(@"请输入关键字",NULL);
        return;
    }
    if (isLoading) {
        return;
    }
    isLoading = YES;
    __weak typeof(self) wkSelf = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:text forKey:@"text"];
    [param setObject:_requesetModel.mManagerId forKey:@"managerId"];
    [param setObject:_requesetModel.mStaffCode forKey:@"staffCode"];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)pageSize] forKey:@"pageSize"];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)pageNum] forKey:@"pageNum"];
//    [IseeAFNetRequest showHUD:self.view];
    [self showLoading];
    if (_searchInt == 0) {
        [param setObject:_requesetModel.latnId forKey:@"latnId"];
        [self.iseeHomeModel isee_findCustMsgWithParam:param WithSuccess:^(id  _Nonnull result) {
            [wkSelf removeLoading];
            [search endRefresh];
            if ([result[@"code"] integerValue] == 200)
            {
                NSArray *data = result[@"data"];
                if (data.count < 15) {
                    search.isPullUp_refresh = NO;
                }
                
                for (int i = 0;i < data.count;i++)
                {
                    NSDictionary *dict = data[i];
                    IseeCustModel *model = [[IseeCustModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [searchCustAry addObject:model];
                    
                }
                [search reloadTable];
            }
            else
            {
                 IseeAlert(result[@"msg"],NULL);
            }
            isLoading = NO;
        } failure:^{
            isLoading = NO;
            [search endRefresh];
            IseeAlert(@"请求超时",NULL);
            [wkSelf removeLoading];
        }];
    }
    else if (_searchInt == 1)
    {
        [self.iseeHomeModel isee_findProdWithParam:param WithSuccess:^(id  _Nonnull result) {
            [wkSelf removeLoading];
            [search endRefresh];
            if ([result[@"code"] integerValue] == 200)
            {
                NSArray *data = result[@"data"];
                if (data.count < 15) {
                    search.isPullUp_refresh = NO;
                }
                
                for (int i = 0;i < data.count;i++)
                {
                    NSDictionary *dict = data[i];
                    IseeProdModel *model = [[IseeProdModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [searchProdAry addObject:model];
                    
                }
                [search reloadTable];
            }
            else
            {
                IseeAlert(result[@"msg"],NULL);
            }
            isLoading = NO;
        } failure:^{
            isLoading = NO;
            [search endRefresh];
//            [IseeAFNetRequest showHUD:wkSelf.view withText:@"请求失败，请重试"];
            IseeAlert(@"请求超时",NULL);
            [wkSelf removeLoading];
        }];
    }
    
}


- (void)findProdute:(NSString *)servId withProductType:(NSString *)productType withText:(NSString *)text withModel:(IseeProdModel *)tempModel
{
    if(text==nil||productType==nil||servId ==nil)
    {
        IseeAlert(@"参数不正确", nil);
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:text forKey:@"text"];
    [param setObject:productType forKey:@"productType"];
    [param setObject:servId forKey:@"servId"];
    [param setObject:_requesetModel.mManagerId forKey:@"managerId"];
    [param setObject:_requesetModel.mStaffCode forKey:@"staffCode"];
//    [IseeAFNetRequest showHUD:self.view];
    [self showLoading];
    __weak typeof(self) wkSelf = self;
    [self.iseeHomeModel isee_findProductWithParam:param WithSuccess:^(id  _Nonnull result) {
        [wkSelf removeLoading];
        if ([result[@"code"] integerValue] == 200)
        {
            NSDictionary *data = result[@"data"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

             // 设置想要的格式，hh与HH的区别:分别表示12小时制,24小时制

             [formatter setDateFormat:@"YYYYMMdd"];

             NSDate *dateNow = [NSDate date];

             //把NSDate按formatter格式转成NSString

             NSString *currentTime = [formatter stringFromDate:dateNow];
             
             NSString *md5Str = [NSString stringWithFormat:@"%@%@ISEE%@",_requesetModel.mLoginName,_requesetModel.mCompanyId,currentTime];
             NSString *md5Key = [IseeConfig md5:md5Str];
            NSString *urlStr;
            urlStr = [NSString stringWithFormat:@"%@%@?accNbr97=%@&productType=%@&accNbr=%@&latnId=%@&servId=%@&custId=%@&crmCustId=%@&loginName=%@&companyId=%@&md5key=%@&source=isee&form=app2",WEBHOST,integratedQueryWEBURL,data[@"accNbr97"],tempModel.productTypeId,tempModel.accNbr,tempModel.latnId,tempModel.servId,data[@"custId"],tempModel.crmCustId,_requesetModel.mLoginName,_requesetModel.mCompanyId,md5Key];
             
             
             IseeWebViewController *frameVC = [[IseeWebViewController alloc] init];
            frameVC.mLoginName = _mLoginName;
            frameVC.mSession   = _requesetModel.mSession;
            frameVC.mSaleNum   = _requesetModel.mSaleNum;
            frameVC.mUserId    = _requesetModel.mUserId;
             frameVC.titleHave = YES;
             frameVC.tabbarHave = NO;
            frameVC.isHomeGo = YES;
             frameVC.titleName = @"综合查询";
             frameVC.titleBgColor = @"#FFFFFF";  //白色
             frameVC.statusBarColor = @"#1B82D2";//@"#50D4F9";  //自定义颜色
            
              
             NSURL *url = [NSURL URLWithString:urlStr];
             frameVC.mWebViewUrl = url;
             frameVC.modalPresentationStyle = UIModalPresentationFullScreen;
             [self presentViewController:frameVC animated:YES completion:nil];
        }
        else if ([result[@"code"] integerValue] == 401)
        {
            IseeAlert(@"客户不属此工号管辖",NULL);
        }
        else
        {
            IseeAlert(result[@"msg"],NULL);
        }
    } failure:^{
        [wkSelf removeLoading];
    }];
}

- (void)findCrm:(NSString *)vipCard withLatnId:(NSString *)latnId withModel:(IseeCustModel *)tempModel
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:vipCard forKey:@"vipCard"];
    [param setObject:latnId forKey:@"latnId"];
    [param setObject:_requesetModel.mManagerId forKey:@"managerId"];
    [param setObject:_requesetModel.mStaffCode forKey:@"staffCode"];
    
//    [IseeAFNetRequest showHUD:self.view];
    [self showLoading];
    __weak typeof(self) wkSelf = self;
    [self.iseeHomeModel isee_findCrmWithParam:param WithSuccess:^(id  _Nonnull result) {
        [wkSelf removeLoading];
        if ([result[@"code"] integerValue] == 200)
        {
            NSArray *data = result[@"data"];
            if (data.count<=0) {
                IseeAlert(@"crm客户查询出错",NULL);
                return;
            }
            NSDictionary *crmDict = [data firstObject];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

             // 设置想要的格式，hh与HH的区别:分别表示12小时制,24小时制

             [formatter setDateFormat:@"YYYYMMdd"];

             NSDate *dateNow = [NSDate date];

             //把NSDate按formatter格式转成NSString

             NSString *currentTime = [formatter stringFromDate:dateNow];
             
             NSString *md5Str = [NSString stringWithFormat:@"%@%@ISEE%@",_requesetModel.mLoginName,_requesetModel.mCompanyId,currentTime];
            NSString *md5Key = [IseeConfig md5:md5Str];
            NSString *urlStr;
            NSString *method;
            NSString *titleStr;
            if ([tempModel.id_type_name isEqualToString:@"本网"]&&tempModel.ser_id) {
                if (data.count > 1){
                    method = enterpriseNewViewWEBURL;
                    titleStr = @"政企视图";
                    urlStr = [NSString stringWithFormat:@"%@%@?vipCard=%@&latnId=%@&loginName=%@&companyId=%@&md5key=%@&source=isee&form=app2",WEBHOST,method,tempModel.ser_id,tempModel.latn_id,_requesetModel.mLoginName,_requesetModel.mCompanyId,md5Key];
                }
                else
                {
                    method = CRMCUSTViewWEBURL;
                    titleStr = @"CRM视图";
                    urlStr = [NSString stringWithFormat:@"%@%@?custId=%@&crmCustId=%@&latnId=%@&loginName=%@&companyId=%@&md5key=%@&source=isee&form=app2",WEBHOST,method,crmDict[@"custId"],crmDict[@"crmCustId"],tempModel.latn_id,_requesetModel.mLoginName,_requesetModel.mCompanyId,md5Key];
                }
                    
            }
            else if (([tempModel.id_type_name isEqualToString:@"他网"]||[tempModel.id_type_name isEqualToString:@"蓝海"])&&tempModel.ser_id) {
                method = BLUEViewWEBURL;
                titleStr = @"蓝海视图";
//                [self findBlue:tempModel.ser_id withModel:tempModel];
                
                IseeAlert(@"正在开发中-敬请期待",NULL);
                return;
                
            }
            else if (((![tempModel.id_type_name isEqualToString:@"他网"])&&(![tempModel.id_type_name isEqualToString:@"蓝海"])&&(![tempModel.id_type_name isEqualToString:@"本网"]))&&tempModel.ser_id)
            {
                method = CRMCUSTViewWEBURL;
                titleStr = @"CRM视图";
                urlStr = [NSString stringWithFormat:@"%@%@?custId=%@&crmCustId=%@&latnId=%@&loginName=%@&companyId=%@&md5key=%@&source=isee&form=app2",WEBHOST,method,crmDict[@"custId"],crmDict[@"crmCustId"],tempModel.latn_id,_requesetModel.mLoginName,_requesetModel.mCompanyId,md5Key];
            }
            
             
             
            IseeWebViewController *frameVC = [[IseeWebViewController alloc] init];
            frameVC.mLoginName = _mLoginName;
            frameVC.mSession   = _requesetModel.mSession;
            frameVC.mSaleNum   = _requesetModel.mSaleNum;
            frameVC.mUserId    = _requesetModel.mUserId;
            frameVC.titleHave = YES;
            frameVC.tabbarHave = NO;
            frameVC.isHomeGo = YES;
            frameVC.reallyGo = YES;
            frameVC.titleName = titleStr;
            frameVC.titleBgColor = @"#FFFFFF";  //白色
            frameVC.statusBarColor = @"#1B82D2";//@"#50D4F9";  //自定义颜色
            
              
             NSURL *url = [NSURL URLWithString:urlStr];
             frameVC.mWebViewUrl = url;
             frameVC.modalPresentationStyle = UIModalPresentationFullScreen;
             [self presentViewController:frameVC animated:YES completion:nil];
        }
        else if ([result[@"code"] integerValue] == 401)
        {
            IseeAlert(@"客户不属此工号管辖",NULL);
        }
        else
        {
            IseeAlert(result[@"msg"],NULL);
        }
    }
    failure:^{
        [wkSelf removeLoading];
    }];
    
}

- (void)findVip:(NSString *)test withModel:(IseeCustModel *)tempModel{
    if(test == nil)
    {
        IseeAlert(@"参数不正确", nil);
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:test forKey:@"text"];
    [param setObject:_requesetModel.mManagerId forKey:@"managerId"];
    [param setObject:_requesetModel.mStaffCode forKey:@"staffCode"];
//    [IseeAFNetRequest showHUD:self.view];
    [self showLoading];
    __weak typeof(self) wkSelf = self;
    [self.iseeHomeModel isee_findVipWithParam:param WithSuccess:^(id  _Nonnull result) {
        [wkSelf removeLoading];
        if ([result[@"code"] integerValue] == 200)
        {
            [self findCrm:tempModel.ser_id withLatnId:_requesetModel.latnId withModel:tempModel];
        }
        else if ([result[@"code"] integerValue] == 401)
        {
            IseeAlert(@"客户不属此工号管辖",NULL);
        }
        else
        {
            IseeAlert(result[@"msg"],NULL);
        }
    }
    failure:^{
        [wkSelf removeLoading];
    }];
}

- (void)findBlue:(NSString *)test withModel:(IseeCustModel *)tempModel{
    if(test==nil)
    {
        IseeAlert(@"参数不正确", nil);
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:test forKey:@"text"];
    [param setObject:_requesetModel.mManagerId forKey:@"managerId"];
    [param setObject:_requesetModel.mStaffCode forKey:@"staffCode"];
//    [IseeAFNetRequest showHUD:self.view];
    [self showLoading];
    __weak typeof(self) wkSelf = self;
    [self.iseeHomeModel isee_findBlueWithParam:param WithSuccess:^(id  _Nonnull result) {
        [wkSelf removeLoading];
        if ([result[@"code"] integerValue] == 200)
        {
            NSArray *data = result[@"data"];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

             // 设置想要的格式，hh与HH的区别:分别表示12小时制,24小时制

             [formatter setDateFormat:@"YYYYMMdd"];

             NSDate *dateNow = [NSDate date];

             //把NSDate按formatter格式转成NSString

             NSString *currentTime = [formatter stringFromDate:dateNow];
             
             NSString *md5Str = [NSString stringWithFormat:@"%@%@ISEE%@",_requesetModel.mLoginName,_requesetModel.mCompanyId,currentTime];
             NSString *md5Key = [IseeConfig md5:md5Str];
            NSString *urlStr;
            NSString *method;
            NSString *titleStr;

            method = BLUEViewWEBURL;
            titleStr = @"蓝海视图";
           
             urlStr = [NSString stringWithFormat:@"%@%@?areaId=%@&latnId=%@&managerId=%@&loginName=%@",WEBHOST,method,_requesetModel.areaId,_requesetModel.latnId,_requesetModel.mManagerId,_requesetModel.mLoginName];
             
            IseeWebViewController *frameVC = [[IseeWebViewController alloc] init];
            frameVC.mLoginName = _mLoginName;
            frameVC.mSession   = _requesetModel.mSession;
            frameVC.mSaleNum   = _requesetModel.mSaleNum;
            frameVC.mUserId    = _requesetModel.mUserId;
            frameVC.titleHave = YES;
            frameVC.tabbarHave = NO;
            frameVC.isHomeGo = YES;
            frameVC.reallyGo = YES;
            frameVC.titleName = titleStr;
            frameVC.titleBgColor = @"#FFFFFF";  //白色
            frameVC.statusBarColor = @"#1B82D2";//@"#50D4F9";  //自定义颜色
            
              
             NSURL *url = [NSURL URLWithString:urlStr];
             frameVC.mWebViewUrl = url;
             frameVC.modalPresentationStyle = UIModalPresentationFullScreen;
             [self presentViewController:frameVC animated:YES completion:nil];
        }
        else if ([result[@"code"] integerValue] == 401)
        {
            IseeAlert(@"客户不属此工号管辖",NULL);
        }
        else
        {
            IseeAlert(result[@"msg"],NULL);
        }
    }
    failure:^{
        [wkSelf removeLoading];
    }];
}

#pragma mark - delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    pageNum = 0;
    if (searchCustAry) {
        [searchCustAry removeAllObjects];
        searchCustAry = nil;
    }
    if (searchProdAry) {
        [searchProdAry removeAllObjects];
        searchProdAry = nil;
    }
    search.isPullUp_refresh = YES;
    searchCustAry = [NSMutableArray array];
    searchProdAry = [NSMutableArray array];
    [self searchWIthText:textField.text];
    return YES;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [search removeTable];
    //实现该方法是需要注意view需要是继承UIControl而来的
}

#pragma mark - tableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_searchInt == 0) {
        return searchCustAry.count;
    }
    return searchProdAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_searchInt == 0) {
        if (!searchCustAry.count) {
            return [UITableViewCell new];
        }
        IseeCustCell *cell = [[IseeCustCell alloc]init];
        cell.selectedBackgroundView=[[UIView alloc]initWithFrame:cell.frame];
         cell.selectedBackgroundView.backgroundColor=[IseeConfig stringTOColor:@"#F4F6FB"];
        cell.model     = searchCustAry[indexPath.row];
        return cell;
    }
    else if (_searchInt == 1)
    {
        if (!searchProdAry.count)
        {
           return [UITableViewCell new];
        }
        IseeProdCell *cell = [[IseeProdCell alloc]init];
        cell.selectedBackgroundView=[[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor=[IseeConfig stringTOColor:@"#F4F6FB"];
        cell.model     = searchProdAry[indexPath.row];
        return cell;
    }
    return [UITableViewCell new];
    
}
- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath {

   [cell setSeparatorInset:UIEdgeInsetsZero];

    [cell setLayoutMargins:UIEdgeInsetsZero];

    cell.preservesSuperviewLayoutMargins = NO;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_searchInt == 0) {
        
//        IseeProdModel *tempModel = searchProdAry[indexPath.row];
//        [self findProdute:tempModel.servId withProductType:tempModel.productTypeId withText:tempModel.accNbr withModel:tempModel];
        
        IseeCustModel *tempModel = searchCustAry[indexPath.row];
        [self findVip:tempModel.ser_id withModel:tempModel];
    }
    else  if (_searchInt == 1) {
        IseeProdModel *tempModel = searchProdAry[indexPath.row];
        [self findProdute:tempModel.servId withProductType:tempModel.productTypeId withText:tempModel.accNbr withModel:tempModel];
    }
}



#pragma mark - scroll
// 开始
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    [search removeTable];
    [self.view endEditing:YES];
}


- (IseeHomeModel *)iseeHomeModel
{
    if (!iseeHomeModel)
    {
        iseeHomeModel = [[IseeHomeModel alloc]init];
    }
    return iseeHomeModel;
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
