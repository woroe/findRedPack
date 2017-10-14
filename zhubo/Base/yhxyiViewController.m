//
//  yhxyiViewController.m
//  zhubo
//
//  Created by Jin on 2017/7/26.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "yhxyiViewController.h"

@interface yhxyiViewController ()

@end

@implementation yhxyiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib. 商务合作 //BusinessCooperation  About
    
    UIButton *fhbut = [self.view viewWithTag:100];
    [fhbut addTarget:self action:@selector(fanhuiAtion) forControlEvents:UIControlEventTouchDown];
    UIButton *wzdbut = [self.view viewWithTag:101];
    [wzdbut addTarget:self action:@selector(fanhuiAtion) forControlEvents:UIControlEventTouchDown];
    
    NSString *urlStr;
    if (self.str.intValue == 1) {
        UILabel *lal = [self.view viewWithTag:1010];
        lal.text = @"用户协议";
        urlStr = @"http://zhubo.duorenxiang.com/Web/AskZhuMsg.aspx?asktype=UserAgreement";
    }
    if(self.str.intValue == 2){
        urlStr = @"http://zhubo.duorenxiang.com/Web/AskZhuMsg.aspx?asktype=BusinessCooperation";
        wzdbut.hidden = YES;
    }
    if(self.str.intValue == 3){
        UILabel *lal = [self.view viewWithTag:1010];
        lal.text = @"关于阿筑";
        urlStr = @"http://zhubo.duorenxiang.com/Web/AskZhuMsg.aspx?asktype=About";
        self.webVIew.frame = self.view.frame;
        wzdbut.hidden = YES;
    }
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webVIew loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.s
}

-(void)fanhuiAtion{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
