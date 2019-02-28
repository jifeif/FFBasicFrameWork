//
//  UIPageControl+Extension.h
//  FFBasicFrameWork
//
//  Created by jisa on 2019/2/26.
//  Copyright © 2019 jisa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FFPageControl : UIView
@property (nonatomic, strong) UIImage *normalIamge;
@property (nonatomic, strong) UIImage *currentImage;
@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, assign) NSInteger currentPages;
/// 模拟如果只有一个的话隐藏
@property (nonatomic, assign) BOOL      hidesForSinglePage;
@property(nullable, nonatomic,strong) UIColor *pageIndicatorTintColor;
@property(nullable, nonatomic,strong) UIColor *currentPageIndicatorTintColor;
@end

NS_ASSUME_NONNULL_END
