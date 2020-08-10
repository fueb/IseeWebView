//
//  BaseViewController.h
//  ynqd
//
//  Created by wengdehui on 16/3/22.
//
//

#import <UIKit/UIKit.h>
#import "UIView+IseeExtension.h"
#import "IseeNaviBarView.h"


@interface IseeBaseViewController : UIViewController

#pragma mark - 导航条相关
@property(nonatomic, copy)NSString *naviTitle;  // 标题
/** 导航条 */
@property(nonatomic, strong)IseeNaviBarView *topNavBar;
/** 内容视图 */
@property (strong, nonatomic) UIView *containerView;

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



- (NSString*)dictionaryToJson:(NSDictionary *)dic;
-(void)showProgress:(id)activity pView:(UIView *)pView text:(NSString *)text;
-(void)closeProgress;
-(void)showMessage:(UIView *)pView text:(NSString *)text;

@end
