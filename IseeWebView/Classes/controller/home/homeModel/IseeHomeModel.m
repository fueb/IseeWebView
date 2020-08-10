//
//  IseeHomeModel.m
//  IseeWebView
//
//  Created by 点芯在线 on 2020/8/10.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import "IseeHomeModel.h"
#import "IseeAFNetRequest.h"

@implementation IseeHomeModel
- (void)isee_homeMenuWithSuccess:(void (^)(id result))success
                        failure:(void (^)(void))failed
{
    NSMutableDictionary *sendDict = [[NSMutableDictionary alloc]init];

    [sendDict setObject:@123 forKey:@"managerId"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAINNAME,HOMEMENU];
    [IseeAFNetRequest requestWithURLString:urlString parameters:sendDict type:RequestTypePost success:success failure:^(id error) {
        //请求失败
        
        NSLog(@"%@", error);
        failed();
    }];

}

- (void)isee_myTaskWithParam:(NSMutableDictionary *)param
                WithSuccess:(void (^)(id result))success
                    failure:(void (^)(void))failed
{
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAINNAME,HOMEMENU];
    [IseeAFNetRequest requestWithURLString:urlString parameters:param type:RequestTypePost success:success failure:^(id error) {
        //请求失败
        
        NSLog(@"%@", error);
        failed();
    }];

}

- (void)isee_querySendOrderWithParam:(NSMutableDictionary *)param
                         WithSuccess:(void (^)(id result))success
                             failure:(void (^)(void))failed
{
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAINNAME,HOMEMENU];
    [IseeAFNetRequest requestWithURLString:urlString parameters:param type:RequestTypePost success:success failure:^(id error) {
        //请求失败
        
        NSLog(@"%@", error);
        failed();
    }];

}

- (void)isee_custInfoWithParam:(NSMutableDictionary *)param
                   WithSuccess:(void (^)(id result))success
                       failure:(void (^)(void))failed
{
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAINNAME,HOMEMENU];
    [IseeAFNetRequest requestWithURLString:urlString parameters:param type:RequestTypePost success:success failure:^(id error) {
        //请求失败
        
        NSLog(@"%@", error);
        failed();
    }];

}
- (void)isee_managerCustomLostWithParam:(NSMutableDictionary *)param
                            WithSuccess:(void (^)(id result))success
                                failure:(void (^)(void))failed
{
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAINNAME,HOMEMENU];
    [IseeAFNetRequest requestWithURLString:urlString parameters:param type:RequestTypePost success:success failure:^(id error) {
        //请求失败
        
        NSLog(@"%@", error);
        failed();
    }];

}

- (void)isee_getBlueCustMsgWithParam:(NSMutableDictionary *)param
                         WithSuccess:(void (^)(id result))success
                             failure:(void (^)(void))failed
{
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAINNAME,HOMEMENU];
    [IseeAFNetRequest requestWithURLString:urlString parameters:param type:RequestTypePost success:success failure:^(id error) {
        //请求失败
        
        NSLog(@"%@", error);
        failed();
    }];

}

@end
