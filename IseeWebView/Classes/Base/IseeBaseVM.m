//
//  BaseVM.m
//  EPay
//
//  Created by 钟吕仙 on 2018/2/5.
//  Copyright © 2018年 strong. All rights reserved.
//

#import "IseeBaseVM.h"

@implementation IseeBaseVM
- (void)registerNotificationCenter {
    /*注册接收通知中心*/
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    /*更新通讯录通知*/
    [center addObserver:self
               selector:@selector(getResultData:)
                   name:[NSString stringWithFormat:@"%@",[self class]]
                 object:nil];
}
- (void)removeNotificationCenter {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                            name:[NSString stringWithFormat:@"%@",[self class]]
                                                  object:nil];
}
- (void)getResultData:(NSNotification *)notification {
    NSLog(@"%@", notification.object);
}
@end
