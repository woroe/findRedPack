//
//  ZBGCTableViewController.m
//  zhubo
//
//  Created by jiangfei on 17/9/17.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "ZBGCTableViewController.h"
#import "ZhuBoTableViewCell.h"
#import "ZhuBoModel.h"
#import "ZBGCDetailViewController.h"
#import "UserDetailViewController.h"
#import "ZhuBoDetailView.h"

#import "shareViewController.h"
#import "GrZhuYeViewController.h"

#import "CommonUtil.h"


@interface ZBGCTableViewController ()<ZhuBoCellDelegate, ZhuBoDetailViewDelegate>{
    
    NSInteger indexInt;
    
    NSInteger indexSelectInt; // 更新index cell的高度
}


@property (nonatomic, assign) NSInteger Page;
@property (nonatomic, strong) NSMutableArray *models;

@end


static NSInteger page = 1;
@implementation ZBGCTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.models = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerRefreshing) name:@"GC_SUSSCESS" object:nil];
    [self loadUI];
}
-(void)viewWillAppear:(BOOL)animated{
    [self loadData];
}
- (void)loadUI {
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight
    | UIViewAutoresizingFlexibleWidth;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZhuBoTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZhuBoTableViewCellID"];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self loadData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        page++;
        [self loadData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}


- (void)headerRefreshing {
    page = 1;
    [self loadData];
}
- (void)loadData {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = @([BaseData shareInstance].userId);
    params[@"BuildSowingType"] = @"SquareNews";
    params[@"Page"] = @(page);
    params[@"PageSize"] = @(PageSize);
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            ZBLog(@"SquareNews--%@", res);
            
            NSArray *dataArr = [res objectForKey:@"data"];
            if (page ==1 ) {
                [self.models removeAllObjects];
            }
            for (NSDictionary *data in dataArr) {
                ZhuBoModel *model = [[ZhuBoModel alloc] initWithDictionary:data];
                model.isAll = NO;
                model.words = [CommonUtil decodeBase64String:model.words];
                [self.models addObject:model];
            }
            if(!dataArr || dataArr.count == 0) {
                //                [SVProgressHUD showErrorWithStatus:@"到底了！！"];
                page --;
            }
            [self.tableView reloadData];
        }
        else{
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    ZhuBoDetailView *view = [[ZhuBoDetailView alloc] init];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [view loadWithModel:self.models[indexPath.row] delegate:self type:indexPath.row];
    [cell addSubview:view];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *content = ((ZhuBoModel *)self.models[indexPath.row]).words;
    CGSize contentSize = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - MARGIN_30 * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize: 30 * SCREEN_W_SCALE]} context:nil].size;
    CGSize contentSize1 = [@"我" boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - MARGIN_30 * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize: 30 * SCREEN_W_SCALE]} context:nil].size;
    
    ZhuBoModel *zhuboM =self.models[indexPath.row];
    if (zhuboM.newsContentType == 4 || zhuboM.newsContentType == 3) {
        if (contentSize.height >contentSize1.height*6){
            if (indexSelectInt > -1) {
                if (zhuboM.isAll) {
                    return ceil(contentSize.height) + ceil(contentSize.height /contentSize1.height) *6 + 3*MARGIN_30 + 105 * SCREEN_W_SCALE + 64;
                }else{
                    return ceil((contentSize1.height+6)*6)+ 3*MARGIN_30 + 105 * SCREEN_W_SCALE + 64;
                }
            }
            return ceil((contentSize1.height+6)*6)+ 3*MARGIN_30 + 105 * SCREEN_W_SCALE + 64;
        }else{
            if ([zhuboM.words isEqualToString:@""] || zhuboM.words == nil ) {
                return contentSize.height+(contentSize.height/(MARGIN_20/2))*3-MARGIN_20+ 90 * SCREEN_W_SCALE + 65 * SCREEN_W_SCALE+MARGIN_30;
            }
            return contentSize.height+(contentSize.height/(MARGIN_20/2))*3-MARGIN_20 +  2*MARGIN_30 + 90 * SCREEN_W_SCALE + 65 * SCREEN_W_SCALE+MARGIN_30;
        }
    }
    return 0.0;
}
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZhuBoModel *model = self.models[indexPath.row];
    [self openZhuBoDetail:model];
}


#pragma mark - ZhuBoCellDelegate
- (void)clickedUser:(id)sender withModel:(ZhuBoModel *)model {
    if(![BaseClasss isLogin]) {
        return;
    }
    if (model.newsContentType == 3) {
        GrZhuYeViewController *userVC = [[GrZhuYeViewController alloc] init];
        userVC.userId = model.userId;
        [self.navigationController pushViewController:userVC animated:YES];
    }
}
- (void)clickedFollow:(id)sender withModel:(ZhuBoModel *)model {
}
- (void)clickedSupport:(id)sender withModel:(ZhuBoModel *)model {
}
- (void)clickedContent:(id)sender withModel:(ZhuBoModel *)model {
    if(![BaseClasss isLogin]) {
        return;
    }
    
    [self openZhuBoDetail:model];
}
- (void)clickedComment:(id)sender withModel:(ZhuBoModel *)model {
    if(![BaseClasss isLogin]) {
        return;
    }
    
    [self openZhuBoDetail:model];
}
- (void)clickedImageBtn:(id)sender withModel:(ZhuBoModel *)model {
    ZBGCDetailViewController *detailVC = [[ZBGCDetailViewController alloc] init];
    detailVC.zhuboModel = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)openZhuBoDetail:(ZhuBoModel *)model {
    
    ZBGCDetailViewController *detailVC = [[ZBGCDetailViewController alloc] init];
    detailVC.zhuboModel = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)clickedGengduo:(id)sender withModel:(ZhuBoModel *)model{
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *AAfx = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"分享");
        shareViewController *entranceVC = [[shareViewController alloc] init];
        entranceVC.newsId = [NSString stringWithFormat:@"%ld",model.newsId];
        entranceVC.titStr = model.words;
        entranceVC.nameStr = model.nickName;
        entranceVC.HeadImgStr = model.headImg;
        [entranceVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        //背景透明
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
            entranceVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        }else{
            self.modalPresentationStyle=UIModalPresentationCurrentContext;
        }
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:entranceVC animated:YES completion:^{
            
        }];
    }];
    [ac addAction:AAfx];
    NSString *str;
    if ([BaseData shareInstance].userId == model.userId) {
        str = @"删除";
    }else{
        str = @"屏蔽";
    }
    UIAlertAction *AAsc = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"删除");
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"BuildSowingType"] = @"NewsOperation";
        params[@"UserId"] = @([BaseData shareInstance].userId);
        params[@"NewsId"] = @(model.newsId);
        params[@"Iscollection"] = @(0);
        params[@"nType"] = @(1);
        if ([BaseData shareInstance].userId == model.userId) {
            params[@"IsDel"] = @(1);
        }else{
            params[@"IsDel"] = @(0);
        }
        
        [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *res = (NSDictionary *)responseObject;
            if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
                if ([BaseData shareInstance].userId == model.userId){
                    //                    [SVProgressHUD showSuccessWithStatus:@""];
                    page = 1;
                    [self loadData];
                }else{
                    //                    [SVProgressHUD showSuccessWithStatus:@""];
                    page = 1;
                    [self loadData];
                }
            }
            else{
                [SVProgressHUD showErrorWithStatus:BaseStringNetError];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //            [SVProgressHUD showErrorWithStatus:@"失败"];
        }];
    }];
    [ac addAction:AAsc];
    UIAlertAction *AAjb = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"举报");
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"BuildSowingType"] = @"UserReport";
        params[@"UserId"] = @([BaseData shareInstance].userId);
        params[@"ReportUserId"] = @(model.userId);
        params[@"NewsId"] = @(model.newsId);
        params[@"NewsType"] = @(1);
        
        [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *res = (NSDictionary *)responseObject;
            if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
                //                [SVProgressHUD showSuccessWithStatus:@""];
            }
            else{
                [SVProgressHUD showErrorWithStatus:BaseStringNetError];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //            [SVProgressHUD showErrorWithStatus:@"举报失败"];
        }];
    }];
    [ac addAction:AAjb];
    UIAlertAction *AAsc1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [ac addAction:AAsc1];
    [self presentViewController:ac animated:YES completion:nil];
}
-(void)qwActionTop:(NSInteger)index{
    ZhuBoModel *model = _models[index];
    model.isAll = !model.isAll;
    [_models replaceObjectAtIndex:index withObject:model];
    indexSelectInt = index;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}
@end
