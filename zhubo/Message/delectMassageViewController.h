//
//  delectMassageViewController.h
//  zhubo
//
//  Created by Jin on 2017/8/22.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol delectMassageViewControllerDelegate <NSObject>

- (void)delecatMessageAtion;

@end

@interface delectMassageViewController: UIViewController

@property (nonatomic, strong) id<delectMassageViewControllerDelegate> delegate;

- (IBAction)delecatAction:(id)sender;


@end
