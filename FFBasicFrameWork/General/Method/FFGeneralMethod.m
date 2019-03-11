//
//  FFGeneralMethod.m
//  FFBasicFrameWork
//
//  Created by jisa on 2019/3/8.
//  Copyright © 2019 jisa. All rights reserved.
//

#import "FFGeneralMethod.h"

@implementation FFGeneralMethod
+ (UIAlertController *)FF_AcquireAlertControllerTitle:(nullable NSString *)title message:(nullable NSString *)message  sureBtn:(nullable NSString *)sure sureBlock:(void(^ __nullable)(void))sureBlock cancleBtn:(nullable NSString *)cancle cancleBlock:(void(^ __nullable)(void))cancleBlock  {
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (cancle.length > 0) {
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:cancle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            cancleBlock();
        }];
        [vc addAction:cancleAction];
    }
    
    if (sure.length > 0) {
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:sure style: cancle.length > 0 ? UIAlertActionStyleDefault : UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            sureBlock();
        }];
        [vc addAction:sureAction];
    }
    return vc;
}

@end
