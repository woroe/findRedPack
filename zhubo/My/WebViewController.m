//
//  WebViewController.m
//  zhubo
//
//  Created by Jin on 2017/8/10.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = self.titleStr;
    [self.webView loadHTMLString:self.webStr baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
