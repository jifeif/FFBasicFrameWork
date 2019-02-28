//
//  UIImage+Compress.m
//  FFBasicFrameWork
//
//  Created by jisa on 2019/2/12.
//  Copyright © 2019 jisa. All rights reserved.
//
/*
 图片压缩
 1：压缩图片质量（可以尽可能的保留图片的清晰度，但是不能保证图片压缩后一定小于指定的大小。为了性能采用二分法导致。循环六次 1/(2^6) = 0.015625 < 0.02 从而达到每次循环 compression减小 0.02 的效果）
 2：压缩图片大小 (会让图片损失一定的精确度，但是可以保证压缩后的图片，一定小于指定的大小)
 平衡性能后如果一定要保证图片小于某个指定的大小就需要方法一和二组合使用。
 
 Assets.xcassets
 1 适用存放小图片，由于图片只支持[UIImage imageNamed:@""]的方式实例化。
 2 不能从Bundle中加载（不能根据路径读取图片）因为图片会被打包在Assets.car文件中
 3 UIImage imageNamed]在图片使用完成后,不会直接被释放掉,具体释放时间由系统决定,适合小图片或者经常使用的图片。
 4 [UIImage imageWithContentsOfFile:@""] 从Bundle中加载图片，使用后会立即释放
 */

#import "UIImage+Extension.h"
#import <Photos/Photos.h>



@implementation UIImage (Extension)
/**
 将图片压缩到指定的质量
 
 @param kb 1MB == 1024KB
 @return 图片压缩后的质量
 */
- (NSData *)FF_CompressQualityToSpecialKB:(CGFloat)kb {
    CGFloat specialBytes = kb * 1024;
    NSData *imageDate = UIImageJPEGRepresentation(self, 1.0);
    if (imageDate.length < specialBytes) {
        return imageDate;
    }
    CGFloat min = 0;
    CGFloat max = 1;
    CGFloat compress = 1;
    for (int i = 0; i < 6; i++) {
        compress = (max + min) / 2;
        imageDate = UIImageJPEGRepresentation(self, compress);
        if (imageDate.length < specialBytes * 0.9) {
            min = compress;
        }else if (imageDate.length > specialBytes) {
            max = compress;
        }else {
            break;
        }
    }
    
    if (imageDate.length <= specialBytes) {
        return imageDate;
    }
    
    UIImage *tempImage = [UIImage imageWithData:imageDate];
    NSUInteger lastDateLength = 0;
    while (imageDate.length > specialBytes && lastDateLength != imageDate.length) {
        lastDateLength = imageDate.length;
        CGFloat tempScale = specialBytes / imageDate.length;
        CGSize tempSize = CGSizeMake((NSUInteger)(tempImage.size.width * tempScale),
                                     (NSUInteger)(tempImage.size.height * tempScale));
        UIGraphicsBeginImageContext(tempSize);
        [tempImage drawInRect:CGRectMake(0, 0, tempSize.width, tempSize.height)];
        tempImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        imageDate = UIImageJPEGRepresentation(tempImage, compress);
    }
    
    return imageDate;
}

- (UIImage *)FF_AcquireSpecialSizeImage:(CGRect)rect {
    CGImageRef imageRef = [self CGImage];
    CGImageRef needImageRef = CGImageCreateWithImageInRect(imageRef, rect);
    return [UIImage imageWithCGImage:needImageRef];
}

- (UIImage *)FF_CompressAspectFitSize:(CGSize)size {
    CGSize originSize = self.size;
    if (originSize.width <= size.width && originSize.height <= size.height) {
        return self;
    }
    UIImage *needImage = self;
    UIGraphicsBeginImageContext(size);
    CGFloat compressScale = MAX(originSize.width / size.width, originSize.height / size.height);
    CGFloat width = originSize.width / compressScale;
    CGFloat height = originSize.height / compressScale;
    [needImage drawInRect:CGRectMake((size.width - width) / 2, (size.height - height) / 2, width, height)];
    needImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return needImage;
}

- (UIImage *)FF_CompressSize:(CGSize)size {
    UIImage *result = self;
    UIGraphicsBeginImageContext(size);
    [result drawInRect:CGRectMake(0, 0, size.width, size.height)];
    result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
    
}

+ (UIImage *)FF_AcquireImageFromColor:(UIColor *)color {
    UIGraphicsBeginImageContext(CGSizeMake(1, 1));
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ref, color.CGColor);
    CGContextFillRect(ref, CGRectMake(0, 0, 1, 1));
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)FF_LoadImageWithName:(NSString *)name type:(NSString *)type {
    if (name && name.length > 0) {
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:type inDirectory:nil forLocalization:nil];
        return [UIImage imageWithContentsOfFile:path];
    }else {
        return [UIImage new];
    }
}

- (BOOL)FF_PhotoLibraryAuthorization {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
        }];
    }else if (status == PHAuthorizationStatusDenied) {
        
    }else {
        return YES;
    }
    return NO;
}

- (PHAssetCollection *)FF_CreatePhotoLibrary {
    NSString *title = [[NSBundle mainBundle].infoDictionary objectForKey:(NSString *)kCFBundleNameKey];
    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    PHAssetCollection *needCollection = nil;
    for (PHAssetCollection *collection in result) {
        if ([collection.localizedTitle isEqualToString:title]) {
            needCollection = collection;
        }
    }
    __block NSString *localIdentifierId = nil;
    if (!needCollection) {
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            localIdentifierId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
        } error:nil];
    }
    if (localIdentifierId) {
        needCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[localIdentifierId] options:nil].firstObject;
    }
    return needCollection;
}

/// 保存图片到相机相册
- (PHFetchResult<PHAsset *> *)FF_CreatedAssets {
    __block NSString *localIdentital = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        localIdentital = [PHAssetChangeRequest creationRequestForAssetFromImage:self].placeholderForCreatedAsset.localIdentifier;
    } error:nil];
    if (localIdentital) {
        return [PHAsset fetchAssetsWithLocalIdentifiers:@[localIdentital] options:nil];
    }else {
        return nil;
    }
}

/// 保存到自定义相册
- (void)FF_SaveImageToAlbum {
    if (![self FF_PhotoLibraryAuthorization]) {
        return;
    }
    PHAssetCollection *collection = [self FF_CreatePhotoLibrary];
    PHFetchResult<PHAsset *> *result = [self FF_CreatedAssets];
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];
        [request insertAssets:result atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } error:nil];
}


@end
