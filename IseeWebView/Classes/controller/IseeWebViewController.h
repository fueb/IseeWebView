//
//  IseeWebViewController.h
//  IseeWebView
//
//  Created by 点芯在线 on 2020/7/28.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <CoreLocation/CoreLocation.h>
//地理编码头文件
#import <AddressBook/AddressBook.h>
#import <Speech/Speech.h>
#import <AVFoundation/AVFoundation.h>



NS_ASSUME_NONNULL_BEGIN

@interface IseeWebViewController : UIViewController

@property(nonatomic, strong) NSURL *mWebViewUrl;

@property(nonatomic,copy) NSString *titleName;     //标题
@property(nonatomic) BOOL titleHave;          //是否显示标题
@property(nonatomic,copy) NSString *titleBgColor;  //标题颜色
@property(nonatomic,copy) NSString *statusBarColor;  //状态栏背景颜色
@property(nonatomic) BOOL tabbarHave;          //是否显示标题
@property(nonatomic) BOOL isHomeGo;          //用于返回首页，跳转页面
// 返回按钮点击操作
- (void)doBackPrev;
// 扫码和心愿单
- (void)addScanAndWishList;
// 设置导航条透明
- (void)clearNavBarBackgroundColor;

// 添加按钮
- (UIButton *)addBtnWithTitle:(NSString *)title action:(SEL)action;

- (UILabel *)addRightMenu:(NSString *)actionName withAction:(SEL)action;

/// 在旋转界面时重新构造导航条
- (void)drawTopNaviBar:(NSString *)titleName withTitleBg:(UIColor *)titlebg withBarBg:(UIColor *)barBg;

@end

NS_ASSUME_NONNULL_END
