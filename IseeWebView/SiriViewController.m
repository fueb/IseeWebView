//
//  SiriViewController.m
//  IseeWebView
//
//  Created by 点芯在线 on 2020/7/26.
//  Copyright © 2020 dxzx. All rights reserved.
//
#define sWith     [UIScreen mainScreen].bounds.size.width
#define sHeight   [UIScreen mainScreen].bounds.size.height
 
 
#import "SiriViewController.h"
 
#import <Speech/Speech.h>
#import <AVFoundation/AVFoundation.h>

 
@interface SiriViewController () <SFSpeechRecognizerDelegate>
 
@property (nonatomic, strong) UIButton *longButton;    // 长按按钮
@property (nonatomic, strong) UITextField     *inputText;     // 语音转化成的文本
 
// 录音引擎
@property (strong, nonatomic) AVAudioEngine            *audioEngine;
// 语音识别任务
@property (strong, nonatomic) SFSpeechRecognitionTask  *recognitionTask;
// 语音识别器
@property (strong, nonatomic) SFSpeechRecognizer       *speechRecognizer;
// 识别请求
@property (strong, nonatomic) SFSpeechAudioBufferRecognitionRequest *recognitionRequest;
 
 
@end
 
@implementation SiriViewController
 
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 创建信息label
    UILabel *textLabel      = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, sWith-100, 30)];
    textLabel.text          = @"【Siri】语音识别转文字";
    textLabel.font          = [UIFont fontWithName:@"HelveticaNeue" size:20.f];
    textLabel.textColor     = [UIColor blackColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:textLabel];
    
    
    
   
    // 退出控制器
    {
        
        UIButton *dismissButton        = [[UIButton alloc] initWithFrame:CGRectMake(sWith/2-50, sHeight-100, 100, 50)];
        dismissButton.tag              = 10;
        dismissButton.backgroundColor  = [UIColor lightGrayColor];
        dismissButton.titleLabel.font  = [UIFont fontWithName:@"HelveticaNeue" size:16.f];
        [dismissButton setTitle:@"返回上一页" forState:UIControlStateNormal];
        [dismissButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [dismissButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:dismissButton];
    }
 
    
    
    // 语音识别
  
        
        self.inputText = [[UITextField alloc]initWithFrame:CGRectMake(50, 200, sWith-100, 100)];
        self.inputText.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
        [self.view addSubview:self.inputText];
        
        
        
        
    // 长按按钮
    self.longButton = [[UIButton alloc]initWithFrame:CGRectMake(sWith/2-50, sHeight-300, sWith-300, sWith-300)];
    [_longButton setTitle:@"开始录音" forState:UIControlStateNormal];
    [_longButton setBackgroundColor:[UIColor redColor]];
    
    // 保持在视图最上面
    [[UIApplication sharedApplication].keyWindow addSubview:self.longButton];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.longButton];
    
    __weak SiriViewController *weakSelf = self;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longClick:)];
    [self.longButton addGestureRecognizer:longPress];

//    self.longButton.eventBlock = ^(TouchType TouchType,NSTimeInterval time){
//
//        switch (TouchType) {
//            case LongTouchBegin:
//                [weakSelf startEvent];
//                break;
//            case LongTouchEnd:
//                [weakSelf endEvent];
//                break;
//
//
//            default:
//                break;
//        }
//
//
//    };
//
    
    // 基本设置
    [self basicSetup];
    
    
}
 
 
 - (void)longClick:(UILongPressGestureRecognizer *)longPress

 {

    
     switch (longPress.state) {

         case UIGestureRecognizerStateBegan:

         {
 [self startEvent];
             //长按开始


             break;

         }
         case UIGestureRecognizerStateEnded:

         {
[self endEvent];
             //长按结束
             break;

         }

         default:

             break;

     }

 }
 
 
 
- (void)basicSetup{
 
    
    
    // 设备识别语言为中文
    NSLocale *cale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh-CN"];
    self.speechRecognizer = [[SFSpeechRecognizer alloc]initWithLocale:cale];
    
    // 申请权限认证
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                    self.longButton.userInteractionEnabled = NO;
                    self.inputText.text  = @"没有授权语音识别";
                    break;
                case SFSpeechRecognizerAuthorizationStatusDenied:
                    self.longButton.userInteractionEnabled = NO;
                    self.inputText.text   = @"用户拒绝使用语音识别权限";
 
                    break;
                case SFSpeechRecognizerAuthorizationStatusRestricted:
                    self.longButton.userInteractionEnabled = NO;
                    self.inputText.text   = @"不能在该设备上进行语音识别";
                    
                    break;
                case SFSpeechRecognizerAuthorizationStatusAuthorized:
                    self.longButton.userInteractionEnabled = YES;
                    self.inputText.text   = @"设备录音可用";
                    break;
                    
                default:
                    break;
            }
            
        });
    }];
 
 
 
 
    // 创建录音引擎
    self.audioEngine = [[AVAudioEngine alloc]init];
 
 
}
 
 
 
 
 
// 语音按钮识别事件
- (void)endEvent{
    
    
    
    
    if ([self.audioEngine isRunning]) {
        
        [self.audioEngine stop];
        [self.recognitionRequest endAudio];
      
    }
    
    
    
//    [self.longButton finishAndRest];
    
}
 
 
 
// 识别语音
-(void)startEvent{
    if (self.recognitionTask) {
        [self.recognitionTask cancel];
        self.recognitionTask = nil;
    }
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    bool  audioBool = [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    bool  audioBool1= [audioSession setMode:AVAudioSessionModeMeasurement error:nil];
    bool  audioBool2= [audioSession setActive:true withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    if (audioBool || audioBool1||  audioBool2) {
        NSLog(@"可以使用");
    }else{
        NSLog(@"这里说明有的功能不支持");
    }
    self.recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc]init];
    AVAudioInputNode *inputNode = self.audioEngine.inputNode;
    self.recognitionRequest.shouldReportPartialResults = true;
    
    //开始识别任务
    self.recognitionTask = [self.speechRecognizer recognitionTaskWithRequest:self.recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        bool isFinal = false;
        if (result) {
            self.inputText.text = [[result bestTranscription] formattedString]; //语音转文本
            isFinal = [result isFinal];
        }
        if (error || isFinal) {
            [self.audioEngine stop];
            [inputNode removeTapOnBus:0];
            self.recognitionRequest = nil;
            self.recognitionTask = nil;
//            self.siriButton.enabled = true;
        }
    }];
    AVAudioFormat *recordingFormat = [inputNode outputFormatForBus:0];
    [inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [self.recognitionRequest appendAudioPCMBuffer:buffer];
    }];
    [self.audioEngine prepare];
    bool audioEngineBool = [self.audioEngine startAndReturnError:nil];
    NSLog(@"%d",audioEngineBool);
//    self.inputText.text = @"正在录音。。。";
}
 
 
#pragma mark - SFSpeechRecognizerDelegate
- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available{
    if (available) {
        
        self.inputText.text = @"语音识别可用";
        
    }else{
      
        self.inputText.text = @"语音识别不可用";
    }
}
 
 
// 退出控制器
- (void)dismiss{
    
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
@end
