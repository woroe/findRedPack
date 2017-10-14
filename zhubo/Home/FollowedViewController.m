//
//  guanzhuViewController.m
//  zhubo
//
//  Created by Jin on 2017/8/5.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "FollowedViewController.h"

#import "guanzhuGrZhuYeTableViewCell.h"

#import "GrZhuYeViewController.h"

@interface FollowedViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    
    UITableView *tablView;
    NSInteger page;
    
    NSMutableArray *muArr;
}

@end

@implementation FollowedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tablView = [[UITableView alloc]init];
    if (self.userId == [BaseData shareInstance].userId){
        tablView.frame = CGRectMake(0, 0, self.view.frame.size.width, SCREEN_HEIGHT-329+40);
    }else{
        tablView.frame = CGRectMake(0, 0, self.view.frame.size.width, SCREEN_HEIGHT-329);
    }
    tablView.delegate = self;
    tablView.dataSource = self;
    tablView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tablView registerNib:[UINib nibWithNibName:@"guanzhuGrZhuYeTableViewCell" bundle:nil] forCellReuseIdentifier:@"guanzhuGrZhuYeTableViewCell"];
    
    tablView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self loadData];
    }];
    [tablView.mj_header beginRefreshing];
    
    [self.view addSubview:tablView];
    
    muArr = [NSMutableArray array];
    page = 1;
    
    [self loadData];
}

- (void)loadData { //Api.aspx?BuildSowingType=UserFansList  DqUserId 当前登录用户的ID，Page 页数 PageSize
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"BuildSowingType"] = @"UserFansList";
    params[@"UserId"] = @(self.userId);
    params[@"DqUserId"] = @([BaseData shareInstance].userId);
    params[@"Page"] = @(page);
    params[@"PageSize"] = @(10);
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        ZBLog(@"BuildSowing_UserFansList--%@", res);
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            
            NSArray *dataArr = [res objectForKey:@"data"];
            if(!dataArr || dataArr.count == 0) {
                [tablView.mj_header endRefreshing];
                [tablView.mj_footer endRefreshing];
                page --;
                if (page > 1 ) {
                    [SVProgressHUD showErrorWithStatus:@"到底了"];
                }
                [tablView reloadData];
                return ;
            }
            if (page == 1) {
                [muArr removeAllObjects];
            }
            for (NSDictionary *dic in dataArr) {
                [muArr addObject:dic];
            }
            NSString *DataCountStr = [res objectForKey:@"DataCount"];
            if (DataCountStr.intValue > 9) {
                tablView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    page++;
                    [self loadData];
                }];
            }
            [tablView reloadData];
            [tablView.mj_header endRefreshing];
            [tablView.mj_footer endRefreshing];
        }
        else{
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return muArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    guanzhuGrZhuYeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"guanzhuGrZhuYeTableViewCell" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSDictionary *dic = muArr[indexPath.row];
    cell.nameLal.text = [dic objectForKey:@"NickName"];
//    NSString *Is_Follow_User = [dic objectForKey:@"Is_Follow_User"];
    [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"HeadImg"]]];
    cell.headerImageView.layer.cornerRadius = cell.headerImageView.frame.size.width / 2;
    cell.headerImageView.layer.masksToBounds = YES;
    
    cell.butSelect.tag = indexPath.row;
    [cell.butSelect addTarget:self action:@selector(dianjiAction:) forControlEvents:UIControlEventTouchDown];
    
//    cell.guanzhuBut.layer.cornerRadius = 5.0;
//    cell.guanzhuBut.tag = indexPath.row+1;
//    [cell.guanzhuBut addTarget:self action:@selector(ganzhuAction:) forControlEvents:UIControlEventTouchUpInside];
//    if (Is_Follow_User.intValue == 0) {
//        [cell.guanzhuBut setTitle:@"+关注" forState:UIControlStateNormal];
//        [cell.guanzhuBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        cell.guanzhuBut.backgroundColor = BaseColorYellow;
//    }else{
//        [cell.guanzhuBut setTitle:@"已关注" forState:UIControlStateNormal];
//        [cell.guanzhuBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        cell.guanzhuBut.backgroundColor = BaseColorGray;
//    }
//    NSString *useriId = [dic objectForKey:@"Id"];
//    if (useriId.intValue == [BaseData shareInstance].userId) {
//        cell.guanzhuBut.hidden = YES;
//    }else{
//        cell.guanzhuBut.hidden = NO;
//    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)dianjiAction:(UIButton *)sender{
    NSDictionary *dic = muArr[sender.tag];
    NSString *useriId = [dic objectForKey:@"Id"];
    if (useriId.intValue != [BaseData shareInstance].userId) {
//        [self.delegate gengxinyonghu:dic index:sender.tag];
        GrZhuYeViewController *userVC = [[GrZhuYeViewController alloc] init];
        userVC.userId = useriId.intValue;
        [self.navigationController pushViewController:userVC animated:YES];
    }
}

-(void)ganzhuAction:(UIButton *)sender{
    NSDictionary *dic = muArr[sender.tag-1];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = @([BaseData shareInstance].userId);
    params[@"FollowUserId"] = [dic objectForKey:@"Id"];
    UIButton *btn = (UIButton *)sender;
    NSString *Is_Follow_User = [dic objectForKey:@"Is_Follow_User"];
    if(Is_Follow_User.intValue == 0){
        params[@"BuildSowingType"] = @"FollowUser";
        btn.backgroundColor = BaseColorGray;
    } else{
        params[@"BuildSowingType"] = @"DelFollowUser";
        btn.backgroundColor = BaseColorYellow;
    }
    
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            if(Is_Follow_User.intValue == 0){
                [SVProgressHUD showSuccessWithStatus:BaseStringFollowSucc];
            }else{
                [SVProgressHUD showSuccessWithStatus:BaseStringFollowNOSucc];
            }
        }else{
            if(Is_Follow_User.intValue == 0){
                btn.backgroundColor = BaseColorYellow;
            } else{
                btn.backgroundColor = BaseColorGray;
            }
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
        [muArr removeAllObjects];
        [self loadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        if(Is_Follow_User.intValue == 0){
            btn.backgroundColor = BaseColorYellow;
        }
        else{
            btn.backgroundColor = BaseColorGray;
        }
        [muArr removeAllObjects];
        [self loadData];
    }];
}

@end
