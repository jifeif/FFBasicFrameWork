//
//  FFBrowserImageItem.m
//  FFBasicFrameWork
//
//  Created by jisa on 2019/2/20.
//  Copyright © 2019 jisa. All rights reserved.
//

#import "FFBrowserImageItem.h"

@implementation FFBrowserImageItem

+ (instancetype)initWithImageURL:(NSString *)imageURL andImageView:(UIImageView *)aImageView {
    return [[FFBrowserImageItem alloc] initWithImageURL:imageURL andImageView:aImageView];
}

- (instancetype)initWithImageURL:(NSString *)imageURL andImageView:(UIImageView *)aImageView {
    if (self = [super init]) {
        self.imageURL = imageURL;
        self.aImageView = aImageView;
    }
    return self;
}

+ (instancetype)initWithImage:(UIImage *)image andImageView:(UIImageView *)aImageView {
    return [[FFBrowserImageItem alloc] initWithImage:image andImageView:aImageView];
}

- (instancetype)initWithImage:(UIImage *)image andImageView:(UIImageView *)aImageView {
    if (self = [super init]) {
        self.image = image;
        self.aImageView = aImageView;
    }
    return self;
}

@end
