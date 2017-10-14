//
//  CircleDetailViewController.m
//  zhubo
//
//  Created by Jin on 2017/6/19.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "CircleDetailViewController.h"
#import "CircleHeaderView.h"

#import "ZhuBoTableViewCell.h"
#import "ZhuBoDetailView.h"

#import "CircleSZViewController.h"
#import "CircleNewsViewController.h"
#import "ZhuBoDetailViewController.h"
#import "shareViewController.h"
#import "ZhuBoEditViewController.h"
#import "CircleNewsViewController.h"
#import "ZhuBoPubEntranceViewController.h"

@interface CircleDetailViewController ()<CircleHeaderViewDelegate,ZhuBoPubEntranceViewControllerwDelegate,ZhuBoDetailViewDelegate>{

    NSDictionary *CircleDic; // 该圈子信息
    UIButton *joinView;
}
//static NSInteger Page = 1;

@property (nonatomic, strong) CircleHeaderView *headerView;
//@property (nonatomic, strong) UILabel *IntroductionLal ;
@property (nonatomic, strong) NSMutableArray *NewsMsgMtArr; // 该圈子发布的新闻信息

@end

@implementation CircleDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    CircleDic = [NSDictionary new];
    _NewsMsgMtArr =[NSMutableArray new];
    
    UIButton *btnLeft1 = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 30, 30)];
    [btnLeft1 setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btnLeft1 addTarget:self action:@selector(deleteFile) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bbiLeft12 = [[UIBarButtonItem alloc] initWithCustomView:btnLeft1];
    self.navigationItem.leftBarButtonItem = bbiLeft12;
    
    [self loadUI];
}
-(void)viewWillAppear:(BOOL)animated{
    [self loadData];
    [self.tableView.mj_header beginRefreshing];
}
-(void)deleteFile{
    [joinView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)loadUI {
    self.title = @"圈子详情";
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadCircle_NewMsgData];
    }];
    self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
    }];
    [self.tableView.mj_header beginRefreshing];
    
}

#pragma mark -- 判断是否是圈主，圈子是否是官方圈子，用户是不是管理员
-(void)pdqzAndQzAndUser{
    
    NSString *CircleUserIdStr = [CircleDic objectForKey:@"CircleUserId"];
    if (CircleUserIdStr.intValue == [BaseData shareInstance].userId) { //是否是圈主 ,圈主可以设置圈子
        UIImage *photoIcon=[UIImage imageNamed: @"shezhi"];
        photoIcon = [photoIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:photoIcon style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
        self.navigationItem.rightBarButtonItem = item;
    }else{
        NSString *IsofficialStr = [CircleDic objectForKey:@"Isofficial"];
        if (IsofficialStr.intValue == 0) { //是否是官方圈子，0不是  1是
            NSString *isaddStr = [CircleDic objectForKey:@"IsAdd"];
            if (isaddStr.intValue == 0){
                joinView = [[UIButton alloc]initWithFrame:CGRectMake(0, self.navigationController.view.window.frame.size.height-50, self.view.frame.size.width, 50)];
                NSString *IsPayStr = [CircleDic objectForKey:@"IsPay"];
                NSString *titStr;
                if (IsPayStr.intValue == 1) {
                    NSString *PriceStr = [CircleDic objectForKey:@"Price"];
                    titStr= [NSString stringWithFormat:@"支付%@元，加入该圈子",PriceStr];
                }else{
                    titStr = [NSString stringWithFormat:@"加入该圈子"];
                }
                [joinView addTarget:self action:@selector(joinAction) forControlEvents:UIControlEventTouchDown
                 ];
                joinView.backgroundColor = BaseColorBlue;
                [joinView setTitle:titStr forState:UIControlStateNormal];
                [joinView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.navigationController.view.window addSubview:joinView];
            }else{
                UIImage *photoIcon=[UIImage imageNamed: @"MoreIcon"];
                photoIcon = [photoIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:photoIcon style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
                self.navigationItem.rightBarButtonItem = item;
            }
        }else{
            NSString *CircleUserId = [CircleDic objectForKey:@"CircleUserId"];
            if (CircleUserId.intValue == [BaseData shareInstance].userId) {
                UIImage *photoIcon=[UIImage imageNamed: @"shezhi"];
                photoIcon = [photoIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:photoIcon style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
                self.navigationItem.rightBarButtonItem = item;
            }
        }
    }
}

-(void)joinAction{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = @([BaseData shareInstance].userId);
    params[@"BuildSowingType"] = @"CircleAdd";
    params[@"CircleId"] = @(_model.circleId);
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        ZBLog(@"BuildSowing_CircleMsg--%@", res);
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            
            [joinView removeFromSuperview];
            [self loadData];
        }
        else{
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
    }];
}
-(void)rightBtnClick{
    NSString *CircleUserIdStr = [CircleDic objectForKey:@"CircleUserId"];
    if (CircleUserIdStr.intValue == [BaseData shareInstance].userId){ //加入的圈子
        CircleSZViewController *szVc = [[CircleSZViewController alloc]init];
        szVc.CircleDic = CircleDic;
        [self.navigationController pushViewController:szVc animated:YES];
    }else{// 自己的圈子
        ZhuBoPubEntranceViewController *entranceVC = [[ZhuBoPubEntranceViewController alloc] init];
        entranceVC.model = self.model;
        entranceVC.delegate = self;
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
}
#pragma mark --  ZhuBoPubEntranceViewControllerwDelegat
- (void)tuichuCircleAtion{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = @([BaseData shareInstance].userId);
    params[@"BuildSowingType"] = @"CircleOut";
    params[@"CircleId"] = @(_model.circleId);
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            ZBLog(@"CircleOut--%@", res);
            [SVProgressHUD showSuccessWithStatus:@""];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
    }];
}
- (void)jubaoCricleAtion{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = @([BaseData shareInstance].userId);
    params[@"BuildSowingType"] = @"UserReport";
    params[@"ReportUserId"] = [CircleDic objectForKey:@"CircleUserId"];
    params[@"NewsId"] = [CircleDic objectForKey:@"Id"];
    params[@"NewsType"] = @(2);
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            ZBLog(@"UserReport--%@", res);
            [SVProgressHUD showSuccessWithStatus:@""];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            [SVProgressHUD showErrorWithStatus:@"举报失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
    }];
}
#pragma mark --  CircleHeaderViewDelegate
-(void)FbNewsCircle{
    NSString *isaddStr = [CircleDic objectForKey:@"IsAdd"];
    if (isaddStr.intValue == 0) {
        [SVProgressHUD showErrorWithStatus:@"您还没有加入该圈子，不能发布动态"];
        return;
    }else{
        NSString *IsAdminSendMsg = [CircleDic objectForKey:@"IsAdminSendMsg"];
        if (IsAdminSendMsg.intValue == 1) {
            NSString *CircleUserId = [CircleDic objectForKey:@"CircleUserId"];
            if (CircleUserId.intValue == [BaseData shareInstance].userId) {
                ZhuBoEditViewController *vc = [[ZhuBoEditViewController alloc]init];
                vc.model = _model;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:@"您还不能再该圈子发布动态"];
            }
        }else{
            ZhuBoEditViewController *vc = [[ZhuBoEditViewController alloc]init];
            vc.model = _model;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

-(void)shareCirle{
    
    NSString *isaddStr = [CircleDic objectForKey:@"IsAdd"];
    if (isaddStr.intValue == 0) {
        [SVProgressHUD showErrorWithStatus:@"您还没有加入该圈子，不能发布动态"];
        return;
    }else{
        shareViewController *entranceVC = [[shareViewController alloc] init];
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
}
#pragma mark --  查询单个圈子（所选择的圈子）
- (void)loadData {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = @([BaseData shareInstance].userId);
    params[@"BuildSowingType"] = @"BuildSowing_CircleMsg";
    params[@"CircleId"] = @(_model.circleId);
    
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        CircleModel *models;
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            ZBLog(@"BuildSowing_CircleMsg--%@", res);
            NSArray *dataArr = [res objectForKey:@"data"];
            if(!dataArr || dataArr.count == 0) {
                return ;
            }else{
                models = [[CircleModel alloc] initWithDictionary:dataArr[0]];
            }
            CircleDic = dataArr[0];
            [self pdqzAndQzAndUser];
            self.headerView = [[CircleHeaderView alloc] init];
            self.headerView .delegate = self;
            [self.headerView loadWithModel:models];
            self.tableView.tableHeaderView = self.headerView;
            [self.tableView reloadData];
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
    params[@"BuildSowingType"] = @"BuildSowing_CircleNewsMsg";
    params[@"CircleId"] = [CircleDic objectForKey:@"Id"];
    params[@"Page"] = @(1);
    params[@"PageSize"] = @(PageSize);
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            ZBLog(@"BuildSowing_CircleNewsMsg--%@", res);
            if ([[res objectForKey:@"StatusCode"] isEqual:@(0)]) {
                [SVProgressHUD  showInfoWithStatus:@"暂无数据"];
                if ([self.NewsMsgMtArr count] == 0) {
                    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                }
                [self.tableView reloadData];
                return ;
            }
            NSArray *dataArr = [res objectForKey:@"data"];
            if(!dataArr || dataArr.count == 0) {
                [self.tableView.mj_header endRefreshing];
                if ([self.NewsMsgMtArr count] == 0) {
                    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                }
                [self.tableView reloadData];
                return ;
            }
            [self.NewsMsgMtArr removeAllObjects];
            for (NSDictionary *data in dataArr) {
                ZhuBoModel *model = [[ZhuBoModel alloc] initWithDictionary:data];
                [self.NewsMsgMtArr addObject:model];
            }
            if ([self.NewsMsgMtArr count] == 0) {
                self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    return 1+self.NewsMsgMtArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }else {
            while ([cell.contentView.subviews lastObject] != nil){
                [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        if ([CircleDic objectForKey:@"Introduction"] == nil || [[CircleDic objectForKey:@"Introduction"] isEqualToString:@""]) {
            cell.textLabel.text =@"暂无圈子简介";
        }else{
            cell.textLabel.text =[CircleDic objectForKey:@"Introduction"];
        }
        cell.textLabel.textColor = BaseColorGray;
        cell.textLabel.font = [UIFont systemFontOfSize:30 *SCREEN_W_SCALE];
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        ZhuBoDetailView *view = [[ZhuBoDetailView alloc] init];
        view.qz_And_News_Str = @"2";
        [view loadWithModel:_NewsMsgMtArr[indexPath.row-1] delegate:self type:1];
        [cell addSubview:view];
        return cell;
    }
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NSString *content = [CircleDic objectForKey:@"Introduction"];
        CGSize contentSize = [content boundingRectWithSize:CGSizeMake(self.view.frame.size.width-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize: 28 * SCREEN_W_SCALE]} context:nil].size;
        return  contentSize.height +10;
    }else{
        NSString *content = ((ZhuBoModel *)_NewsMsgMtArr[indexPath.row-1]).words;
        CGSize contentSize = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - MARGIN_30 * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize: 28 * SCREEN_W_SCALE]} context:nil].size;
        return 700 * SCREEN_W_SCALE + contentSize.height - 28 * SCREEN_W_SCALE;
    }
    return 0.00f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row>0) {
        ZhuBoDetailViewController *detailVC = [[ZhuBoDetailViewController alloc] init];
        detailVC.qz_And_News_Str =@"2";
        detailVC.zhuboModel = _NewsMsgMtArr[indexPath.row-1];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
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
    ZhuBoDetailViewController *detailVC = [[ZhuBoDetailViewController alloc] init];
    detailVC.zhuboModel = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)openPhotoBrowser:(NSInteger)index NSMutableArray:(NSMutableArray *)arr{
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithPhotos:arr];
    [browser setCurrentPhotoIndex:index];
    [self.navigationController pushViewController:browser animated:YES];
}
- (void)openZhuBoDetail:(ZhuBoModel *)model {
    
    ZhuBoDetailViewController *detailVC = [[ZhuBoDetailViewController alloc] init];
    detailVC.zhuboModel = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)clickedUser:(id)sender withModel:(ZhuBoModel *)model {
    if(![BaseClasss isLogin]) {
        return;
    }
    UserDetailViewController *userVC = [[UserDetailViewController alloc] init];
    userVC.userId = model.userId;
    [self.navigationController pushViewController:userVC animated:YES];
}
- (void)clickedGengduo:(id)sender withModel:(ZhuBoModel *)model{
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *AAfx = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"分享");
        shareViewController *entranceVC = [[shareViewController alloc] init];
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
    if ([BaseData shareInstance].userId == model.userId) {
        UIAlertAction *AAsc = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"删除");
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"BuildSowingType"] = @"NewsOperation";
            params[@"UserId"] = @([BaseData shareInstance].userId);
            params[@"NewsId"] = @(model.newsId);
            params[@"Iscollection"] = @"";
            params[@"nType"] = @(0);
            params[@"IsDel"] = @(1);
            
            [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *res = (NSDictionary *)responseObject;
                if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
                    [SVProgressHUD showSuccessWithStatus:@""];
                }
                else{
                    [SVProgressHUD showErrorWithStatus:BaseStringNetError];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [SVProgressHUD showErrorWithStatus:@"删除失败"];
            }];
        }];
        [ac addAction:AAsc];
    }else{
        UIAlertAction *AAsc = [UIAlertAction actionWithTitle:@"屏蔽" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {;
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"BuildSowingType"] = @"NewsOperation";
            params[@"UserId"] = @([BaseData shareInstance].userId);
            params[@"NewsId"] = @(model.newsId);
            params[@"Iscollection"] = @"0";
            params[@"nType"] = @(0);
            params[@"IsDel"] = @(0);
            
            [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *res = (NSDictionary *)responseObject;
                if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
                    [SVProgressHUD showSuccessWithStatus:@""];
                }else{
                    [SVProgressHUD showErrorWithStatus:BaseStringNetError];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [SVProgressHUD showErrorWithStatus:@"屏蔽失败"];
            }];
        }];
        [ac addAction:AAsc];
    }
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
                [SVProgressHUD showSuccessWithStatus:@""];
            }
            else{
                [SVProgressHUD showErrorWithStatus:BaseStringNetError];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"举报失败"];
        }];
    }];
    [ac addAction:AAjb];
    UIAlertAction *AAsc1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [ac addAction:AAsc1];
    [self presentViewController:ac animated:YES completion:nil];
}



@end
