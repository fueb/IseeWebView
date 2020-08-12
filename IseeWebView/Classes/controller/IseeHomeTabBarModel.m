//
//  IseeHomeTabBarModel.m
//  IseeWebView
//
//  Created by 点芯在线 on 2020/8/12.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import "IseeHomeTabBarModel.h"
#import "IseeAFNetRequest.h"
#import "IseeConfig.h"

@implementation IseeHomeTabBarModel
- (void)isee_loginWith:(NSString *)managerId
         withStaffCode:(NSString *)staffCode
               Success:(void (^)(id result))success
               failure:(void (^)(void))failed
{
    NSMutableDictionary *sendDict = [[NSMutableDictionary alloc]init];


    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    // 设置想要的格式，hh与HH的区别:分别表示12小时制,24小时制

    [formatter setDateFormat:@"YYYYMMddHHmmss"];

    NSDate *dateNow = [NSDate date];

    //把NSDate按formatter格式转成NSString
    NSString *currentTime = [formatter stringFromDate:dateNow];
    [sendDict setObject:managerId forKey:@"managerId"];
    [sendDict setObject:staffCode forKey:@"staffCode"];
    [sendDict setObject:currentTime forKey:@"timestamp"];
    
    NSString *md5Str = [NSString stringWithFormat:@"%@%@1!9@3#6$8%%9z",staffCode,currentTime];
    
    
    [sendDict setObject:[IseeConfig md5:md5Str] forKey:@"token"];
    
    NSArray *keys = sendDict.allKeys;
    NSArray *values = sendDict.allValues;
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAINNAME,LOGINURL];
    
    for (int i = 0; i < keys.count; i++) {
        if(i == 0)
        {
            urlString = [urlString stringByAppendingFormat:@"?%@=%@",keys[i],values[i]];
        }
        else
        {
            urlString = [urlString stringByAppendingFormat:@"&%@=%@",keys[i],values[i]];
        }
    }
    
    [IseeAFNetRequest requestWithURLString:urlString parameters:sendDict type:RequestTypePost success:success failure:^(id error) {
        //请求失败
        
        NSLog(@"%@", error);
        failed();
    }];

}
@end
