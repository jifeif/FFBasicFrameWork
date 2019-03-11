//
//  FFCameraViewController.m
//  FFBasicFrameWork
//
//  Created by jisa on 2019/3/8.
//  Copyright © 2019 jisa. All rights reserved.
//

#import "FFCameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@interface FFCameraViewController ()<AVCapturePhotoCaptureDelegate>
@property (nonatomic, strong) AVCaptureDevice *captureDevice;
@property (nonatomic, strong) AVCaptureDeviceInput *deviceInput;
@property (nonatomic, strong) AVCaptureMetadataOutput *metadataOutput;
@property (nonatomic, strong) AVCaptureSession     *session;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@property (nonatomic, strong) AVCapturePhotoOutput *photoOutput;
#else
@property (nonatomic, strong) AVCaptureStillImageOutput      *imageOutPut;
#endif
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, strong) UIButton *lightBtn;
@property (nonatomic, strong) UIButton *changeBtn;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIButton *cancleBtn;
@end

@implementation FFCameraViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.isNeedSaveLibrary = YES;
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    UILabel -> UIView -> UIResponder
//    UIWindow -> UIView -> UIResponder
//    UIControl -> UIView -> UIResponder
//    UIButton -> UIControl -> UIView -> UIResponder
//    UITextView -> UIScrollView -> UIView -> UIResponder
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self FF];
    [self.view addSubview:self.cancleBtn];
    [self.view addSubview:self.sureBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self FF_VideoAuthorization];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.cancleBtn.frame = CGRectMake(SCREEN_WIDTH - 60, 20, 40, 40);
    self.sureBtn.frame = CGRectMake((SCREEN_WIDTH - 60) / 2, SCREEN_HEIGHT - 90, 60, 60);
}
#pragma mark -- camera
/// 相机授权
- (BOOL)FF_VideoAuthorization {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusDenied) {
        UIAlertController *vc = [FFGeneralMethod FF_AcquireAlertControllerTitle:nil message:@"前往设置相机权限" sureBtn:@"前往设置" sureBlock:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        } cancleBtn:@"放弃" cancleBlock:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        } ];
        [self presentViewController:vc animated:YES completion:nil];
        return NO;
    }else if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (!granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            }
        }];
        return NO;
    }else {
        return YES;
    }
}

- (void)FF {
    AVCaptureDevice *device = nil;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    AVCaptureDeviceDiscoverySession *session = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    device = [session.devices lastObject];
#else
    NSArray *deviceArray = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    device = [deviceArray lastObject];
#endif
    self.captureDevice = device;
    
    self.deviceInput = [AVCaptureDeviceInput  deviceInputWithDevice:device error:nil];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    self.photoOutput = [[AVCapturePhotoOutput alloc] init];
#else
    self.imageOutPut = [[AVCaptureStillImageOutput alloc] init];
#endif
    self.session = [[AVCaptureSession alloc] init];
    if ([self.session canSetSessionPreset:AVCaptureSessionPresetPhoto]) {
        self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    }else {
        self.session.sessionPreset = AVCaptureSessionPresetHigh;
    }
    if ([self.session canAddInput:self.deviceInput]) {
        [self.session addInput:self.deviceInput];
    }
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    if ([self.session canAddOutput:self.photoOutput]) {
        [self.session addOutput:self.photoOutput];
    }
#else
    if ([self.session canAddOutput:self.imageOutPut]) {
        [self.session addOutput:self.imageOutPut];
    }
#endif
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer removeFromSuperlayer];
    [self.view.layer addSublayer:self.previewLayer];
    [self.session startRunning];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#else
    if ([self.captureDevice lockForConfiguration:nil]) {
        //自动白平衡 不会执行
        if ([self.captureDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            self.captureDevice.whiteBalanceMode = AVCaptureWhiteBalanceModeAutoWhiteBalance;
        }
        //自动闪光灯，
        if ([self.captureDevice isFlashModeSupported:AVCaptureFlashModeOn]) {
            [self.captureDevice setFlashMode:AVCaptureFlashModeOn];
        }
        [self.captureDevice unlockForConfiguration];
    }
#endif
}

#pragma mark -- AVCaptureMetadataOutputObjectsDelegate
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0
- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(nullable NSError *)error{
    if (error) {
        NSLog(@"%@", error);
    }else {
        NSData *data = [photo fileDataRepresentation];
        [self FF_SaveLibrary:data];
    }
}
#elif __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhotoSampleBuffer:(nullable CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(nullable CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(nullable AVCaptureBracketedStillImageSettings *)bracketSettings error:(nullable NSError *)error {
    NSData *data = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
    [self FF_SaveLibrary:data];
}
#endif


#pragma mark -- method
- (void)FF_SureTakePhotos {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    AVCapturePhotoSettings *settings = [AVCapturePhotoSettings photoSettings];
    if ([self.photoOutput.supportedFlashModes containsObject:@(AVCaptureFlashModeOn)]) {
        settings.flashMode = AVCaptureFlashModeOn;
    }
    [self.photoOutput capturePhotoWithSettings:settings delegate:self];
#else
    AVCaptureConnection *connection = [self.imageOutPut connectionWithMediaType:AVMediaTypeAudio];
    if (connection) {
        __weak typeof(self) weakSelf = self;
        [self.imageOutPut captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef  _Nullable imageDataSampleBuffer, NSError * _Nullable error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            NSData *data = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            [strongSelf FF_SaveLibrary:data];
        }];
    }
#endif
}

- (void)FF_Cancle {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)FF_SaveLibrary:(NSData *)data {
    UIImage *aImage = [UIImage imageWithData:data];
    if (self.isNeedSaveLibrary) {
        [aImage FF_SaveImageToAlbum];
    }
    
    if (self.acquirePhotoBlock) {
        self.acquirePhotoBlock(aImage);
    }
}

#pragma mark -- lazy
- (UIButton *)cancleBtn {
    if (!_cancleBtn) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancleBtn.titleLabel.font = FontSystem15;
        [_cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancleBtn.backgroundColor = FFColorRGB(0x000000);
        [_cancleBtn addTarget:self action:@selector(FF_Cancle) forControlEvents:UIControlEventTouchUpInside];
        _cancleBtn.layer.cornerRadius = 20;
        _cancleBtn.layer.masksToBounds = YES;
    }
    return _cancleBtn;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        _sureBtn.backgroundColor = BlackColor;
        _sureBtn.layer.cornerRadius = 30;
        _sureBtn.layer.masksToBounds = YES;
        [_sureBtn addTarget:self action:@selector(FF_SureTakePhotos) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}


@end
