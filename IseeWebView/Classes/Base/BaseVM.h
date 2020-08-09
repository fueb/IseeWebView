//
//  BaseVM.h
//  EPay
//
//  Created by 钟吕仙 on 2018/2/5.
//  Copyright © 2018年 strong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseVM;
@protocol BaseVMDelegate <NSObject>
@optional
- (void)resultData:(id)result isSucceed:(BOOL)isSucceed tag:(NSInteger)tag;

@end

@interface BaseVM : NSObject
@property (nonatomic, assign) id<BaseVMDelegate> delegate;
- (void)registerNotificationCenter;
- (void)removeNotificationCenter;

@end
