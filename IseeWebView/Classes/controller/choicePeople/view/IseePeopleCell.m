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
}

@end

@implementation IseePeopleCell

- (void)setModel:(NSString *)model
{
    _model = model;
    [self addSubview:self.userNameLab];
   
    
    [userNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.left.equalTo(@25);
        make.height.equalTo(@20);
        make.right.equalTo(@10);
        
    }];



}

- (UILabel *)userNameLab
{
    if (!userNameLab)
    {
        userNameLab      = [[UILabel alloc]init];
        userNameLab.font = [UIFont systemFontOfSize:15];
        userNameLab.textColor = [IseeConfig stringTOColor:@"#636363"];
        userNameLab.text = _model;
        userNameLab.layer.opacity = 0.68;
    }
    return userNameLab;
}

@end
