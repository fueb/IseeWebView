//
//  UIViewController+Common.m
//  FXYIM
//
//  Created by strong on 17/4/10.
//  Copyright © 2017年 strong. All rights reserved.
//

#import "UIViewController+Common.h"
#import "Config.h"


@implementation UIViewController (Common)
- (void)setBottomLogoView
{
//    WS(weakSelf);
//    UIImageView *bottomImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_bottom_prompt"]];
//    [self.view addSubview:bottomImgView];
//    [bottomImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(@-15);
//        make.centerX.equalTo(weakSelf.view);
//        make.width.equalTo(@120);
//        make.height.equalTo(@15);
//    }];
}
/**
 创建导航栏按键
 
 @param type        1、右侧导航栏按键；0、左侧导航栏按键；
 @param title       按键标题
 @param image       按键图标
 @param selectImage 按键按下状态图片
 */
- (void)createBarBtnWithType:(NSInteger)type
                       title:(NSString *)title
                       image:(NSString *)image
                 selectImage:(NSString *)selectImage
{
    UIButton *button = [[UIButton alloc]init];
    button.frame = CGRectMake(0, 0, title.length?100:30, 30);
    if (title.length) [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectImage] forState:UIControlStateSelected];
    [button addTarget:self
               action:type?@selector(rightAction:):@selector(leftAction:)
     forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if (type)
    {
        [button setImageEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
        space.width = -3;
        button.contentHorizontalAlignment = 2;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:space, barButton, nil];
    }
    else
    {
        space.width = -5;
        button.contentHorizontalAlignment = 1;
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:space, barButton, nil];
    }
}
/**
@param type        1、右侧导航栏按键；0、左侧导航栏按键；
@param title       按键标题
@param image       按键图标
@param selectImage 按键按下状态图片
@param size        控件size
*/
- (void)createBarBtnWithType:(NSInteger)type
                       title:(NSString *)title
                       image:(NSString *)image
                 selectImage:(NSString *)selectImage
                        size:(CGSize)size
{
    UIButton *button = [[UIButton alloc]init];
    //    button.frame = CGRectMake(0, 0, title.length?100:30, 30);
    button.frame = CGRectMake(0, 0, size.width, size.width);
    if (title.length) [button setTitle:title forState:UIControlStateNormal];
    if (UIScreenWidth == 320) button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectImage] forState:UIControlStateSelected];
    [button addTarget:self
               action:type?@selector(rightAction:):@selector(leftAction:)
     forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if (type)
    {
        space.width = -5;
        button.contentHorizontalAlignment = 2;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:space, barButton, nil];
    }
    else
    {
        space.width = -12;
        button.contentHorizontalAlignment = 1;
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:space, barButton, nil];
    }
}
/**
 左侧导航栏按键点击事件
 
 @param btn 左侧导航栏按键
 */
- (void)leftAction:(UIButton *)btn
{
    [self backAction];
}

/**
 右侧导航栏按键点击事件
 
 @param btn 右侧导航栏按键
 */
- (void)rightAction:(UIButton *)btn
{
    
}

/**
 返回事件
 */
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

//吐司
//- (void)showToast:(NSString *)toast
//{
//    MBProgressHUD *HUD  = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:HUD];
//    HUD.label.text     = toast;
//    HUD.mode = MBProgressHUDModeText;
//    [HUD showAnimated:YES];
//    HUD.bezelView.color = [UIColor blackColor];
//    HUD.label.textColor = [UIColor whiteColor];
//    HUD.bezelView.alpha = 0.7;
//    HUD.detailsLabel.textColor = [UIColor redColor];
//    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
//        sleep(2);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [HUD hideAnimated:YES];
//        });
//    });
//}

@end
