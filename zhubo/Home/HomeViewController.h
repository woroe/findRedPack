//
//  HomeViewController.h
//  zhubo
//
//  Created by Jin on 2017/6/8.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : BaseViewController

+ (instancetype)shareInstance;
- (void)loadLoginVC;
- (void)pushZhuBoEdit:(NSInteger)type;

@end
