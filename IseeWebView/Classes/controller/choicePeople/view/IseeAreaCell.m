//
//  IseeAreaCell.m
//  IseeWebView
//
//  Created by 余友良 on 2020/10/19.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import "IseeAreaCell.h"
#import <Masonry.h>
#import "IseeConfig.h"

@interface IseeAreaCell()
{
    UILabel *userNameLab;

}
@end

@implementation IseeAreaCell

- (void)setModel:(NSString *)model
{
    _model = model;

    [self addSubview:self.userNameLab];


    [userNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.left.equalTo(@25);
        make.height.equalTo(@20);
        make.right.equalTo(@20);
        
    }];


}

- (UILabel *)userNameLab
{
    if (!userNameLab)
    {
        userNameLab      = [[UILabel alloc]init];
        userNameLab.font = [UIFont fontWithName:@"PingFangSC" size:14];
        userNameLab.textColor = [IseeConfig stringTOColor:@"#262C33"];
        userNameLab.text = _model;
        userNameLab.textAlignment = NSTextAlignmentLeft;
        userNameLab.alpha = 1.0;

    }
    return userNameLab;
}


@end
