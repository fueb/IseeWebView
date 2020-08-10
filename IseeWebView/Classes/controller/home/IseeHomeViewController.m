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

@interface IseeHomeViewController (){
    IseeHomeModel   *iseeHomeModel;
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
        NSString *urlStr = [NSString stringWithFormat:@"%@?loginName=%@&companyId=%@&md5key=%@&source=isee",DOMAINNAME,_mLoginName,_mCompanyId,md5Key];
        IseeWebViewController *frameVC = [[IseeWebViewController alloc] init];
        frameVC.titleHave = YES;
        frameVC.titleName = tempMenuDict[@"moduleName"];
        frameVC.titleBgColor = @"#FFFFFF";  //白色
        frameVC.statusBarColor = @"#3086E8";//@"#50D4F9";  //自定义颜色
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"test" ofType:@"html" inDirectory:@"www"];
           //    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        frameVC.mWebViewUrl = url;//[NSURL URLWithString:@"http://8.129.218.5:8080/qyportal/rights"];//urlTF.text];
        frameVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [wkSelf presentViewController:frameVC animated:YES completion:nil];
    }];
    [self.view addSubview:home];
    
    [self getMenu];
    // Do any additional setup after loading the view.
}
#pragma -mark network

//验证码点击切换
- (void)getMenu
{
    [IseeAFNetRequest showHUD:self.view];
    [self.iseeHomeModel isee_homeMenuWithSuccess:^(id  _Nonnull result) {
        NSLog(@"%@", result);
        if ([result[@"code"] integerValue] == 200)
        {
            NSDictionary *data = result[@"data"];
            NSArray *all = data[@"all"];
            NSArray *define = data[@"define"];
            
            
            [modelAry addObjectsFromArray:all];
            [modelAry addObjectsFromArray:define];
            [home setModel:modelAry];
        }
        else
        {
            NSLog(@"%@",result[@"errmsg"], nil);
        }
    } failure:^{
        [home setModel:modelAry];
    }];
    
    
}
- (void)getTask{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@123 forKey:@"managerId"];
    [param setObject:@123 forKey:@"latnId"];
    [param setObject:@123 forKey:@"areaId"];
    [param setObject:@123 forKey:@"statId"];
    
     [IseeAFNetRequest showHUD:self.view];
    [self.iseeHomeModel isee_myTaskWithParam:param WithSuccess:^(id  _Nonnull result) {
        NSLog(@"%@", result);
        if ([result[@"code"] integerValue] == 200)
        {
            NSDictionary *data = result[@"data"];
            NSString *taskNum = data[@"value6"];
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
    [param setObject:@"123" forKey:@"loginName"];
    [param setObject:@"" forKey:@"latnId"];
    [param setObject:@"" forKey:@"mothId"];
    [param setObject:type forKey:@"queryType"];
    
     [IseeAFNetRequest showHUD:self.view];
    [self.iseeHomeModel isee_querySendOrderWithParam:param WithSuccess:^(id  _Nonnull result) {
        NSLog(@"%@", result);
        if ([result[@"code"] integerValue] == 200)
        {
            NSDictionary *data = result[@"data"];
            NSInteger taskNum = data[@"processingAllCount"];
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
    [param setObject:@123 forKey:@"managerId"];
    [param setObject:@123 forKey:@"latnId"];
    [param setObject:@123 forKey:@"areaId"];
    [param setObject:@123 forKey:@"statId"];
    
     [IseeAFNetRequest showHUD:self.view];
    [self.iseeHomeModel isee_custInfoWithParam:param WithSuccess:^(id  _Nonnull result) {
        NSLog(@"%@", result);
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
    [param setObject:@123 forKey:@"managerId"];
    [param setObject:@123 forKey:@"latnId"];
    [param setObject:@123 forKey:@"statCycleId"];
    
     [IseeAFNetRequest showHUD:self.view];
    [self.iseeHomeModel isee_managerCustomLostWithParam:param WithSuccess:^(id  _Nonnull result) {
        NSLog(@"%@", result);
        if ([result[@"code"] integerValue] == 200)
        {
            NSDictionary *data = result[@"data"];
            NSString *chargeCount = data[@"chargeCount"];
            NSString *assetsCount = data[@"assetsCount"];
            NSString *teletrafficCount = data[@"teletrafficCount"];
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
    [param setObject:@123 forKey:@"managerId"];
    [param setObject:@123 forKey:@"latnId"];
    [param setObject:@123 forKey:@"statCycleId"];
    [param setObject:@123 forKey:@"source"];

    
     [IseeAFNetRequest showHUD:self.view];
    [self.iseeHomeModel isee_getBlueCustMsgWithParam:param WithSuccess:^(id  _Nonnull result) {
        NSLog(@"%@", result);
        if ([result[@"code"] integerValue] == 200)
        {
            NSDictionary *data = result[@"data"];
            NSString *blueOceanCnt = data[@"blueOceanCnt"];
            NSString *interviewCnt = data[@"interviewCnt"];
            NSString *newCntYear = data[@"newCntYear"];
            NSString *newCntMonth = data[@"newCntMonth"];
        }
        else
        {
            NSLog(@"%@",result[@"errmsg"], nil);
        }
    } failure:^{
        
    }];
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
