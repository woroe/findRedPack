//
//  CircleCreatViewController.h
//  zhubo
//
//  Created by Jin on 2017/6/19.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CircleCreatViewControllerDelegate <NSObject>

-(void)CircleOKRead;//创建成功时的回调


@end

@interface CircleCreatViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic, strong) id<CircleCreatViewControllerDelegate> delegate;

@end
