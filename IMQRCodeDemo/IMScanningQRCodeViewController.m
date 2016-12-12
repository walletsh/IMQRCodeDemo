//
//  IMScanningQRCodeViewController.m
//  IMQRCodeDemo
//
//  Created by imwallet on 16/10/10.
//  Copyright © 2016年 imWallet. All rights reserved.
//

#import "IMScanningQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "IMScanningView.h"
#import "IMScanResultViewController.h"

@interface IMScanningQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, strong) IMScanningView *scanningView;

@end

@implementation IMScanningQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"扫描二维码";
    
    [self setupNavViews];
    
    [self setupSubViews];
    
    [self setupScanningQRCode];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resumeAnimation) name:UIApplicationWillEnterForegroundNotification object:nil];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_session startRunning];
    [self.scanningView scanLineAnimationAction];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_session stopRunning];
}


-(void)resumeAnimation
{
    [self.scanningView scanLineAnimationAction];
}
-(void)setupNavViews
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightItemClick:)];
}

- (void)rightItemClick:(UIBarButtonItem *)sender {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:imagePicker animated:YES completion:nil]; // 显示相册
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        if (features.count > 0) {
            [features enumerateObjectsUsingBlock:^(CIQRCodeFeature * _Nonnull feature, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *scannedResult = feature.messageString;
                NSLog(@"scannedResult : %@", scannedResult);
            }];
        }else{
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"该图片不包含二维码" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alertVC addAction:cancelAction];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)setupSubViews
{
    self.scanningView = [[IMScanningView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scanningView];
}

#pragma mark - - - 二维码扫描
- (void)setupScanningQRCode {
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 设置扫描范围(每一个取值0～1，以屏幕右上角为坐标原点)
    // 注：微信二维码的扫描范围是整个屏幕， 这里并没有做处理（可不用设置）
    output.rectOfInterest = CGRectMake(0.05, 0.2, 0.7, 0.6);
    
    self.session = [[AVCaptureSession alloc] init];
    // 高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([_session canAddInput:input]) {
        [_session addInput:input];
    }
    
    if ([_session canAddOutput:output]) {
        [_session addOutput:output];
    }
    
    // 设置输出数据类型，需要将元数据输出添加到会话后，才能指定元数据类型，否则会报错
    // 设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code,  AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.frame = self.view.layer.bounds;
    
    [self.view.layer insertSublayer:_previewLayer atIndex:0];
    
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    [self.session stopRunning];
    
    NSLog(@"metadataObjects ： %@", metadataObjects);
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        NSString *stringValue = metadataObject.stringValue;
        NSLog(@"stringValue : %@", stringValue);
        IMScanResultViewController *scanResultVC = [[IMScanResultViewController alloc] init];
        scanResultVC.resultUrl = stringValue;
        [self.navigationController pushViewController:scanResultVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
