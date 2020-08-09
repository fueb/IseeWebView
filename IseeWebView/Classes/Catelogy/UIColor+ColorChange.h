//
//  UIColor+ColorChange.h
//  IseeWebView
//
//  Created by 点芯在线 on 2020/7/28.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorChange)

// 颜色转换：iOS中（以#开头）十六进制的颜色转换为UIColor(RGB)
+ (UIColor *) colorWithHexString: (NSString *)color;

@end
