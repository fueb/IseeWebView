//
//  IseeProdCell.m
//  IseeWebView
//
//  Created by 点芯在线 on 2020/8/25.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import "IseeProdCell.h"
#import <Masonry.h>

#import "IseeConfig.h"

@interface IseeProdCell ()
{
    UILabel     *stateNameLab;         //交易单号标签
    UILabel     *productTypeLab;           //支付时间标签
    UILabel     *accNbrLab;    //支付金额标签
}
@end

@implementation IseeProdCell


- (void)setModel:(IseeProdModel *)model
{
    _model = model;
    [self addSubview:self.stateNameLab];
    [self addSubview:self.productTypeLab];
    [self addSubview:self.accNbrLab];

    CGFloat stateWidth = 100;
    if ([model.stateName isEqualToString:@"正常"]) {
        [stateNameLab setBackgroundColor:[IseeConfig stringTOColor:@"#EAFDCE"]];
        [stateNameLab setTextColor:[IseeConfig stringTOColor:@"#95E653"]];
        stateWidth = 40.0f;
    }
    else if ([model.stateName isEqualToString:@"拆机"]) {
        [stateNameLab setBackgroundColor:[IseeConfig stringTOColor:@"#F4F4F4"]];
        [stateNameLab setTextColor:[IseeConfig stringTOColor:@"#6E6E6E"]];
        stateWidth = 40.0f;
    }
    else if ([model.stateName isEqualToString:@"在用"]) {
        [stateNameLab setBackgroundColor:[IseeConfig stringTOColor:@"#E3F1FD"]];
        [stateNameLab setTextColor:[IseeConfig stringTOColor:@"#62A3E0"]];
        stateWidth = 40.0f;
    }
    else if ([model.stateName isEqualToString:@"主动停机"]) {
        [stateNameLab setBackgroundColor:[IseeConfig stringTOColor:@"#FDEED8"]];
        [stateNameLab setTextColor:[IseeConfig stringTOColor:@"#F1B988"]];
        stateWidth = 70.0f;
    }
    else if ([model.stateName isEqualToString:@"欠费双向停机"]) {
        [stateNameLab setBackgroundColor:[IseeConfig stringTOColor:@"#F9DEDF"]];
        [stateNameLab setTextColor:[IseeConfig stringTOColor:@"#E2757B"]];
        stateWidth = 100.0f;
    }
    
    [stateNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.left.equalTo(@15);
        make.height.equalTo(@25);
        make.width.equalTo(@(stateWidth));
    }];
    
    [productTypeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(stateNameLab);
        make.left.equalTo(stateNameLab.mas_right).offset(10);
        make.width.equalTo(@100);
    }];
    
    [accNbrLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-15);
        make.top.height.equalTo(stateNameLab);
        make.left.equalTo(productTypeLab.mas_right).offset(10);
    }];
    

}

- (UILabel *)stateNameLab
{
    if (!stateNameLab)
    {
        stateNameLab      = [[UILabel alloc]init];
        stateNameLab.font = [UIFont systemFontOfSize:15];
        stateNameLab.textColor = [IseeConfig stringTOColor:@"#BBBBBB"];
        stateNameLab.text = _model.stateName;
        stateNameLab.layer.cornerRadius = 5;
        stateNameLab.layer.masksToBounds = YES;
        stateNameLab.textAlignment = 1;
        
    }
    return stateNameLab;
}

- (UILabel *)productTypeLab
{
    if (!productTypeLab)
    {
        productTypeLab      = [[UILabel alloc]init];
        productTypeLab.font = [UIFont systemFontOfSize:15];
        productTypeLab.text = _model.productType;
        productTypeLab.textColor = [IseeConfig stringTOColor:@"#BBBBBB"];
        
        productTypeLab.numberOfLines = 0;
    }
    return productTypeLab;
}

- (UILabel *)accNbrLab
{
    if (!accNbrLab)
    {
        accNbrLab      = [[UILabel alloc]init];
        accNbrLab.font = [UIFont systemFontOfSize:15];
        
        accNbrLab.text = _model.accNbr;
    }
    return accNbrLab;
}


@end
