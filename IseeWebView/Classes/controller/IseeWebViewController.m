//
//  IseeWebViewController.m
//  IseeWebView
//
//  Created by 点芯在线 on 2020/7/28.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import "IseeWebViewController.h"
#import <objc/message.h>
#import "IseeScanView.h"
#import "IseeConfig.h"
#import "CLLocation+IseeSino.h"
#import "IseeBSJSON.h"
#import "UIViewController+IseeCommon.h"
#import "IseeNaviBarView.h"

@interface IseeWebViewController ()<WKNavigationDelegate, WKUIDelegate,UIImagePickerControllerDelegate,ScanViewDelegate,CLLocationManagerDelegate,SFSpeechRecognizerDelegate>
{
    IseeScanView    *scanView;                //二维码扫描对象
    NSString    *method;
    __block NSString    *soundStr;
}
@property (nonatomic, strong) WKWebView *wkWebView;
@property (strong,nonatomic) CLLocationManager * locationManager;
// 用作地理编码、反地理编码的工具类
@property (nonatomic, strong) CLGeocoder *geoC;

// 录音引擎
@property (strong, nonatomic) AVAudioEngine            *audioEngine;
// 语音识别任务
@property (strong, nonatomic) SFSpeechRecognitionTask  *recognitionTask;
// 语音识别器
@property (strong, nonatomic) SFSpeechRecognizer       *speechRecognizer;
// 识别请求
@property (strong, nonatomic) SFSpeechAudioBufferRecognitionRequest *recognitionRequest;

//js回调方法
@property (strong, nonatomic) NSString *callBack;
@property (strong, nonatomic) NSString *seq;

@property(nonatomic, copy)NSString *naviTitle;  // 标题
/** 导航条 */
@property(nonatomic, strong)IseeNaviBarView *topNavBar;
/** 内容视图 */
@property (strong, nonatomic) UIView *containerView;

@end

@implementation IseeWebViewController


#pragma mark - 懒加载
-(CLGeocoder *)geoC
{
    if (!_geoC) {
        _geoC = [[CLGeocoder alloc] init];
    }
    return _geoC;
}
-(CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc]init];
        // 设置定位距离过滤参数 （当上次定位和本次定位之间的距离 > 此值时，才会调用代理通知开发者）
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        // 设置定位精度 （精确度越高，越耗电，所以需要我们根据实际情况，设定对应的精度）
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.allowsBackgroundLocationUpdates = YES;
        _locationManager.delegate = self;
    }
    return _locationManager;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_titleHave) {
        [self drawTopNaviBar:_titleName withTitleBg:[IseeConfig stringTOColor:_titleBgColor] withBarBg:[IseeConfig stringTOColor:_statusBarColor]];
    }
    
    //配置wkWebView
    [self configWKWebView];
    
}

/// 在旋转界面时重新构造导航条
- (void)drawTopNaviBar:(NSString *)titleName withTitleBg:(UIColor *)titlebg withBarBg:(UIColor *)barBg {
    if (_topNavBar) {
        [_topNavBar removeFromSuperview];
    }
    // 添加自定义的导航条
    IseeNaviBarView *naviBar = [[IseeNaviBarView alloc] initWithController:self];
    [self.view addSubview:naviBar];
    self.topNavBar = naviBar;
//    if (_isHomeGo)
//    {//首页打开需要返回
    [_topNavBar addBackBtn];
//    }
    
    [_topNavBar setNavigationTitle:titleName];
    [_topNavBar setNavigationBarClolor:barBg];
    [_topNavBar setTitleColor:titlebg];

}


- (UIButton *)addBtnWithTitle:(NSString *)title action:(SEL)action {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 100, 50)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.borderColor = [[UIColor grayColor] CGColor];
    btn.layer.borderWidth = 1;
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UILabel *)addRightMenu:(NSString *)actionName withAction:(SEL)action {
    return [_topNavBar addRightMenu:actionName withAction:action];
}

#pragma mark - 导航条调用

- (void)addScanAndWishList {
    [_topNavBar addScanAndWishList];
}

// 设置导航条透明
- (void)clearNavBarBackgroundColor {
    [_topNavBar clearNavBarBackgroundColor];
}

#pragma mark - set

- (void)setNaviTitle:(NSString *)naviTitle {
    _naviTitle = naviTitle;
    [_topNavBar setNavigationTitle:naviTitle];
}

#pragma mark - action

- (void)doBackPrev {
//    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
//    if (_reallyGo) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//        return;
//    }
    if (self.wkWebView.canGoBack) {

        [self.wkWebView goBack];

    }else{
        if (_isHomeGo) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }
}
- (void)goBackChoice {
    [self dismissViewControllerAnimated:YES completion:nil];

}


//配置wkWebView
- (void)configWKWebView{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    CGFloat safeBottom = 0;
       
    if ([IseeConfig isNotchScreen]) {
        safeBottom = 34;
    }
    
    CGRect wkFrame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-(50+safeBottom));
    
    CGFloat statusBarH = 64.0;
    if (@available(iOS 13.0, *)) {
         UIWindowScene *windowScene = (UIWindowScene *)[UIApplication sharedApplication].connectedScenes.allObjects.firstObject;
         statusBarH = windowScene.statusBarManager.statusBarFrame.size.height + NavBarHeight;
    } else {
         statusBarH = NavHeight;
    }

    if (_titleHave && _tabbarHave) {
        wkFrame = CGRectMake(0, statusBarH, ScreenWidth, ScreenHeight - statusBarH -(50+safeBottom));
    }
    else if (_titleHave)
    {
        wkFrame = CGRectMake(0, statusBarH, ScreenWidth, ScreenHeight - statusBarH);
    }
    else if (_tabbarHave)
    {
        wkFrame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - (50+safeBottom));
    }
    self.wkWebView = [[WKWebView alloc] initWithFrame:wkFrame configuration:config];
    [self.view addSubview:self.wkWebView];
    
    self.wkWebView.UIDelegate = self;
    self.wkWebView.navigationDelegate = self;
    [self.wkWebView.scrollView setShowsVerticalScrollIndicator:NO];
    [self.wkWebView.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];

    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:_mWebViewUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30]];
    NSLog(@"打开web链接：%@",_mWebViewUrl);

    WKUserContentController *userCC = config.userContentController;
    //意思是网页中需要传递的参数是通过这个JS中的showMessage方法来传递的
//    [userCC addScriptMessageHandler:self name:@"soundrecord"];
}
-(void)gotoRecor:(int)timeOut{
//    SiriViewController *siriVc =[[SiriViewController alloc] init];
//    [self presentViewController:siriVc animated:YES completion:nil];
    [self basicSetup];
//    [self startEvent];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeOut * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self endEvent];
    });
}


 
- (void)basicSetup{
 
    
    
    // 设备识别语言为中文
    NSLocale *cale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh-CN"];
    self.speechRecognizer = [[SFSpeechRecognizer alloc]initWithLocale:cale];
    
    // 申请权限认证
    __weak IseeWebViewController * weakSelf = self;
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
              
            switch (status) {
                case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                    NSLog(@"没有授权语音识别");
                    break;
                case SFSpeechRecognizerAuthorizationStatusDenied:
                    NSLog(@"用户拒绝授权");
                    break;
                case SFSpeechRecognizerAuthorizationStatusRestricted:
                    NSLog(@"不能在该设备上进行语音识别");
                    break;
                case SFSpeechRecognizerAuthorizationStatusAuthorized:
                    
                    NSLog(@"设备录音可用");
                    [weakSelf startEvent];
                    
                    break;
                    
                default:
                    break;
            }
            
        });
    }];
 
 
 
 
    // 创建录音引擎
    self.audioEngine = [[AVAudioEngine alloc]init];
 
 
}
#pragma mark - SFSpeechRecognizerDelegate
- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available{
    if (available) {
        
       NSLog(@"语音识别可用");
        
    }else{
      
         NSLog(@"语音识别不可用");
    }
}
 
 // 语音按钮识别事件
 - (void)endEvent{

     if ([self.audioEngine isRunning]) {
         
        
         
         IseeBSJSON *jsonCode = [[IseeBSJSON alloc] init];
         [jsonCode setObject:@"0000" forKey:@"code"];
         [jsonCode setObject:@"ok" forKey:@"msg"];
         [jsonCode setObject:_seq forKey:@"seq"];
         IseeBSJSON * nextJson = [[IseeBSJSON alloc] init];
         //经度
         [nextJson setObject:soundStr forKey:@"soundStr"];
         
         [jsonCode setObject:nextJson forKey:@"data"];
          NSString *js1 = [NSString stringWithFormat:@"\"%@\",%@", method,[jsonCode serialization]];
         NSString *js = [NSString stringWithFormat:@"eval(%@(%@))", _callBack,js1];
         [self execJavaScript:js];
         
         [self.audioEngine stop];
         [self.recognitionRequest endAudio];
       
     }
     
     
     
 //    [self.longButton finishAndRest];
     
 }

//跳转页面
-(void)goController{
    
    NSString *urlStr = [NSString stringWithFormat:@"zqhelper://account=%@&token=ac3c9575492d3c8e55da8b9d7dd73e38&bundleid=%@",_mLoginName,[[NSBundle mainBundle] bundleIdentifier]];
    NSLog(@"销售助手url:%@",urlStr);
    
    NSURL *url = [NSURL URLWithString:urlStr];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
           
        }];
//        if(@available(iOS 10.0, *))
//        {
//
//            
//
//        }else{
//
//            [[UIApplication sharedApplication] openURL:url];
//
//        }

        
    }else{
        NSLog(@"设备没有安装销售助手");
        if (_isHomeGo)
        {
            [self dismissViewControllerAnimated:YES completion:^{
        
            }];
        }
        else
        {
            [self.tabBarController setSelectedIndex:0];
        }
    }

    
}

//获取登录信息
-(void)getUserInfo{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *loginStr = [userDefault objectForKey:@"IseeWebSsoLoginJson"];
    IseeBSJSON *jsonCode = [[IseeBSJSON alloc] init];
    [jsonCode setObject:@"0000" forKey:@"code"];
    [jsonCode setObject:@"ok" forKey:@"msg"];
    [jsonCode setObject:_seq forKey:@"seq"];
    IseeBSJSON * nextJson = [[IseeBSJSON alloc] init];
    [nextJson setObject:loginStr forKey:@"loginJsonStr"];

    [jsonCode setObject:nextJson forKey:@"data"];
     NSString *js1 = [NSString stringWithFormat:@"\"%@\",%@", method,[jsonCode serialization]];
    NSString *js = [NSString stringWithFormat:@"eval(%@(%@))", _callBack,js1];
    [self execJavaScript:js];
   
}

-(void)getSession{
    NSLog(@"获取session");
    IseeBSJSON *jsonCode = [[IseeBSJSON alloc] init];
    [jsonCode setObject:@"0000" forKey:@"code"];
    [jsonCode setObject:@"ok" forKey:@"msg"];
    [jsonCode setObject:_seq forKey:@"seq"];
    IseeBSJSON * nextJson = [[IseeBSJSON alloc] init];
    [nextJson setObject:_mSession forKey:@"session"];

    [jsonCode setObject:nextJson forKey:@"data"];
     NSString *js1 = [NSString stringWithFormat:@"\"%@\",%@", method,[jsonCode serialization]];
    NSString *js = [NSString stringWithFormat:@"eval(%@(%@))", _callBack,js1];
    [self execJavaScript:js];
}
-(void)openIsee{
    [self dismissViewControllerAnimated:YES completion:nil];
}



-(void)exitIsee{
//

    UIViewController *vc        = [[NSClassFromString(@"PersonalCenterController") alloc]init];
    SEL runAction = NSSelectorFromString(@"logOut");
    
    if([vc respondsToSelector:runAction]){

        objc_msgSend(vc, runAction);
    }
    
    
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
    
    __weak IseeWebViewController * weakSelf = self;
    //开始识别任务
    self.recognitionTask = [self.speechRecognizer recognitionTaskWithRequest:self.recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        bool isFinal = false;
        if (result) {
            NSLog(@"result:%@",[[result bestTranscription] formattedString]);
//            self.inputText.text = [[result bestTranscription] formattedString]; //语音转文本
            soundStr = [[result bestTranscription] formattedString];
            
            
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

-(void)gotoLocation{
    //    请求始终授权
        [_locationManager requestAlwaysAuthorization];
        
        
    //    请求前台授权
    //    [_locationManager requestWhenInUseAuthorization];
        
        // 2.判断定位服务是否可用
        if([CLLocationManager locationServicesEnabled])
        {
    //        多次定位
//            [self.locationManager startUpdatingLocation];
    //        只定位一次
            [self.locationManager requestLocation];
        }else
        {
            NSLog(@"不能定位呀");
        }
}

- (void)backGeoCooder:(NSString *)lat wtihLon:(NSString *)lon {
    // 过滤空数据
    if ([lat length] == 0 || [lon length] == 0) {
        return;
    }
    
    // 保存 Device 的现语言 (英语 法语 ，，，)
    NSMutableArray *userDefaultLanguages = [[NSUserDefaults standardUserDefaults]
    objectForKey:@"AppleLanguages"];
    // 强制 成 简体中文
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans",nil]
    forKey:@"AppleLanguages"];
    
    // 创建CLLocation对象
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[lat doubleValue] longitude:[lon doubleValue]];
    // 根据CLLocation对象进行反地理编码
    [self.geoC reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * __nullable placemarks, NSError * __nullable error) {
        
        if (error!=NULL) {
            NSLog(@"error:",[error debugDescription]);
            return;
        }
        
        // 包含区，街道等信息的地标对象
        CLPlacemark *placemark = [placemarks firstObject];
        // 城市名称
                NSString *city = placemark.locality;
        // 街道名称
                NSString *street = placemark.thoroughfare;
        // 全称
        NSString *name = placemark.name;
        NSLog(@"name:%@",name);
    }];
}

-(void)locationManager:(nonnull CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations
{
      CLLocation *location = locations.lastObject;
    NSString *lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    NSString *lon = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    location = [location locationMarsFromEarth];
    lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    lon = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    
//    [self backGeoCooder:lat wtihLon:lon];
    IseeBSJSON *jsonCode = [[IseeBSJSON alloc] init];
    [jsonCode setObject:@"0000" forKey:@"code"];
    [jsonCode setObject:@"ok" forKey:@"msg"];
    [jsonCode setObject:_seq forKey:@"seq"];
    IseeBSJSON * nextJson = [[IseeBSJSON alloc] init];
    //经度
    [nextJson setObject:lon forKey:@"longitude"];
    //纬度
    [nextJson setObject:lat forKey:@"latitude"];

    [jsonCode setObject:nextJson forKey:@"data"];
     NSString *js1 = [NSString stringWithFormat:@"\"%@\",%@", method,[jsonCode serialization]];
    NSString *js = [NSString stringWithFormat:@"eval(%@(%@))", _callBack,js1];
    [self execJavaScript:js];
}

/**
 * 当定位失败后调用此方法
 */
-(void)locationManager:(nonnull CLLocationManager *)manager didFailWithError:(nonnull NSError *)error
{
    
    NSLog(@"定位失败--%@", error.localizedDescription);
}

-(void)gotoMyPhoto{
    //拍照
    UIImagePickerController *camera = [[UIImagePickerController alloc] init];
    camera.delegate = self;
    camera.allowsEditing = YES;
    //检查摄像头是否支持摄像机模式
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        //拍照
        camera.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        NSLog(@"Camera not exist");
        return;
    }
//    [self presentModalViewController:camera animated:YES];
    [self presentViewController:camera animated:YES completion:^{
        
    }];
}

/**
 * 扫描二维码
 */
-(void)gotoScanQRCode{
    [self addScanView];
}

/**
 添加扫描界面
 */
- (void)addScanView
{
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]init];
    barButton.title = @"";
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:space, barButton, nil];
    if (scanView)
    {
        [scanView removeFromSuperview];
        scanView = nil;
    }
    
    scanView = [[IseeScanView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth,
                                                         self.view.bounds.size.height)];
    scanView.is_AnmotionFinished = YES;
    scanView.backgroundColor = [UIColor clearColor];
    scanView.delegate = self;
    scanView.alpha = 0;
    [self.view addSubview:scanView];
    [self ePay_reStartScan];
    [UIView animateWithDuration:0.5 animations:^{
        scanView.alpha = 1;
    }completion:^(BOOL finished){
        
    }];
}

- (void)scanCancel
{
    if (scanView)
       {
           [scanView removeFromSuperview];
           scanView = nil;
       } 
}

/**
 开启扫描动画
 */
- (void)ePay_reStartScan
{
    scanView.is_Anmotion = NO;
    if (scanView.is_AnmotionFinished)
    {
        [scanView loopDrawLine];
    }
    [scanView start];
}

#pragma mark --- ScanViewDelegate
/**
 扫描结果返回

 @param result 扫描结果
 */
- (void)scanResult:(NSString *)result
{
    scanView.is_Anmotion = YES;
    [scanView stop];
    [scanView removeFromSuperview];
 
    NSLog(@"%@", result);
    
    IseeBSJSON *jsonCode = [[IseeBSJSON alloc] init];
    [jsonCode setObject:@"0000" forKey:@"code"];
    [jsonCode setObject:@"ok" forKey:@"msg"];
    [jsonCode setObject:_seq forKey:@"seq"];
    IseeBSJSON * nextJson = [[IseeBSJSON alloc] init];
    
    [nextJson setObject:result forKey:@"scan_result"];

    [jsonCode setObject:nextJson forKey:@"data"];
     NSString *js1 = [NSString stringWithFormat:@"\"%@\",%@", method,[jsonCode serialization]];
    NSString *js = [NSString stringWithFormat:@"eval(%@(%@))", _callBack,js1];
    [self execJavaScript:js];
}




#pragma mark - private
/* 页面开始加载 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"页面开始加载");
}
/* 开始返回内容 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"开始返回内容");
}
/* 页面加载完成 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"页面加载完成");
}
/* 页面加载失败 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"页面加载失败:%@",error);
    
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{// 类似 UIWebView 的 -webView: shouldStartLoadWithRequest: navigationType:

    
    NSURL *URL = navigationAction.request.URL;
    NSString * urlStr = [[URL absoluteString] stringByRemovingPercentEncoding];
    
    
    IseeBSJSON *jsonObj = [self genJSONResponseHeader:urlStr];
    
    if (jsonObj != NULL)
    {
            
        method =@"";
        method = [jsonObj objectForKey:@"method"];
        _callBack = [jsonObj objectForKey:@"callback"];
        _seq = [jsonObj objectForKey:@"seq"];
        if ([method isEqualToString:@"deviceInfo"])
        {
//                    BUDeviceInfoOrder *order = (BUDeviceInfoOrder *)[busiSystem.orderManager createNewOrder:BUORDERTYPE_DEVICEINFO];
//                    NSString *js = [order callback];
//                    [self execJavaScript:js];
        }
        else if([method isEqualToString:@"getLocation"])
        {
            [self gotoLocation];
        }
        else if ([method isEqualToString:@"systeminfo"])
        {
            IseeBSJSON *jsonCode = [[IseeBSJSON alloc] init];
            [jsonCode setObject:@"0000" forKey:@"code"];
            [jsonCode setObject:@"ok" forKey:@"msg"];
            [jsonCode setObject:_seq forKey:@"seq"];
            IseeBSJSON * nextJson = [[IseeBSJSON alloc] init];
            //设备id
            [nextJson setObject:@"" forKey:@"deviceid"];
            //wifi mac
            [nextJson setObject:@"" forKey:@"wifimac"];
            //blue mac
            [nextJson setObject:@"" forKey:@"bluemac"];
            //os type
            [nextJson setObject:@"ios" forKey:@"ostype"];
            //date
            [nextJson setObject:@"" forKey:@"date"];
            //appversion
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
             [nextJson setObject:version forKey:@"appversion"];
            //versiondesc
            [nextJson setObject:@"" forKey:@"versiondesc"];
            [jsonCode setObject:nextJson forKey:@"data"];
             NSString *js1 = [NSString stringWithFormat:@"\"%@\",%@", method,[jsonCode serialization]];
            NSString *js = [NSString stringWithFormat:@"eval(%@(%@))", _callBack,js1];
            [self execJavaScript:js];
        }
        else if([method isEqualToString:@"location"])
        {
            [self gotoLocation];
        }
        else if([method isEqualToString:@"soundrecord"])
        {
            IseeBSJSON  *jsTmp = [jsonObj objectForKey:@"data"];
            NSString *str = [jsTmp objectForKey:@"timeOut"];
            int time = [str intValue];
            [self gotoRecor:time==0?10:time];
        }
        else if([method isEqualToString:@"soundstop"])
        {
            [self endEvent];
        }
        else if([method isEqualToString:@"soundplay"])
        {
//                    [self PlayRecord];
        }
        else if([method isEqualToString:@"takephoto"]){
            [self gotoMyPhoto];
        }
        else if([method isEqualToString:@"scanqrcode"]){
            [self gotoScanQRCode];
        }
        else if([method isEqualToString:@"openZqhelper"]){
            [self goController];
        }
        else if([method isEqualToString:@"getUserInfo"]){
            [self getUserInfo];
        }
        else if([method isEqualToString:@"exit"]){
            [self exitIsee];
        }
        else if([method isEqualToString:@"getSession"]){
            [self getSession];
        }
        else if([method isEqualToString:@"openIsee"]){
            [self openIsee];
        }
        else if([method isEqualToString:@"goBackChoice"]){
            [self goBackChoice];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
     
        decisionHandler(WKNavigationActionPolicyAllow); // 必须实现 加载
        return;
}



#pragma mark ImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    
    NSLog(@"info = %@",info);
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if([mediaType isEqualToString:@"public.image"])    //被选中的是图片
    {
        //获取照片实例
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        long maxLenth = 0.3 * 1024 * 1024;
        
        
//        NSData * imageData = [WsalePhotoProcessContoller compressOriginalImage:image toMaxDataSizeKBytes:maxLenth];
//        image = [[UIImage alloc] initWithData:imageData];
        
        
        [self saveImg:image];
        
    }
    
    NSLog(@"info=%@",info);
    
    

    
}

-(void)saveImg:(UIImage *) image
{
//    NSLog(@"Review Image");
    NSData *_data = UIImageJPEGRepresentation(image, 0.2f);
//    NSString *_encodedImageStr = [_data base64Encoding];
    NSString *image64 = [_data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    IseeBSJSON *jsonCode = [[IseeBSJSON alloc] init];
    [jsonCode setObject:@"0000" forKey:@"code"];
    [jsonCode setObject:@"ok" forKey:@"msg"];
    [jsonCode setObject:_seq forKey:@"seq"];
    IseeBSJSON * nextJson = [[IseeBSJSON alloc] init];
    //base64
    [nextJson setObject:image64 forKey:@"img_data"];
    
    [jsonCode setObject:nextJson forKey:@"data"];
     NSString *js1 = [NSString stringWithFormat:@"\"%@\",%@", method,[jsonCode serialization]];
    NSString *js = [NSString stringWithFormat:@"eval(%@(%@))", _callBack,js1];
    [self execJavaScript:js];

}

-(IseeBSJSON *)genJSONResponseHeader:(NSString *)data
{
//    urlStr    __NSCFString *    @"plugin://{\"method\" : \"takephoto\",\"data\" : \"\",\"callback\" : \"nativeWindow\",\"seq\" : \"0\"}"    0x00006000034710a0
    
    if (data.length <= 0) {
        return nil;
    }
    IseeBSJSON *resultJson = [[IseeBSJSON alloc] init];
    if([data rangeOfString:@"plugin://"].location !=NSNotFound){

        data = [data stringByReplacingOccurrencesOfString:@"plugin://" withString:@""];
        resultJson = [[IseeBSJSON alloc] initWithData:[data dataUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding];
   }
    else{
        return nil;
    }
    return resultJson;
}

-(void)execJavaScript:(NSString *)js{
//    [self.wkWebView stringByEvaluatingJavaScriptFromString:js];
    [self.wkWebView evaluateJavaScript:js completionHandler:nil];
}

#pragma mark KVO的监听代理
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    
    //网页title
     if ([keyPath isEqualToString:@"title"])
    {
        if (object == self.wkWebView)
        {
            
            [_topNavBar setNavigationTitle:self.wkWebView.title];
            NSString *title = self.wkWebView.title;
            if ([title isEqualToString:@"工具"]||[title isEqualToString:@"沙盘"]||[title isEqualToString:@"消息"]||[title isEqualToString:@"我的"]) {
                if (!_isHomeGo) {
                    [_topNavBar backBtnHide];
                }
                
                
            }
            else
            {
                [_topNavBar backBtnShow];
            }
            
            CGFloat safeBottom = 0;
               
            if ([IseeConfig isNotchScreen]) {
                safeBottom = 34;
            }
            
            CGRect wkFrame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-(50+safeBottom));
            
            CGFloat statusBarH = 64.0;
            if (@available(iOS 13.0, *)) {
                 UIWindowScene *windowScene = (UIWindowScene *)[UIApplication sharedApplication].connectedScenes.allObjects.firstObject;
                 statusBarH = windowScene.statusBarManager.statusBarFrame.size.height + NavBarHeight;
            } else {
                 statusBarH = NavHeight;
            }
           
            if ([title isEqualToString:@"我的"])
            {
                [_topNavBar setHidden:YES];
                wkFrame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - (50+safeBottom));
                
            }
            else
            {
                [_topNavBar setHidden:NO];
                if (_titleHave && _tabbarHave) {
                    wkFrame = CGRectMake(0, statusBarH, ScreenWidth, ScreenHeight - statusBarH -(50+safeBottom));
                }
                else if (_titleHave)
                {
                    wkFrame = CGRectMake(0, statusBarH, ScreenWidth, ScreenHeight - statusBarH);
                }
                else if (_tabbarHave)
                {
                    wkFrame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - (50+safeBottom));
                }
            }
            [self.wkWebView setFrame:wkFrame];
            [self.wkWebView setNeedsDisplay];
            NSLog(@"%@",self.title);
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark 移除观察者
- (void)dealloc
{
    [self.wkWebView removeObserver:self forKeyPath:@"title"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
