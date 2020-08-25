//
//  AFNetRequest.m
//  FXYIM
//
//  Created by strong on 17/3/1.
//  Copyright © 2017年 strong. All rights reserved.
//

#import "IseeAFNetRequest.h"
#import "MBProgressHUD.h"
#import "AFAppDotNetAPIClient.h"

@implementation IseeAFNetRequest
static MBProgressHUD *HUD;
+ (void)showHUD:(UIView *)view
{
    [HUD removeFromSuperview];
    HUD = nil;
    HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    [HUD hideAnimated:YES afterDelay:10.0];
//    HUD.activityIndicatorColor = [UIColor whiteColor];
    HUD.label.text = @"请稍等...";
    
    [HUD showAnimated:YES];
    HUD.bezelView.color = [UIColor blackColor];
    HUD.label.textColor = [UIColor whiteColor];
    HUD.bezelView.alpha = 0.7;
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        sleep(30);
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hideAnimated:YES];
        });
    });
}

+ (void)removeHUD
{
    [HUD removeFromSuperview];
    HUD = nil;
}

+ (void)requestWithURLString:(NSString *)URLString
                  parameters:(id)parameters
                        type:(RequestType)type
                     success:(void (^)(id result))success
                     failure:(void (^)(id error))failure
{
    NSLog(@"入参：%@",[[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil]encoding:NSUTF8StringEncoding]);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy        = [self customSecurityPolicy];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html;charset=utf-8",@"text/javascript", nil];
    manager.requestSerializer.timeoutInterval = 20;
    URLString=[URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    switch (type)
    {
        case RequestTypeGet:
        {
            [manager GET:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    [IseeAFNetRequest removeHUD];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;// 关闭网络指示器
                    });
                    if ([responseObject isKindOfClass:[NSDictionary class]])
                    {
                        success(responseObject);
                    }
                    else
                    {
                        id result = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                    options:0
                                                                      error:nil];
                        success(result);
                    }
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [IseeAFNetRequest removeHUD];
                if (failure) {
                    failure(error);
                }
            }];
            
            
        }
            break;
        case RequestTypePost:
        {
            
            [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [IseeAFNetRequest removeHUD];
                if (success)
                {
                    id result = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                options:0
                                                                  error:nil];
                    success(result);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [IseeAFNetRequest removeHUD];
                if (failure)
                {
                    failure(error);
                }
            }];
            
        }
            break;
    }    
}

#pragma mark  请求前统一处理：如果是没有网络，则不论是GET请求还是POST请求，均无需继续处理
- (BOOL)requestBeforeCheckNetWork
{
    struct sockaddr zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sa_len = sizeof(zeroAddress);
    zeroAddress.sa_family = AF_INET;
    SCNetworkReachabilityRef defaultRouteReachability =
    SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    if (!didRetrieveFlags)
    {
        return NO;
    }
    BOOL isReachable     = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    BOOL isNetworkEnable =(isReachable && !needsConnection) ? YES : NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        /*  网络指示器的状态： 有网络 ： 开  没有网络： 关  */
        [UIApplication sharedApplication].networkActivityIndicatorVisible = isNetworkEnable;
    });
    return isNetworkEnable;
}


- (void)cancleRequest
{
    [_requestTask cancel];
}

#pragma mark- 配置https
+ (AFSecurityPolicy *)customSecurityPolicy {
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [securityPolicy setValidatesDomainName:NO];
    securityPolicy.allowInvalidCertificates = YES;
    return securityPolicy;
}

@end
