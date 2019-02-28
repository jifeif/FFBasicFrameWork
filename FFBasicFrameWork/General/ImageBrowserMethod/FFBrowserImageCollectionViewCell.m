//
//  FFBrowserImageCollectionViewCell.m
//  FFBasicFrameWork
//
//  Created by jisa on 2019/2/14.
//  Copyright © 2019 jisa. All rights reserved.
//

#import "FFBrowserImageCollectionViewCell.h"
#import "FFBrowserImageItem.h"

NSString *const FFBrowserImageCollectionViewCell_identity = @"FFBrowserImageCollectionViewCellIdentity";

@interface FFBrowserImageCollectionViewCell ()<UIScrollViewDelegate, CAAnimationDelegate, UIGestureRecognizerDelegate>
/// 容器为了缩放图片
@property (nonatomic, strong) UIScrollView *aScrollView;
/// Pan手势起始点
@property (nonatomic, assign) CGPoint       panStartPoint;
/// Pan手势
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@end

@implementation FFBrowserImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.aScrollView];
        [self.aScrollView addSubview:self.aImageView];
        [self FF_AddGesture];
        self.aScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
#if _IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_12_0
#else
#endif
    }
    return self;
}

#pragma mark -- system method
- (void)layoutSubviews {
    [super layoutSubviews];
    self.aScrollView.frame = self.bounds;
}

#pragma mark -- method
- (void)FF_AddGesture {
    // 单击
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(FF_HiddenBrowserView)];
    [self.aImageView addGestureRecognizer:tap];
    
    // 双击
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(FF_DoubleTouch)];
    doubleTap.numberOfTapsRequired = 2;
    //避免手势冲突，只有双击事件响应失败，才会响应单击事件
    [tap requireGestureRecognizerToFail:doubleTap];
    [self.aImageView addGestureRecognizer:doubleTap];
    
    // 拖动
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(FF_Pan:)];
    self.panGesture.delegate = self;
    [_aImageView addGestureRecognizer:self.panGesture];
}

- (void)setShowImage:(UIImage *)showImage {
    _showImage = showImage;
    CGSize imageSize = showImage.size;
    CGFloat height = imageSize.height * SCREEN_WIDTH / imageSize.width ;
    self.aImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    if (height > SCREEN_HEIGHT) {
        self.aImageView.center = CGPointMake(SCREEN_WIDTH / 2, height / 2);
    }else {
        self.aImageView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
    }
    self.aImageView.image = showImage;
}

- (void)setShowImageURL:(NSString *)showImageURL {
    _showImageURL = showImageURL;
}

- (void)setBrowserImageItem:(FFBrowserImageItem *)browserImageItem {
    _browserImageItem = browserImageItem;
    if (browserImageItem.image) {
        [self FF_SetImage:browserImageItem.image];
    }else {
        __weak typeof(self) weak_self = self;
        NSLog(@"%@", browserImageItem.imageURL);
        [self.aImageView FF_LoadImageWithURLString:browserImageItem.imageURL andPlaceholdImage:nil resultBlock:^(UIImage * _Nullable image, NSError * _Nullable error) {
            __strong typeof(weak_self) strong_self = weak_self;
            if (image) {
                [strong_self FF_SetImage:image];
            }
        }];
    }
    
}

- (void)FF_SetImage:(UIImage *)image {
    CGSize imageSize = image.size;
    CGFloat height = imageSize.height * SCREEN_WIDTH / imageSize.width ;
    self.aImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    if (height > SCREEN_HEIGHT) {
        self.aImageView.center = CGPointMake(SCREEN_WIDTH / 2, height / 2);
    }else {
        self.aImageView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
    }
    self.aImageView.image = image;
    self.aScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, height);
    NSLog(@"%@", NSStringFromCGSize(self.aScrollView.contentSize));

}

// 单击
- (void)FF_HiddenBrowserView {
    if (self.aScrollView.zoomScale != 1.0) {
        [self.aScrollView setZoomScale:1.0 animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.28 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(FF_NeedHiddenImageBrowserView)]) {
                [self.delegate FF_NeedHiddenImageBrowserView];
            }
        });
    }else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(FF_NeedHiddenImageBrowserView)]) {
            [self.delegate FF_NeedHiddenImageBrowserView];
        }
    }
}

// 双击
- (void)FF_DoubleTouch {
    if (self.aScrollView.zoomScale < 1.5) {
        [self.aScrollView setZoomScale:2.0 animated:YES];
    }else {
        [self.aScrollView setZoomScale:1.0 animated:YES];
    }
}

// 拖动
- (void)FF_Pan:(UIPanGestureRecognizer *)pan {
    UIGestureRecognizerState state = pan.state;
    if (self.aScrollView.zoomScale > 1.1) {
        return;
    }
    switch (state) {
        case UIGestureRecognizerStateBegan:{
            self.panStartPoint = [pan locationInView:self.contentView];
            break;
        }
        case UIGestureRecognizerStateChanged:{
            CGPoint pin = [pan translationInView:self];
            CGFloat angle = 0;
            if (self.panStartPoint.x > SCREEN_WIDTH / 2) {
                //顺时针
                angle = M_PI_2 * pin.y / SCREEN_HEIGHT;
            }else {
                //逆时针
                angle = -M_PI_2 * pin.y / SCREEN_HEIGHT;
            }
            CGAffineTransform form1 = CGAffineTransformMakeRotation(angle);
            CGAffineTransform form2 = CGAffineTransformMakeTranslation(0, pin.y);
            CGAffineTransform form = CGAffineTransformConcat(form1, form2);
            self.aImageView.transform = form;
            double percent = 1 - fabs(pin.y / (SCREEN_HEIGHT / 2));
            self.supreCollectionView.superview.backgroundColor = [UIColor colorWithWhite:0 alpha:percent];
            break;
        }
        case UIGestureRecognizerStateCancelled:{
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:{
            CGPoint point = [pan translationInView:self.contentView];
            CGFloat velocityY = [pan velocityInView:self.contentView].y;
            if (fabs(point.y) > 200 || fabs(velocityY) > SCREEN_HEIGHT / 2) {
                [self FF_ContinueImageViewAnimationFromPoint:point];
            }else {
                [self FF_ImageViewInitialStateAnimation];
            }
            break;
        }
        default:
            break;
    }
}

- (void)FF_ContinueImageViewAnimationFromPoint:(CGPoint)point {
    BOOL isLeftDismiss = self.panStartPoint.x <= SCREEN_WIDTH / 2;
    BOOL isTopDismiss = point.y <= 0;
    CGFloat startAngle = 0;
    CGFloat endAngle = 0;
    CGFloat tranformMoveHeight = 0;
    if (isLeftDismiss) {
        startAngle = -M_PI_2 * (point.y / SCREEN_HEIGHT);
        endAngle = isTopDismiss ? M_PI_2 : -M_PI_2;
    }else {
        startAngle = M_PI_2 * (point.y / SCREEN_HEIGHT);
        endAngle = isTopDismiss ? -M_PI_2 : M_PI_2;
    }
    
    if (isTopDismiss) {
        tranformMoveHeight = -SCREEN_HEIGHT;
    }else {
        tranformMoveHeight = SCREEN_HEIGHT;
    }
    
    
    CABasicAnimation *basicRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basicRotation.fromValue = @(startAngle);
    basicRotation.toValue = @(endAngle);
    CABasicAnimation *basicTransfrom = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    basicTransfrom.fromValue = @(point.y);
    basicTransfrom.toValue = @(tranformMoveHeight);
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[basicRotation, basicTransfrom];
    animationGroup.duration = 0.4;
    animationGroup.repeatCount = 1;
    animationGroup.autoreverses = NO;
    animationGroup.delegate = self;
    [animationGroup setValue:@"animationGroup" forKey:@"aId"];
    [self.aImageView.layer addAnimation:animationGroup forKey:@"animationGroup"];
    
    CGAffineTransform form1 = CGAffineTransformMakeRotation(endAngle);
    CGAffineTransform form2 = CGAffineTransformMakeTranslation(0, tranformMoveHeight);
    CGAffineTransform form = CGAffineTransformConcat(form1, form2);
    self.aImageView.transform = form;
    [UIView animateWithDuration:0.4 animations:^{
        self.contentView.alpha = 0;
    } completion:^(BOOL finished) {
    }];
}

// 恢复初始状态的动画
- (void)FF_ImageViewInitialStateAnimation {
    [UIView animateWithDuration:0.5 animations:^{
        self.aImageView.transform = CGAffineTransformIdentity;
        self.supreCollectionView.superview.backgroundColor = [UIColor blackColor];
    }];
}

#pragma mark -- scrollView delegate
/// 返回要缩放的View
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.aImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // 如果ContentSize宽度大于屏幕宽度，则图片中心点在X轴上的位置为ContentSize.width / 2,否则，图片中心点在X轴上的位置为ContentSize.width / 2 + (屏幕的宽度-ContentSize的宽度) / 2;
    // 保持图片居中
    CGSize contentSize = scrollView.contentSize;
    CGFloat offSetX = contentSize.width > SCREEN_WIDTH ? 0 : (SCREEN_WIDTH - contentSize.width) / 2;
    CGFloat offSetY = contentSize.height > SCREEN_HEIGHT ? 0 : (SCREEN_HEIGHT - contentSize.height) / 2;
    self.aImageView.center = CGPointMake(contentSize.width / 2 + offSetX,
                                         contentSize.height / 2 + offSetY);
}

#pragma mark -- animation delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([[anim valueForKey:@"aId"] isEqualToString:@"animationGroup"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(FF_DismisNavigation)]) {
            [self.delegate FF_DismisNavigation];
        }
    }
}

#pragma mark -- gesture delegate
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    if (![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return  YES;
    }
    if (self.aScrollView.contentSize.height > self.contentView.bounds.size.height) {
        return NO;
    }
    //判断滑动方向
    CGPoint velocity = [gestureRecognizer velocityInView:self.contentView];
    
    // 如果是左右滑动，不在响应拖拽手势；如果是上下滑动，就相应拖拽的手势
    if (fabs(velocity.x) > fabs(velocity.y)){
        return NO;
    }else{
        return YES;
    }

}



#pragma mark -- lazy
- (UIScrollView *)aScrollView {
    if (!_aScrollView) {
        _aScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _aScrollView.bounces = NO;
        _aScrollView.delegate = self;
        _aScrollView.showsVerticalScrollIndicator = YES;
        _aScrollView.showsHorizontalScrollIndicator = YES;
        _aScrollView.minimumZoomScale = 0.5;
        _aScrollView.maximumZoomScale = 2;
        _aScrollView.delaysContentTouches = NO;
    }
    return _aScrollView;
}

- (UIImageView *)aImageView {
    if (!_aImageView) {
        _aImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _aImageView.contentMode = UIViewContentModeScaleAspectFit;
        _aImageView.userInteractionEnabled = YES;
    }
    return _aImageView;
}

@end
