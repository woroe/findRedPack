//
//  tongzhiViewController.m
//  zhubo
//
//  Created by Jin on 2017/8/10.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "tongzhiViewController.h"
#import "tongzhiTableViewCell.h"

#import "WebViewController.h"

@interface tongzhiViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)NSMutableArray *muArr;

@end

@implementation tongzhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _muArr = [NSMutableArray array];
    
    self.title = @"通知";
    
    self.tabView.delegate = self;
    self.tabView.dataSource = self;
    [self.tabView registerNib:[UINib nibWithNibName:@"tongzhiTableViewCell" bundle:nil] forCellReuseIdentifier:@"tongzhiTableViewCellID"];
    [self.tabView setSeparatorInset:UIEdgeInsetsZero];
    [self.tabView setLayoutMargins:UIEdgeInsetsZero];
    self.tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self loadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = @([BaseData shareInstance].userId);
    params[@"BuildSowingType"] = @"SystemMsg";
    params[@"Page"] = @(1);
    params[@"PageSize"] = @(10);
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        ZBLog(@"BuildSowing_GetUserMsg--%@", res);
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            
            [_muArr removeAllObjects];
            NSArray *dataArr = [res objectForKey:@"data"];
            if(!dataArr || dataArr.count == 0) {
                [self.tabView reloadData];
                return ;
            }else{
                for (NSDictionary *dic in dataArr) {
                    [_muArr addObject:dic];
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
    return _muArr.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
//执行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"删除删除删除删除删除删除删除删除删除");
    [self delegetAction:indexPath.row];
}
//侧滑出现的文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tongzhiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tongzhiTableViewCellID" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([_muArr count] !=0 ) {
        NSDictionary *dic = [_muArr objectAtIndex:indexPath.row];
        NSString *IsLookStr = [dic objectForKey:@"IsLook"];
        if (IsLookStr.intValue ==0) {
            cell.neirLal.text = [dic objectForKey:@"Title"];
            cell.neirLal.textColor = [UIColor blackColor];
            cell.shijianLal.text = [dic objectForKey:@"AddTime"];
            cell.shijianLal.textColor = [UIColor blackColor];
        }else{
            cell.neirLal.text = [dic objectForKey:@"Title"];
            cell.neirLal.textColor = [UIColor lightGrayColor];
            cell.shijianLal.text = [dic objectForKey:@"AddTime"];
            cell.shijianLal.textColor = [UIColor lightGrayColor];
        }
        
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self selectAction:indexPath.row];
}

- (void)selectAction:(NSInteger )index111 {
    NSDictionary *dic = [_muArr objectAtIndex:index111];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"BuildSowingType"] = @"SystemMsgEdit";
    params[@"Id"] = [dic objectForKey:@"Id"];
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        ZBLog(@"SystemMsgEdit--%@", res);
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            
            NSDictionary *dic = [_muArr objectAtIndex:index111];
            WebViewController *webView = [[WebViewController alloc]init];
            webView.webStr = [dic objectForKey:@"Msg"];
            webView.titleStr = [dic objectForKey:@"Title"];
            [self.navigationController pushViewController:webView animated:YES];
        }
        else{
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
    }];
}
- (void)delegetAction:(NSInteger )index111 {
    NSDictionary *dic = [_muArr objectAtIndex:index111];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"BuildSowingType"] = @"SystemMsgDel";
    params[@"Id"] = [dic objectForKey:@"Id"];
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        ZBLog(@"SystemMsgEdit--%@", res);
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            [self loadData];
        }
        else{
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
    }];
}
@end
