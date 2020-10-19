//
//  IseePeopleCell.m
//  IseeWebView
//
//  Created by 余友良 on 2020/10/16.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import "IseePeopleCell.h"
#import <Masonry.h>
#import "IseeConfig.h"

@interface IseePeopleCell()
{
    UILabel *userNameLab;
    UIImageView *icon;
    UILabel *companyLab;
}

@end

@implementation IseePeopleCell

- (void)setModel:(IseePeopleModel *)model
{
    _model = model;
    [self addSubview:self.icon];
    [self addSubview:self.userNameLab];
    [self addSubview:self.companyLab];
    
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.left.equalTo(@25);
        make.height.equalTo(@20);
        make.width.equalTo(@20);
    }];
    [userNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.left.equalTo(icon.mas_right).with.offset(22);
        make.height.equalTo(@20);
        make.width.equalTo(@100);
        
    }];
    [companyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.right.equalTo(@-20);
        make.left.mas_equalTo(userNameLab.mas_right);
        make.height.equalTo(@20);
    }];


}

- (UILabel *)userNameLab
{
    if (!userNameLab)
    {
        userNameLab      = [[UILabel alloc]init];
        userNameLab.font = [UIFont fontWithName:@"PingFangSC" size:14];
        userNameLab.textColor = [IseeConfig stringTOColor:@"#262C33"];
        userNameLab.text = _model.staffName;
        userNameLab.textAlignment = NSTextAlignmentLeft;
        userNameLab.alpha = 1.0;

    }
    return userNameLab;
}
- (UILabel *)companyLab
{
    if (!companyLab)
    {
        companyLab      = [[UILabel alloc]init];
        companyLab.font = [UIFont fontWithName:@"PingFangSC" size:14];
        companyLab.textColor = [IseeConfig stringTOColor:@"#888A9D"];
        companyLab.text = _model.areaName;
        companyLab.textAlignment = NSTextAlignmentRight;
        companyLab.alpha = 1.0;

    }
    return companyLab;
}
- (UIImageView *)icon
{
    if (!icon)
    {
        icon      = [[UIImageView alloc]init];
        icon.image = [IseeConfig imageNamed:@"custManageIcon.svg" size:CGSizeMake(20, 20)];
    }
    return icon;
}

@end
