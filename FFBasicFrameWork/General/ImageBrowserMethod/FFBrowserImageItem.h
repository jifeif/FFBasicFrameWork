//
//  FFBrowserImageItem.h
//  FFBasicFrameWork
//
//  Created by jisa on 2019/2/20.
//  Copyright © 2019 jisa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FFBrowserImageItem : NSObject
/// 通过URL获取图片
@property (nonatomic, strong) NSString *imageURL;
/// 通过在前一个页面的imageView的位置，来做动画
@property (nonatomic, strong) UIImageView *aImageView;
/// 直接传递的是图片
@property (nonatomic, strong) UIImage *image;

+ (instancetype)initWithImageURL:(NSString *)imageURL andImageView:(UIImageView *)aImageView;
+ (instancetype)initWithImage:(UIImage *)image andImageView:(UIImageView *)aImageView;
@end

NS_ASSUME_NONNULL_END
