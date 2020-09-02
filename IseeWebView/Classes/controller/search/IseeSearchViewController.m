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
#import "IseeConfig.h"
#import "IseeHomeModel.h"
#import "IseeWebViewController.h"

@interface IseeSearchViewController ()
{
    IseeSearchView *search;
    IseeHomeModel   *iseeHomeModel;
    NSMutableArray *modelAry;
    
    NSMutableArray *searchCustAry;
    NSMutableArray *searchProdAry;
}
@end

@implementation IseeSearchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    modelAry = [[NSMutableArray alloc] init];
    CGFloat safeBottom = 0;
    if ([IseeConfig isNotchScreen]) {
        safeBottom = 34;
    }
    search = [[IseeSearchView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
    
    search.mDelegate = self;
    
    [self.view addSubview:search];
    [search setModel:modelAry];
    [self setClick];
    // Do any additional setup after loading the view.
}

- (void)setClick{
    [search setCancelClick:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}


- (void)searchWIthText:(NSString *)text{
    if (text.length <= 0) {
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:text forKey:@"text"];
    [IseeAFNetRequest showHUD:self.view];
    if (_searchInt == 0) {
        [param setObject:_latnId forKey:@"latnId"];
        [self.iseeHomeModel isee_findCustMsgWithParam:param WithSuccess:^(id  _Nonnull result) {
            if ([result[@"code"] integerValue] == 200)
            {
                NSArray *data = result[@"data"];
                searchCustAry = [NSMutableArray array];
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
        } failure:^{
            
        }];
    }
    else if (_searchInt == 1)
    {
        [self.iseeHomeModel isee_findProdWithParam:param WithSuccess:^(id  _Nonnull result) {
            if ([result[@"code"] integerValue] == 200)
            {
                NSArray *data = result[@"data"];
                searchProdAry = [NSMutableArray array];
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
        } failure:^{
            
        }];
    }
    
}


- (void)findProdute:(NSString *)servId withProductType:(NSString *)productType withText:(NSString *)text withModel:(IseeProdModel *)tempModel
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:text forKey:@"text"];
    [param setObject:productType forKey:@"productType"];
    [param setObject:servId forKey:@"servId"];
    [IseeAFNetRequest showHUD:self.view];
    [self.iseeHomeModel isee_findProductWithParam:param WithSuccess:^(id  _Nonnull result) {
        if ([result[@"code"] integerValue] == 200)
        {
            NSDictionary *data = result[@"data"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

             // 设置想要的格式，hh与HH的区别:分别表示12小时制,24小时制

             [formatter setDateFormat:@"YYYYMMdd"];

             NSDate *dateNow = [NSDate date];

             //把NSDate按formatter格式转成NSString

             NSString *currentTime = [formatter stringFromDate:dateNow];
             
             NSString *md5Str = [NSString stringWithFormat:@"%@%@isee%@",_mLoginName,_mCompanyId,currentTime];
             NSString *md5Key = [IseeConfig md5:md5Str];
            NSString *urlStr;
            urlStr = [NSString stringWithFormat:@"%@%@?accNbr=%@&latnId=%@&servId=%@&custId=%@&crmCustId=%@&loginName=%@&companyId=%@&md5key=%@&source=isee&form=app2",WEBHOST,integratedQueryWEBURL,tempModel.accNbr,tempModel.latnId,tempModel.servId,data[@"custId"],tempModel.crmCustId,_mLoginName,_mCompanyId,md5Key];
             
             
             IseeWebViewController *frameVC = [[IseeWebViewController alloc] init];
            frameVC.mLoginName = _mLoginName;
            frameVC.mSession   = self.mSession;
            frameVC.mSaleNum   = self.mSaleNum;
            frameVC.mUserId    = self.mUserId;
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
        
    }];
}

#pragma mark - delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
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
    return 55;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_searchInt == 0) {
        IseeCustModel *tempModel = searchCustAry[indexPath.row];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

         // 设置想要的格式，hh与HH的区别:分别表示12小时制,24小时制

         [formatter setDateFormat:@"YYYYMMdd"];

         NSDate *dateNow = [NSDate date];

         //把NSDate按formatter格式转成NSString

         NSString *currentTime = [formatter stringFromDate:dateNow];
         
         NSString *md5Str = [NSString stringWithFormat:@"%@%@isee%@",_mLoginName,_mCompanyId,currentTime];
         NSString *md5Key = [IseeConfig md5:md5Str];
        NSString *urlStr;
        urlStr = [NSString stringWithFormat:@"%@%@?vipCard=%@&latnId=%@&loginName=%@&companyId=%@&md5key=%@&source=isee&form=app2",WEBHOST,enterpriseNewViewWEBURL,tempModel.ser_id,tempModel.latn_id,_mLoginName,_mCompanyId,md5Key];
         
        if ([tempModel.id_type_name isEqualToString:@"他网"]||[tempModel.id_type_name isEqualToString:@"蓝海"]) {
            
        }
        else if ((![tempModel.id_type_name isEqualToString:@"他网"])&&(![tempModel.id_type_name isEqualToString:@"蓝海"])&&(![tempModel.id_type_name isEqualToString:@"本网"]))
        {
            
        }
         
        IseeWebViewController *frameVC = [[IseeWebViewController alloc] init];
        frameVC.mLoginName = _mLoginName;
        frameVC.mSession   = self.mSession;
        frameVC.mSaleNum   = self.mSaleNum;
        frameVC.mUserId    = self.mUserId;
        frameVC.titleHave = YES;
        frameVC.tabbarHave = NO;
        frameVC.isHomeGo = YES;
        frameVC.reallyGo = YES;
        frameVC.titleName = @"政企视图";
        frameVC.titleBgColor = @"#FFFFFF";  //白色
        frameVC.statusBarColor = @"#1B82D2";//@"#50D4F9";  //自定义颜色
        
          
         NSURL *url = [NSURL URLWithString:urlStr];
         frameVC.mWebViewUrl = url;
         frameVC.modalPresentationStyle = UIModalPresentationFullScreen;
         [self presentViewController:frameVC animated:YES completion:nil];
    }
    else  if (_searchInt == 1) {
        IseeProdModel *tempModel = searchProdAry[indexPath.row];
        [self findProdute:tempModel.servId withProductType:tempModel.productType withText:tempModel.accNbr withModel:tempModel];
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
