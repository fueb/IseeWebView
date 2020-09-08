//
//  IseeChoiceRegionView.h
//  
//
//  Created by 点芯在线 on 2020/9/8.
//

#import <UIKit/UIKit.h>
#import "IseeChoiceRegionViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface IseeChoiceRegionView : UIView
@property (nonatomic,assign)IseeChoiceRegionViewController *mDelegate;
- (void)setModel:(NSMutableArray *)model;
- (void)reloadTable;
@end

NS_ASSUME_NONNULL_END
