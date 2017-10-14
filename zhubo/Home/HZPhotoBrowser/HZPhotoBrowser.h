//
//  HZPhotoBrowser.h
//  photoBrowser
//
//  Created by huangzhenyu on 15/6/23.
//  Copyright (c) 2015年 eamon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZPhotoBrowserView.h"

#import "ZYTagImageView.h"
#import "ZYTagInfo.h"
#import "ZYTagView.h"
#import "ZhuBoModel.h"

@class HZPhotoBrowser;

@protocol HZPhotoBrowserDelegate <NSObject>

- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;
- (ZhuBoModel *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;
@end

@interface HZPhotoBrowser : UIViewController

@property (nonatomic, weak) UIView *sourceImagesContainerView;
@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, assign) NSInteger imageCount;//图片总数

@property (nonatomic, strong) ZhuBoModel *model;


@property (nonatomic, weak) id<HZPhotoBrowserDelegate> delegate;

- (void)show;
@end
