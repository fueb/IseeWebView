//
//  ScanView.m
//  二维码
//
//  Created by strong on 16/12/21.
//  Copyright © 2016年 strong. All rights reserved.
//

#import "IseeScanView.h"
#import "IseeConfig.h"
#define widthRate  UIScreenWidth/320      //宽度比例
#define heightRate UIScreenHeight/320     //高度比例

@implementation IseeScanView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self instanceDevice];
    }
    return self;
}

- (void)instanceDevice
{
    //扫描区域
    UIImageView * scanZomeBack=[[UIImageView alloc] init];
    scanZomeBack.backgroundColor = [UIColor clearColor];
    scanZomeBack.layer.borderColor = [UIColor whiteColor].CGColor;
    scanZomeBack.layer.borderWidth = 2.5;
    scanZomeBack.image = [UIImage imageNamed:@"scanscanBg"];
    //添加一个背景图片
    CGRect mImagerect = CGRectMake(60 * widthRate,(self.frame.size.height - 200 * widthRate) / 2,
                                   200 * widthRate, 200 * widthRate);
    scanZomeBack.frame = mImagerect;
    [self addSubview:scanZomeBack];
    
    CGRect scanCrop = [self getScanCrop:mImagerect readerViewBounds:self.frame];
    //获取摄像设备
    AVCaptureDevice      *device    = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput *input     = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    output.rectOfInterest = scanCrop;
    //初始化链接对象
    session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    if (input)
    {
        [session addInput:input];
    }
    if (output)
    {
        [session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        NSMutableArray *a = [[NSMutableArray alloc] init];
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode])
        {
            [a addObject:AVMetadataObjectTypeQRCode];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code])
        {
            [a addObject:AVMetadataObjectTypeEAN13Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code])
        {
            [a addObject:AVMetadataObjectTypeEAN8Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code])
        {
            [a addObject:AVMetadataObjectTypeCode128Code];
        }
        output.metadataObjectTypes = a;
    }
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.layer.bounds;
    [self.layer insertSublayer:layer atIndex:0];
    [self setOverlayPickerView:self];
    //开始捕获
    [session startRunning];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 20, 50, 50)];
    [backBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [backBtn addTarget:_delegate action:@selector(scanCancel) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
   
}

-(void)loopDrawLine
{
    _is_AnmotionFinished = NO;
    CGRect rect = CGRectMake(60*widthRate, (self.frame.size.height - 200 * widthRate) / 2, 200*widthRate, 2);
    if (_readLineView)
    {
        _readLineView.alpha = 1;
        _readLineView.frame = rect;
    }
    else
    {
        _readLineView = [[UIImageView alloc] initWithFrame:rect];
        [_readLineView setImage:[UIImage imageNamed:@"scanLine"]];
        [self addSubview:_readLineView];
    }
    
    [UIView animateWithDuration:1.5 animations:^{
        //修改fream的代码写在这里
        _readLineView.frame = CGRectMake(60*widthRate,(self.frame.size.height - 200 * widthRate) / 2+200*widthRate-5,200*widthRate,2);
    } completion:^(BOOL finished) {
        if (!_is_Anmotion)
        {
            [self loopDrawLine];
        }
        _is_AnmotionFinished = YES;
    }];
}

- (void)setOverlayPickerView:(IseeScanView *)reader
{
    
    CGFloat wid = 60 * widthRate;
    CGFloat heih = (self.frame.size.height-200*widthRate)/2;
    
    //最上部view
    CGFloat alpha = 0.6;
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, heih)];
    upView.alpha = alpha;
    upView.backgroundColor = [UIColor blackColor];
    [reader addSubview:upView];
    
    //金额显示标签
    self.moneyNumberLab.frame = CGRectMake(wid, heih - 30, 180, 25);
    [reader addSubview:self.moneyNumberLab];
    //开关灯按键
    UIButton *lampBtn = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenWidth - wid - 25, heih - 30, 25, 25)];
    [lampBtn setImage:[UIImage imageNamed:@"scanning_btn_light_close"] forState:UIControlStateNormal];
    [lampBtn setImage:[UIImage imageNamed:@"scanning_btn_light_open"] forState:UIControlStateSelected];
    [lampBtn addTarget:self action:@selector(lampBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [upView addSubview:lampBtn];

    
    //左侧的view
    UIView * cLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, heih, wid, 200*widthRate)];
    cLeftView.alpha = alpha;
    cLeftView.backgroundColor = [UIColor blackColor];
    [reader addSubview:cLeftView];
    
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(UIScreenWidth-wid, heih, wid, 200*widthRate)];
    rightView.alpha = alpha;
    rightView.backgroundColor = [UIColor blackColor];
    [reader addSubview:rightView];
    
    //底部view
    UIView * downView = [[UIView alloc] initWithFrame:CGRectMake(0, heih+200*widthRate, UIScreenWidth, UIScreenHeight - heih - 200 * widthRate)];
    downView.alpha = alpha;
    downView.backgroundColor = [UIColor blackColor];
    [reader addSubview:downView];
    
}


- (CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    CGFloat x,y,width,height;
    x      = (CGRectGetHeight(readerViewBounds)-CGRectGetHeight(rect))/2/CGRectGetHeight(readerViewBounds);
    y      = (CGRectGetWidth(readerViewBounds)-CGRectGetWidth(rect))/2/CGRectGetWidth(readerViewBounds);
    width  = CGRectGetHeight(rect)/CGRectGetHeight(readerViewBounds);
    height = CGRectGetWidth(rect)/CGRectGetWidth(readerViewBounds);
    return CGRectMake(x, y, width, height);
}

- (void)lampBtnAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil)
    {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if ([device hasTorch] && [device hasFlash])
        {
            
            [device lockForConfiguration:nil];
            if (btn.selected)
            {
                [device setTorchMode:AVCaptureTorchModeOn];
                
            }
            else
            {
                [device setTorchMode:AVCaptureTorchModeOff];
            }
            [device unlockForConfiguration];
        }
    }
}

- (void)start
{
    [session startRunning];
}

- (void)stop
{
    [session stopRunning];
}

#pragma mark - 扫描结果
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects && metadataObjects.count > 0)
    {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex : 0 ];
        //输出扫描字符串
        if (_delegate && [_delegate respondsToSelector:@selector(scanResult:)])
        {
            [_delegate scanResult:metadataObject.stringValue];
        }
    }
}


/**
 识别图片中的二维/条形码

 @param codeImage 目标图片

 @return 条形码
 */
+ (NSString *)getCodeForImage:(UIImage *)codeImage
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    CIImage *image = [CIImage imageWithCGImage:codeImage.CGImage];
    NSArray *features = [detector featuresInImage:image];
    CIQRCodeFeature *feature = [features firstObject];
    NSString *result = feature.messageString;
    return result;
}

- (UILabel *)moneyNumberLab
{
    if (!_moneyNumberLab)
    {
        _moneyNumberLab           = [[UILabel alloc]init];
        _moneyNumberLab.textColor = [UIColor whiteColor];
    }
    return _moneyNumberLab;
}
@end
