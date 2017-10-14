//
//  guanzhuViewController.h
//  zhubo
//
//  Created by Jin on 2017/8/5.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol guanzhuViewControllerDelegate <NSObject>

-(void)gengxinyonghu:(NSDictionary *)dic index:(NSInteger)index;

@end

@interface guanzhuViewController : UIViewController

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, strong) id<guanzhuViewControllerDelegate> delegate;

@end
