//
//  Config.m
//  lteIosApp
//
//  Created by dream on 16/10/21.
//
//

#import "IseeConfig.h"
#import <CommonCrypto/CommonDigest.h>

@implementation IseeConfig
/**
 *
 * 字符串转color
 */
+ (UIColor *) stringTOColor:(NSString *)str
{
    if (!str || [str isEqualToString:@""]||str.length < 7) {
        return nil;
    }
    unsigned red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 1;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&red];
    range.location = 3;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&green];
    range.location = 5;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&blue];
    
    UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
    return color;
}
+ (void)labelFont:(UILabel *)lab sizeWith:(NSInteger)size
{
    lab.font = [UIFont fontWithName:@"Helvetica" size:size];
}

+ (NSString *)getTimeStr:(NSString *)fomat
{
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:fomat];
    NSString *time = [dateformatter stringFromDate:senddate];
    return time;
}

+ (BOOL)isNotchScreen {
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return NO;
    }
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    NSInteger notchValue = size.width / size.height * 100;
    
    if (216 == notchValue || 46 == notchValue) {
        return YES;
    }
    
    return NO;
}

//md5加密
+ (NSString *)md5:(NSString *)md5Str {
    const char* cStr = [md5Str cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), digest);
    
    NSMutableString* outputstring = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i=0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [outputstring appendFormat:@"%02x", digest[i]];
    }
    
    return [outputstring uppercaseString];
}

@end
