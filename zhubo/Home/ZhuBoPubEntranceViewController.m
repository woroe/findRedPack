//
//  ZhuBoPubEntranceViewController.m
//  zhubo
//
//  Created by Jin on 2017/6/12.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "ZhuBoPubEntranceViewController.h"

@interface ZhuBoPubEntranceViewController ()

@end

@implementation ZhuBoPubEntranceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.468f];
}

- (IBAction)choiceCamera:(id)sender {//退出圈子
    [self dismissViewController];
    [self.delegate tuichuCircleAtion];
}
- (IBAction)choicePhoto:(id)sender {
//    [[HomeViewController shareInstance] pushZhuBoEdit:0];
    [self dismissViewController];
    [self.delegate jubaoCricleAtion];
}



- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismissViewController];
}

@end
