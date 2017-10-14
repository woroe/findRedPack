//
//  UserDetailViewController.m
//  zhubo
//
//  Created by Jin on 2017/6/15.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "UserDetailViewController.h"
#import "UserDetailHeader.h"
#import "UserDetailModel.h"
#import "ZhuBoModel.h"

#import "EMessageVIewControllViewController.h"

#import "ZhuBoDetailViewController.h"
#import "ZhuBoDetailView.h"

@interface UserDetailViewController ()

@property(nonatomic, strong)NSMutableArray *NewsMsgMtArr;

@property(nonatomic, strong) UserDetailHeader *headerView;
@property(nonatomic, strong) UserDetailModel *userModel;

@end

@implementation UserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _NewsMsgMtArr = [NSMutableArray new];
    
    [self loadUI];
    [self loadData];
    [self loadCircle_NewMsgData];
    [self loadHeaderView];
}

- (void)loadUI {
    self.title = @"用户详情";
    
}

- (void)loadHeaderView {
    
    UserDetailHeader *headerView = [[UserDetailHeader alloc] init];
    [headerView loadWithModel:_userModel];
    headerView.followBtnView.userInteractionEnabled = YES;
    [headerView.followBtnView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedFollowBtn:)]];
    
    [headerView.messageBtnView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(messageFollowBtn:)]];
    
    self.headerView = headerView;
    self.tableView.tableHeaderView = headerView;
}


- (void)clickedFollowBtn:(id)sender {
}

-(void)messageFollowBtn:(id)sender {
    
    NSString *hxyhStr = [NSString stringWithFormat:@"askzhu_%@",@([BaseData shareInstance].userId)];
    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
    if (!isAutoLogin) {
        EMError *error1 = [[EMClient sharedClient] loginWithUsername:hxyhStr password:@"123456"];
        if (!error1) {
            NSLog(@"登录成功");
            
        }else{
            NSLog(@"登录失败____%@",error1);
        }
    }
    NSString *hxyhStr11 = [NSString stringWithFormat:@"askzhu_%@",@(_userModel.userId)];
    EMessageVIewControllViewController *messageView = [[EMessageVIewControllViewController alloc]initWithConversationChatter:hxyhStr11 conversationType:EMConversationTypeChat];
    [self.navigationController pushViewController:messageView animated:YES];
}
- (void)loadData {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"DqUserId"] = @([BaseData shareInstance].userId);
    params[@"UserId"] = @(_userId);
    params[@"BuildSowingType"] = @"BuildSowing_UserDetial";
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        ZBLog(@"BuildSowing_UserDetial--%@", res);
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            
            NSArray *dataArr = [res objectForKey:@"data"];
            if(!dataArr || dataArr.count == 0) {
                return ;
            }
            for (NSDictionary *data in dataArr) {
                UserDetailModel *model = [[UserDetailModel alloc] initWithDictionary:data];
                _userModel = model;
                [self.tableView reloadData];
            }
            [self loadHeaderView];
        }
        else{
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
    }];
}

#pragma mark --  查询圈子新闻信息（所在的圈子）
- (void)loadCircle_NewMsgData {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = @([BaseData shareInstance].userId);
    params[@"BuildSowingType"] = @"BuildSowing_News";
    params[@"Page"] = @(1);
    params[@"PageSize"] = @(PageSize);
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            ZBLog(@"BuildSowing_CircleNewsMsg--%@", res);
            if ([[res objectForKey:@"StatusCode"] isEqual:@(0)]) {
                [SVProgressHUD  showInfoWithStatus:@"暂无数据"];
                return ;
            }
            NSArray *dataArr = [res objectForKey:@"data"];
            if(!dataArr || dataArr.count == 0) {
                [self.tableView.mj_header endRefreshing];
                return ;
            }
            [self.NewsMsgMtArr removeAllObjects];
            for (NSDictionary *data in dataArr) {
                ZhuBoModel *model = [[ZhuBoModel alloc] initWithDictionary:data];
                [self.NewsMsgMtArr addObject:model];
            }
            [self.tableView reloadData];
        }
        else{
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.NewsMsgMtArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    ZhuBoDetailView *view = [[ZhuBoDetailView alloc] init];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [view loadWithModel:_NewsMsgMtArr[indexPath.row] delegate:self type:1];
    [cell addSubview:view];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *content = ((ZhuBoModel *)_NewsMsgMtArr[indexPath.row]).words;
    CGSize contentSize = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - MARGIN_30 * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize: 28 * SCREEN_W_SCALE]} context:nil].size;
    return 700 * SCREEN_W_SCALE + contentSize.height - 28 * SCREEN_W_SCALE;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZhuBoDetailViewController *detailVC = [[ZhuBoDetailViewController alloc] init];
    detailVC.zhuboModel = _NewsMsgMtArr[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}



@end
