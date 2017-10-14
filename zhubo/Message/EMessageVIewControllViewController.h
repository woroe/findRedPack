//
//  EMessageVIewControllViewController.h
//  zhubo
//
//  Created by Jin on 2017/7/16.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <EaseUI/EaseUI.h>

@interface EMessageVIewControllViewController : EaseMessageViewController<EaseMessageViewControllerDelegate,EaseMessageViewControllerDataSource>


@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSDictionary *dic;


@end
