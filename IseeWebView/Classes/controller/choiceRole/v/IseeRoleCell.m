//
//  IseeRoleCell.m
//  IseeWebView
//
//  Created by 余友良 on 2020/11/20.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import "IseeRoleCell.h"
#import <Masonry.h>
#import "IseeConfig.h"
@interface IseeRoleCell ()
{
        UILabel     *managerTypeNameLab;         //交易单号标签
        UILabel     *areaNameLab;         //交易单号标签
        UILabel     *regionLab;           //支付时间标签
    UIImageView     *iconImg;
}
@end

@implementation IseeRoleCell

- (void)setModel:(IseeRoleModel *)model
{
    _model = model;
    [self addSubview:self.managerTypeNameLab];
    [self addSubview:self.areaNameLab];
    [self addSubview:self.iconImg];

    
    [managerTypeNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.left.equalTo(@25);
        make.height.equalTo(@20);
        make.width.equalTo(@100);
        
    }];
    
    [areaNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(managerTypeNameLab);
        make.left.equalTo(managerTypeNameLab.mas_right);
        make.right.equalTo(iconImg.mas_left).offset(-10);
    }];

    
    [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10);
        make.width.equalTo(@15);
        make.height.equalTo(@20);
        make.top.equalTo(areaNameLab);
    }];
    
    [iconImg setImage:[IseeConfig imageNamed:@"forward" size:CGSizeMake(15, 20)]];
    

}

- (UILabel *)managerTypeNameLab
{
    if (!managerTypeNameLab)
    {
        managerTypeNameLab      = [[UILabel alloc]init];
        managerTypeNameLab.font = [UIFont systemFontOfSize:15];
        managerTypeNameLab.textColor = [IseeConfig stringTOColor:@"#636363"];
        managerTypeNameLab.text = _model.managerTypeName;
        managerTypeNameLab.layer.opacity = 0.68;
    }
    return managerTypeNameLab;
}

- (UILabel *)areaNameLab
{
    if (!areaNameLab)
    {
        areaNameLab      = [[UILabel alloc]init];
        areaNameLab.font = [UIFont systemFontOfSize:15];
        areaNameLab.textColor = [IseeConfig stringTOColor:@"#636363"];
        areaNameLab.text = _model.areaName;
        areaNameLab.layer.opacity = 0.68;
        areaNameLab.textAlignment = 2;
    }
    return areaNameLab;
}

- (UIImageView *)iconImg
{
    if (!iconImg)
    {
        iconImg      = [[UIImageView alloc]init];
        

    }
    return iconImg;
}


@end
