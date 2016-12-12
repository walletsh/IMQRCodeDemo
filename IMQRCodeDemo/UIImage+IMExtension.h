//
//  UIImage+IMExtension.h
//  IMQRCodeDemo
//
//  Created by imwallet on 16/10/10.
//  Copyright © 2016年 imWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (IMExtension)

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size;

@end
