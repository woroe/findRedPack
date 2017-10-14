//
//  ZhuBoDetailViewController.h
//  zhubo
//
//  Created by Jin on 2017/6/15.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZhuBoModel.h"

@interface ZhuBoDetailViewController : UIViewController

@property (nonatomic, strong)ZhuBoModel *zhuboModel;
@property (nonatomic, strong)NSString *qz_And_News_Str;//1新闻  2 圈子动态

@end
