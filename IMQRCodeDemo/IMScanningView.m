//
//  IMScanningView.m
//  IMQRCodeDemo
//
//  Created by imwallet on 16/10/11.
//  Copyright © 2016年 imWallet. All rights reserved.
//

#import "IMScanningView.h"
#import <AVFoundation/AVFoundation.h>

#define scanViewX self.frame.size.width * 0.15
#define scanViewY self.frame.size.height * 0.15
#define scanViewWH self.frame.size.width - scanViewX * 2

#define scanLineH 12
#define scanImageWH 16

@interface IMScanningView ()

@property (nonatomic, strong) UIImageView *scanLine;

@end

@implementation IMScanningView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupScanningQRCodeEdging];
    }
    return self;
}

/**
 创建扫描框
 */
-(void)setupScanningQRCodeEdging
{
    UIView *scanView = [[UIView alloc] initWithFrame:CGRectMake(scanViewX, scanViewY, scanViewWH, scanViewWH)];
    scanView.backgroundColor = [UIColor clearColor];
    [self addSubview:scanView];
    
    //添加四个角的image
    UIImageView *leftUpImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scanImageWH, scanImageWH)];
    leftUpImage.image = [UIImage imageNamed:@"QRCodeTopLeft"];
    [scanView addSubview:leftUpImage];
    
    UIImageView *rightUpImage = [[UIImageView alloc] initWithFrame:CGRectMake(scanViewWH - scanImageWH, 0, scanImageWH, scanImageWH)];
    rightUpImage.image = [UIImage imageNamed:@"QRCodeTopRight"];
    [scanView addSubview:rightUpImage];
    
    UIImageView *leftDownImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, scanViewWH - scanImageWH, scanImageWH, scanImageWH)];
    leftDownImage.image = [UIImage imageNamed:@"QRCodebottomLeft"];
    [scanView addSubview:leftDownImage];
    
    UIImageView *rightDownImage = [[UIImageView alloc] initWithFrame:CGRectMake(scanViewWH - scanImageWH, scanViewWH - scanImageWH, scanImageWH, scanImageWH)];
    rightDownImage.image = [UIImage imageNamed:@"QRCodebottomRight"];
    [scanView addSubview:rightDownImage];
    
    
    self.scanLine = [[UIImageView alloc] initWithFrame:CGRectMake(scanViewX, scanViewY, scanViewWH, scanLineH)];
    self.scanLine.image = [UIImage imageNamed:@"QRCodeLine"];
    [self addSubview:self.scanLine];
    
    // 上 下 左 右的留白View
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, scanViewY)];
    topView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [self addSubview:topView];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, scanViewY, scanViewX, scanViewWH)];
    leftView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [self addSubview:leftView];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(scanView.frame), scanViewY, scanViewWH, scanViewWH)];
    rightView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [self addSubview:rightView];
    
    CGFloat bottomViewY = CGRectGetMaxY(scanView.frame);
    CGFloat bottomViewH = self.frame.size.height - bottomViewY;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, bottomViewY, self.frame.size.width, bottomViewH)];
    bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [self addSubview:bottomView];
    
    // 提示Label
    UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 25)];
    promptLabel.backgroundColor = [UIColor clearColor];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.font = [UIFont boldSystemFontOfSize:13.0];
    promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    promptLabel.text = @"将二维码/条码放入框内, 即可自动扫描";
    [bottomView addSubview:promptLabel];
    
    // 添加闪光灯按钮
    UIButton *lightButton = [[UIButton alloc] initWithFrame:CGRectMake(scanViewX, CGRectGetMaxY(promptLabel.frame) + 10, scanViewWH, 40)];
    [lightButton setTitle:@"打开照明灯" forState:UIControlStateNormal];
    [lightButton setTitle:@"关闭照明灯" forState:UIControlStateSelected];
    [lightButton setTitleColor:promptLabel.textColor forState:UIControlStateNormal];
    lightButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [lightButton addTarget:self action:@selector(lightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:lightButton];
    
}

-(void)scanLineAnimationAction
{
    CAKeyframeAnimation *scanLineAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    scanLineAnimation.values = @[@(0), @(scanViewWH - 10), @(0)];
    scanLineAnimation.duration = 4.0;
    scanLineAnimation.repeatCount = MAXFLOAT;
    [_scanLine.layer addAnimation:scanLineAnimation forKey:@"translationAnimation"];
}

-(void)lightButtonAction:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        [self turnTorchOn:YES];
    }else{
        [self turnTorchOn:NO];
    }
}
#pragma mark-> 开关闪光灯
- (void)turnTorchOn:(BOOL)on
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if ([device hasTorch] && [device hasFlash]){
        [device lockForConfiguration:nil];
        if(on){
            [device setTorchMode:AVCaptureTorchModeOn];
            [device setFlashMode:AVCaptureFlashModeOn];
        }else{
            [device setTorchMode:AVCaptureTorchModeOff];
            [device setFlashMode:AVCaptureFlashModeOff];
        }
        [device unlockForConfiguration];
    }

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
