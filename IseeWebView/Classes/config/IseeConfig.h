//
//  Config.h
//  lteIosApp
//
//  Created by dream on 16/10/21.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//当前设备的宽高
#define UIScreenHeight ([[UIScreen mainScreen] bounds].size.height)
#define UIScreenWidth  ([[UIScreen mainScreen] bounds].size.width)

//底部的安全距离
#define kBottomSafeAreaHeight [UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom

/*告警框*/
#define IseeAlert(title,msg) [[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show]

#define IseeBundle_Name @"IseeWebResource.bundle"
#define IseeBundle_Path [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:IseeBundle_Name]
#define IseeBundle [NSBundle bundleWithPath:IseeBundle_Path]


#define BASEGREEN   @"#05a642"
#define oldgreen    @"#76d754"
@interface IseeConfig : NSObject

+ (UIColor *) stringTOColor:(NSString *)str;
+ (void)labelFont:(UILabel *)lab sizeWith:(NSInteger)size;
+ (NSString *)getTimeStr:(NSString *)fomat;
+ (BOOL)isNotchScreen;
//md5加密
+ (NSString *)md5:(NSString *)md5Str;
+ (UIImage *)imageNamed:(NSString *)imageName;
@end
