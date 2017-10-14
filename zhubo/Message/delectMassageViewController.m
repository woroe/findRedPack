//
//  delectMassageViewController.m
//  zhubo
//
//  Created by Jin on 2017/8/22.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "delectMassageViewController.h"

@interface delectMassageViewController ()

@end

@implementation delectMassageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.468f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismissViewController];
}

- (IBAction)delecatAction:(id)sender {
    [self dismissViewController];
    [self.delegate delecatMessageAtion];
}
@end
