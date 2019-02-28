//
//  UIImage+Compress.h
//  FFBasicFrameWork
//
//  Created by jisa on 2019/2/12.
//  Copyright © 2019 jisa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Extension)

/**
 将图片压缩到指定的质量(大小)

 @param kb 1MB == 1024KB
 @return 图片压缩后的质量
 */
- (NSData *)FF_CompressQualityToSpecialKB:(CGFloat)kb;

/**
 获取裁剪后的图片

 @param rect 图片要裁剪的区域
 @return 裁剪后需要的图片
 */
- (UIImage *)FF_AcquireSpecialSizeImage:(CGRect)rect;


/**
 压缩图片到指定的尺寸

 @param size 要压缩的尺寸
 @return 压缩后的图片
 */
- (UIImage *)FF_CompressAspectFitSize:(CGSize)size;
/*
 压缩图片到指定的尺寸
 */
- (UIImage *)FF_CompressSize:(CGSize)size;

/**
 是否有相册授权，如果未决定的话，请求系统弹窗

 @return 是否相册授权成功
 */
- (BOOL)FF_PhotoLibraryAuthorization;

/**
 保存图片到自定义相册
 */
- (void)FF_SaveImageToAlbum;



/***************************************/

/**
 通过颜色获取图片
 
 @param color 颜色
 @return 图片
 */
+ (UIImage *)FF_AcquireImageFromColor:(UIColor *)color;


/**
 加载图片

 @param name 名称
 @param type 类型
 @return 需要的图片
 */
+ (UIImage *)FF_LoadImageWithName:(NSString *)name type:(NSString *)type;

@end

NS_ASSUME_NONNULL_END
