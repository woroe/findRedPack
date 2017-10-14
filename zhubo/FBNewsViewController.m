//
//  FBNewsViewController.m
//  zhubo
//
//  Created by Jin on 2017/7/25.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "FBNewsViewController.h"

#import "TJBQViewController.h"

@interface FBNewsViewController ()<UIScrollViewDelegate>


@property (nonatomic, strong) UIScrollView *scrollView;


@end


@implementation FBNewsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect frame = self.view.frame;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    TJBQViewController *vc = [[TJBQViewController alloc]init];
    [self addChildViewController:vc];
    [self.scrollView addSubview:vc.view];
}

- (void)hiddenTipsLabel {
    //    self.labelTipTitle.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

}


@end
