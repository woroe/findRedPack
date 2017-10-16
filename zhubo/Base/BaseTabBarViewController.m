//
//  BaseTabBarViewController.m
//  zhubo
//
//  Created by Jin on 2017/6/8.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "BaseTabBarViewController.h"

#import "FBNewsViewController.h"
#import "TJBQViewController.h"

#import "HVideoViewController.h"

#import "UITabBarItem+DKSBadge.h"


@interface BaseTabBarViewController ()<UITabBarDelegate, UITabBarControllerDelegate>{

    
    NSTimer *timer ;
}

@property (nonatomic, assign)NSInteger selectedItemIndex;

@end

@implementation BaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1];
    [self loadTabBar];
    
}

- (void)loadTabBar {
    NSMutableArray *VCs = [NSMutableArray array];
    NSArray *navis = @[@"HomeNaviViewController", @"CircleNaviViewController", @"FBNewsNavViewController", @"MessageNaviViewController", @"MyNaviViewController"];
    NSArray *rootvcs = @[@"HomeViewController", @"findIndexController", @"FBNewsViewController", @"MessageViewController", @"MyViewController"];
    NSArray *titles = @[@"筑播", @"附近", @"", @"消息", @"我的"];
    NSArray *images = @[@"tab_home", @"btm_nearby", @"h_fabu", @"tab_xiaoxi", @"tab_user"];
    NSArray *selecteds = @[@"shouye_select", @"btm_nearby_clicked", @"h_fabu", @"tab_xiaoxi_f", @"btm_my_clicked"];
    for (NSInteger i = 0 ;i < 5; i++) {
        UIViewController *vc = [self viewController:navis[i] root:rootvcs[i] withTitle:titles[i] image:images[i] selected:selecteds[i]];
        [VCs addObject:vc];
    }
//    NSMutableArray *VCs = [NSMutableArray array];
//    NSArray *navis = @[@"HomeNaviViewController", @"CircleNaviViewController", @"MessageNaviViewController", @"MyNaviViewController"];
//    NSArray *rootvcs = @[@"HomeViewController", @"CircleViewController", @"MessageViewController", @"MyViewController"];
//    NSArray *titles = @[@"首页", @"圈子", @"消息", @"我的"];
//    NSArray *images = @[@"tab_home", @"tab_faxian", @"tab_xiaoxi", @"tab_user"];
//    NSArray *selecteds = @[@"shouye_select", @"tab_faxian_f", @"tab_xiaoxi_f", @"tab_user_f"];
//    for (NSInteger i = 0 ;i < 4; i++) {
//        UIViewController *vc = [self viewController:navis[i] root:rootvcs[i] withTitle:titles[i] image:images[i] selected:selecteds[i]];
//        [VCs addObject:vc];
//    }
    
    
    self.viewControllers = VCs;
    self.delegate = self;
    self.tabBar.barTintColor = [UIColor whiteColor];
    
    [self gcdAction];
}

-(void)gcdAction{
    NSTimer *timer111 = [NSTimer scheduledTimerWithTimeInterval:5.0f repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"UserId"] = @([BaseData shareInstance].userId);
        params[@"BuildSowingType"] = @"GetUnread";
        
        [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *res = (NSDictionary *)responseObject;
            if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
//                ZBLog(@"BuildSowing_News--%@", res);
                NSArray *dataArr = [res objectForKey:@"data"];
                if (dataArr.count >0) {
                    NSDictionary *dic = dataArr[0];
                    NSString *strIsUnread = [dic objectForKey:@"IsUnread"];
                    if (strIsUnread.intValue >0) {
                        [self.tabBar.items[4] showBadge];
                        self.tabBar.items[4].tag = 1;
                    }else{
                        [self.tabBar.items[4] hidenBadge];
                        self.tabBar.items[4].tag = 2;
                    }
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        }];
    }];
    [timer111 fire];
}

- (void)loadData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = @([BaseData shareInstance].userId);
    params[@"BuildSowingType"] = @"GetUnread";
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
//            ZBLog(@"BuildSowing_News--%@", res);
            NSArray *dataArr = [res objectForKey:@"data"];
            if (dataArr.count >0) {
                NSDictionary *dic = dataArr[0];
                NSString *strIsUnread = [dic objectForKey:@"IsUnread"];
                if (strIsUnread.intValue >0) {
                    [self.tabBar.items[4] showBadge];
                }else{
                    [self.tabBar.items[4] hidenBadge];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (UIViewController *)viewController:(NSString *)navi root:(NSString *)root withTitle:(NSString *)title image:(NSString *)image selected:(NSString *)selected {
    
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:image] selectedImage:[UIImage imageNamed:selected]];
    item.selectedImage = [UIImage imageNamed:selected];
//    item.badgeColor = [UIColor whiteColor];
    
    UIViewController *rootVC = (UIViewController *)[[NSClassFromString(root) alloc] init];
    UINavigationController *naviVC = (UINavigationController *)[[NSClassFromString(navi) alloc] initWithRootViewController:rootVC];
    naviVC.navigationBar.translucent = NO;
    naviVC.tabBarItem = item;
    return naviVC;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    if(self.selectedIndex >= 2 && [BaseClasss isLogin] == NO){
//        self.tabBar.barTintColor = [UIColor whiteColor];
        self.selectedIndex = self.selectedItemIndex;
        return;
    }
//    self.tabBar.barTintColor = [UIColor whiteColor];
    self.selectedItemIndex = self.selectedIndex;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    UIViewController *vc = viewController.childViewControllers[0];
    if ([vc isKindOfClass:[FBNewsViewController class]]) {
        HVideoViewController *ctrl = [[NSBundle mainBundle] loadNibNamed:@"HVideoViewController" owner:nil options:nil].lastObject;
        ctrl.HSeconds = 30;//设置可录制最长时间
        ctrl.perAndFanhuiInt =1;
        ctrl.takeBlock = ^(id item) {
            if ([item isKindOfClass:[NSURL class]]) {
            } else {
            }
        };
        [self presentViewController:ctrl animated:NO completion:nil];
        
        return NO;
    }
    return YES;
}

@end
