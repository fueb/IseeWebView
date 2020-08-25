//
//  IseeProdModel.m
//  IseeWebView
//
//  Created by 点芯在线 on 2020/8/25.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import "IseeProdModel.h"

@implementation IseeProdModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (void)setLatnId:(NSString *)latnId
{
    _latnId = latnId;
    NSString *latn_id = [NSString stringWithFormat:@"%@",latnId];
    if ([latn_id isEqualToString:@"77"])
    {
        
        _latName = @"温州市";
    }
    else if ([latn_id isEqualToString:@"72"])
    {
        
        _latName = @"湖州市";
    }
    else if ([latn_id isEqualToString:@"73"])
    {
        
        _latName = @"嘉兴市";
    }
    else if ([latn_id isEqualToString:@"80"])
    {
        
        _latName = @"舟山市";
    }
    else if ([latn_id isEqualToString:@"71"])
    {
        
        _latName = @"杭州市";
    }
    else if ([latn_id isEqualToString:@"75"])
    {
        
        _latName = @"绍兴市";
    }
    else if ([latn_id isEqualToString:@"74"])
    {
        
        _latName = @"宁波市";
    }
    else if ([latn_id isEqualToString:@"70"])
    {
        
        _latName = @"衢州市";
    }
    else if ([latn_id isEqualToString:@"79"])
    {
        
        _latName = @"金华市";
    }
    else if ([latn_id isEqualToString:@"76"])
    {
        
        _latName = @"台州市";
    }
    else if ([latn_id isEqualToString:@"78"])
    {
        
        _latName = @"丽水市";
    }
}
@end
