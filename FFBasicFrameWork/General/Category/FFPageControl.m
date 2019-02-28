//
//  UIPageControl+Extension.m
//  FFBasicFrameWork
//
//  Created by jisa on 2019/2/26.
//  Copyright © 2019 jisa. All rights reserved.
//

/*
 UIPagecontrol 的默认大小是 8 * 8 左右间隔是4.
 */



#import "FFPageControl.h"

@interface FFPageControl ()
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, assign) CGFloat viewDistance;
@property (nonatomic, strong) NSMutableArray<UIImageView *> *viewArray;
@property (nonatomic, assign) NSInteger lastSelect;
@end

@implementation FFPageControl
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self FF_initializeData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self FF_initializeData];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.normalIamge && self.currentImage && (self.normalIamge.size.height == self.currentImage.size.height)) {
        [self FF_updateSelectImageLayout];
    }else {
        CGFloat leftDis = (SCREEN_WIDTH - (self.viewWidth + self.viewDistance) * self.numberOfPages) / 2;
        for (int i = 0; i < self.viewArray.count; i++) {
            UIImageView *aImageView = self.viewArray[i];
            aImageView.frame = CGRectMake(leftDis + self.viewDistance + (self.viewDistance * 2 + self.viewWidth) * i , (self.bounds.size.height -  self.viewHeight) / 2, self.viewWidth, self.viewHeight);
            aImageView.layer.cornerRadius = self.viewHeight / 2;
            aImageView.layer.masksToBounds = YES;
        }
    }
}

#pragma mark -- set
- (void)setNumberOfPages:(NSInteger)numberOfPages {
    _numberOfPages = numberOfPages;
    [self.viewArray removeAllObjects];
    for (int i = 0; i < numberOfPages; i++) {
        UIImageView *aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
        aImageView.contentMode = UIViewContentModeScaleAspectFill;
        aImageView.backgroundColor = i == self.currentPages ? self.currentPageIndicatorTintColor : self.pageIndicatorTintColor;
        aImageView.image = self.currentImage;
        [self addSubview: aImageView];
        [self.viewArray addObject:aImageView];
    }
    if (self.numberOfPages == 1) {
        self.hidden = _hidesForSinglePage;
    }
}

- (void)setCurrentPages:(NSInteger)currentPages {
    _currentPages = currentPages;
    [self FF_setUp];
}

- (void)setNormalIamge:(UIImage *)normalIamge {
    _normalIamge = normalIamge;
    for (UIImageView *aImageView in self.viewArray) {
        aImageView.image = normalIamge;
    }
    [self FF_setUp];
}

- (void)setCurrentImage:(UIImage *)currentImage {
    _currentImage = currentImage;
    [self FF_setUp];
    if (currentImage != 0 && _numberOfPages > 0) {
        [self FF_updateSelectImageLayout];
    }
}


- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    if (self.viewArray.count > 0) {
        UIImageView *aImageView = self.viewArray[self.currentPages];
        aImageView.backgroundColor = currentPageIndicatorTintColor;
    }
    if (self.normalIamge || self.currentImage) {
        return;
    }else {
        [self FF_setUp];
    }
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    _pageIndicatorTintColor = pageIndicatorTintColor;
    int i = 0;
    for (UIImageView *aImageView in self.viewArray) {
        aImageView.backgroundColor = i == self.currentPages ? self.currentPageIndicatorTintColor : pageIndicatorTintColor;
        i++;
    }
    if (self.normalIamge || self.currentImage) {
        return;
    }else {
        [self FF_setUp];
    }
}

- (void)setHidesForSinglePage:(BOOL)hidesForSinglePage {
    _hidesForSinglePage = hidesForSinglePage;
    if (self.numberOfPages == 1) {
        self.hidden = hidesForSinglePage;
    }
}

#pragma mark -- method
- (void)FF_initializeData {
    self.viewWidth = 8;
    self.viewHeight = 8;
    self.viewDistance = 4;
    self.lastSelect = 0;
    self.currentPages = 0;
    self.numberOfPages = 0;
    self.hidesForSinglePage = YES;
    self.viewArray = [@[] mutableCopy];
    self.currentPageIndicatorTintColor = [UIColor grayColor];
    self.pageIndicatorTintColor = [UIColor whiteColor];
}

- (void)FF_setUp {
    if (self.numberOfPages > 0) {
        if (self.currentImage && self.normalIamge && (self.normalIamge.size.height == self.currentImage.size.height)) {
            [self FF_imageStateChange];
        }else {
            [self FF_colorStateChange];
        }
    }
}

- (void)FF_imageStateChange {
    if (self.lastSelect != _currentPages) {
        self.viewArray[_currentPages].image = self.currentImage;
        self.viewArray[_lastSelect].image = self.normalIamge;
        self.lastSelect = _currentPages;
    }
}

- (void)FF_colorStateChange {
    if (self.lastSelect != _currentPages) {
        self.viewArray[_currentPages].backgroundColor = self.currentPageIndicatorTintColor;
        self.viewArray[_lastSelect].backgroundColor = self.pageIndicatorTintColor;
        self.lastSelect = _currentPages;
    }
}

- (void)FF_updateSelectImageLayout {
    CGFloat normalWidth = self.normalIamge.size.width;
    CGFloat selectWidth = self.currentImage.size.width;
    CGFloat height = self.normalIamge.size.height;
    CGFloat leftDis = (SCREEN_WIDTH - normalWidth * (self.numberOfPages - 1) - selectWidth) / 2;
    CGFloat startDis = leftDis + self.viewDistance;
    for (int i = 0; i < self.viewArray.count; i++) {
        UIImageView *aImageView = self.viewArray[i];
        if (i == self.currentPages) {
            startDis = startDis + self.viewDistance * 2 + normalWidth * i;
            aImageView.frame = CGRectMake(startDis, (self.bounds.size.height - height) / 2, selectWidth, height);
        }else {
            startDis = startDis + self.viewDistance * 2 + normalWidth * (i - 1) + selectWidth;
            aImageView.frame = CGRectMake(startDis, (self.bounds.size.height - height) / 2, normalWidth, height);
        }
    }
}




@end
