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


@interface IseeHomeViewController ()<UITextFieldDelegate>{
    IseeHomeModel   *iseeHomeModel;
    IseeHomeTabBarModel   *iseeHomeTabBarModel;
    IseeHomeView *home;
    NSMutableArray *modelAry;
}

@end

@implementation IseeHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat safeBottom = 0;
    modelAry = [[NSMutableArray alloc] init];
    
    if ([IseeConfig isNotchScreen]) {
        safeBottom = 34;
    }
    home = [[IseeHomeView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight-(50+safeBottom))];
    
    home.mDelegate = self;
    
    [self.view addSubview:home];
//    [home setModel:modelAry];
    [self login];
    
    // Do any additional setup after loading the view.
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
    
    NSMutableDictionary *keyPointDict = [NSMutableDictionary dictionary];
    [keyPointDict setObject:@"35291" forKey:@"boardBandNum"];
    [keyPointDict setObject:@"23" forKey:@"boardBandChange"];
    [keyPointDict setObject:@"88546" forKey:@"moveNum"];
    [keyPointDict setObject:@"-23" forKey:@"moveChange"];
    [keyPointDict setObject:@"15345" forKey:@"iptvNum"];
    [keyPointDict setObject:@"23" forKey:@"iptvChange"];
    [keyPointDict setObject:@"21291" forKey:@"shareNum"];
    [keyPointDict setObject:@"-23" forKey:@"shareChange"];
//    [home setKeyPointDict:keyPointDict];
//
//    [home setFluWith:@"6" withVolume:@"6" withAssets:@"6"];
//
//    [home setMyBuleWith:@"7856" withVisitedNum:@"2865" withYearNum:@"3354" withMonthNum:@"765"];
    __weak typeof(IseeHomeViewController) *wkSelf = self;
    [home setMenuClick:^(NSInteger tag) {
        NSDictionary *tempMenuDict = [modelAry objectAtIndex:tag];
        NSLog(@"%@",tempMenuDict[@"moduleName"]);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

        // 设置想要的格式，hh与HH的区别:分别表示12小时制,24小时制

        [formatter setDateFormat:@"YYYYMMdd"];

        NSDate *dateNow = [NSDate date];

        //把NSDate按formatter格式转成NSString

        NSString *currentTime = [formatter stringFromDate:dateNow];
        
        NSString *md5Str = [NSString stringWithFormat:@"%@%@isee%@",_mLoginName,_mCompanyId,currentTime];
        NSString *md5Key = [IseeConfig md5:md5Str];
        NSString *urlStr = [NSString stringWithFormat:@"%@?loginName=%@&companyId=%@&md5key=%@&source=isee",WEBHOST,_mLoginName,_mCompanyId,md5Key];
        
        IseeWebViewController *frameVC = [[IseeWebViewController alloc] init];
        frameVC.titleHave = YES;
        frameVC.tabbarHave = NO;
        frameVC.titleName = tempMenuDict[@"moduleName"];
        frameVC.titleBgColor = @"#FFFFFF";  //白色
        frameVC.statusBarColor = @"#3086E8";//@"#50D4F9";  //自定义颜色
       
         
        NSURL *url = [NSURL URLWithString:urlStr];
        frameVC.mWebViewUrl = url;
        frameVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [wkSelf presentViewController:frameVC animated:YES completion:nil];
    }];
    
    //任务点击
    [home setVisitListClick:^(NSInteger type) {
        NSString *urlStr;// = [NSString stringWithFormat:@"%@?loginName=%@&companyId=%@&md5key=%@&source=isee",WEBHOST,_mLoginName,_mCompanyId,md5Key];
        NSString *titleName;
        if (type == 1) {
            urlStr = VISITLISTWEBURL;
            titleName = @"走访任务";
        }
        else if (type == 2)
        {
            urlStr = @"http://115.233.6.88:9090/custInfoApp/visitList?loginName=15306735610&companyId=221077&md5key=162a99d33535d11e0b09e74dfe2a6220&source=isee";
            titleName = @"欠费催缴";
        }
        else if (type == 3)
        {
            urlStr = @"http://115.233.6.88:9090/custInfoApp/visitList?loginName=15306735610&companyId=221077&md5key=162a99d33535d11e0b09e74dfe2a6220&source=isee";
            titleName = @"电路到期";
        }
        else if (type == 4)
        {
            urlStr = @"http://115.233.6.88:9090/custInfoApp/visitList?loginName=15306735610&companyId=221077&md5key=162a99d33535d11e0b09e74dfe2a6220&source=isee";
            titleName = @"宽带(专线)到期";
        }
        IseeWebViewController *frameVC = [[IseeWebViewController alloc] init];
       frameVC.titleHave = YES;
        frameVC.tabbarHave = NO;
       frameVC.titleName = titleName;
       frameVC.titleBgColor = @"#FFFFFF";  //白色
       frameVC.statusBarColor = @"#3086E8";//@"#50D4F9";  //自定义颜色
      
        
       NSURL *url = [NSURL URLWithString:urlStr];
       frameVC.mWebViewUrl = url;
       frameVC.modalPresentationStyle = UIModalPresentationFullScreen;
       [wkSelf presentViewController:frameVC animated:YES completion:nil];
    }];
    
    //波动
    [home setFluClick:^(NSInteger type) {
        
        NSString *urlStr;// = [NSString stringWithFormat:@"%@?loginName=%@&companyId=%@&md5key=%@&source=isee",WEBHOST,_mLoginName,_mCompanyId,md5Key];
        NSString *titleName;
        if (type == 1) {
            urlStr = VISITLISTWEBURL;
            titleName = @"收入波动";
        }
        else if (type == 2)
        {
            urlStr = @"http://115.233.6.88:9090/custInfoApp/visitList?loginName=15306735610&companyId=221077&md5key=162a99d33535d11e0b09e74dfe2a6220&source=isee";
            titleName = @"话务量波动";
        }
        else if (type == 3)
        {
            urlStr = @"http://115.233.6.88:9090/custInfoApp/visitList?loginName=15306735610&companyId=221077&md5key=162a99d33535d11e0b09e74dfe2a6220&source=isee";
            titleName = @"资产波动";
        }
        
        
        IseeWebViewController *frameVC = [[IseeWebViewController alloc] init];
         frameVC.titleHave = YES;
          frameVC.tabbarHave = NO;
         frameVC.titleName = titleName;
         frameVC.titleBgColor = @"#FFFFFF";  //白色
         frameVC.statusBarColor = @"#3086E8";//@"#50D4F9";  //自定义颜色
        
          
         NSURL *url = [NSURL URLWithString:urlStr];
         frameVC.mWebViewUrl = url;
         frameVC.modalPresentationStyle = UIModalPresentationFullScreen;
         [wkSelf presentViewController:frameVC animated:YES completion:nil];
    }];
    
}


- (void)login{
    
    [IseeAFNetRequest showHUD:self.view];
    [self.iseeHomeTabBarModel isee_loginWith:_mManagerId withStaffCode:_mStaffCode Success:^(id  _Nonnull result) {
        NSLog(@"%@", result);
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
            NSLog(@"%@",result[@"errmsg"], nil);
        }
    } failure:^{
    //        [home setModel:modelAry];
    }];

    
        
        
    
}

//验证码点击切换
- (void)getMenu
{
    [IseeAFNetRequest showHUD:self.view];
    [self.iseeHomeModel isee_homeMenuWith:self.mManagerId Success:^(id  _Nonnull result) {
        NSLog(@"%@", result);
        if ([result[@"code"] integerValue] == 200)
        {
            NSDictionary *data = result[@"data"];
            NSArray *all = data[@"all"];
            NSArray *define = data[@"define"];
            
            
//            [modelAry addObjectsFromArray:all];
            [modelAry addObjectsFromArray:define];
            [home setModel:modelAry];
            [self getTask];//走访任务
            [self getQuerySendOrder:@"1"];
            [self getQuerySendOrder:@"4"];
            [self getQuerySendOrder:@"5"];
            [self getImporant];
            [self getManagerCustomLost];//波动
            [self getMyBule];
        }
        else
        {
            NSLog(@"%@",result[@"errmsg"], nil);
        }
    } failure:^{
//        [home setModel:modelAry];
    }];
    
    
}
- (void)getTask{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:_mManagerId forKey:@"managerId"];
    [param setObject:_latnId forKey:@"latnId"];
    [param setObject:_areaId forKey:@"areaId"];
    [param setObject:@7 forKey:@"statId"];
    
     [IseeAFNetRequest showHUD:self.view];
    [self.iseeHomeModel isee_myTaskWithParam:param WithSuccess:^(id  _Nonnull result) {
        NSLog(@"%@", result);
        if ([result[@"code"] integerValue] == 200)
        {
            NSDictionary *data = result[@"data"];
            NSString *taskNum = data[@"value6"];
            if (taskNum != nil&&(![taskNum isKindOfClass:[NSNull class]])) {
                [home setTaskNum:taskNum];
            }
            
        }
        else
        {
            NSLog(@"%@",result[@"errmsg"], nil);
        }
    } failure:^{
        
    }];
}

- (void)getQuerySendOrder:(NSString *)type{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:_mLoginName forKey:@"loginName"];
    [param setObject:_latnId forKey:@"latnId"];
    [param setObject:type forKey:@"queryType"];
     
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    [formatter setDateFormat:@"YYYYMM"];
    NSDate *dateNow = [NSDate date];
    NSString *currentTime = [formatter stringFromDate:dateNow];
     
    [param setObject:currentTime forKey:@"monthId"];
    
    [IseeAFNetRequest showHUD:self.view];
    [self.iseeHomeModel isee_querySendOrderWithParam:param WithSuccess:^(id  _Nonnull result) {
        NSLog(@"%@", result);
        if ([result[@"code"] integerValue] == 200)
        {
            NSDictionary *data = result[@"data"];
            NSInteger taskNum = data[@"processingAllCount"];
            
            [home setQuerySendOrder:[NSString stringWithFormat:@"%@",taskNum] withType:type];
            
        }
        else
        {
            NSLog(@"%@",result[@"errmsg"], nil);
        }
    } failure:^{
        
    }];
}

- (void)getImporant{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:_mManagerId forKey:@"managerId"];
    [param setObject:_latnId forKey:@"latnId"];
    [param setObject:_areaId forKey:@"areaId"];
    [param setObject:@6 forKey:@"statId"];
    
     [IseeAFNetRequest showHUD:self.view];
    [self.iseeHomeModel isee_custInfoWithParam:param WithSuccess:^(id  _Nonnull result) {
        NSLog(@"getImporant:%@", result);
        if ([result[@"code"] integerValue] == 200)
        {
            NSDictionary *data = result[@"data"];
            NSString *baordBandSum = data[@"value1"];
            NSString *baordBandAdd = data[@"value2"];
            NSString *moveSum = data[@"value3"];
            NSString *moveAdd = data[@"value4"];
            NSString *iptvSum = data[@"value5"];
            NSString *iptvAdd = data[@"value6"];
            NSString *shareSum = data[@"value7"];
            NSString *shareAdd = data[@"value8"];
        }
        else
        {
            NSLog(@"%@",result[@"errmsg"], nil);
        }
    } failure:^{
        
    }];
}


- (void)getManagerCustomLost{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:_mManagerId forKey:@"managerId"];
    [param setObject:_latnId forKey:@"latnId"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    [formatter setDateFormat:@"YYYYMM"];
    NSDate *dateNow = [NSDate date];
    NSString *currentTime = [formatter stringFromDate:dateNow];
    
    [param setObject:currentTime forKey:@"statCycleId"];
    
     [IseeAFNetRequest showHUD:self.view];
    [self.iseeHomeModel isee_managerCustomLostWithParam:param WithSuccess:^(id  _Nonnull result) {
        NSLog(@"%@", result);
        if ([result[@"code"] integerValue] == 200)
        {
            NSDictionary *data = result[@"data"];
            long chargeCount = [data[@"chargeCount"] longValue];
            long assetsCount = [data[@"assetsCount"] longValue];
            long teletrafficCount = [data[@"teletrafficCount"] longValue];
            [home setFluWith:[NSString stringWithFormat:@"%ld",chargeCount] withVolume:[NSString stringWithFormat:@"%ld",teletrafficCount] withAssets:[NSString stringWithFormat:@"%ld",assetsCount]];
            
        }
        else
        {
            NSLog(@"%@",result[@"errmsg"], nil);
        }
    } failure:^{
        
    }];
}

- (void)getMyBule{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:_mManagerId forKey:@"managerId"];
    [param setObject:_latnId forKey:@"latnId"];
//    [param setObject:@123 forKey:@"source"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMM"];
    NSDate *dateNow = [NSDate date];
    NSString *currentTime = [formatter stringFromDate:dateNow];
    [param setObject:currentTime forKey:@"statCycleId"];
    

    
     [IseeAFNetRequest showHUD:self.view];
    [self.iseeHomeModel isee_getBlueCustMsgWithParam:param WithSuccess:^(id  _Nonnull result) {
        NSLog(@"%@", result);
        if ([result[@"code"] integerValue] == 200)
        {
            NSDictionary *data = result[@"data"];
            long blueOceanCnt = [data[@"blueOceanCnt"] longValue];
            long interviewCnt = [data[@"interviewCnt"] longValue];
            long newCntYear = [data[@"newCntYear"] longValue];
            long newCntMonth = [data[@"newCntMonth"] longValue];
            
            [home setMyBuleWith:[NSString stringWithFormat:@"%ld",blueOceanCnt] withVisitedNum:[NSString stringWithFormat:@"%ld",interviewCnt] withYearNum:[NSString stringWithFormat:@"%ld",newCntYear] withMonthNum:[NSString stringWithFormat:@"%ld",newCntMonth]];
        }
        else
        {
            NSLog(@"%@",result[@"errmsg"], nil);
        }
    } failure:^{
        
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
