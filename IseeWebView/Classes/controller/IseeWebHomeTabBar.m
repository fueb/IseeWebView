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


#import "IseeWebHomeTabBar.h"
#import "IseeWebViewController.h"
#import "IseeConfig.h"
#import "IseeHomeViewController.h"


@interface IseeWebHomeTabBar ()<UINavigationControllerDelegate>
{
    
}

@end

@implementation IseeWebHomeTabBar

- (instancetype)initWithLoginName:(NSString *)loginName withCompanyId:(NSString *)comanyId
{
    self.mCompanyId = comanyId;
    self.mLoginName = loginName;
    self = [super init];
    if (self != nil)
    {
        self.mCompanyId = comanyId;
        self.mLoginName = loginName;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
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
                                       selImgKey : @"toolSelect"} ,
                                     
                                     @{classKey  : @"IseeWebViewController",
                                       titleKey  : @"沙盘",
                                       imgKey    : @"sandTable",
                                       selImgKey : @"sandTableSelect"},
                                     
                                     @{classKey  : @"IseeWebViewController",
                                       titleKey  : @"消息",
                                       imgKey    : @"message",
                                       selImgKey : @"messageSelect"},
                                     
                                     @{classKey  : @"IseeWebViewController",
                                       titleKey  : @"我的",
                                       imgKey    : @"my",
                                       selImgKey : @"mySelect"},nil];
    
    for (NSDictionary *dict in childItemsAry)
    {
        UIViewController *vc        = [[NSClassFromString(dict[classKey]) alloc]init];
        if ([vc isKindOfClass:[IseeWebViewController class]]) {
            IseeWebViewController *iseeVc = (IseeWebViewController *)vc;
            iseeVc.titleHave = NO;
            iseeVc.titleName = @"test";
            iseeVc.titleBgColor = @"#AAAAAA";  //白色
            iseeVc.statusBarColor = @"#FFFFFF";//@"#50D4F9";  //自定义颜色
            NSString *filePath = [[NSBundle mainBundle]pathForResource:@"test" ofType:@"html" inDirectory:@"www"];
                  
            NSURL *url = [NSURL fileURLWithPath:filePath];
            iseeVc.mWebViewUrl = url;
        }
        else if([vc isKindOfClass:[IseeHomeViewController class]])
        {
            IseeHomeViewController *iseeHome = (IseeHomeViewController *)vc;
            iseeHome.mCompanyId = self.mCompanyId;
            iseeHome.mLoginName = self.mLoginName;
        }
        
        
        vc.title                    = dict[titleKey];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        nav.delegate                = self;
        nav.navigationBar.translucent = NO;
        
//        nav.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"top_bg"]];
        nav.navigationBarHidden = YES;
        [nav.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
        /*常态*/
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[IseeConfig stringTOColor:@"#707175"], NSForegroundColorAttributeName, [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f],NSFontAttributeName,nil] forState:UIControlStateNormal];
        /*点击后状态*/
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[IseeConfig stringTOColor:@"#2e63bc"], NSForegroundColorAttributeName, [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f],NSFontAttributeName,nil] forState:UIControlStateSelected];
        
        
        UITabBarItem *item   = vc.tabBarItem;
        item.title           = dict[titleKey];
        item.image           = [[UIImage imageNamed:dict[imgKey]]
                                imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage   = [[UIImage imageNamed:dict[selImgKey]]
                                imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        
        [self addChildViewController:nav];
    }
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
