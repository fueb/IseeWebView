//
//  IseeLoadingView.m
//  IseeWebView
//
//  Created by 余友良 on 2020/9/17.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import "IseeLoadingView.h"
#import <Masonry.h>

@interface IseeLoadingView ()
{
    UIImageView *gifImageView;
}


@end

@implementation IseeLoadingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (instancetype)showHUDAddedTo:(UIView *)view animated:(BOOL)animated
{
    IseeLoadingView *hud = [[self alloc] initWithView:view];
    [view addSubview:hud];
    return hud;
}
- (id)initWithView:(UIView *)view {
    NSAssert(view, @"View must not be nil.");
    self = [self initWithFrame:view.bounds];
    [self getIseeLoading];
    return self;
}
//loading
- (void)getIseeLoading{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"IseeWebResource.bundle" ofType:nil];
    NSString *configPath = [bundlePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",@"img",@"iseeLoading.gif"]];
    configPath = [NSString stringWithFormat:@"file:///%@",configPath];
    NSURL *fileUrl = [NSURL URLWithString:configPath];
    
    //将GIF图片转换成对应的图片源
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)fileUrl, NULL);
    //获取其中图片源个数，即由多少帧图片组成
    size_t frameCount = CGImageSourceGetCount(gifSource);
    //定义数组存储拆分出来的图片
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    for (size_t i = 0; i < frameCount; i++) {
        //从GIF图片中取出源图片
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        //将图片源转换成UIimageView能使用的图片源
        UIImage *imageName = [UIImage imageWithCGImage:imageRef];
        //将图片加入数组中
        [frames addObject:imageName];
        CGImageRelease(imageRef);
    }
    gifImageView = [[UIImageView alloc] init];
    //将图片数组加入UIImageView动画数组中
    gifImageView.animationImages = frames;
    //每次动画时长
    gifImageView.animationDuration = 1.3;
    //开启动画，此处没有调用播放次数接口，UIImageView默认播放次数为无限次，故这里不做处理
    [gifImageView startAnimating];
    [self addSubview:gifImageView];
    __weak typeof(self) wkSelf = self;
    [gifImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(wkSelf);
        make.width.height.mas_equalTo(120);
    }];
}
@end
