//
//  UIImage+IseeSVGTool.m
//  IseeWebView
//
//  Created by 点芯在线 on 2020/9/3.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import "UIImage+IseeSVGTool.h"

#import <SVGKImage.h>


@implementation UIImage (IseeSVGTool)

+(UIImage *)svgImgNamed:(NSString *)name size:(CGSize)size{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"IseeWebResource.bundle" withExtension:nil];
    NSBundle *bundle = [NSBundle bundleWithURL:url];
    SVGKImage *svgImg = [SVGKImage imageNamed:name inBundle:bundle];//[SVGKImage imageNamed:name];
    svgImg.size = size;
    return svgImg.UIImage;
}

+ (UIImage *)svgImageNamed:(NSString *)name size:(CGSize)size imageColor:(UIColor *)color {
 
    SVGKImage *svgImage = [SVGKImage imageNamed:name];
 
    svgImage.size = size;
 
    CGRect rect = CGRectMake(0, 0, svgImage.size.width, svgImage.size.height);
 
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(svgImage.UIImage.CGImage);
 
    BOOL opaque = alphaInfo == kCGImageAlphaNoneSkipLast
 
    || alphaInfo == kCGImageAlphaNoneSkipFirst
 
    || alphaInfo == kCGImageAlphaNone;
 
    UIGraphicsBeginImageContextWithOptions(svgImage.size, opaque, svgImage.scale);
 
    CGContextRef context = UIGraphicsGetCurrentContext();
 
    CGContextTranslateCTM(context, 0, svgImage.size.height);
 
    CGContextScaleCTM(context, 1.0, -1.0);
 
    CGContextSetBlendMode(context, kCGBlendModeNormal);
 
    CGContextClipToMask(context, rect, svgImage.UIImage.CGImage);
 
    CGContextSetFillColorWithColor(context, color.CGColor);
 
    CGContextFillRect(context, rect);
 
    UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();
 
    UIGraphicsEndImageContext();
 
    return imageOut;
 
}

@end
