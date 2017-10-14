//
//  ZhuBoPubEntranceViewController.h
//  zhubo
//
//  Created by Jin on 2017/6/12.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleModel.h"

@protocol ZhuBoPubEntranceViewControllerwDelegate <NSObject>

- (void)tuichuCircleAtion;
- (void)jubaoCricleAtion;

@end

@interface ZhuBoPubEntranceViewController : UIViewController

@property (nonatomic, strong) id<ZhuBoPubEntranceViewControllerwDelegate> delegate;

@property (nonatomic, strong)CircleModel *model;


@end
