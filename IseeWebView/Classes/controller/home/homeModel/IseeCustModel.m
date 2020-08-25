//
//  BillModel.m
//  EPay
//
//  Created by strong on 17/5/12.
//  Copyright © 2017年 strong. All rights reserved.
//

#import "IseeCustModel.h"

@implementation IseeCustModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
- (void)setLatn_id:(NSString *)latn_ids
{
    _latn_id = latn_ids;
    NSString *latn_id = [NSString stringWithFormat:@"%@",latn_ids];
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
