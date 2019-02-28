//
//  UIImageView+Extension.m
//  FFBasicFrameWork
//
//  Created by jisa on 2019/2/23.
//  Copyright © 2019 jisa. All rights reserved.
//

#import "UIImageView+Extension.h"

@implementation UIImageView (Extension)

- (void)FF_LoadImageWithURLString:(nonnull NSString *)urlString andPlaceholdImage:(nullable NSString *)placeholdImageName resultBlock:(void(^)(UIImage * _Nullable image, NSError * _Nullable error))resultBlock{
    if ([urlString containsString:@"http"]) {
        NSURL *url = [NSURL URLWithString:urlString];
        if (placeholdImageName) {
            [self sd_setImageWithURL:url placeholderImage:FFIMAGE(placeholdImageName) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                resultBlock(image, error);
            }];
        }else {
            [self sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                resultBlock(image, error);
            }];
        }
    }
}

@end
