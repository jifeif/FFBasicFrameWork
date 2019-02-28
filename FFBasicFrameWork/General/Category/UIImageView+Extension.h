//
//  UIImageView+Extension.h
//  FFBasicFrameWork
//
//  Created by jisa on 2019/2/23.
//  Copyright © 2019 jisa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (Extension)
- (void)FF_LoadImageWithURLString:(nonnull NSString *)urlString andPlaceholdImage:(nullable NSString *)placeholdImageName resultBlock:(void(^)(UIImage * _Nullable image, NSError * _Nullable error))resultBlock;
@end

NS_ASSUME_NONNULL_END
