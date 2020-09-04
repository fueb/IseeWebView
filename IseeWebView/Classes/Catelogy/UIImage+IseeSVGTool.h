//
//  UIImage+IseeSVGTool.h
//  IseeWebView
//
//  Created by 点芯在线 on 2020/9/3.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (IseeSVGTool)
+(UIImage *)svgImgNamed:(NSString *)name size:(CGSize)size;
+ (UIImage *)svgImageNamed:(NSString *)name size:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
