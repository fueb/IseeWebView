//
//  IseeChoiceRegionView.m
//  
//
//  Created by 点芯在线 on 2020/9/8.
//

#import "IseeChoiceRegionView.h"
#import "IseeConfig.h"
#import "IseeNaviBarView.h"
#import <Masonry.h>

@interface IseeChoiceRegionView()

//@property (nonatomic, strong) UITableView *regionTable;
@end

@implementation IseeChoiceRegionView
{
    UITableView *regionTable;
    UIImageView *topBgView;
    UILabel *titleLab;
    UIImageView *iconImg;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    return self;
}

- (void)setModel:(NSMutableArray *)model
{
    [self topView];
    [self getTable];
}

- (void)topView{
    __weak typeof(self) wkSelf = self;
    [self addSubview:self.topBgView];
    [topBgView addSubview:self.titleLab];
    [topBgView addSubview:self.iconImg];
    [topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(wkSelf);
        make.height.mas_equalTo(@208);
    }];
    CGFloat statuHeight = 44.0;
    if (@available(iOS 13.0, *)) {
         UIWindowScene *windowScene = (UIWindowScene *)[UIApplication sharedApplication].connectedScenes.allObjects.firstObject;
         statuHeight = windowScene.statusBarManager.statusBarFrame.size.height;
    } else {
         statuHeight = StatusBarHeight;
    }
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topBgView.mas_top).offset(statuHeight);
        make.left.right.mas_equalTo(topBgView);
        make.height.mas_equalTo(30);
    }];
    [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLab.mas_bottom).offset(26);
        make.height.width.mas_equalTo(@90);
        make.centerX.mas_equalTo(titleLab);
    }];
    [iconImg setImage:[IseeConfig imageNamed:@"choiceRegion" size:CGSizeMake(90, 90)]];
    [topBgView setImage:[IseeConfig imageNamed:@"choiceBg"]];

}
- (void)getTable{
    __weak typeof(self) wkSelf = self;
    [self addSubview:self.regionTable];

    [regionTable mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.bottom.right.mas_equalTo(wkSelf);
        make.top.mas_equalTo(topBgView.mas_bottom);
    }];
}

- (void)reloadTable{
    [regionTable reloadData];
}

#pragma mark view
- (UITableView *)regionTable
{
    if (regionTable == nil)
    {
        regionTable = [[UITableView alloc] init];
        regionTable.backgroundColor = [UIColor whiteColor];
        regionTable.delegate = _mDelegate;
        regionTable.dataSource = _mDelegate;
        regionTable.tableFooterView = [[UIView alloc]init];
    }
    return regionTable;
}
- (UIImageView *)topBgView
{
    if (regionTable == nil)
    {
        topBgView = [[UIImageView alloc] init];
        topBgView.backgroundColor = [UIColor whiteColor];
        
    }
    return topBgView;
}
- (UIView *)titleLab
{
    if (titleLab == nil)
    {
        titleLab = [[UILabel alloc] init];
        titleLab.backgroundColor = [UIColor clearColor];
        titleLab.textColor = [UIColor whiteColor];
        titleLab.textAlignment = 1;
        titleLab.text = @"服务区域";
        [titleLab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:20]];
    }
    return titleLab;
}
- (UIView *)iconImg
{
    if (iconImg == nil)
    {
        iconImg = [[UIImageView alloc] init];
        iconImg.backgroundColor = [UIColor clearColor];
        
    }
    return iconImg;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
