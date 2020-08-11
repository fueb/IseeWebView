//
//  HomeView.h
//  IseeWebView
//
//  Created by 点芯在线 on 2020/8/6.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IseeHomeView : UIView
@property (nonatomic,strong) void (^menuClick)(NSInteger type);
@property (nonatomic,strong) void (^searchItemClick)(NSInteger type);
@property (nonatomic,strong)NSMutableArray *model;
@property (nonatomic,strong)NSString *taskNum;
@property (nonatomic,strong)NSString *querySendOrder;
@property (nonatomic,strong)NSMutableDictionary *keyPointDict;
@property (nonatomic,strong)NSString *incomeNum;
@property (nonatomic,strong)NSString *volumeNum;
@property (nonatomic,strong)NSString *assetsNum;
@property (nonatomic,strong)NSString *myBuleNum;
@property (nonatomic,strong)NSString *visitedNum;
@property (nonatomic,strong)NSString *yearNum;
@property (nonatomic,strong)NSString *monthNum;
-(void)setQuerySendOrder:(NSString *)querySendOrder withType:(NSString *)type;
-(void)setFluWith:(NSString *)incomeNum withVolume:(NSString *)volumeNum withAssets:(NSString *)assetsNum;
-(void)setMyBuleWith:(NSString *)myBuleNum withVisitedNum:(NSString *)visitedNum withYearNum:(NSString *)yearNum withMonthNum:(NSString *)monthNum;
- (instancetype)initWithFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
