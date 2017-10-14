//
//  BaseViewController.m
//  zhubo
//
//  Created by Jin on 2017/6/8.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    self.view.backgroundColor = RandomColor;
    self.view.backgroundColor = BaseColorBackGround;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
//    UIImage *image = [UIImage imageNamed:@"back"];
//    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:nil action:nil];
//    self.navigationItem.backBarButtonItem = backItem;
//    
//    [[UINavigationBar appearance] setBackIndicatorImage:[[UIImage alloc]init]];
//    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[[UIImage alloc] init]];
}


@end
