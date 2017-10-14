//
//  mingxiViewController.m
//  zhubo
//
//  Created by Jin on 2017/7/26.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "mingxiViewController.h"
#import "mxTableViewCell.h"

@interface mingxiViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *mxArr;
}

@property(nonatomic ,strong) UITableView *tabView;

@end

@implementation mingxiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    mxArr = [NSMutableArray new];
    
    UITableView *tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    [tabView registerNib:[UINib nibWithNibName:@"mxTableViewCell" bundle:nil] forCellReuseIdentifier:@"mxTableViewCellID"];
    tabView.delegate = self;
    tabView.dataSource = self;
    tabView.bounces = NO;
    self.tabView = tabView;
    [self.view addSubview:tabView];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = @([BaseData shareInstance].userId);
    params[@"BuildSowingType"] = @"PayMsg";
    params[@"Page"] = @(1);
    params[@"PageSize"] = @(10);
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        ZBLog(@"BuildSowing_GetUserMsg--%@", res);
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            
            NSArray *dataArr = [res objectForKey:@"data"];
            if(!dataArr || dataArr.count == 0) {
                return ;
            }else{
                for (NSDictionary *dic in dataArr) {
                    [mxArr addObject:dic];
                }
            }
            [self.tabView reloadData];
        }
        else{
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return mxArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    mxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mxTableViewCellID" forIndexPath:indexPath];
    cell.accessoryType=UITableViewCellAccessoryNone;
    if ([mxArr count] !=0 ) {
        NSDictionary *dic = [mxArr objectAtIndex:indexPath.row];
        UILabel *shijianLai = [cell viewWithTag:10];
        shijianLai.text = [dic objectForKey:@"PayTime"];
        
        UILabel *qianLai = [cell viewWithTag:11];
        qianLai.text = [NSString stringWithFormat:@"$%@",[dic objectForKey:@"PayMoney"]];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}



@end
