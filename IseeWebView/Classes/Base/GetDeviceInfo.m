//
//  GetDeviceInfo.m
//  IseeWebView
//
//  Created by 点芯在线 on 2020/7/27.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import "GetDeviceInfo.h"
#import <UIKit/UIDevice.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation GetDeviceInfo

+(NSString *)getDeviceInfoJson{

    NSDate*currentDate = [NSDate date];

    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];

    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];

    NSString*currentString = [dateformatter stringFromDate:currentDate];

    NSString * wifimac = [GetDeviceInfo WifiMacAddress];
    if (wifimac == nil) {
        wifimac = @"";
    }
    NSMutableDictionary *deviceDict = [NSMutableDictionary dictionary];
    [deviceDict setObject:[UIDevice currentDevice].identifierForVendor.UUIDString forKey:@"deviceid"];
    [deviceDict setObject:wifimac forKey:@"wifimac"];
//    [deviceDict setObject:[GetDeviceInfo WifiMacAddress] forKey:@"bluemac"];
    [deviceDict setObject:@"ios" forKey:@"ostype"];
    [deviceDict setObject:currentString forKey:@"date"];
    [deviceDict setObject:[[UIDevice currentDevice] systemVersion] forKey:@"appversion"];
    [deviceDict setObject:[[UIDevice currentDevice] systemName] forKey:@"versiondesc"];
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:deviceDict options:NSJSONWritingPrettyPrinted error:&parseError];

        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

}

+(NSString *)WifiMacAddress
{
    NSArray *ifs = CFBridgingRelease(CNCopySupportedInterfaces());
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
    }
    NSDictionary *dic = (NSDictionary *)info;
    NSString *ssid = [[dic objectForKey:@"SSID"] lowercaseString];
    NSString *bssid = [dic objectForKey:@"BSSID"];
    NSLog(@"ssid:%@ \nssid:%@",ssid,bssid);
    return bssid;
}

@end
