//
//  BaseViewController.m
//  ynqd
//
//  Created by wengdehui on 16/3/22.
//
//

#import "IseeBaseViewController.h"
#import "MBProgressHUD.h"
//#import "CommonUtil.h"
//#import "RequestDelegate.h"

@interface IseeBaseViewController (){
    MBProgressHUD *hud;
}

@end

@implementation IseeBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // setup data
    self.view.backgroundColor = [UIColor whiteColor];
    // 所有界面隐藏导航栏,用自定义的导航栏代替
//    self.fd_prefersNavigationBarHidden = YES;
    // drawUI
//    [self drawTopNaviBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    if (self.navigationController.navigationBar.height == 0) {
//        _topNavBar.alpha = 0;
//    }
    // 将导航放到最顶部,不然后面有其它的层会被覆盖
    [self.view bringSubviewToFront:_topNavBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)showProgress:(id)activity pView:(UIView *)pView text:(NSString *)text
{
    hud = [[MBProgressHUD alloc] initWithView:pView];
    [pView addSubview:hud];
    if (text == nil) {
        hud.labelText = @"请求中,请等待.";
    }else{
        hud.labelText = text;
    }
    [hud show:YES];
}

-(void)closeProgress
{
    if (hud != nil) {
        [hud removeFromSuperview];
        hud = nil;
    }
}

-(void)showMessage:(UIView *)pView text:(NSString *)text
{
    hud = [MBProgressHUD showHUDAddedTo:pView animated:YES];
    hud.mode = UIPushBehaviorModeContinuous;
    hud.labelText = text;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


-(void)responseFail:(NSError *)error statusCode:(NSInteger)statusCode{
    [self closeProgress];
    //告知异常信息
//    BOOL isNetWork = [[CommonUtil getInstance] netWorkJudgment];
//    if (isNetWork) {
//        [self showMessage:self.view text:[NSString stringWithFormat:@"%@，请稍后重试",[error localizedDescription]]];
//    }else{
//        [self showMessage:self.view text:@"网络原因,请检查网络是否打开."];
//    }
}


- (NaviBarView *)topNavBar {
    return _topNavBar;
}

#pragma mark - drawUI

- (void)drawUI {
    
}

/// 在旋转界面时重新构造导航条
- (void)drawTopNaviBar:(NSString *)titleName withTitleBg:(UIColor *)titlebg withBarBg:(UIColor *)barBg {
    if (_topNavBar) {
        [_topNavBar removeFromSuperview];
    }
    // 添加自定义的导航条
    NaviBarView *naviBar = [[NaviBarView alloc] initWithController:self];
    [self.view addSubview:naviBar];
    self.topNavBar = naviBar;
    [_topNavBar addBackBtn];
    [_topNavBar setNavigationTitle:titleName];
    [_topNavBar setNavigationBarClolor:barBg];
    [_topNavBar setTitleColor:titlebg];
//
//    if (![self isKindOfClass:[HomeViewController class]] && ![self isKindOfClass:[AccountViewController class]]) {
//        // 添加返回按钮
//        [_topNavBar addBackBtn];
//        // 添加底部分割线 - 如果不需要添加,这里处理即可
//        [_topNavBar addBottomSepLine];
//    }
    
    // 自动放一个容器在下面,如果全屏的界面就往 self.view 加子,非全屏的往 container 加
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, ScreenHeight - NavHeight)];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.containerView];
}

- (UIButton *)addBtnWithTitle:(NSString *)title action:(SEL)action {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 100, 50)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.borderColor = [[UIColor grayColor] CGColor];
    btn.layer.borderWidth = 1;
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UILabel *)addRightMenu:(NSString *)actionName withAction:(SEL)action {
    return [_topNavBar addRightMenu:actionName withAction:action];
}

#pragma mark - 导航条调用

- (void)addScanAndWishList {
    [_topNavBar addScanAndWishList];
}

// 设置导航条透明
- (void)clearNavBarBackgroundColor {
    [_topNavBar clearNavBarBackgroundColor];
}

#pragma mark - set

- (void)setNaviTitle:(NSString *)naviTitle {
    _naviTitle = naviTitle;
    [_topNavBar setNavigationTitle:naviTitle];
}

#pragma mark - action

- (void)doBackPrev {
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
