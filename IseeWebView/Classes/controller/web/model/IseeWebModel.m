//
//  IseeWebModel.m
//  IseeWebView
//
//  Created by 余友良 on 2020/11/20.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import "IseeWebModel.h"
#import "IseeAFNetRequest.h"

@implementation IseeWebModel
- (void)isee_addRecordWithParam:(NSMutableDictionary *)param
                    WithSuccess:(void (^)(id result))success
                        failure:(void (^)(void))failed
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAINNAME,ADDRECORD];
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
