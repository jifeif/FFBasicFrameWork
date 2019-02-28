//
//  FFBrowserImageCollectionViewCell.h
//  FFBasicFrameWork
//
//  Created by jisa on 2019/2/14.
//  Copyright © 2019 jisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FFBrowserImageCollectionViewCellProtocol <NSObject>

/// 隐藏图片浏览view
- (void)FF_NeedHiddenImageBrowserView;
/// 取消导航
- (void)FF_DismisNavigation;
@end

NS_ASSUME_NONNULL_BEGIN
@class FFBrowserImageItem;
extern NSString *const FFBrowserImageCollectionViewCell_identity;
@interface FFBrowserImageCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImage *showImage;
@property (nonatomic, copy)   NSString *showImageURL;
@property (nonatomic, strong) FFBrowserImageItem *browserImageItem;

/// 要浏览的图片
@property (nonatomic, strong) UIImageView *aImageView;
@property (nonatomic, weak) id<FFBrowserImageCollectionViewCellProtocol> delegate;

@property (nonatomic, weak) UICollectionView *supreCollectionView;

@end

NS_ASSUME_NONNULL_END
