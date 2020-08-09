//
//  HomeView.m
//  IseeWebView
//
//  Created by 点芯在线 on 2020/8/6.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import "HomeView.h"
#import "Masonry.h"
#import "Config.h"

@interface HomeView ()

@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) UIView *contentView;//子视图容器
@property (nonatomic, strong) UIView *downView;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UIView *upBgView;
@property (nonatomic, strong) UIView *taskBgView;
@property (nonatomic, strong) UIView *repairBgView;
@property (nonatomic, strong) UIView *faultBgView;
@property (nonatomic, strong) UIView *complaintBgView;
@property (nonatomic, strong) UIView *visitBgView;
@property (nonatomic, strong) UIView *callBgView;
@property (nonatomic, strong) UIView *expirBgView;
@property (nonatomic, strong) UIView *bordbandBgView;
@property (nonatomic, strong) UIView *developeBgView;
@property (nonatomic, strong) UIView *devBoardbandBgView;
@property (nonatomic, strong) UIView *devMoveBgView;
@property (nonatomic, strong) UIView *devIptvBgView;
@property (nonatomic, strong) UIView *devShareBgView;
@property (nonatomic, strong) UIView *incomeFluBgView;
@property (nonatomic, strong) UIView *volumeFluBgView;
@property (nonatomic, strong) UIView *assetsFluBgView;
@end

@implementation HomeView
{
    //superView
    UIView *searchBgView;
    UIView *downView;
    UIView *menuView;
    UIView *upBgView;
    UIView *taskBgView;
    UIView *repairBgView;
    UIView *faultBgView;
    UIView *complaintBgView;
    
    UIView *developeBgView;
    UIView *devShareBgView;
    UIView *devIptvBgView;
    UIView *devBoardbandBgView;
    UIView *devMoveBgView;
    
    UIView *incomeFluBgView;
    UIView *volumeFluBgView;
    UIView *assetsFluBgView;
    
    UIView *visitBgView;
    UIView *callBgView;
    UIView *bordbandBgView;
    UIView *expirBgView;
    
    UIButton *businessBtn;
    UIButton *numBtn;
    UIButton *knowBtn;
    UITextField *searchField;
    
    
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}

- (void)setModel:(NSArray *)model
{
    model = @[@1,@2,@3,@4,@5,@1,@2,@3,@4,@5];
    _model = model;
    [self getScroll];
    [self searchView];
    [self taskView];
    [self menu];
    [self down];
    [self developeView];
}

- (void)getScroll{
    __weak typeof(self) wkSelf = self;
    
    _scroll = [[UIScrollView alloc] init];
    if ([Config isNotchScreen]) {
        _scroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        _scroll.automaticallyAdjustsScrollIndicatorInsets = NO;
    }
//    _scroll.automaticallyAdjustsScrollIndicatorInsets = NO;
    _scroll.bounces = NO;
    //设置是否显示水平和垂直显示条
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.showsHorizontalScrollIndicator = NO;
//    [_scroll setBackgroundColor:[UIColor yellowColor]];
    [self addSubview:_scroll];
    
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [Config stringTOColor:@"#ECECEC"];
    [_scroll addSubview:_contentView];
     
    [_scroll addSubview:self.downView];
    
    searchBgView = [[UIView alloc] init];
    [searchBgView setBackgroundColor:[Config stringTOColor:@"#3086E8"]];
    
    [_scroll addSubview:searchBgView];
    
    [_scroll addSubview:self.upBgView];
    [_scroll addSubview:self.menuView];
    [_scroll addSubview:self.taskBgView];
    [_scroll addSubview:self.repairBgView];
    [_scroll addSubview:self.complaintBgView];
    [_scroll addSubview:self.faultBgView];
    
    [_scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(0);
            make.centerX.equalTo(_scroll);

    }];
    
    [searchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scroll.mas_top);
        make.height.equalTo(@(300));
        make.left.right.equalTo(_scroll);
    }];
    
    [upBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchBgView.mas_bottom);
        make.height.equalTo(@(415));
        make.left.right.equalTo(_scroll);
    }];
    
    [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(searchBgView.mas_centerY).offset(35);
        make.left.mas_equalTo(_scroll.mas_left).offset(10);
        make.right.mas_equalTo(_scroll.mas_right).offset(-10);
        make.height.mas_equalTo(200);
    }];
    
    [taskBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(menuView.mas_bottom).offset(15);
        make.left.mas_equalTo(_scroll.mas_left).offset(10);
        make.right.mas_equalTo(_scroll.mas_right).offset(-10);
        make.height.mas_equalTo(200);
    }];
    
    [repairBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(taskBgView.mas_bottom).offset(15);
        make.left.mas_equalTo(taskBgView.mas_left);
        make.width.equalTo(complaintBgView);
        make.height.mas_equalTo(80);
    }];
    
    [faultBgView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.mas_equalTo(repairBgView);
           make.left.mas_equalTo(repairBgView.mas_right).offset(10);
           make.width.equalTo(repairBgView);
           make.height.mas_equalTo(80);
    }];
    
    [complaintBgView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.mas_equalTo(repairBgView);
           make.left.mas_equalTo(faultBgView.mas_right).offset(10);
           make.right.mas_equalTo(taskBgView.mas_right);
           make.height.mas_equalTo(80);
        make.width.equalTo(faultBgView);
    }];
    
    [downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(upBgView.mas_bottom).with.offset(10);
        make.height.equalTo(@(750));
        make.left.right.equalTo(searchBgView);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)searchView{
    businessBtn = [[UIButton alloc] init];
    [businessBtn setTitle:@"查企业" forState:UIControlStateNormal];
    [businessBtn setTitleColor:[Config stringTOColor:@"#BBBBBB"] forState:UIControlStateNormal];
    [businessBtn setTitleColor:[Config stringTOColor:@"#FFFFFF"] forState:UIControlStateSelected];
    businessBtn.selected = YES;
    [searchBgView addSubview:businessBtn];
    
    numBtn = [[UIButton alloc] init];
    [numBtn setTitle:@"查号码" forState:UIControlStateNormal];
    [numBtn setTitleColor:[Config stringTOColor:@"#BBBBBB"] forState:UIControlStateNormal];
    [numBtn setTitleColor:[Config stringTOColor:@"#FFFFFF"] forState:UIControlStateSelected];
    numBtn.selected = NO;
    [searchBgView addSubview:numBtn];
    
    knowBtn = [[UIButton alloc] init];
    [knowBtn setTitle:@"查知识" forState:UIControlStateNormal];
    [knowBtn setTitleColor:[Config stringTOColor:@"#BBBBBB"] forState:UIControlStateNormal];
    [knowBtn setTitleColor:[Config stringTOColor:@"#FFFFFF"] forState:UIControlStateSelected];
    knowBtn.selected = NO;
    [searchBgView addSubview:knowBtn];
    
    searchField = [[UITextField alloc] init];
//    searchField.placeholder = @"请输入企业名称";
    
    NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请输入企业名称" attributes:@{NSForegroundColorAttributeName : [Config stringTOColor:@"#87C0F8"]}];
    searchField.attributedPlaceholder = placeholderString;

    [self setRightViewWithTextField:searchField imageName:@"camerIcon" withImg:@"micIcon"];
    [self setLeftViewWithTextField:searchField imageName:@"queryIcon"];
    [searchField setBackgroundColor:[Config stringTOColor:@"#CAE1F9"]];
    [searchField.layer setCornerRadius:10];
    searchField.layer.masksToBounds = YES;
    [searchBgView addSubview:searchField];
    
    [searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(searchBgView.mas_left).with.offset(30);
        make.right.mas_equalTo(searchBgView.mas_right).with.offset(-30);
        make.centerY.mas_equalTo(searchBgView.mas_centerY).with.offset(-5);
    }];
    
    [numBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.centerX.mas_equalTo(searchField.mas_centerX);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(searchField.mas_top).with.offset(-10);
    }];
    
    [businessBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.width.mas_equalTo(80);
           make.right.mas_equalTo(numBtn.mas_left).with.offset(-30);
           make.height.mas_equalTo(30);
           make.bottom.mas_equalTo(searchField.mas_top).with.offset(-10);
       }];
    
    [knowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.width.mas_equalTo(80);
           make.left.mas_equalTo(numBtn.mas_right).offset(30);
           make.height.mas_equalTo(30);
           make.bottom.mas_equalTo(searchField.mas_top).with.offset(-10);
       }];
    
    
    
}

- (void)menu{
    for (int i = 0; i < _model.count; i++) {
        CGFloat height = 100;
        CGFloat width = (UIScreenWidth-20)/5;
        CGRect frame = CGRectMake((i%5)*width, 0, width, height);
        if (i > 4) {
            frame.origin.y = 100;
        }
        UIView *menuItemBgView = [[UIView alloc] initWithFrame:frame];
        
        UIView *imgBgView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, width-30, width-30)];
        imgBgView.layer.cornerRadius = (width-30)/2;
        imgBgView.backgroundColor = [Config stringTOColor:@"#308AF5"];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, width-50, width-50)];
        
        
        [imgView setImage:[UIImage imageNamed:@"preAccept"]];
        
        UILabel *menuTextLab = [[UILabel alloc] init];
        menuTextLab.text = @"预受理";
        menuTextLab.textColor = [UIColor blackColor];
        menuTextLab.textAlignment = NSTextAlignmentCenter;
        
        [imgBgView addSubview:imgView];
        [menuItemBgView addSubview:imgBgView];
        [menuItemBgView addSubview:menuTextLab];
        [menuView addSubview:menuItemBgView];
        [menuTextLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(menuItemBgView);
            make.top.mas_equalTo(imgView.mas_bottom).offset(3);
        }];
        
        
    }
}


- (void)taskView{
    
   
    
    [taskBgView addSubview:self.visitBgView];
    [taskBgView addSubview:self.callBgView];
    [taskBgView addSubview:self.expirBgView];
    [taskBgView addSubview:self.bordbandBgView];
    
    UIView *horLine = [[UIView alloc] init];
    horLine.backgroundColor = [Config stringTOColor:@"#D5DEE7"];
    [taskBgView addSubview:horLine];
    
    UIView *verLine = [[UIView alloc] init];
    verLine.backgroundColor = [Config stringTOColor:@"#D5DEE7"];
    [taskBgView addSubview:verLine];
    
    [visitBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(taskBgView);
        make.right.mas_equalTo(taskBgView.mas_centerX);
        make.bottom.mas_equalTo(taskBgView.mas_centerY);
    }];
    [visitBgView layoutIfNeeded];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:visitBgView.bounds byRoundingCorners:UIRectCornerTopLeft cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = visitBgView.bounds;
    maskLayer.path = maskPath.CGPath;
    visitBgView.layer.mask = maskLayer;
    
   
    
    [callBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(taskBgView);
        make.left.mas_equalTo(taskBgView.mas_centerX);
        make.bottom.mas_equalTo(taskBgView.mas_centerY);
    }];
    [callBgView layoutIfNeeded];
    
    UIBezierPath *callMaskPath = [UIBezierPath bezierPathWithRoundedRect:callBgView.bounds byRoundingCorners:UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *callMaskLayer = [[CAShapeLayer alloc] init];
    callMaskLayer.frame = callBgView.bounds;
    callMaskLayer.path = callMaskPath.CGPath;
    callBgView.layer.mask = callMaskLayer;
    
    [expirBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(visitBgView);
        make.bottom.mas_equalTo(taskBgView.mas_bottom);
        make.top.mas_equalTo(taskBgView.mas_centerY);
    }];
    [expirBgView layoutIfNeeded];
    
    UIBezierPath *expirMaskPath = [UIBezierPath bezierPathWithRoundedRect:expirBgView.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *expirMaskLayer = [[CAShapeLayer alloc] init];
    expirMaskLayer.frame = expirBgView.bounds;
    expirMaskLayer.path = expirMaskPath.CGPath;
    expirBgView.layer.mask = expirMaskLayer;
    
    [bordbandBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(expirBgView);
        make.left.mas_equalTo(taskBgView.mas_centerX);
        make.bottom.right.mas_equalTo(taskBgView);
    }];
    [bordbandBgView layoutIfNeeded];
    
    UIBezierPath *bbMaskPath = [UIBezierPath bezierPathWithRoundedRect:bordbandBgView.bounds byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *bbMaskLayer = [[CAShapeLayer alloc] init];
    bbMaskLayer.frame = bordbandBgView.bounds;
    bbMaskLayer.path = bbMaskPath.CGPath;
    bordbandBgView.layer.mask = bbMaskLayer;
    
    
    [horLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.height.top.centerX.mas_equalTo(taskBgView);
    }];
    
    [verLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.right.centerY.mas_equalTo(taskBgView);
    }];
    
    [self taskViewItem:visitBgView withImg:@"visitIcon" withTitle:@"走访任务" withNum:@"555"];
    [self taskViewItem:callBgView withImg:@"callIcon" withTitle:@"欠费催缴" withNum:@"555"];
    [self taskViewItem:expirBgView withImg:@"expir" withTitle:@"电路到期" withNum:@"555"];
    [self taskViewItem:bordbandBgView withImg:@"boardband" withTitle:@"宽带(专线)到期" withNum:@"555"];

}
- (void)taskViewItem:(UIView *)bgView withImg:(NSString *)imgName withTitle:(NSString *)title withNum:(NSString *)num{
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = title;
    titleLab.textColor = [UIColor grayColor];
    titleLab.font = [UIFont fontWithName:@"Helvetica" size:15];
    UILabel *numLab = [[UILabel alloc] init];
    numLab.text = num;
    numLab.textColor = [UIColor blackColor];
    numLab.textAlignment = NSTextAlignmentCenter;
    numLab.font = [UIFont fontWithName:@"Helvetica-Oblique" size:20];
    [bgView addSubview:icon];
    [bgView addSubview:titleLab];
    [bgView addSubview:numLab];
    
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView.mas_left).offset(10);
        make.width.height.mas_equalTo(30);
        make.top.mas_equalTo(bgView.mas_top).offset(35);
    }];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(icon.mas_right).offset(5);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(105);
        make.top.mas_equalTo(bgView.mas_top).offset(25);
    }];
    
    [numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLab.mas_right);
        make.height.mas_equalTo(50);
        make.right.mas_equalTo(bgView.mas_right);
        make.top.mas_equalTo(bgView.mas_top).offset(25);
    }];
    
}

- (void)down{
    UILabel * fllowLab = [[UILabel alloc] init];
    fllowLab.text = @"重点关注";
    fllowLab.textColor = [Config stringTOColor:@"#474858"];
    fllowLab.font = [UIFont fontWithName:@"Helvetica" size:20];
    
    UILabel * myBule = [[UILabel alloc] init];
    myBule.text = @"我的蓝海";
    myBule.textColor = [Config stringTOColor:@"#474858"];
    myBule.font = [UIFont fontWithName:@"Helvetica" size:20];
    
    
    [downView addSubview:fllowLab];
    [downView addSubview:myBule];
    
    [downView addSubview:self.developeBgView];
    [downView addSubview:self.incomeFluBgView];
    [downView addSubview:self.volumeFluBgView];
    [downView addSubview:self.assetsFluBgView];
    
    [fllowLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(downView.mas_left).offset(10);
        make.right.mas_equalTo(downView.mas_right).offset(-10);
        make.top.mas_equalTo(downView.mas_top).offset(15);
        make.height.equalTo(@30);
    }];
    [developeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(fllowLab);
        make.top.mas_equalTo(fllowLab.mas_bottom).offset(15);
        make.height.equalTo(@200);
    }];
    [incomeFluBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(fllowLab);
        make.top.mas_equalTo(developeBgView.mas_bottom).offset(10);
        make.width.mas_equalTo(assetsFluBgView);
        make.height.equalTo(@130);
    }];
    
    [volumeFluBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(incomeFluBgView.mas_right).offset(5);
        make.top.mas_equalTo(incomeFluBgView);
        make.width.mas_equalTo(incomeFluBgView);
        make.height.equalTo(incomeFluBgView);
    }];
    
    [assetsFluBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(volumeFluBgView.mas_right).offset(5);
        make.right.mas_equalTo(fllowLab.mas_right);
        make.top.mas_equalTo(incomeFluBgView);
        make.width.mas_equalTo(volumeFluBgView);
        make.height.equalTo(incomeFluBgView);
    }];
    
    [myBule mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(fllowLab);
        make.top.mas_equalTo(assetsFluBgView.mas_bottom).offset(35);
    }];
    
    [self getFluItem:incomeFluBgView withIcon:@"income" withStr:@"收入波动" withNum:@"5"];
    [self getFluItem:volumeFluBgView withIcon:@"volume" withStr:@"话务量波动" withNum:@"5"];
    [self getFluItem:assetsFluBgView withIcon:@"assets" withStr:@"资产波动" withNum:@"5"];
    
    UIView *myBuleNumBg = [[UIView alloc] init];
    UIView *visitedBg = [[UIView alloc] init];
    UIView *yearBg = [[UIView alloc] init];
    UIView *monthBg = [[UIView alloc] init];
//    myBuleNumBg.backgroundColor = [UIColor redColor];
//    visitedBg.backgroundColor = [UIColor redColor];
//    yearBg.backgroundColor = [UIColor redColor];
//    monthBg.backgroundColor = [UIColor redColor];
    [downView addSubview:myBuleNumBg];
    [downView addSubview:visitedBg];
    [downView addSubview:yearBg];
    [downView addSubview:monthBg];
    
    [myBuleNumBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(myBule.mas_bottom).offset(20);
        make.left.right.mas_equalTo(myBule);
        make.height.mas_equalTo(40);
    }];
    [visitedBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(myBuleNumBg.mas_bottom).offset(10);
        make.left.right.height.mas_equalTo(myBuleNumBg);
    }];
    [yearBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(visitedBg.mas_bottom).offset(10);
        make.left.right.height.mas_equalTo(visitedBg);
    }];
    [monthBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(yearBg.mas_bottom).offset(10);
        make.left.right.height.mas_equalTo(yearBg);
    }];
    
    [self getMyBuleItem:myBuleNumBg withTitle:@"蓝海客户数" withTitleColor:[Config stringTOColor:@"#308AF5"] withSum:@"7856" withNum:@"7856"];
    [self getMyBuleItem:visitedBg withTitle:@"已走访" withTitleColor:[Config stringTOColor:@"#4ED1F8"] withSum:@"7856" withNum:@"2865"];
    [self getMyBuleItem:yearBg withTitle:@"本年新增" withTitleColor:[Config stringTOColor:@"#F19834"] withSum:@"7856" withNum:@"3354"];
    [self getMyBuleItem:monthBg withTitle:@"本月新增" withTitleColor:[Config stringTOColor:@"#613CF4"] withSum:@"7856" withNum:@"765"];
    
    UIView *percentageBg = [[UIView alloc] init];
//    percentageBg.backgroundColor = [UIColor redColor];
    
    [downView addSubview:percentageBg];
    
    [percentageBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(myBule.mas_left).offset(170);
        make.top.mas_equalTo(monthBg.mas_bottom);
        make.right.height.mas_equalTo(monthBg);
    }];
    
    NSMutableArray *perItemAry = [NSMutableArray array];
    NSMutableArray *perLineAry = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        UILabel *perItem = [[UILabel alloc] init];
        [percentageBg addSubview:perItem];
        NSString *str = [NSString stringWithFormat:@"%d%%",(i+1)*20];
        perItem.text = str;
        perItem.textAlignment = 2;
        perItem.textColor = [Config stringTOColor:@"#555555"];
        perItem.font = [UIFont fontWithName:@"Helvetica" size:13];
        [perItemAry addObject:perItem];
    }
    
    [perItemAry mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    
    // 设置array的垂直方向的约束
    [perItemAry mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.top.height.equalTo(percentageBg);
    }];
    
    for (int i = 0; i<5; i++) {
        UILabel *perItem = [perItemAry objectAtIndex:i];
        
        UILabel *lineItem = [[UILabel alloc] init];
        [percentageBg addSubview:lineItem];
        lineItem.backgroundColor = [Config stringTOColor:@"#E0E0E0"];
        
        [lineItem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@190);
            make.top.equalTo(percentageBg.mas_top).offset(-190);
            make.right.equalTo(perItem.mas_right);
            make.width.equalTo(@1);
        }];
    }
}

- (void)developeView{
    UILabel * developeTitleLab = [[UILabel alloc] init];
    developeTitleLab.text = @"重点关注";
    developeTitleLab.textAlignment = 1;
    developeTitleLab.textColor = [Config stringTOColor:@"#474858"];
    developeTitleLab.font = [UIFont fontWithName:@"Helvetica" size:15];
    developeTitleLab.backgroundColor = [UIColor whiteColor];
    [downView addSubview:developeTitleLab];
    
    [developeTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(developeBgView);
        make.width.mas_equalTo(@100);
        make.centerY.mas_equalTo(developeBgView.mas_top);
        make.height.equalTo(@30);
    }];
    
    [self addSubview:self.devShareBgView];
    [self addSubview:self.devMoveBgView];
    [self addSubview:self.devIptvBgView];
    [self addSubview:self.devBoardbandBgView];
    
    [devBoardbandBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(developeTitleLab.mas_bottom);
        make.left.equalTo(developeBgView.mas_left).offset(10);
        make.bottom.mas_equalTo(developeBgView.mas_bottom).offset(-20);
        make.width.equalTo(devMoveBgView);
    }];
    
    [devMoveBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(devBoardbandBgView);
        make.left.equalTo(devBoardbandBgView.mas_right);
        make.bottom.mas_equalTo(devBoardbandBgView);
        make.right.equalTo(developeBgView.mas_centerX);
        make.width.equalTo(devMoveBgView);
    }];
    [devIptvBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(devBoardbandBgView);
        make.left.equalTo(developeBgView.mas_centerX);
        make.bottom.mas_equalTo(devBoardbandBgView);
        make.right.equalTo(devShareBgView.mas_left);
        make.width.equalTo(devShareBgView);
    }];
    [devShareBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(devBoardbandBgView);
        make.bottom.mas_equalTo(devBoardbandBgView);
        make.right.equalTo(developeBgView.mas_right).offset(-10);
        make.width.equalTo(devIptvBgView);
    }];
    
    [self getDevItem:devBoardbandBgView withIcon:@"devBoardBand" withStr:@"宽带" withSum:@"35291" withChange:@"23"];
    [self getDevItem:devMoveBgView withIcon:@"devMove" withStr:@"移动" withSum:@"35291" withChange:@"23"];
    [self getDevItem:devIptvBgView withIcon:@"devIptv" withStr:@"天翼高清" withSum:@"35291" withChange:@"23"];
    [self getDevItem:devShareBgView withIcon:@"devShare" withStr:@"商企分享" withSum:@"35291" withChange:@"23"];
}

- (void)getDevItem:(UIView *)bgView withIcon:(NSString *)imgName withStr:(NSString *)title withSum:(NSString *)sum withChange:(NSString *)changeNum{
    UIImageView *iconi = [[UIImageView alloc] init];
    UILabel *titleLab = [[UILabel alloc] init];
    UILabel *sumLab = [[UILabel alloc] init];
    UILabel *changeLab = [[UILabel alloc] init];
    UIImageView *changeImg = [[UIImageView alloc] init];
    [bgView addSubview:iconi];
    [bgView addSubview:titleLab];
    [bgView addSubview:sumLab];
    [bgView addSubview:changeLab];
    [bgView addSubview:changeImg];
    
    [iconi setImage:[UIImage imageNamed:imgName]];
    
    titleLab.textAlignment = 1;
    titleLab.textColor = [Config stringTOColor:@"#3A84D0"];
    titleLab.text = title;
    titleLab.font = [UIFont fontWithName:@"Helvetica" size:15];
    
    
    sumLab.textAlignment = 1;
    sumLab.textColor = [Config stringTOColor:@"#021129"];
    sumLab.text = sum;
    sumLab.font = [UIFont fontWithName:@"Helvetica" size:20];
    
    changeLab.textAlignment = 2;
    changeLab.textColor = [Config stringTOColor:@"#021129"];
    changeLab.text = changeNum;
    changeLab.font = [UIFont fontWithName:@"Helvetica" size:15];
    
    iconi.backgroundColor = [UIColor whiteColor];
    titleLab.backgroundColor = [UIColor whiteColor];
    sumLab.backgroundColor = [UIColor whiteColor];
    changeLab.backgroundColor = [UIColor whiteColor];
    changeImg.backgroundColor = [UIColor orangeColor];
    
    [iconi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgView.mas_centerX);
        make.width.height.mas_equalTo(35);
        make.top.mas_equalTo(bgView.mas_top).offset(20);
    }];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgView.mas_centerX);
        make.width.mas_equalTo(bgView);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(iconi.mas_bottom).offset(5);
    }];
    [sumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgView.mas_centerX);
        make.width.mas_equalTo(bgView);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(titleLab.mas_bottom).offset(5);
    }];
    [changeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView.mas_left);
        make.right.mas_equalTo(bgView.mas_centerX).offset(10);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(sumLab.mas_bottom);
    }];
    [changeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(changeLab.mas_right).offset(5);
        make.width.height.mas_equalTo(20);
        make.centerY.mas_equalTo(changeLab.mas_centerY);
    }];
    
}

-(void)getFluItem:(UIView *)bgView withIcon:(NSString *)imgName withStr:(NSString *)title withNum:(NSString *)sum{
    UIImageView *topRightImg = [[UIImageView alloc] init];
    UIImageView *iconi = [[UIImageView alloc] init];
    UILabel *titleLab = [[UILabel alloc] init];
    UILabel *sumLab = [[UILabel alloc] init];
    
    [bgView addSubview:topRightImg];
    [bgView addSubview:iconi];
    [bgView addSubview:titleLab];
    [bgView addSubview:sumLab];
    
    [topRightImg setImage:[UIImage imageNamed:@"earlyWarn"]];
    
    [iconi setImage:[UIImage imageNamed:imgName]];
    
    titleLab.textAlignment = 1;
    titleLab.textColor = [Config stringTOColor:@"#6A6B6E"];
    titleLab.text = title;
    titleLab.font = [UIFont fontWithName:@"Helvetica" size:15];
    
    
    sumLab.textAlignment = 1;
    sumLab.textColor = [Config stringTOColor:@"#00000"];
    sumLab.text = sum;
    sumLab.font = [UIFont fontWithName:@"Helvetica-Oblique" size:20];
    
    iconi.backgroundColor = [UIColor clearColor];
    titleLab.backgroundColor = [UIColor clearColor];
    sumLab.backgroundColor = [UIColor clearColor];
    
    [topRightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(bgView);
        make.width.height.mas_equalTo(40);
    }];
    
    [iconi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgView.mas_centerX);
        make.width.height.mas_equalTo(38);
        make.top.mas_equalTo(bgView.mas_top).offset(10);
    }];
    
    [sumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgView.mas_centerX);
        make.width.mas_equalTo(bgView);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(iconi.mas_bottom).offset(10);
    }];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgView.mas_centerX);
        make.width.mas_equalTo(bgView);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(sumLab.mas_bottom).offset(5);
    }];
    
    
    [topRightImg layoutIfNeeded];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:topRightImg.bounds byRoundingCorners:UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = topRightImg.bounds;
    maskLayer.path = maskPath.CGPath;
    topRightImg.layer.mask = maskLayer;
    
    
}

- (void)getMyBule{
    
}
- (void)getMyBuleItem:(UIView *)bgView withTitle:(NSString *)title withTitleColor:(UIColor *)tColor withSum:(NSString *)sum withNum:(NSString *)num{
    UILabel *titleLab = [[UILabel alloc] init];
    UILabel *numLab = [[UILabel alloc] init];
    UILabel *sumLab = [[UILabel alloc] init];
    UILabel *imgLab = [[UILabel alloc] init];
    
    [bgView addSubview:titleLab];
    [bgView addSubview:numLab];
    [bgView addSubview:sumLab];
    [bgView addSubview:imgLab];
    
    titleLab.text = title;
    titleLab.textColor = [Config stringTOColor:@"9A9A9A"];
    titleLab.textAlignment = 2;
    titleLab.font = [UIFont fontWithName:@"Helvetica" size:15];
    
    numLab.text = num;
    numLab.textColor = tColor;
    numLab.textAlignment = 1;
    numLab.font = [UIFont fontWithName:@"Helvetica" size:15];
    
    sumLab.backgroundColor = [UIColor clearColor];
    
    imgLab.backgroundColor = tColor;
    imgLab.layer.cornerRadius = 5;
    imgLab.layer.masksToBounds = YES;
    
    float sumFl = [sum floatValue];
    float numFl = [num floatValue];
    
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(bgView);
        make.width.equalTo(@100);
    }];
    
    [numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLab.mas_right).offset(5);
        make.width.mas_equalTo(60);
        make.top.bottom.mas_equalTo(titleLab);
    }];
    
    [sumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bgView.mas_right);
        make.left.mas_equalTo(numLab.mas_right).offset(5);
        make.centerY.mas_equalTo(titleLab);
        make.height.mas_equalTo(10);
    }];
    
    [imgLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.mas_equalTo(sumLab);
        make.width.equalTo(sumLab.mas_width).multipliedBy(numFl/sumFl);
    }];
    
    
}
/**
 *  给UITextField设置右侧的图片
 *
 *  @param textField UITextField
 *  @param imageName 图片名称
 */
-(void)setRightViewWithTextField:(UITextField *)textField imageName:(NSString *)imageName withImg:(NSString *)img{
    UIView *reght = [[UIView alloc] init];
//    reght.backgroundColor = [UIColor redColor];
    [reght setBounds:CGRectMake(0, 0, 80, 40)];
    
    UIImageView *image1 = [[UIImageView alloc]init];
    image1.image = [UIImage imageNamed:imageName];
    [image1 setFrame:CGRectMake(0, 0, 40, 40)];
//    image1.contentMode = UIViewContentModeCenter;
    UIImageView *image2 = [[UIImageView alloc]init];
    image2.image = [UIImage imageNamed:img];
    [image2 setFrame:CGRectMake(40, 0, 40, 40)];
//    image2.contentMode = UIViewContentModeCenter;
    [reght addSubview:image1];
    [reght addSubview:image2];
//    reght.contentMode = UIViewContentModeCenter;
    
    textField.rightView = reght;
    textField.rightViewMode = UITextFieldViewModeAlways;
    
}

/**
 *  给UITextField设置左侧的图片
 *
 *  @param textField UITextField
 *  @param imageName 图片名称
 */
-(void)setLeftViewWithTextField:(UITextField *)textField imageName:(NSString *)imageName{
    
    UIView *left = [[UIView alloc] init];
    //    reght.backgroundColor = [UIColor redColor];
    [left setBounds:CGRectMake(0, 0, 40, 40)];
    
    UIImageView *leftView = [[UIImageView alloc]init];
    leftView.image = [UIImage imageNamed:imageName];
    [leftView setFrame:CGRectMake(0, 0, 40, 40)];
    [left addSubview:leftView];
//    leftView.contentMode = UIViewContentModeCenter;
    textField.leftView = left;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
}

- (UIView *)menuView
{
    if (menuView == nil) {
        UIView *av = [[UIView alloc] init];
        [av setBackgroundColor:[UIColor whiteColor]];
        av.layer.cornerRadius = 10;
//        av.layer.masksToBounds = YES;
        av.layer.shadowColor = [UIColor blackColor].CGColor;
    //        self.layer.shadowOffset = CGSizeMake(3, 3);//有偏移量的情况,默认向右向下有阴影
        av.layer.shadowOffset = CGSizeZero; //设置偏移量为0,四周都有阴影
        av.layer.shadowRadius = 5.0f;//阴影半径，默认3
        av.layer.shadowOpacity = 0.3f;//阴影透明度，默认0
        av.layer.masksToBounds = NO;
        
        menuView = av;
    }
    return menuView;
}

- (UIView *)upBgView
{
    if (upBgView == nil) {
        UIView *av = [[UIView alloc] init];
        av.backgroundColor = [UIColor whiteColor];
        upBgView = av;
    }
    return upBgView;
}

- (UIView *)taskBgView
{
    if (taskBgView == nil) {
        UIView *av = [[UIView alloc] init];
        [av setBackgroundColor:[UIColor whiteColor]];
        av.layer.cornerRadius = 10;

        av.layer.shadowColor = [UIColor blackColor].CGColor;
    //        self.layer.shadowOffset = CGSizeMake(3, 3);//有偏移量的情况,默认向右向下有阴影
        av.layer.shadowOffset = CGSizeZero; //设置偏移量为0,四周都有阴影
        av.layer.shadowRadius = 5.0f;//阴影半径，默认3
        av.layer.shadowOpacity = 0.3f;//阴影透明度，默认0
        av.layer.masksToBounds = NO;
        taskBgView = av;
    }
    return taskBgView;
}

- (UIView *)repairBgView
{
    if (repairBgView == nil) {
        UIView *av = [[UIView alloc] init];
        [av setBackgroundColor:[Config stringTOColor:@"#43B8E9"]];
        av.layer.cornerRadius = 10;

        av.layer.shadowColor = [UIColor blackColor].CGColor;
    //        self.layer.shadowOffset = CGSizeMake(3, 3);//有偏移量的情况,默认向右向下有阴影
        av.layer.shadowOffset = CGSizeZero; //设置偏移量为0,四周都有阴影
        av.layer.shadowRadius = 5.0f;//阴影半径，默认3
        av.layer.shadowOpacity = 0.3f;//阴影透明度，默认0
        av.layer.masksToBounds = NO;
        repairBgView = av;
    }
    return repairBgView;
}

- (UIView *)faultBgView
{
    if (faultBgView == nil) {
        UIView *av = [[UIView alloc] init];
        [av setBackgroundColor:[Config stringTOColor:@"#7456F5"]];
        av.layer.cornerRadius = 10;

        av.layer.shadowColor = [UIColor blackColor].CGColor;
    //        self.layer.shadowOffset = CGSizeMake(3, 3);//有偏移量的情况,默认向右向下有阴影
        av.layer.shadowOffset = CGSizeZero; //设置偏移量为0,四周都有阴影
        av.layer.shadowRadius = 5.0f;//阴影半径，默认3
        av.layer.shadowOpacity = 0.3f;//阴影透明度，默认0
        av.layer.masksToBounds = NO;
        faultBgView = av;
    }
    return faultBgView;
}

- (UIView *)complaintBgView
{
    if (complaintBgView == nil) {
        UIView *av = [[UIView alloc] init];
        [av setBackgroundColor:[Config stringTOColor:@"#EC7C76"]];
        av.layer.cornerRadius = 10;

        av.layer.shadowColor = [UIColor blackColor].CGColor;
    //        self.layer.shadowOffset = CGSizeMake(3, 3);//有偏移量的情况,默认向右向下有阴影
        av.layer.shadowOffset = CGSizeZero; //设置偏移量为0,四周都有阴影
        av.layer.shadowRadius = 5.0f;//阴影半径，默认3
        av.layer.shadowOpacity = 0.3f;//阴影透明度，默认0
        av.layer.masksToBounds = NO;
        complaintBgView = av;
    }
    return complaintBgView;
}
- (UIView *)visitBgView
{
    if (visitBgView == nil) {
        UIView *av = [[UIView alloc] init];
        av.backgroundColor = [UIColor whiteColor];
        
        visitBgView = av;
    }
    return visitBgView;
}

- (UIView *)callBgView
{
    if (callBgView == nil) {
        UIView *av = [[UIView alloc] init];
        av.backgroundColor = [UIColor whiteColor];
        
        callBgView = av;
    }
    return callBgView;
}

- (UIView *)bordbandBgView
{
    if (bordbandBgView == nil) {
        UIView *av = [[UIView alloc] init];
        av.backgroundColor = [UIColor whiteColor];
        
        bordbandBgView = av;
    }
    return bordbandBgView;
}

- (UIView *)expirBgView
{
    if (expirBgView == nil) {
        UIView *av = [[UIView alloc] init];
        av.backgroundColor = [UIColor whiteColor];
        
        expirBgView = av;
    }
    return expirBgView;
}

- (UIView *)downView
{
    if (downView == nil) {
        UIView *av = [[UIView alloc] init];
        av.backgroundColor = [UIColor whiteColor];
        
        downView = av;
    }
    return downView;
}

- (UIView *)developeBgView
{
    if (developeBgView == nil) {
        UIView *av = [[UIView alloc] init];
        av.backgroundColor = [UIColor whiteColor];
        av.layer.cornerRadius = 10;
        av.layer.borderColor = [Config stringTOColor:@"#DFE5EC"].CGColor;
        av.layer.borderWidth = 2;
        developeBgView = av;
    }
    return developeBgView;
}

- (UIView *)devIptvBgView
{
    if (devIptvBgView == nil) {
        UIView *av = [[UIView alloc] init];
        av.backgroundColor = [UIColor whiteColor];
        
        devIptvBgView = av;
    }
    return devIptvBgView;
}

- (UIView *)devMoveBgView
{
    if (devMoveBgView == nil) {
        UIView *av = [[UIView alloc] init];
        av.backgroundColor = [UIColor whiteColor];
        
        devMoveBgView = av;
    }
    return devMoveBgView;
}

- (UIView *)devBoardbandBgView
{
    if (devBoardbandBgView == nil) {
        UIView *av = [[UIView alloc] init];
        av.backgroundColor = [UIColor whiteColor];
        
        devBoardbandBgView = av;
    }
    return devBoardbandBgView;
}

- (UIView *)devShareBgView
{
    if (devShareBgView == nil) {
        UIView *av = [[UIView alloc] init];
        av.backgroundColor = [UIColor whiteColor];
        
        devShareBgView = av;
    }
    return devShareBgView;
}

- (UIView *)incomeFluBgView
{
    if (incomeFluBgView == nil) {
        UIView *av = [[UIView alloc] init];
        [av setBackgroundColor:[Config stringTOColor:@"#F1F4FA"]];
        av.layer.cornerRadius = 10;

        incomeFluBgView = av;
    }
    return incomeFluBgView;
}

- (UIView *)volumeFluBgView
{
    if (volumeFluBgView == nil) {
        UIView *av = [[UIView alloc] init];
        [av setBackgroundColor:[Config stringTOColor:@"#F1F4FA"]];
        av.layer.cornerRadius = 10;

        volumeFluBgView = av;
    }
    return volumeFluBgView;
}

- (UIView *)assetsFluBgView
{
    if (assetsFluBgView == nil) {
        UIView *av = [[UIView alloc] init];
        [av setBackgroundColor:[Config stringTOColor:@"#F1F4FA"]];
        av.layer.cornerRadius = 10;

        assetsFluBgView = av;
    }
    return assetsFluBgView;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
