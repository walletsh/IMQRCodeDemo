//
//  ViewController.m
//  IMQRCodeDemo
//
//  Created by imwallet on 16/10/10.
//  Copyright © 2016年 imWallet. All rights reserved.
//

#import "ViewController.h"

#import "UIImage+IMExtension.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.imgView=[[UIImageView alloc]initWithFrame:CGRectMake(100, 100, [UIScreen mainScreen].bounds.size.width/2.0, [UIScreen mainScreen].bounds.size.width/2.0)];
    [self.view addSubview:_imgView];
    
    NSString *message = @"http://www.baidu.com";
    
    // 绘制普通二维码
//    [self setupGenerateQRCodeWithMessage:message];
    
    // 绘制彩色二维码
    [self setupColorGenerateQRCodeWithMessage:message];
    
    // 绘制带有图标的二维码
//    NSString *imageName = @"houzi";
//    [self setupIconGenerateQRCodeWithMessage:message imageName:imageName];
}


/**
 绘制普通二维码
 */
-(void)setupGenerateQRCodeWithMessage:(NSString *)message
{
    CIFilter *filter=[CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [filter setDefaults];
    
    NSData *data=[message dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    
    CIImage *outputImage=[filter outputImage];

    //将CIImage转换成UIImage,并放大显示
    _imgView.image = [UIImage createNonInterpolatedUIImageFormCIImage:outputImage withSize:100.0];
    
    _imgView.layer.shadowOffset = CGSizeMake(0, 0.5);
    _imgView.layer.shadowRadius = 1;
    _imgView.layer.shadowColor=[UIColor blackColor].CGColor;
    _imgView.layer.shadowOpacity=0.3;
    
}


/**
 绘制带有颜色的二维码
 */
-(void)setupColorGenerateQRCodeWithMessage:(NSString *)message
{
    CIFilter *filter=[CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [filter setDefaults];
    
    NSData *data=[message dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    
    CIImage *outputImage=[filter outputImage];
    // 图片小于(27,27),我们需要放大
    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(9, 9)];
    
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"];
    [colorFilter setDefaults];
    [colorFilter setValue:outputImage forKey:@"inputImage"];
    [colorFilter setValue:[CIColor redColor] forKey:@"inputColor0"];
    [colorFilter setValue:[CIColor cyanColor] forKey:@"inputColor1"];
    
    CIImage *colorImage = [colorFilter outputImage];
    _imgView.image = [UIImage imageWithCIImage:colorImage];
}


/**
 绘制带有图标的二维码
 */
-(void)setupIconGenerateQRCodeWithMessage:(NSString *)message imageName:(NSString *)imageName
{
    CIFilter *filter=[CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [filter setDefaults];
    
    NSData *data=[message dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    
    CIImage *outputImage=[filter outputImage];
    // 图片小于(27,27),我们需要放大
    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];
    
    UIImage *backgroundImage = [UIImage imageWithCIImage:outputImage];

    // - - - - - - - - - - - - - - - - 添加中间小图标 - - - - - - - - - - - - - - - -
    UIGraphicsBeginImageContext(backgroundImage.size);
    
    [backgroundImage drawInRect:CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height)];
    
    UIImage *icon = [UIImage imageNamed:imageName];
    CGFloat iconW = 100;
    CGFloat iconH = iconW;
    CGFloat iconX = (backgroundImage.size.width - iconW) * 0.5;
    CGFloat iconY = (backgroundImage.size.height - iconH) * 0.5;
    [icon drawInRect:CGRectMake(iconX, iconY, iconW, iconH)];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    _imgView.image = resultImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
