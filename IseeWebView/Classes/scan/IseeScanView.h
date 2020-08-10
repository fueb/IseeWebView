//
//  ScanView.h
//  二维码
//
//  Created by strong on 16/12/21.
//  Copyright © 2016年 strong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol ScanViewDelegate <NSObject>
- (void)scanResult:(NSString *)result;
@end


@interface IseeScanView : UIView<AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *session;
    NSTimer          *countTime;
}
@property (nonatomic,weak) id<ScanViewDelegate> delegate;
@property (nonatomic,copy) UIImageView * readLineView;
@property (nonatomic,assign)BOOL is_Anmotion;
@property (nonatomic,assign)BOOL is_AnmotionFinished;
@property (nonatomic,copy)UILabel  *moneyNumberLab;   //支付金额标签

//开启关闭扫描
- (void)start;
- (void)stop;

- (void)loopDrawLine;//初始化扫描线@end

+ (NSString *)getCodeForImage:(UIImage *)codeImage;

@end
