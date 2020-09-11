//
//  Config.m
//  lteIosApp
//
//  Created by dream on 16/10/21.
//
//

#import "IseeConfig.h"
#import <CommonCrypto/CommonDigest.h>
#import "UIImage+IseeSVGTool.h"

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
    
    return [outputstring lowercaseString];
}

//获取bundle图片
+ (UIImage *)imageNamed:(NSString *)imageName
{
  
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"IseeWebResource.bundle" withExtension:nil];
    NSBundle *bundle = [NSBundle bundleWithURL:url];
    NSString *name = [@"img" stringByAppendingPathComponent:imageName];
    
    UIImage *image = [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];//[UIImage imageNamed:imageName];
    //优先取上层bundle 里的图片，如果没有，则用自带资源的图片
    return image ? image : [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];

//    return [UIImage imageNamed:name];
}

//获取bundle图片
+ (UIImage *)imageNamed:(NSString *)imageName size:(CGSize)size
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"IseeWebResource.bundle" withExtension:nil];
    NSBundle *bundle = [NSBundle bundleWithURL:url];
    NSString *name = [@"img" stringByAppendingPathComponent:imageName];
    imageName = [NSString stringWithFormat:@"svg/%@",imageName];
    
    UIImage *image;
    @try {
        image = [UIImage svgImgNamed:imageName size:size];
    } @catch (NSException *exception) {
        image = nil;
        NSLog(@"加载%@.svg失败",imageName);
    } @finally {
        
    }
    
    
    //[UIImage sv:name inBundle:bundle compatibleWithTraitCollection:nil];
    //优先取上层bundle 里的图片，如果没有，则用自带资源的图片
    return image ? image : [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
}

+ (NSString *)getLongValue:(id)value
{
    if([value isKindOfClass:[NSNull class]])
    {
        return @"-";
    }
    return [NSString stringWithFormat:@"%ld",[value longValue]];
}

@end
