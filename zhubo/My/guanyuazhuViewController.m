//
//  guanyuazhuViewController.m
//  zhubo
//
//  Created by Jin on 2017/8/31.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "guanyuazhuViewController.h"

@interface guanyuazhuViewController ()

@end

@implementation guanyuazhuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"关于阿筑";
    
    UIImage *photoIcon=[UIImage imageNamed: @"back"];
    photoIcon = [photoIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:photoIcon style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
    self.navigationItem.leftBarButtonItem = item;

    
    UIImageView *imageView = [self.view viewWithTag:10];
    imageView.image = [UIImage imageNamed:@"guanyu"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)rightBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
