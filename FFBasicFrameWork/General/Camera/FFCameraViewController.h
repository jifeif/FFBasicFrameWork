//
//  FFCameraViewController.h
//  FFBasicFrameWork
//
//  Created by jisa on 2019/3/8.
//  Copyright © 2019 jisa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FFCameraViewController : UIViewController
///   是否需要保存到图库，默认YES
@property (nonatomic, assign) BOOL isNeedSaveLibrary;
@property (nonatomic, copy) void(^acquirePhotoBlock)(UIImage *aImage);
@end

NS_ASSUME_NONNULL_END
