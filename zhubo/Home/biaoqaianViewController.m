//
//  biaoqaianViewController.m
//  zhubo
//
//  Created by Jin on 2017/8/5.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "biaoqaianViewController.h"

#import "biaoqianGrZhuYeTableViewCell.h"
#import "biaoqianXQViewController.h"

@interface biaoqaianViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    
    UITableView *tabView;
    NSInteger page;
    
    NSMutableArray *muArr;
}


@end

@implementation biaoqaianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tabView = [[UITableView alloc]init];
    if (self.userId == [BaseData shareInstance].userId){
        tabView.frame = CGRectMake(0, 0, self.view.frame.size.width, SCREEN_HEIGHT-329+40);
    }else{
        tabView.frame = CGRectMake(0, 0, self.view.frame.size.width, SCREEN_HEIGHT-329);
    }
    [tabView registerNib:[UINib nibWithNibName:@"biaoqianGrZhuYeTableViewCell" bundle:nil] forCellReuseIdentifier:@"biaoqianGrZhuYeTableViewCellID"];
    tabView.delegate = self;
    tabView.dataSource = self;
    tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self loadData];
    }];
    [tabView.mj_header beginRefreshing];
    
    [self.view addSubview:tabView];
    
    muArr = [NSMutableArray array];
    page = 1;
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {  //BuildSowingType=BuildSowing_UserLabel
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = @(self.userId);
    params[@"BuildSowingType"] = @"BuildSowing_UserLabel";
    params[@"Page"] = @(page);
    params[@"PageSize"] = @(10);
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        ZBLog(@"BuildSowing_UserLabel--%@", res);
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            
            NSArray *dataArr = [res objectForKey:@"data"];
            if(!dataArr || dataArr.count == 0) {
                [tabView.mj_header endRefreshing];
                [tabView.mj_footer endRefreshing];
                page --;
                if (page > 1 ) {
                    [SVProgressHUD showErrorWithStatus:@"到底了"];
                }
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
                tabView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    page++;
                    [self loadData];
                }];
            }
            [tabView reloadData];
            [tabView.mj_header endRefreshing];
            [tabView.mj_footer endRefreshing];
        }
        else{
            [tabView.mj_header endRefreshing];
            [tabView.mj_footer endRefreshing];
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [tabView.mj_header endRefreshing];
        [tabView.mj_footer endRefreshing];
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
    biaoqianGrZhuYeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"biaoqianGrZhuYeTableViewCellID" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSDictionary *dic = muArr[indexPath.row];
    cell.biaoqianNeirLal.text = [dic objectForKey:@"Msg"];
    cell.zhangshuLal.text = [NSString stringWithFormat:@"%@P",[dic objectForKey:@"lcount"]];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = muArr[indexPath.row];
    biaoqianXQViewController *vc = [[biaoqianXQViewController alloc]init];
    vc.biaoqianText = [dic objectForKey:@"Msg"];
    vc.zhangshuText = [dic objectForKey:@"lcount"];
    vc.userBQStr = @"1";
    vc.userId = self.userId;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
