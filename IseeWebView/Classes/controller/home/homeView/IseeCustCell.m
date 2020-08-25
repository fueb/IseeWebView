//
//  IseeCustCell.m
//  IseeWebView
//
//  Created by 点芯在线 on 2020/8/25.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import "IseeCustCell.h"
#import <Masonry.h>

#import "IseeConfig.h"

@interface IseeCustCell ()
{
        UILabel     *idTypeNameLab;         //交易单号标签
        UILabel     *serNameLab;           //支付时间标签
        UILabel     *serIdLab;    //支付金额标签
}
@end

@implementation IseeCustCell


- (void)setModel:(IseeCustModel *)model
{
    _model = model;
    [self addSubview:self.idTypeNameLab];
    [self addSubview:self.serNameLab];
    [self addSubview:self.serIdLab];

    
    [idTypeNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@5);
        make.left.equalTo(@15);
        make.height.equalTo(@45);
        make.width.equalTo(@100);
    }];
    
    [serNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(idTypeNameLab);
        make.left.equalTo(idTypeNameLab.mas_right).offset(10);
        make.right.equalTo(serIdLab.mas_left).offset(-10);
    }];
    
    [serIdLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-15);
        make.top.height.equalTo(idTypeNameLab);
        make.width.equalTo(@100);
    }];
    

}

- (UILabel *)idTypeNameLab
{
    if (!idTypeNameLab)
    {
        idTypeNameLab      = [[UILabel alloc]init];
        idTypeNameLab.font = [UIFont systemFontOfSize:15];
        idTypeNameLab.textColor = [IseeConfig stringTOColor:@"#BBBBBB"];
        idTypeNameLab.text = [NSString stringWithFormat:@"%@-%@",_model.latName,_model.id_type_name];
    }
    return idTypeNameLab;
}

- (UILabel *)serNameLab
{
    if (!serNameLab)
    {
        serNameLab      = [[UILabel alloc]init];
        serNameLab.font = [UIFont systemFontOfSize:15];
        serNameLab.text = _model.ser_name;
        serNameLab.numberOfLines = 0;
    }
    return serNameLab;
}

- (UILabel *)serIdLab
{
    if (!serIdLab)
    {
        serIdLab      = [[UILabel alloc]init];
        serIdLab.font = [UIFont systemFontOfSize:15];
        serIdLab.textColor = [IseeConfig stringTOColor:@"#BBBBBB"];
        
        serIdLab.text = _model.ser_id;
    }
    return serIdLab;
}

@end
