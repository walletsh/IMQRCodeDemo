//
//  IMHomeViewController.m
//  IMQRCodeDemo
//
//  Created by imwallet on 16/10/11.
//  Copyright © 2016年 imWallet. All rights reserved.
//

#import "IMHomeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "IMScanningQRCodeViewController.h"

@interface IMHomeViewController ()

@end

@implementation IMHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)scanQRCodeClick:(UIButton *)sender {
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        IMScanningQRCodeViewController *scanVC = [[IMScanningQRCodeViewController alloc] init];
        [self.navigationController pushViewController:scanVC animated:YES];
    }else{
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"未检测到您的摄像头, 请在真机上测试" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:doneAction];
        [self presentViewController:alertVC animated:YES completion:nil];
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
