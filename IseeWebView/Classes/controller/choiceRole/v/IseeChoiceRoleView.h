//
//  IseeChoiceRoleView.h
//  IseeWebView
//
//  Created by 余友良 on 2020/11/20.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IseeChoiceRoleViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface IseeChoiceRoleView : UIView
@property (nonatomic,assign)IseeChoiceRoleViewController *mDelegate;
- (void)setModel:(NSMutableArray *)model;
- (void)reloadTable;
@end

NS_ASSUME_NONNULL_END
