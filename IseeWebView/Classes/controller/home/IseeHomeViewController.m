//
//  IseeHomeViewController.m
//  IseeWebView
//
//  Created by 点芯在线 on 2020/8/6.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import "IseeHomeViewController.h"
#import "HomeView.h"
#import "Config.h"
@interface IseeHomeViewController ()

@end

@implementation IseeHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat safeBottom = 0;
    if ([Config isNotchScreen]) {
        safeBottom = 34;
    }
    HomeView *home = [[HomeView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight-(50+safeBottom))];
    
    [self.view addSubview:home];
    [home setModel:[NSArray array]];
    // Do any additional setup after loading the view.
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
