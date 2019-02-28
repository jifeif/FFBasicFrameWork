
//
//  FFBrowserImageViewController.m
//  FFBasicFrameWork
//
//  Created by jisa on 2019/2/20.
//  Copyright © 2019 jisa. All rights reserved.
//

#import "FFBrowserImageViewController.h"
#import "FFBrowserImageCollectionViewCell.h"
#import "FFBrowserImageItem.h"
#import "FFPageControl.h"


@interface FFBrowserImageViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, FFBrowserImageCollectionViewCellProtocol>
@property (nonatomic, strong) UICollectionView *aCollectionView;
@property (nonatomic, strong) NSMutableArray<FFBrowserImageItem *> *itemArray;
@property (nonatomic, assign) NSInteger         selectIndex;
@property (nonatomic, strong) FFPageControl    *pageControl;
@end

@implementation FFBrowserImageViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.itemArray = [@[] mutableCopy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.aCollectionView];
    self.view.backgroundColor = [UIColor clearColor];
    self.pageControl = [[FFPageControl alloc] init];
    self.pageControl.numberOfPages = self.itemArray.count;
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    [self.view addSubview:self.pageControl];
    self.pageControl.frame = CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50);
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_11_0
    _aCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
#else
    self.automaticallyAdjustsScrollViewInsets = NO;
#endif
}

#pragma mark -- system method
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.aCollectionView.frame = self.view.bounds;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.pageControl.currentPages = self.selectIndex;
    [self.aCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    UIImageView *needImageView = self.itemArray[self.selectIndex].aImageView;
    CGRect startRect = [self.view convertRect:needImageView.frame fromView:needImageView.superview];
    CGSize tempSize = needImageView.image.size;
    CGFloat width = tempSize.width;
    CGFloat height = tempSize.height;
    CGSize endSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH / width * height > SCREEN_HEIGHT ? SCREEN_HEIGHT : SCREEN_WIDTH / width * height);
    UIImageView *placeImageView = [[UIImageView alloc] initWithImage:needImageView.image];
    placeImageView.frame = startRect;
    placeImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:placeImageView];
    self.aCollectionView.hidden = YES;
    [UIView animateWithDuration:0.28 animations:^{
        placeImageView.center = self.view.center;
        placeImageView.bounds = CGRectMake(0, 0, endSize.width, endSize.height);
        self.view.backgroundColor = [UIColor blackColor];
    } completion:^(BOOL finished) {
        self.aCollectionView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            placeImageView.alpha = 0;
        } completion:^(BOOL finished) {
            [placeImageView removeFromSuperview];
        }];
    }];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark -- flexable method
- (void)FF_acquireNeedDataWithImageArray:(nullable NSArray *)imageArray imageURLArray:(nullable NSArray *)imageURLArray imageViewArray:(nullable NSArray *)imageViewArray selectIndex:(NSInteger)selectIndex {
    self.selectIndex = selectIndex;
    NSInteger max = MAX(imageArray.count, imageURLArray.count);
    NSInteger count = imageViewArray.count;
    NSAssert(max == count, @"传递的数据有问题");
    for (int i = 0; i < imageViewArray.count; i++) {
        FFBrowserImageItem *item = nil;
        if (imageArray.count > 0) {
            item = [FFBrowserImageItem initWithImage:imageArray[i] andImageView:imageViewArray[i]];
        }else {
            item = [FFBrowserImageItem initWithImageURL:imageURLArray[i] andImageView:imageViewArray[i]];
        }
        [self.itemArray addObject:item];
    }
}



#pragma mark --  delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FFBrowserImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FFBrowserImageCollectionViewCell_identity forIndexPath:indexPath];
    cell.supreCollectionView = self.aCollectionView;
    FFBrowserImageItem *item = self.itemArray[indexPath.row];
    cell.browserImageItem = item;
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.selectIndex = scrollView.contentOffset.x / scrollView.frame.size.width ;
    self.pageControl.currentPages = self.selectIndex;
}

- (void)FF_DismisNavigation {
    [self dismissViewControllerAnimated:NO completion:nil];
}

/// 隐藏图片浏览view
- (void)FF_NeedHiddenImageBrowserView {
    
    FFBrowserImageCollectionViewCell *cell = (FFBrowserImageCollectionViewCell *)[self.aCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex inSection:0]];
    FFBrowserImageItem *item = self.itemArray[self.selectIndex];
    CGRect originRect = [self.view convertRect:cell.aImageView.frame fromView:self.view];
    CGRect endRect = CGRectZero;
    if (item.aImageView) {
        endRect = [self.view convertRect:item.aImageView.frame fromView:item.aImageView.superview];
    }
    
    /// 占位
    UIImageView *placeImageView = [[UIImageView alloc] initWithImage:cell.aImageView.image];
    placeImageView.frame = originRect;
    [self.view addSubview:placeImageView];
    
    self.aCollectionView.hidden = YES;
    [UIView animateWithDuration:0.28 animations:^{
        if (![item.aImageView isEqual:[NSNull null]]) {
            placeImageView.frame = endRect;
        }
        self.pageControl.alpha = 0;
        self.view.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [placeImageView removeFromSuperview];
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

#pragma mark -- lazy
- (UICollectionView *)aCollectionView
{
    if (!_aCollectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        
        _aCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [_aCollectionView registerClass:[FFBrowserImageCollectionViewCell class] forCellWithReuseIdentifier:FFBrowserImageCollectionViewCell_identity];
        _aCollectionView.showsVerticalScrollIndicator = NO;
        _aCollectionView.showsHorizontalScrollIndicator = NO;
        _aCollectionView.delaysContentTouches = NO;
        _aCollectionView.backgroundColor = [UIColor clearColor];
        [_aCollectionView setContentSize:CGSizeMake(SCREEN_WIDTH * self.itemArray.count, SCREEN_HEIGHT)];
        _aCollectionView.pagingEnabled = YES;
        _aCollectionView.delegate = self;
        _aCollectionView.dataSource = self;
    }
    return _aCollectionView;
}

@end
