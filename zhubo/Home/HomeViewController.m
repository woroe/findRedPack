//
//  HomeViewController.m
//  zhubo
//
//  Created by Jin on 2017/6/8.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTitleView.h"
#import "ZhuBoTableViewController.h"
#import "DiscoverViewController.h"
#import "ZhuBoPubEntranceViewController.h"
#import "ZhuBoEditViewController.h"

#import "ZhuBoTJTableViewController.h"
#import "ZhuBoGZTableViewController.h"
#import "ZBGCTableViewController.h"

#import "UITabBarItem+DKSBadge.h"

@interface HomeViewController ()<HomeTitleViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) HomeTitleView *titleView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ZhuBoPubEntranceViewController *entranceVC;
@property (nonatomic, strong) BaseLoginViewController *loginVC;


@end

@implementation HomeViewController

static HomeViewController *_share;

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _share = [super allocWithZone:zone];
    });
    
    return _share;
}
+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _share = [[self alloc] init];
    });
    
    return _share;
}
- (id)copyWithZone:(NSZone *)zone{
    return _share;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gohome_zuiXing) name:@"gohome_zuiXing" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gohome) name:@"gohome" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tishixiaoxi) name:@"tishixiaoxi" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goHome_GC) name:@"GC_SUSSCESS" object:nil];
    [self loadLoginVC];
    [self loadUI];
}
- (void)viewWillAppear:(BOOL)animated {
    self.edgesForExtendedLayout = UIRectEdgeNone;
}
-(void)gohome{
    [self selectedBtn:1];
}
-(void)tishixiaoxi{
    NSArray *arrControllers = self.tabBarController.viewControllers;
    for(UIViewController *viewController in arrControllers){
        if ([viewController isKindOfClass:[MessageNaviViewController class]]) {
            [viewController.tabBarItem showBadge];
        }
    }
}
-(void)gohome_zuiXing {
    [self selectedBtn:1];
}

-(void)goHome_GC {
    [self selectedBtn:2];
}

- (void)loadUI {
    
    //titleView
    HomeTitleView *titleView = [HomeTitleView instanceView];
    titleView.delegate = self;
    titleView.zhuboBtn.titleLabel.font = [UIFont systemFontOfSize: 17.0];
    titleView.discoverBtn.titleLabel.font = [UIFont systemFontOfSize: 17.0];
    titleView.guanzhuBtn.titleLabel.font = [UIFont systemFontOfSize: 17.0];
    self.navigationItem.titleView = titleView;
    self.titleView = titleView;
    
    //rightBarButtonItem
//    UIImage *photoIcon=[UIImage imageNamed: @"photoIcon"];
//    photoIcon = [photoIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:photoIcon style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
//    self.navigationItem.rightBarButtonItem = item;
    
    //scrollView
    CGRect frame = self.view.frame;
    frame.size.height = CONTENT_HEIGHT;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 4, CONTENT_HEIGHT);
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    
    ZhuBoTableViewController *zhuboVC1 = [[ZhuBoTableViewController alloc] init];
    zhuboVC1.view.frame = frame;
    [self addChildViewController:zhuboVC1];
    [self.scrollView addSubview:zhuboVC1.view];
    
    frame = self.view.frame;
    frame.origin.x = frame.size.width;
    frame.size.height =  frame.size.height-80;
    ZhuBoGZTableViewController *zhuboVC2 = [[ZhuBoGZTableViewController alloc] init];
    zhuboVC2.view.frame = frame;
    [self addChildViewController:zhuboVC2];
    [self.scrollView addSubview:zhuboVC2.view];
    
    frame = self.view.frame;
    frame.origin.x = 2*frame.size.width;
    frame.size.height =  frame.size.height-60;
    ZBGCTableViewController *zhuboVC3 = [[ZBGCTableViewController alloc] init];
    zhuboVC3.view.frame = frame;
    [self addChildViewController:zhuboVC3];
    [self.scrollView addSubview:zhuboVC3.view];
    
    frame = self.view.frame;
    frame.origin.x = 3*frame.size.width;
    frame.size.height =  frame.size.height-60;
    ZhuBoTJTableViewController *zhuboVC = [[ZhuBoTJTableViewController alloc] init];
    zhuboVC.view.frame = frame;
    [self addChildViewController:zhuboVC];
    [self.scrollView addSubview:zhuboVC.view];
    
//    frame = self.view.frame;
//    frame.origin.x = frame.size.width;
//    DiscoverViewController *discoverVC = [[DiscoverViewController alloc] init];
//    discoverVC.view.frame = frame;
//    [self addChildViewController:discoverVC];
//    [self.scrollView addSubview:discoverVC.view];
    
    ZBLog(@"--1-%@", NSStringFromCGRect(self.view.frame));
    ZBLog(@"--scrollView-%@",NSStringFromCGRect(self.scrollView.frame));
    
}
- (void)loadLoginVC {
    NSDictionary *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    if(user){
        [[BaseData shareInstance] setUser:user];
        return;
    }
    
    if(!self.loginVC){
        self.loginVC = [[BaseLoginViewController alloc] init];
    }
    [self presentViewController:self.loginVC animated:YES completion:^{
    }];
}


#pragma mark - click

- (void)rightBtnClick {
    ZhuBoPubEntranceViewController *entranceVC = [[ZhuBoPubEntranceViewController alloc] init];
    [entranceVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    //背景透明
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        entranceVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    }else{
        self.modalPresentationStyle=UIModalPresentationCurrentContext;
    }
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:entranceVC animated:YES completion:^{
    }];
}
- (void)pushZhuBoEdit:(NSInteger)type {
//    ZhuBoEditViewController *editVC = [[ZhuBoEditViewController alloc] init];
//    editVC.photoType = type;
//    [self.navigationController pushViewController:editVC animated:YES];
}
#pragma mark - delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self.titleView setSelectedBtn:index];
}

- (void)selectedBtn:(NSInteger)index {
    CGPoint point = self.scrollView.contentOffset;
    point.x = index * self.scrollView.frame.size.width;
    self.scrollView.contentOffset = point;
    [self.titleView setSelectedBtn:index];
}



@end
