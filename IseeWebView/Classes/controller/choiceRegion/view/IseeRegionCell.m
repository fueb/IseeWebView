//
//  IseeRegionCell.m
//  IseeWebView
//
//  Created by 点芯在线 on 2020/9/8.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import "IseeRegionCell.h"
#import <Masonry.h>
#import "IseeConfig.h"
@interface IseeRegionCell ()
{
        UILabel     *areaNameLab;         //交易单号标签
        UILabel     *regionLab;           //支付时间标签
    UIImageView     *iconImg;
}
@end

@implementation IseeRegionCell

- (void)setModel:(IseeRegionModel *)model
{
    _model = model;
    [self addSubview:self.areaNameLab];
    [self addSubview:self.iconImg];

    
    [areaNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.left.equalTo(@25);
        make.height.equalTo(@20);
        make.right.equalTo(iconImg.mas_left);
        
    }];

    
    [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10);
        make.width.equalTo(@15);
        make.height.equalTo(@20);
        make.top.equalTo(areaNameLab);
    }];
    
    [iconImg setImage:[IseeConfig imageNamed:@"forward" size:CGSizeMake(15, 20)]];
    

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
