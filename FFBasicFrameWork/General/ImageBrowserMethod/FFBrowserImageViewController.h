//
//  FFBrowserImageViewController.h
//  FFBasicFrameWork
//
//  Created by jisa on 2019/2/20.
//  Copyright © 2019 jisa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FFBrowserImageViewController : UIViewController
- (void)FF_acquireNeedDataWithImageArray:(nullable NSArray *)imageArray imageURLArray:(nullable NSArray *)imageURLArray imageViewArray:(nullable NSArray *)imageViewArray selectIndex:(NSInteger)selectIndex;
@end

NS_ASSUME_NONNULL_END
