//
//  IseeWebHomeTabBar.m
//  IseeWebView
//
//  Created by 点芯在线 on 2020/8/6.
//  Copyright © 2020 dxzx. All rights reserved.
//
#define classKey   @"rootVCClassString"
#define titleKey   @"title"
#define imgKey     @"imageName"
#define selImgKey  @"selectedImageName"
#define urlKey     @"webViewUrl"

#import "IseeWebHomeTabBar.h"
#import "IseeWebViewController.h"
#import "IseeConfig.h"
#import "IseeHomeViewController.h"
#import "IseeAFNetRequest.h"


@interface IseeWebHomeTabBar ()<UINavigationControllerDelegate>
{
    
}

@end

@implementation IseeWebHomeTabBar

- (instancetype)initWithLoginName:(NSString *)loginName withCompanyId:(NSString *)comanyId withSession:(NSString *)session withUserId:(NSString *)userId withSaleNum:(NSString *)saleNum
{
    self.mCompanyId = comanyId;
    self.mLoginName = loginName;
    self.mSession   = session;
    self.mSaleNum   = saleNum;
    self.mUserId    = userId;
    self = [super init];
    if (self != nil)
    {
        self.mCompanyId = comanyId;
        self.mLoginName = loginName;
        self.mSession   = session;
        self.mSaleNum   = saleNum;
        self.mUserId    = userId;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self show];
   
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    UINavigationController *nav = (UINavigationController *)viewController;
    UIViewController *VC =nav.topViewController;
    if ([VC isKindOfClass:[IseeWebViewController class]]) {
        
        
        
        return YES;
    }
    return YES;
    
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSLog(@"item name = %@", item.title);
    NSArray *childAry = self.childViewControllers;
    int i = 0;
    for (IseeWebViewController *VC in childAry) {
        
    }
}

- (void)show{
    self.view.backgroundColor = [UIColor whiteColor];
        self.tabBar.translucent = NO;
        NSMutableArray *childItemsAry = [[NSMutableArray alloc]initWithObjects:
                                         @{classKey  : @"IseeHomeViewController",
                                           titleKey  : @"首页",
                                           imgKey    : @"homePage",
                                           selImgKey : @"homePageSelect"},
                                         
                                         @{classKey  : @"IseeWebViewController",
                                           titleKey  : @"工具",
                                           imgKey    : @"tool",
                                           selImgKey : @"toolSelect",
                                           urlKey    : TOOLWEBURL} ,
                                         
                                         @{classKey  : @"IseeWebViewController",
                                           titleKey  : @"沙盘",
                                           imgKey    : @"sandTable",
                                           selImgKey : @"sandTableSelect",
                                           urlKey    : SANDTABLE},
                                         
                                         @{classKey  : @"IseeWebViewController",
                                           titleKey  : @"消息",
                                           imgKey    : @"message",
                                           selImgKey : @"messageSelect",
                                           urlKey    : MESSAGEWEBURL},
                                         
                                         @{classKey  : @"IseeWebViewController",
                                           titleKey  : @"我的",
                                           imgKey    : @"my",
                                           selImgKey : @"mySelect",
                                           urlKey    : MYWEBURL},nil];
        
        for (NSDictionary *dict in childItemsAry)
        {
            UIViewController *vc        = [[NSClassFromString(dict[classKey]) alloc]init];
            if ([vc isKindOfClass:[IseeWebViewController class]]) {
                IseeWebViewController *iseeVc = (IseeWebViewController *)vc;
                iseeVc.mLoginName = self.mLoginName;
                iseeVc.mSession   = self.mSession;
                iseeVc.mSaleNum   = self.mSaleNum;
                iseeVc.mUserId    = self.mUserId;
                iseeVc.titleHave = YES;
                iseeVc.tabbarHave = YES;
                iseeVc.isHomeGo = NO;
                iseeVc.titleName = dict[titleKey];
                iseeVc.titleBgColor = @"#FFFFFF";  //白色
                iseeVc.statusBarColor = @"#1B82D2";//@"#50D4F9";  //自定义颜色
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

                   [formatter setDateFormat:@"YYYYMMdd"];
                   NSDate *dateNow = [NSDate date];
                   NSString *currentTime = [formatter stringFromDate:dateNow];
                      
                NSString *md5Str = [NSString stringWithFormat:@"%@%@ISEE%@",_mLoginName,_mCompanyId,currentTime];
                NSString *md5Key = [[IseeConfig md5:md5Str] lowercaseString];
                
                NSString *urlStr = [NSString stringWithFormat:@"%@%@?loginName=%@&companyId=%@&md5key=%@&source=isee&form=app2",WEBHOST,dict[urlKey],_mLoginName,_mCompanyId,md5Key];
                
                NSURL *url = [NSURL URLWithString:urlStr];//urlTF.text];
//                 NSString *filePath = [[NSBundle mainBundle]pathForResource:@"test" ofType:@"html" inDirectory:@"www"];
//                url = [NSURL fileURLWithPath:filePath];
                iseeVc.mWebViewUrl = url;
            }
            else if([vc isKindOfClass:[IseeHomeViewController class]])
            {
                IseeHomeViewController *iseeHome = (IseeHomeViewController *)vc;
                iseeHome.mCompanyId = self.mCompanyId;
                iseeHome.mLoginName = self.mLoginName;
                iseeHome.mSession   = self.mSession;
                iseeHome.mSaleNum   = self.mSaleNum;
                iseeHome.mUserId    = self.mUserId;
            }
            
            
            vc.title                    = dict[titleKey];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            nav.delegate                = self;
            nav.navigationBar.translucent = NO;
            
    //        nav.navigationBar.barTintColor = [UIColor colorWithPatternImage:[IseeConfig imageNamed:@"top_bg"]];
            nav.navigationBarHidden = YES;
            [nav.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
            /*常态*/
            [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[IseeConfig stringTOColor:@"#707175"], NSForegroundColorAttributeName, [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f],NSFontAttributeName,nil] forState:UIControlStateNormal];
            /*点击后状态*/
            [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[IseeConfig stringTOColor:@"#2e63bc"], NSForegroundColorAttributeName, [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f],NSFontAttributeName,nil] forState:UIControlStateSelected];
            
            
            UITabBarItem *item   = vc.tabBarItem;
            item.title           = dict[titleKey];
            item.image           = [[IseeConfig imageNamed:dict[imgKey]]
                                    imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            item.selectedImage   = [[IseeConfig imageNamed:dict[selImgKey]]
                                    imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
            
            [self addChildViewController:nav];
        }
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
