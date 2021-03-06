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
- (void)isee_homeMenuWith:(NSMutableDictionary *)param
                  Success:(void (^)(id result))success
                  failure:(void (^)(void))failed
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAINNAME,HOMEMENU];
    NSArray *keys = param.allKeys;
    NSArray *values = param.allValues;
    
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
    
    [IseeAFNetRequest requestWithURLString:urlString parameters:param type:RequestTypePost success:success failure:^(id error) {
        //请求失败
        
        NSLog(@"%@", error);
        failed();
    }];

}

- (void)isee_myTaskWithParam:(NSMutableDictionary *)param
                WithSuccess:(void (^)(id result))success
                    failure:(void (^)(void))failed
{
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAINNAME,MYTASK];
    NSArray *keys = param.allKeys;
    NSArray *values = param.allValues;
    
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
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAINNAME,GETDEALCOUNT];
    
    NSArray *keys = param.allKeys;
    NSArray *values = param.allValues;
    
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
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAINNAME,KEYPOINT];
    
    NSArray *keys = param.allKeys;
    NSArray *values = param.allValues;
    
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
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAINNAME,CUSTOMLOST];
    
    NSArray *keys = param.allKeys;
    NSArray *values = param.allValues;
    
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
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAINNAME,MYBULE];
    NSArray *keys = param.allKeys;
    NSArray *values = param.allValues;
    
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
    
    [IseeAFNetRequest requestWithURLString:urlString parameters:param type:RequestTypePost success:success failure:^(id error) {
        //请求失败
        
        NSLog(@"%@", error);
        failed();
    }];

}

- (void)isee_findCustMsgWithParam:(NSMutableDictionary *)param
                      WithSuccess:(void (^)(id result))success
                          failure:(void (^)(void))failed
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAINNAME,FINDCUST];
    NSArray *keys = param.allKeys;
    NSArray *values = param.allValues;
    
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
    
    [IseeAFNetRequest requestWithURLString:urlString parameters:param type:RequestTypePost success:success failure:^(id error) {
        //请求失败
        
        NSLog(@"%@", error);
        failed();
    }];
}

- (void)isee_findProdWithParam:(NSMutableDictionary *)param
                   WithSuccess:(void (^)(id result))success
                       failure:(void (^)(void))failed
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAINNAME,FINDPROD];
    NSArray *keys = param.allKeys;
    NSArray *values = param.allValues;
    
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
    
    [IseeAFNetRequest requestWithURLString:urlString parameters:param type:RequestTypePost success:success failure:^(id error) {
        //请求失败
        
        NSLog(@"%@", error);
        failed();
    }];
}

- (void)isee_findProductWithParam:(NSMutableDictionary *)param
                      WithSuccess:(void (^)(id result))success
                          failure:(void (^)(void))failed
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAINNAME,FINDPRODUCT];
    NSArray *keys = param.allKeys;
    NSArray *values = param.allValues;
    
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
    
    [IseeAFNetRequest requestWithURLString:urlString parameters:param type:RequestTypePost success:success failure:^(id error) {
        //请求失败
        
        NSLog(@"%@", error);
        failed();
    }];
}

- (void)isee_findCrmWithParam:(NSMutableDictionary *)param
                  WithSuccess:(void (^)(id result))success
                      failure:(void (^)(void))failed
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAINNAME,FINDCRM];
    NSArray *keys = param.allKeys;
    NSArray *values = param.allValues;
    
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
    
    [IseeAFNetRequest requestWithURLString:urlString parameters:param type:RequestTypePost success:success failure:^(id error) {
        //请求失败
        
        NSLog(@"%@", error);
        failed();
    }];
}

- (void)isee_findVipWithParam:(NSMutableDictionary *)param
                  WithSuccess:(void (^)(id result))success
                      failure:(void (^)(void))failed
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAINNAME,FINDVIP];
    NSArray *keys = param.allKeys;
    NSArray *values = param.allValues;
    
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
    
    [IseeAFNetRequest requestWithURLString:urlString parameters:param type:RequestTypePost success:success failure:^(id error) {
        //请求失败
        
        NSLog(@"%@", error);
        failed();
    }];
}

- (void)isee_findBlueWithParam:(NSMutableDictionary *)param
                   WithSuccess:(void (^)(id result))success
                       failure:(void (^)(void))failed
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAINNAME,FINDBLUEOCEAN];
    NSArray *keys = param.allKeys;
    NSArray *values = param.allValues;
    
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
    
    [IseeAFNetRequest requestWithURLString:urlString parameters:param type:RequestTypePost success:success failure:^(id error) {
        //请求失败
        
        NSLog(@"%@", error);
        failed();
    }];
}

@end
