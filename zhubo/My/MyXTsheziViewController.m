//
//  MyXTsheziViewController.m
//  zhubo
//
//  Created by Jin on 2017/7/13.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "MyXTsheziViewController.h"

#import "BaseLoginViewController.h"

#import "yhxyiViewController.h"

#import "guanyuazhuViewController.h"

@interface MyXTsheziViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)NSMutableArray *textFArr;

@property(nonatomic,strong)UITableView *tabView;

@end

@implementation MyXTsheziViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"系统设置";
    self.view.backgroundColor = BaseColorhuise;
    
    _dataArr = [[NSMutableArray alloc] initWithObjects:@"关于阿筑", nil];
    _textFArr = [NSMutableArray new];
    
    UITableView *tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
    tabView.backgroundColor = [UIColor colorWithRed:239/255.0f green:240/255.0f blue:242/255.0f alpha:1];
    tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabView.delegate = self;
    tabView.dataSource = self;
    tabView.scrollEnabled = NO;
    self.tabView = tabView;
    [self.view addSubview:self.tabView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }else {
        while ([cell.contentView.subviews lastObject] != nil){
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {// 关于阿筑
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = _dataArr[0];
    }
    if(indexPath.section == 1){
        cell.textLabel.text = @"退出登录";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor redColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        guanyuazhuViewController *vc = [[guanyuazhuViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 1) {
        
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要退出登录吗" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *AAsc = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 退出环信
            EMError *error = [[EMClient sharedClient] logout:YES];
            if (!error) {
                ZBLog(@"退出退出成功");
            }
            NSDictionary *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
            if(user){
                NSUserDefaults *userDe = [NSUserDefaults standardUserDefaults];
                [userDe removeObjectForKey:@"user"];
            }
            [[BaseData shareInstance] setUser:nil];
            // APP退出
            BaseLoginViewController *loginVC = [[BaseLoginViewController alloc] init];
            [self presentViewController:loginVC animated:YES completion:^{
            }];
        }];
        [ac addAction:AAsc];
        UIAlertAction *AAsc1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [ac addAction:AAsc1];
        [self presentViewController:ac animated:YES completion:nil];
    }
}
/*!
 *  当前登录账号已经被从服务器端删除时会收到该回调
 */
- (void)userAccountDidRemoveFromServer{
    ZBLog(@"当前登录账号已经被从服务器端删除时会收到该回调");
}
/*!
 *  当前登录账号在其它设备登录时会接收到该回调
 */
- (void)userAccountDidLoginFromOtherDevice{
    ZBLog(@"当前登录账号在其它设备登录时会接收到该回调");
}


@end
