//
//  BaseNaviViewController.m
//  zhubo
//
//  Created by Jin on 2017/6/9.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "BaseNaviViewController.h"

@interface BaseNaviViewController ()<UINavigationBarDelegate>

@end

@implementation BaseNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.barTintColor = BaseColorPurple;
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.translucent = NO;
    self.navigationBar.tintColor = [UIColor whiteColor];
    
    self.toolbar.barTintColor = [UIColor whiteColor];
    self.toolbar.tintColor = [UIColor whiteColor];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}



@end
