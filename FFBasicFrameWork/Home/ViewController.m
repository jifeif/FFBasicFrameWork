//
//  ViewController.m
//  FFBasicFrameWork
//
//  Created by jisa on 2019/2/12.
//  Copyright © 2019 jisa. All rights reserved.
//
/*
 NSLayoutConstraint
 1: 必须将自动布局转约束的属性关闭 translatesAutoresizingMaskIntoConstraints = NO
 2: addContraint时必须将约束添加在公共父视图上，如果只涉及到一个视图那么添加在该视图上。
 
 
 */

#import "ViewController.h"
#import "FFBrowserImageViewController.h"
#import "FFHomeCollectionViewCell.h"

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *aCollectionView;

@property (nonatomic, strong) UIImageView *aImageView;
@property (nonatomic, strong) UIButton    *aBtn;
@property (nonatomic, strong) NSArray     *imageArr;

@end

@implementation ViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageArr = @[
                      @"http://ww3.sinaimg.cn/bmiddle/005WR3hOjw1eo3ltq2kyrj315o0rogq2.jpg",
                      @"http://ww2.sinaimg.cn/bmiddle/005WR3hOjw1eo3ltpfur8j30dw0a7q36.jpg",
                      @"http://ww3.sinaimg.cn/bmiddle/670721e9ly1fgna7r4w7vj20u010fdl6.jpg",
                      @"http://ww4.sinaimg.cn/bmiddle/6bacde9agw1dm5uqi9in4j.jpg",
                      @"http://ww4.sinaimg.cn/bmiddle/005XUU3ely1fidpy7iha9j30hs13y7eg.jpg",
                      @"http://wx3.sinaimg.cn/mw690/4b08ac5ely1fi6cnvl5kdj20zk18gwmi.jpg",
                      @"http://wx4.sinaimg.cn/mw690/4b08ac5ely1fi6cnybwb0j20tm18ggr7.jpg",
                      @"http://wx2.sinaimg.cn/mw690/006qaoP0gy1fhyv70qdpej32kw3vcnpg.jpg",
                      @"http://wx3.sinaimg.cn/mw690/4b08ac5ely1fi6cnvl5kdj20zk18gwmi.jpg",
                      @"http://wx4.sinaimg.cn/mw690/4b08ac5ely1fi6cnybwb0j20tm18ggr7.jpg",
                      @"http://wx2.sinaimg.cn/mw690/006qaoP0gy1fhyv70qdpej32kw3vcnpg.jpg"
                      ];

//    self.view.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:self.aImageView];
//    [self.view addSubview:self.aBtn];
//    self.aImageView.frame = CGRectMake(20, 64, 150, 200);
//    NSLayoutConstraint *lay1 = [NSLayoutConstraint constraintWithItem:self.aBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.aImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:20];
//    NSLayoutConstraint *lay2 = [NSLayoutConstraint constraintWithItem:self.aBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:37];
//    NSLayoutConstraint *lay3 = [NSLayoutConstraint constraintWithItem:self.aBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-37];
//    NSLayoutConstraint *lay4 = [NSLayoutConstraint constraintWithItem:self.aBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44];
//    self.aBtn.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.view addConstraints:@[lay1, lay2, lay3]];
//    [self.aBtn addConstraint:lay4];
}

#pragma mark -- method
//- (void)FF_Click:(UIButton *)btn {
//
//    UIImage *image = [UIImage FF_LoadImageWithName:@"1" type:@"jpg"];
//    self.aImageView.image = image;
//
////    self.aImageView.contentMode = UIViewContentModeTop;
//    [image FF_SaveImageToAlbum];
//
////    [FFBrowserImageView FF_ShowBrowser];
//}
//
//- (void)tap:(UITapGestureRecognizer *)tap {
//    FFBrowserImageViewController *vc = [[FFBrowserImageViewController alloc] init];
//    [vc FF_acquireNeedDataWithImageArray:@[self.aImageView.image] imageURLArray:nil imageViewArray:@[self.aImageView] selectIndex:0];
//    [self presentViewController:vc animated:NO completion:nil];
//
//}

#pragma mark --
//- (UIImageView *)aImageView {
//    if (!_aImageView) {
//        _aImageView = [[UIImageView alloc] init];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
//        _aImageView.userInteractionEnabled = YES;
//        [_aImageView addGestureRecognizer:tap];
//    }
//    return _aImageView;
//}
//
//- (UIButton *)aBtn {
//    if (!_aBtn) {
//        _aBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//        _aBtn.backgroundColor = [UIColor magentaColor];
//        [_aBtn setTitle:@"点击" forState:UIControlStateNormal];
//        [_aBtn addTarget:self action:@selector(FF_Click:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _aBtn;
//}

#pragma mark -- collectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FFHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BrowserCell" forIndexPath:indexPath];
    [cell.aImageView FF_LoadImageWithURLString:self.imageArr[indexPath.row] andPlaceholdImage:nil resultBlock:^(UIImage * _Nullable image, NSError * _Nullable error) {
        CGFloat wid = cell.aImageView.frame.size.width;
        if (image.size.height > SCREEN_HEIGHT) {
            cell.aImageView.contentMode = UIViewContentModeTop;
            CGSize size = CGSizeMake(wid, image.size.height *  wid / image.size.width);
            cell.aImageView.image = [image FF_CompressSize:size];
        }else {
            cell.aImageView.contentMode = UIViewContentModeScaleAspectFit;
            cell.aImageView.image = image;
        }
    }];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FFBrowserImageViewController *vc = [[FFBrowserImageViewController alloc] init];
    NSMutableArray *array = [@[] mutableCopy];
    for (int i = 0; i < self.imageArr.count; i++) {
        FFHomeCollectionViewCell *cell = (FFHomeCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [array addObject:cell.aImageView ? : [NSNull null]];
    }
    [vc FF_acquireNeedDataWithImageArray:nil imageURLArray:self.imageArr imageViewArray:array selectIndex:indexPath.row];
    [self presentViewController:vc animated:NO completion:nil];
}

@end
