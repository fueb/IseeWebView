//
//  IseeHomeViewController.m
//  IseeWebView
//
//  Created by 点芯在线 on 2020/8/6.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import "IseeHomeViewController.h"
#import "IseeHomeView.h"
#import "IseeConfig.h"
#import "IseeHomeModel.h"
#import "MBProgressHUD.h"
#import "IseeAFNetRequest.h"
#import "IseeWebViewController.h"
#import "IseeHomeTabBarModel.h"
#import "IseeCustModel.h"
#import "IseeCustCell.h"
#import "IseeProdModel.h"
#import "IseeProdCell.h"
#import "IseeSearchViewController.h"
#import "IseeLoadingView.h"

@interface IseeHomeViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    IseeHomeModel   *iseeHomeModel;
    IseeHomeTabBarModel   *iseeHomeTabBarModel;
    IseeHomeView *home;
    NSMutableArray *modelAry;
    NSInteger searchInt;
    NSMutableArray *searchCustAry;
    NSMutableArray *searchProdAry;
    BOOL isFirstOpen;
    IseeLoadingView *loading;
    
}
@property (nonatomic, strong)NSDictionary *loginDict;
@end

@implementation IseeHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isFirstOpen = YES;
    CGFloat safeBottom = 0;
    searchInt = 0;
    modelAry = [[NSMutableArray alloc] init];
    
    if ([IseeConfig isNotchScreen]) {
        safeBottom = 34;
    }
    home = [[IseeHomeView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight-(50+safeBottom))];
    if (safeBottom == 0)
    {
        home = [[IseeHomeView alloc] initWithFrame:CGRectMake(0, -20, UIScreenWidth, UIScreenHeight-(50+safeBottom)+20)];
    }
    
    
    home.mDelegate = self;
    
    [self.view addSubview:home];
//    [home setModel:modelAry];
    [self ssoLogin];
//    [self login];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    if (!isFirstOpen) {
        [self getMenu];
    }
    
    isFirstOpen = NO;
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


-(void)goSearch{
    IseeSearchViewController *vc = [[IseeSearchViewController alloc] init];
    vc.latnId = _latnId;
    vc.searchInt = searchInt;
    vc.mSession = _mSession;
    vc.mLoginName = _mLoginName;
    vc.mCompanyId = _mCompanyId;
    vc.mUserId = _mUserId;
    vc.mSaleNum = _mSaleNum;
    vc.areaId = _areaId;
    vc.mManagerId = _mManagerId;
    vc.requesetModel = _requesetModel;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}


#pragma -mark network
- (void)getData{
    [self getMenu];//菜单
    
//    [self getQuerySendOrder:@"1"];//宽带
//    [self getQuerySendOrder:@"4"];//欠费催缴
//    [self getQuerySendOrder:@"5"];//电路到期
//    [self getImporant];//重点关注
//    [self getManagerCustomLost];//波动
//    [self getMyBule];//我的蓝海
    
//    [home setTaskNum:@"28"];
//    [home setQuerySendOrder:@"33" withType:@"1"];
//    [home setQuerySendOrder:@"45" withType:@"4"];
//    [home setQuerySendOrder:@"127" withType:@"5"];
    
//    NSMutableDictionary *keyPointDict = [NSMutableDictionary dictionary];
//    [keyPointDict setObject:@"35291" forKey:@"boardBandNum"];
//    [keyPointDict setObject:@"23" forKey:@"boardBandChange"];
//    [keyPointDict setObject:@"88546" forKey:@"moveNum"];
//    [keyPointDict setObject:@"-23" forKey:@"moveChange"];
//    [keyPointDict setObject:@"15345" forKey:@"iptvNum"];
//    [keyPointDict setObject:@"23" forKey:@"iptvChange"];
//    [keyPointDict setObject:@"21291" forKey:@"shareNum"];
//    [keyPointDict setObject:@"-23" forKey:@"shareChange"];
//    [home setKeyPointDict:keyPointDict];
//
//    [home setFluWith:@"6" withVolume:@"6" withAssets:@"6"];
//
//    [home setMyBuleWith:@"7856" withVisitedNum:@"2865" withYearNum:@"3354" withMonthNum:@"765"];
    __weak typeof(IseeHomeViewController) *wkSelf = self;
    [home setMenuClick:^(NSInteger tag) {
        NSDictionary *tempMenuDict = [modelAry objectAtIndex:tag];
        NSLog(@"%@",tempMenuDict[@"moduleName"]);
        NSString *moduleName = tempMenuDict[@"moduleName"];
        NSString *methodName;
        if (moduleName.length<=0) {
            return;
        }
        
        if ([moduleName isEqualToString:@"联系人管理"]) {
            methodName = contactManagementWEBURL;
        }
        else if ([moduleName isEqualToString:@"装维工单"]) {
            methodName = InstallationWorkorderWEBURL;
        }
        else if ([moduleName isEqualToString:@"套餐使用量"]) {
            methodName = packageUsageWEBURL;
        }
        else if ([moduleName isEqualToString:@"套餐优惠"]) {
            methodName = packageOfferWEBURL;
        }
        else if ([moduleName isEqualToString:@"客户积分"]) {
            methodName = customerPointsWEBURL;
        }
        else if ([moduleName isEqualToString:@"虚拟网信息"]) {
            methodName = vpnInformationWEBURL;
        }
        else if ([moduleName isEqualToString:@"客户账单"]) {
            methodName = customerBillWEBURL;
        }
        else if ([moduleName isEqualToString:@"消费余额"]) {
            methodName = customerOverageWEBURL;
        }
        else if ([moduleName isEqualToString:@"用户欠费"]) {
            methodName = customerArrearsWEBURL;
        }
        else if ([moduleName isEqualToString:@"电子发票"]) {
            methodName = invoiceQueryWEBURL;
        }
        else if ([moduleName isEqualToString:@"缴费日志"]) {
            methodName = paymentLogWEBURL;
        }
        else if ([moduleName isEqualToString:@"联系人管理"]) {
            methodName = contactManagementWEBURL;
        }
        else if ([moduleName isEqualToString:@"政企视图"]) {
            methodName = enterpriseNewViewWEBURL;
        }
        else if ([moduleName isEqualToString:@"故障单"]) {
            methodName = MALFUCTIONQUERYWEBURL;
        }
        else if ([moduleName isEqualToString:@"投诉单"]) {
            methodName = COMPLAINTQUERYWEBURL;
        }
        else if ([moduleName isEqualToString:@"订单查询"]) {
            methodName = ORDERQUERYWEBURL;
        }
        else if ([moduleName isEqualToString:@"资产查询"]) {
            methodName = ASSETSQUERYWEBURL;
        }
        
        if ([moduleName isEqualToString:@"预受理"]||[moduleName isEqualToString:@"业务办理"]||[moduleName isEqualToString:@"受理助手"]||[moduleName isEqualToString:@"我的客户"]||[moduleName isEqualToString:@"销售助手"])
        {
            NSString *urlStr = [NSString stringWithFormat:@"zqhelper://account=%@&bundleid=%@",_requesetModel.mLoginName,[[NSBundle mainBundle] bundleIdentifier]];
            NSLog(@"销售助手url:%@",urlStr);
            
            NSURL *url = [NSURL URLWithString:urlStr];

            if ([[UIApplication sharedApplication] canOpenURL:url])
            {
                if(@available(iOS 10.0, *))
                {
                   [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success)
                    {
                     
                   }];
                }
                else
                {
                                   
                   [[UIApplication sharedApplication] openURL:url];
                                   
                                           
                }
           
            
            }else{
                NSLog(@"设备没有安装销售助手");
                IseeAlert(@"设备没有安装销售助手", nil);
            }
            return;
        }
         
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

        // 设置想要的格式，hh与HH的区别:分别表示12小时制,24小时制

        [formatter setDateFormat:@"YYYYMMdd"];

        NSDate *dateNow = [NSDate date];

        //把NSDate按formatter格式转成NSString

        NSString *currentTime = [formatter stringFromDate:dateNow];
        
        NSString *md5Str = [NSString stringWithFormat:@"%@%@ISEE%@",_requesetModel.mLoginName,_requesetModel.mCompanyId,currentTime];
        if ([moduleName isEqualToString:@"更多"]) {
            methodName = TOOLWEBURL;
            md5Str = [NSString stringWithFormat:@"%@%@ISEE%@",_requesetModel.mLoginName,_requesetModel.mCompanyId,currentTime];
        }
        
        NSString *md5Key = [IseeConfig md5:md5Str];
        NSString *urlStr = [NSString stringWithFormat:@"%@%@?loginName=%@&companyId=%@&md5key=%@&source=isee&form=app2",WEBHOST,methodName,_requesetModel.mLoginName,_requesetModel.mCompanyId,md5Key];
        if ([moduleName isEqualToString:@"联系人管理"]) {
            urlStr = [NSString stringWithFormat:@"%@%@?managerId=%@&latnId=%@&areaId=%@",WEBHOST,contactManagementWEBURL,_requesetModel.mManagerId,_requesetModel.latnId,_requesetModel.areaId];
//            urlStr = @"http://115.233.6.88:9090/custInfoApp/contactManagement/Index?managerId=120608&latnId=71&areaId=66363";
        }
        
        IseeWebViewController *frameVC = [[IseeWebViewController alloc] init];
        frameVC.mLoginName = _mLoginName;
        frameVC.mSession   = self.mSession;
        frameVC.mSaleNum   = self.mSaleNum;
        frameVC.mUserId    = self.mUserId;
        frameVC.titleHave = YES;
        frameVC.tabbarHave = NO;
        frameVC.isHomeGo = YES;
        frameVC.titleName = tempMenuDict[@"moduleName"];
        frameVC.titleBgColor = @"#FFFFFF";  //白色
        frameVC.statusBarColor = @"#1B82D2";//@"#50D4F9";  //自定义颜色
       
         
        NSURL *url = [NSURL URLWithString:urlStr];
        frameVC.mWebViewUrl = url;
        frameVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [wkSelf presentViewController:frameVC animated:YES completion:nil];
    }];
    
    //任务点击
    [home setVisitListClick:^(NSInteger type) {
        NSString *methodName;
        NSString *titleName;
        if (type == 1) {
            methodName = VISITLISTWEBURL;
            titleName = @"走访任务";
        }
        else if (type == 2)
        {
            methodName = WORKORDERWEBURL;
            titleName = @"欠费催缴";
            
        }
        else if (type == 3)
        {
            methodName = CIRCUITWEBURL;
            titleName = @"电路到期";
            
            
        }
        else if (type == 4)
        {
            methodName = BROADBANDWEBURL;
            titleName = @"宽带(专线)到期";
            
        }
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYYMMdd"];
        NSDate *dateNow = [NSDate date];
        NSString *currentTime = [formatter stringFromDate:dateNow];
        
        NSString *md5Str = [NSString stringWithFormat:@"%@%@ISEE%@",_requesetModel.mLoginName,_requesetModel.mCompanyId,currentTime];
        NSString *md5Key = [IseeConfig md5:md5Str];
        NSString *urlStr = [NSString stringWithFormat:@"%@%@?loginName=%@&companyId=%@&md5key=%@&source=isee&form=app2",WEBHOST,methodName,_requesetModel.mLoginName,_requesetModel.mCompanyId,md5Key];
        if (type != 1) {
            
            urlStr = [urlStr stringByAppendingFormat:@"&managerId=%@&latnId=%@",_requesetModel.mManagerId,_requesetModel.latnId];
        }
        
        IseeWebViewController *frameVC = [[IseeWebViewController alloc] init];
        frameVC.mLoginName = _mLoginName;
        frameVC.mSession   = self.mSession;
        frameVC.mSaleNum   = self.mSaleNum;
        frameVC.mUserId    = self.mUserId;
       frameVC.titleHave = YES;
       frameVC.tabbarHave = NO;
        frameVC.isHomeGo = YES;
       frameVC.titleName = titleName;
       frameVC.titleBgColor = @"#FFFFFF";  //白色
       frameVC.statusBarColor = @"#1B82D2";//@"#50D4F9";  //自定义颜色
      
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
       NSURL *url = [NSURL URLWithString:urlStr];
        
//        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"test" ofType:@"html" inDirectory:@"www"];
//       url = [NSURL fileURLWithPath:filePath];
        
       frameVC.mWebViewUrl = url;
       frameVC.modalPresentationStyle = UIModalPresentationFullScreen;
       [wkSelf presentViewController:frameVC animated:YES completion:nil];
    }];
    
    //波动
    [home setFluClick:^(NSInteger type) {
        NSString *methodName = FLUWEBURL;
        NSString *titleName;
        NSInteger intType;
        if (type == 1) {
            intType = 1;
            titleName = @"收入波动";
        }
        else if (type == 2)
        {
            intType = 3;
            titleName = @"话务量波动";
        }
        else if (type == 3)
        {
            intType = 2;
            titleName = @"资产波动";
        }
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYYMMdd"];
        NSDate *dateNow = [NSDate date];
        NSString *currentTime = [formatter stringFromDate:dateNow];
        
        NSString *md5Str = [NSString stringWithFormat:@"%@%@ISEE%@",_mLoginName,_mCompanyId,currentTime];
        NSString *md5Key = [IseeConfig md5:md5Str];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@%@?loginName=%@&companyId=%@&md5key=%@&source=isee&form=app2&type=%d",WEBHOST,methodName,_mLoginName,_mCompanyId,md5Key,intType];
        
        
        IseeWebViewController *frameVC = [[IseeWebViewController alloc] init];
        frameVC.mLoginName = _mLoginName;
        frameVC.mSession   = self.mSession;
        frameVC.mSaleNum   = self.mSaleNum;
        frameVC.mUserId    = self.mUserId;
         frameVC.titleHave = YES;
          frameVC.tabbarHave = NO;
        frameVC.isHomeGo = YES;
         frameVC.titleName = titleName;
         frameVC.titleBgColor = @"#FFFFFF";  //白色
         frameVC.statusBarColor = @"#1B82D2";//@"#50D4F9";  //自定义颜色
        
          
         NSURL *url = [NSURL URLWithString:urlStr];
         frameVC.mWebViewUrl = url;
         frameVC.modalPresentationStyle = UIModalPresentationFullScreen;
         [wkSelf presentViewController:frameVC animated:YES completion:nil];
    }];
    
    //查询类型
    [home setSearchItemClick:^(NSInteger type) {
        searchInt = type;
        if (searchInt == 0)
        {
            [searchProdAry removeAllObjects];
        }
        else if (searchInt == 1)
        {
             [searchCustAry removeAllObjects];
        }
        [home reloadTable];
    }];
}

- (void)ssoLogin{
    [self showLoading];
    
    __weak typeof(self) wkSelf = self;
    [self.iseeHomeTabBarModel isee_ssoLoginWith:_requesetModel.mLoginName withCompanyId:_requesetModel.mCompanyId withStaffCode:_requesetModel.mStaffCode withManagerId:_requesetModel.mManagerId
    withManagerTypeId:@"220"  Success:^(id  _Nonnull result) {
        NSLog(@"%@", result);
        [wkSelf removeLoading];
        if ([result[@"code"] integerValue] == 200)
        {
            NSDictionary *data = result[@"data"];
            NSMutableDictionary *tempLoginDict = [[NSMutableDictionary alloc] initWithDictionary:data];
            [tempLoginDict setObject:self.mUserId forKey:@"userId"];
            [tempLoginDict setObject:self.mSaleNum forKey:@"saleNum"];
            NSData *resultData = [NSJSONSerialization dataWithJSONObject:tempLoginDict options:NSJSONWritingPrettyPrinted error:nil];
            NSString *loginStr = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:loginStr forKey:@"IseeWebSsoLoginJson"];
            
            [userDefault synchronize];
            self.loginDict = [NSDictionary dictionaryWithDictionary:data];
            NSDictionary *currentManagerTm = data[@"currentManagerTm"];
            long tempMangerId = [currentManagerTm[@"managerId"] longValue];
            NSString *tempCode = currentManagerTm[@"staffCode"];
            _mManagerId = [NSString stringWithFormat:@"%ld",tempMangerId];
            _mStaffCode = [NSString stringWithFormat:@"%@",tempCode];
            if (_mManagerId.length>0) {
                [self login];
            }
            else
            {
                IseeAlert(@"单点登录失败",NULL);
            }
            
        }
        else
        {
             IseeAlert(result[@"msg"],NULL);
        }
    } failure:^{
        [wkSelf removeLoading];
    }];
    
}

- (void)login{
    
    [self showLoading];
    
    __weak typeof(self) wkSelf = self;
    [self.iseeHomeTabBarModel isee_loginWith:_requesetModel.mManagerId withStaffCode:_requesetModel.mStaffCode Success:^(id  _Nonnull result) {
        NSLog(@"%@", result);
        [wkSelf removeLoading];
        if ([result[@"code"] integerValue] == 200)
        {
            NSDictionary *data = result[@"data"];
            
            NSDictionary *currentManagerTm = data[@"currentManagerTm"];
            _areaId = (NSString * )currentManagerTm[@"areaId"];
            _latnId = (NSString * )currentManagerTm[@"latnId"];
            _mLoginName = (NSString *)currentManagerTm[@"relaMobile"];
            
           
            [self getData];
        }
        else
        {
             IseeAlert(result[@"msg"],NULL);
        }
    } failure:^{
    //        [home setModel:modelAry];
        [wkSelf removeLoading];
    }];

    
        
        
    
}


- (void)getMenu
{
    [self showLoading];
    
    __weak typeof(self) wkSelf = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:_requesetModel.mManagerId forKey:@"managerId"];
    [param setObject:_requesetModel.mStaffCode forKey:@"staffCode"];
    [self.iseeHomeModel isee_homeMenuWith:param Success:^(id  _Nonnull result) {
        NSLog(@"%@", result);
        [wkSelf removeLoading];
        if ([result[@"code"] integerValue] == 200)
        {
            NSDictionary *data = result[@"data"];
            NSArray *all = data[@"all"];
            NSArray *define = data[@"define"];
            
            if (modelAry.count > 0) {
                [modelAry removeAllObjects];
            }
//            [modelAry addObjectsFromArray:all];
            [modelAry addObjectsFromArray:define];
            NSMutableDictionary *moreDict = [NSMutableDictionary dictionary];
            [moreDict setObject:@"10" forKey:@"orderId"];
            [moreDict setObject:@"more" forKey:@"icon"];
            [moreDict setObject:@"更多" forKey:@"moduleName"];
            [moreDict setObject:@"2" forKey:@"sumModuleId"];
            [moreDict setObject:@"-1" forKey:@"moduleId"];
            [modelAry addObject:moreDict];
            
            [home setModel:modelAry];
            [self getTask];//走访任务
            [self getQuerySendOrder:@"1"];
//            [self getQuerySendOrder:@"4"];
//            [self getQuerySendOrder:@"5"];
            [self getImporant];
            [self getManagerCustomLost];//波动
            [self getMyBule];
        }
        else
        {
            NSLog(@"%@",result[@"errmsg"], nil);
        }
    } failure:^{
        [wkSelf removeLoading];
//        [home setModel:modelAry];
    }];
    
    
}
- (void)getTask{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:_requesetModel.mManagerId forKey:@"managerId"];
    [param setObject:_requesetModel.mStaffCode forKey:@"staffCode"];
    [param setObject:_requesetModel.latnId forKey:@"latnId"];
    [param setObject:_requesetModel.areaId forKey:@"areaId"];
    [param setObject:@7 forKey:@"statId"];
    
     [self showLoading];
    
    __weak typeof(self) wkSelf = self;
    [self.iseeHomeModel isee_myTaskWithParam:param WithSuccess:^(id  _Nonnull result) {
        [wkSelf removeLoading];
        NSLog(@"%@", result);
        if ([result[@"code"] integerValue] == 200)
        {
            NSDictionary *data = result[@"data"];
            NSLog(@"getTask:%@",[data description]);
//            NSString * tempValue6 = [IseeConfig getLongValue:data[@"value6"]];//[data[@"value6"] longValue];
            NSString *taskNum = [IseeConfig getLongValue:data[@"value6"]];//[NSString stringWithFormat:@"%ld",tempValue6];
            if (taskNum != nil&&(![taskNum isKindOfClass:[NSNull class]])) {
                [home setTaskNum:taskNum];
            }
            
        }
        else
        {
            NSLog(@"%@",result[@"errmsg"], nil);
        }
    } failure:^{
        [wkSelf removeLoading];
        
    }];
}

- (void)getQuerySendOrder:(NSString *)type{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:_requesetModel.mManagerId forKey:@"managerId"];
    [param setObject:_requesetModel.mStaffCode forKey:@"staffCode"];
    [param setObject:_requesetModel.latnId forKey:@"latnId"];
     
    
    [self showLoading];
    
    __weak typeof(self) wkSelf = self;
    [self.iseeHomeModel isee_querySendOrderWithParam:param WithSuccess:^(id  _Nonnull result) {
        NSLog(@"%@", result);
        [wkSelf removeLoading];
        if ([result[@"code"] integerValue] == 200)
        {
            NSDictionary *data = result[@"data"];
//            long kdCount = [IseeConfig getLongValue:data[@"kdCount"]];//[data[@"kdCount"] longValue];
//            long qfCount = [IseeConfig getLongValue:data[@"qfCount"]];//[data[@"qfCount"] longValue];
//            long dlCount = [IseeConfig getLongValue:data[@"dlCount"]];//[data[@"dlCount"] longValue];

            
            [home setQuerySendOrder:[IseeConfig getLongValue:data[@"kdCount"]] withType:@"1"];
            [home setQuerySendOrder:[IseeConfig getLongValue:data[@"qfCount"]] withType:@"4"];
            [home setQuerySendOrder:[IseeConfig getLongValue:data[@"dlCount"]] withType:@"5"];
            
        }
        else
        {
            NSLog(@"%@",result[@"errmsg"], nil);
        }
    } failure:^{
        [wkSelf removeLoading];
    }];
}

- (void)getImporant{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:_requesetModel.mManagerId forKey:@"managerId"];
    [param setObject:_requesetModel.mStaffCode forKey:@"staffCode"];
    [param setObject:_requesetModel.latnId forKey:@"latnId"];
    [param setObject:_requesetModel.areaId forKey:@"areaId"];
    [param setObject:@6 forKey:@"statId"];
    
     [self showLoading];
    
    __weak typeof(self) wkSelf = self;
    [self.iseeHomeModel isee_custInfoWithParam:param WithSuccess:^(id  _Nonnull result) {
        [wkSelf removeLoading];
        NSLog(@"getImporant:%@", result);
        if ([result[@"code"] integerValue] == 200)
        {
            NSDictionary *data = result[@"data"];
//            long baordBandSum = [IseeConfig getLongValue:data[@"value1"]];//[data[@"value1"] longValue];
//            long baordBandAdd = [IseeConfig getLongValue:data[@"value2"]];//[data[@"value2"] longValue];
//            long moveSum = [IseeConfig getLongValue:data[@"value3"]];//[data[@"value3"] longValue];
//            long moveAdd = [IseeConfig getLongValue:data[@"value4"]];//[data[@"value4"] longValue];
//            long iptvSum = [IseeConfig getLongValue:data[@"value5"]];//[data[@"value5"] longValue];
//            long iptvAdd = [IseeConfig getLongValue:data[@"value6"]];//[data[@"value6"] longValue];
//            long shareSum = [IseeConfig getLongValue:data[@"value7"]];//[data[@"value7"] longValue];
//            long shareAdd = [IseeConfig getLongValue:data[@"value8"]];//[data[@"value8"] longValue];

            NSMutableDictionary *keyPointDict = [NSMutableDictionary dictionary];
            [keyPointDict setObject:[IseeConfig getLongValue:data[@"value1"]] forKey:@"boardBandNum"];
            [keyPointDict setObject:[IseeConfig getLongValue:data[@"value2"]] forKey:@"boardBandChange"];
            [keyPointDict setObject:[IseeConfig getLongValue:data[@"value3"]] forKey:@"moveNum"];
            [keyPointDict setObject:[IseeConfig getLongValue:data[@"value4"]] forKey:@"moveChange"];
            [keyPointDict setObject:[IseeConfig getLongValue:data[@"value5"]] forKey:@"iptvNum"];
            [keyPointDict setObject:[IseeConfig getLongValue:data[@"value6"]] forKey:@"iptvChange"];
            [keyPointDict setObject:[IseeConfig getLongValue:data[@"value7"]] forKey:@"shareNum"];
            [keyPointDict setObject:[IseeConfig getLongValue:data[@"value8"]] forKey:@"shareChange"];
            [home setKeyPointDict:keyPointDict];
            
        }
        else
        {
            NSLog(@"%@",result[@"errmsg"], nil);
        }
    } failure:^{
        [wkSelf removeLoading];
    }];
}


- (void)getManagerCustomLost{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:_requesetModel.mManagerId forKey:@"managerId"];
    [param setObject:_requesetModel.mStaffCode forKey:@"staffCode"];
    [param setObject:_requesetModel.latnId forKey:@"latnId"];
    [param setObject:_requesetModel.areaId forKey:@"areaId"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    [formatter setDateFormat:@"YYYYMM"];
    NSDate *dateNow = [NSDate date];
    NSString *currentTime = [formatter stringFromDate:dateNow];
    
    [param setObject:currentTime forKey:@"statCycleId"];
    
     [self showLoading];
    
    __weak typeof(self) wkSelf = self;
    [self.iseeHomeModel isee_managerCustomLostWithParam:param WithSuccess:^(id  _Nonnull result) {
        [wkSelf removeLoading];
        NSLog(@"%@", result);
        if ([result[@"code"] integerValue] == 200)
        {
            NSDictionary *data = result[@"data"];
//            long chargeCount = [IseeConfig getLongValue:data[@"chargeCount"]];//[data[@"chargeCount"] longValue];
//            long assetsCount = [IseeConfig getLongValue:data[@"assetsCount"]];//[data[@"assetsCount"] longValue];
//            long teletrafficCount = [IseeConfig getLongValue:data[@"teletrafficCount"]];//[data[@"teletrafficCount"] longValue];
            [home setFluWith:[IseeConfig getLongValue:data[@"chargeCount"]] withVolume:[IseeConfig getLongValue:data[@"teletrafficCount"]] withAssets:[IseeConfig getLongValue:data[@"assetsCount"]]];
            
        }
        else
        {
            NSLog(@"%@",result[@"errmsg"], nil);
        }
    } failure:^{
        [wkSelf removeLoading];
    }];
}

- (void)getMyBule{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:_requesetModel.mManagerId forKey:@"managerId"];
    [param setObject:_requesetModel.mStaffCode forKey:@"staffCode"];
    [param setObject:_requesetModel.latnId forKey:@"latnId"];
    [param setObject:_requesetModel.areaId forKey:@"areaId"];
//    [param setObject:@123 forKey:@"source"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMM"];
    NSDate *dateNow = [NSDate date];
    NSString *currentTime = [formatter stringFromDate:dateNow];
    [param setObject:currentTime forKey:@"statCycleId"];
    

    
     [self showLoading];
    
    __weak typeof(self) wkSelf = self;
    [self.iseeHomeModel isee_getBlueCustMsgWithParam:param WithSuccess:^(id  _Nonnull result) {
        [wkSelf removeLoading];
        NSLog(@"%@", result);
        if ([result[@"code"] integerValue] == 200)
        {
            NSDictionary *data = result[@"data"];
//            long blueOceanCnt = [IseeConfig getLongValue:data[@"blueOceanCnt"]];//[data[@"blueOceanCnt"] longValue];
//            long interviewCnt = [IseeConfig getLongValue:data[@"interviewCnt"]];//[data[@"interviewCnt"] longValue];
//            long newCntYear = [IseeConfig getLongValue:data[@"newCntYear"]];//[data[@"newCntYear"] longValue];
//            long newCntMonth = [IseeConfig getLongValue:data[@"newCntMonth"]];//[data[@"newCntMonth"] longValue];
            
            [home setMyBuleWith:[IseeConfig getLongValue:data[@"blueOceanCnt"]] withVisitedNum:[IseeConfig getLongValue:data[@"interviewCnt"]] withYearNum:[IseeConfig getLongValue:data[@"newCntYear"]] withMonthNum:[IseeConfig getLongValue:data[@"newCntMonth"]]];
        }
        else
        {
            NSLog(@"%@",result[@"errmsg"], nil);
        }
    } failure:^{
        [wkSelf removeLoading];
    }];
}

- (void)searchWIthText:(NSString *)text{
    if (text.length <= 0) {
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:text forKey:@"text"];
    [param setObject:_requesetModel.mManagerId forKey:@"managerId"];
    [param setObject:_requesetModel.mStaffCode forKey:@"staffCode"];
    
    [self showLoading];
    
    __weak typeof(self) wkSelf = self;
    if (searchInt == 0) {
        [param setObject:_requesetModel.latnId forKey:@"latnId"];
        [self.iseeHomeModel isee_findCustMsgWithParam:param WithSuccess:^(id  _Nonnull result) {
            [wkSelf removeLoading];
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
                [home reloadTable];
            }
            else
            {
                 IseeAlert(result[@"msg"],NULL);
            }
        } failure:^{
            [wkSelf removeLoading];
        }];
    }
    else if (searchInt == 1)
    {
        [self.iseeHomeModel isee_findProdWithParam:param WithSuccess:^(id  _Nonnull result) {
            [wkSelf removeLoading];
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
                [home reloadTable];
            }
            else
            {
                IseeAlert(result[@"msg"],NULL);
            }
        } failure:^{
            [wkSelf removeLoading];
        }];
    }
    
}

- (void)findProdute:(NSString *)servId withProductType:(NSString *)productType withText:(NSString *)text withModel:(IseeProdModel *)tempModel
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:text forKey:@"text"];
    [param setObject:productType forKey:@"productType"];
    [param setObject:servId forKey:@"servId"];
    [param setObject:_requesetModel.mManagerId forKey:@"managerId"];
    [param setObject:_requesetModel.mStaffCode forKey:@"staffCode"];
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
             
             NSString *md5Str = [NSString stringWithFormat:@"%@%@ISEE%@",_mLoginName,_mCompanyId,currentTime];
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
        [wkSelf removeLoading];
    }];
}

#pragma mark -init

- (IseeHomeModel *)iseeHomeModel
{
    if (!iseeHomeModel)
    {
        iseeHomeModel = [[IseeHomeModel alloc]init];
    }
    return iseeHomeModel;
}
- (IseeHomeTabBarModel *)iseeHomeTabBarModel
{
    if (!iseeHomeTabBarModel)
    {
        iseeHomeTabBarModel = [[IseeHomeTabBarModel alloc]init];
    }
    return iseeHomeTabBarModel;
}
#pragma mark - delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (searchInt == 2)
    {
        return NO;
    }
    [self goSearch];
    return NO;

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [home removeTable];
    //实现该方法是需要注意view需要是继承UIControl而来的
}

#pragma mark - tableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (searchInt == 0) {
        return searchCustAry.count;
    }
    return searchProdAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (searchInt == 0) {
        if (!searchCustAry.count) {
            return [UITableViewCell new];
        }
        IseeCustCell *cell = [[IseeCustCell alloc]init];
        cell.model     = searchCustAry[indexPath.row];
        return cell;
    }
    else if (searchInt == 1)
    {
        if (!searchProdAry.count)
        {
           return [UITableViewCell new];
        }
        IseeProdCell *cell = [[IseeProdCell alloc]init];
        cell.model     = searchProdAry[indexPath.row];
        return cell;
    }
    return [UITableViewCell new];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (searchInt == 0) {
        IseeCustModel *tempModel = searchCustAry[indexPath.row];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

         // 设置想要的格式，hh与HH的区别:分别表示12小时制,24小时制

         [formatter setDateFormat:@"YYYYMMdd"];

         NSDate *dateNow = [NSDate date];

         //把NSDate按formatter格式转成NSString

         NSString *currentTime = [formatter stringFromDate:dateNow];
         
         NSString *md5Str = [NSString stringWithFormat:@"%@%@ISEE%@",_mLoginName,_mCompanyId,currentTime];
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
         frameVC.titleName = @"政企视图";
         frameVC.titleBgColor = @"#FFFFFF";  //白色
         frameVC.statusBarColor = @"#1B82D2";//@"#50D4F9";  //自定义颜色
        
          
         NSURL *url = [NSURL URLWithString:urlStr];
         frameVC.mWebViewUrl = url;
         frameVC.modalPresentationStyle = UIModalPresentationFullScreen;
         [self presentViewController:frameVC animated:YES completion:nil];
    }
    else  if (searchInt == 1) {
        IseeProdModel *tempModel = searchProdAry[indexPath.row];
        [self findProdute:tempModel.servId withProductType:tempModel.productType withText:tempModel.accNbr withModel:tempModel];
    }
}

#pragma mark - scroll
// 开始
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [home removeTable];
    [self.view endEditing:YES];
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
