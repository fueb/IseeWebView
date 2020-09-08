//
//  IseeChoiceRegionModel.m
//  IseeWebView
//
//  Created by 点芯在线 on 2020/9/8.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import "IseeChoiceRegionModel.h"
#import "IseeAFNetRequest.h"


@implementation IseeChoiceRegionModel

- (void)isee_findRegionWithParam:(NSMutableDictionary *)param
                     WithSuccess:(void (^)(id result))success
                         failure:(void (^)(void))failed
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAINNAME,GETREGION];
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
