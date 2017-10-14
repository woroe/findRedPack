//
//  HVideoViewController.h
//  Join
//
//  Created by 黄克瑾 on 2017/1/11.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TJBQViewController.h"

@protocol HVideoViewControllerDelegate <NSObject>

- (void)geiPlayerUrl:(NSString *)url image:(UIImage *)image;
- (void)getImage:(UIImage *)image;
- (void)getImageArr:(UIImage *)image arr:(NSMutableArray *)arr;
- (void)onCancelAction;

@end

typedef void(^TakeOperationSureBlock)(id item);

@interface HVideoViewController : UIViewController

@property (copy, nonatomic) TakeOperationSureBlock takeBlock;

@property (assign, nonatomic) NSInteger HSeconds;

@property (nonatomic, strong) id<HVideoViewControllerDelegate> delegate;

@property (nonatomic, assign) NSInteger perAndFanhuiInt; // 1 第一次进入  2 第二次进入

@property (nonatomic, assign) NSInteger xiangceAndXiangjiBool;  // 1 相机   2 相册
@property (nonatomic, assign) NSInteger addtagArrayCountInt;

@property (nonatomic, assign) BOOL isBool;

@end
