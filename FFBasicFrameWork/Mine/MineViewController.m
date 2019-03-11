//
//  MineViewController.m
//  FFBasicFrameWork
//
//  Created by jisa on 2019/3/8.
//  Copyright © 2019 jisa. All rights reserved.
//

#import "MineViewController.h"
#import "FFCameraViewController.h"

@interface MineViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;
@property (nonatomic, strong) FFCameraViewController *cameraVC;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.portraitImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.portraitImageView.layer.borderWidth = 1;
    self.portraitImageView.layer.cornerRadius = 40;
}


- (IBAction)FF_clickProtrait:(id)sender {
    UIAlertController *con = [self FF_AlertControllerActionSheetWithTitle:nil message:nil];
    [self presentViewController:con animated:YES completion:nil];
}

- (UIAlertController *)FF_AlertControllerActionSheetWithTitle:(nullable NSString *)title message:(nullable NSString *)message {
    /// 修改UIAlertAction的颜色，利用KVC     [cancle setValue:PMTitleColor forKey:@"_titleTextColor"];
    /*
    // 修改title和message的样式。同理
    NSMutableAttributedString *alertTitleStr = [[NSMutableAttributedString alloc] initWithString:@"提示"];
    [alertTitleStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, alertTitleStr.length)];
    [alertTitleStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, alertTitleStr.length)];
    [alertController setValue:alertTitleStr forKey:@"attributedTitle"];
    
    NSMutableAttributedString *alertMsgStr = [[NSMutableAttributedString alloc] initWithString:@"修改内容"];
    [alertTitleStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, alertMsgStr.length)];
    [alertTitleStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, alertMsgStr.length)];
    [alertController setValue:alertMsgStr forKey:@"attributedMessage"];
     // https://www.jianshu.com/p/f6752f7f8709 如果需要修改UIAlertAction的字体参考。
    */
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAlertAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.cameraVC = [[FFCameraViewController alloc] init];
        [self presentViewController:self.cameraVC animated:YES completion:nil];
        NSLog(@"相册");
    }];
    UIAlertAction *libraryAlertAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"相机");
    }];
    UIAlertAction *cancleAlertAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [controller addAction:cameraAlertAction];
    [controller addAction:libraryAlertAction];
    [controller addAction:cancleAlertAction];
    return controller;
}


@end
