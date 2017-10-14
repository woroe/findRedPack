//
//  searchViewController.h
//  zhubo
//
//  Created by Jin on 2017/7/17.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CircleModel.h"

@protocol searchViewControllerDelegate <NSObject>

-(void)FbNewsCircle:(CircleModel *)sender;//发布动态


@end


@interface searchViewController : UIViewController<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) id<searchViewControllerDelegate> delegate;

@end
