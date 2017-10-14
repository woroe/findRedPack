//
//  WPhotoViewController.h
//  photoDemo
//
//  Created by wangxinxu on 2017/6/1.
//  Copyright © 2017年 wangxinxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myPhotoCell.h"
#import "UIImage+fixOrientation.h"
#import "WPMacros.h"
#import "WPFunctionView.h"
#import "NavView.h"

@protocol WPhotoViewControllerDelegate <NSObject>

- (void)getWPHPlayerUrl:(NSString *)url image:(UIImage *)image;
- (void)getWPHImage:(UIImage *)image;

@end

@interface WPhotoViewController : UIViewController

@property (assign, nonatomic) NSInteger selectPhotoOfMax;/**< 选择照片的最多张数 */

/** 回调方法 */
@property (nonatomic, copy) void(^selectPhotosBack)(NSMutableArray *photosArr);


@property (nonatomic, assign) NSInteger perAndFanhuiInt;
@property (nonatomic, assign) NSInteger addtagArrayCountInt;

@property (nonatomic, assign) BOOL isXiangJi;


@property (nonatomic, strong) id<WPhotoViewControllerDelegate> delegate;

@end
