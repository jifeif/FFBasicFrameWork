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

/**
 配置数据源

 @param imageArray 要浏览的大图（提前获得，不需要通过URL加载）
 @param imageURLArray 要浏览的图片（通过URL加载）
 @param imageViewArray imageView的数组，通过此来获取在父视图中的位置，用于做动画，
 @param selectIndex 点击的图片。
 */
- (void)FF_acquireNeedDataWithImageArray:(nullable NSArray *)imageArray imageURLArray:(nullable NSArray *)imageURLArray imageViewArray:(nullable NSArray *)imageViewArray selectIndex:(NSInteger)selectIndex;
@end

NS_ASSUME_NONNULL_END
