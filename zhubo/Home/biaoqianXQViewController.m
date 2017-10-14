//
//  biaoqianXQViewController.m
//  zhubo
//
//  Created by Jin on 2017/8/7.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "biaoqianXQViewController.h"

#import "zhuboGrZhuYeTableViewCell.h"
#import "ZhuBoDetailViewController.h"
#import "ZhuBoModel.h"

@interface biaoqianXQViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSInteger page;
    
    NSMutableArray *muArr;
    UITableView *tabView;
    
    ZhuBoModel *model;
}

@property (weak, nonatomic) IBOutlet UIImageView *diyizhangTuImageView;

@property (weak, nonatomic) IBOutlet UILabel *biaoqianNameLal;

@property (weak, nonatomic) IBOutlet UILabel *zhangshuLal;

@end

@implementation biaoqianXQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    muArr = [NSMutableArray array];
    page=1;
    
    tabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH+2, SCREEN_HEIGHT-90)];
    tabView.delegate = self;
    tabView.dataSource = self;
    tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tabView];
    
    self.biaoqianNameLal.text = self.biaoqianText;
//    self.zhangshuLal.text = [NSString stringWithFormat:@"%@张图片",self.zhangshuText];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {  //BuildSowingType=BuildSowing_UserLabel  lbTxt 标签名称 Page  PageSize  x?BuildSowingType=GetLabelFile
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_userBQStr.integerValue == 1) {
        params[@"BuildSowingType"] = @"GetUserLabelFile";
        params[@"UserId"] = @(self.userId);
        params[@"lbTxt"] = self.biaoqianText;
        params[@"Page"] = @(page);
        params[@"PageSize"] = @(10);
    }else{
        params[@"BuildSowingType"] = @"GetLabelFile";
        params[@"lbTxt"] = self.biaoqianText;
        params[@"Page"] = @(page);
        params[@"PageSize"] = @(10);
    }
    
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        ZBLog(@"GetLabelFile--%@", res);
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            
            NSArray *dataArr = [res objectForKey:@"data"];
            if(!dataArr || dataArr.count == 0) {
                [SVProgressHUD showErrorWithStatus:BaseStringNetError];
                return ;
            }
            for (NSDictionary *dic in dataArr) {
                [muArr addObject:dic];
            }
            NSDictionary *dic1111 = muArr[0];
            NSString *NewsContentType= [dic1111 objectForKey:@"NewsContentType"];
            NSString *srcStr ;
            if (NewsContentType.intValue == 2) {
                srcStr = [dic1111 objectForKey:@"FirstImsg"];
            }else{
                srcStr = [dic1111 objectForKey:@"Src"];
            }
            self.zhangshuLal.text = [NSString stringWithFormat:@"%li张图片",muArr.count];
            [self.diyizhangTuImageView sd_setImageWithURL:[NSURL URLWithString:srcStr]];
            [tabView reloadData];
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
    if ([muArr count]%3 != 0) {
        return [muArr count]/3+1;
    }else{
        return [muArr count]/3;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    zhuboGrZhuYeTableViewCell *cell = [[zhuboGrZhuYeTableViewCell alloc] init];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if ((indexPath.row+1)*3 < [muArr count] || (indexPath.row+1)*3 == [muArr count] ) {
        for (int i =0; i <3; i++) {
            NSDictionary *dic = muArr[indexPath.row*3 + i%3];
            NSString *NewsContentType= [dic objectForKey:@"NewsContentType"];
            NSString *str ;
            if (NewsContentType.intValue == 2) {
                str = [dic objectForKey:@"FirstImsg"];
            }else{
                str = [dic objectForKey:@"Src"];
            }
            if (i== 0) {
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH/3-2, SCREEN_WIDTH/3-2)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:str]];
                [cell addSubview:imageView];
                
                UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH/3-2, SCREEN_WIDTH/3-2)];
                but.tag = indexPath.row*3 + i%3;
                [but addTarget:self action:@selector(chakandatuAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:but];
            }
            if (i== 1) {
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(1+(SCREEN_WIDTH/3-2), 5, SCREEN_WIDTH/3-2, SCREEN_WIDTH/3-2)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:str]];
                [cell addSubview:imageView];
                
                UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(1+(SCREEN_WIDTH/3-2), 5, SCREEN_WIDTH/3-2, SCREEN_WIDTH/3-2)];
                but.tag = indexPath.row*3 + i%3;
                [but addTarget:self action:@selector(chakandatuAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:but];
            }
            if (i== 2) {
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(2+2*(SCREEN_WIDTH/3-2), 5, SCREEN_WIDTH/3+10, SCREEN_WIDTH/3-2)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:str]];
                [cell.contentView addSubview:imageView];
                
                UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(2+2*(SCREEN_WIDTH/3-2), 5, SCREEN_WIDTH/3+10, SCREEN_WIDTH/3-2)];
                but.tag = indexPath.row*3 + i%3;
                [but addTarget:self action:@selector(chakandatuAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:but];
            }
        }
    }else{
        for (int i =0; i <[muArr count]%3; i++) {
            NSDictionary *dic = muArr[indexPath.row*3 + i%3];
            NSString *NewsContentType= [dic objectForKey:@"NewsContentType"];
            NSString *str ;
            if (NewsContentType.intValue == 2) {
                str = [dic objectForKey:@"FirstImsg"];
            }else{
                str = [dic objectForKey:@"Src"];
            }
            if (i== 0) {
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH/3-2, SCREEN_WIDTH/3-2)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:str]];
                
                [cell addSubview:imageView];
                
                UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH/3-2, SCREEN_WIDTH/3-2)];
                but.tag = indexPath.row*3 + i%3;
                [but addTarget:self action:@selector(chakandatuAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:but];
            }
            if (i== 1) {
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(1+(SCREEN_WIDTH/3-2), 5, self.view.frame.size.width/3-2, SCREEN_WIDTH/3-2)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:str]];
                [cell addSubview:imageView];
                
                UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(1+(SCREEN_WIDTH/3-2), 5, SCREEN_WIDTH/3-2, SCREEN_WIDTH/3-2)];
                but.tag = indexPath.row*3 + i%3;
                [but addTarget:self action:@selector(chakandatuAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:but];
            }
            if (i== 2) {
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(2+2*(SCREEN_WIDTH/3-2), 5, SCREEN_WIDTH/3+10, SCREEN_WIDTH/3-2)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:str]];
                [cell.contentView addSubview:imageView];
                
                UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(2+2*(SCREEN_WIDTH/3-2), 5, SCREEN_WIDTH/3+10, SCREEN_WIDTH/3-2)];
                but.tag = indexPath.row*3 + i%3;
                [but addTarget:self action:@selector(chakandatuAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:but];
            }
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.width/3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)chakandatuAction:(UIButton *)sender{
    
    NSDictionary *dic = muArr[sender.tag];
    [self loadComment:[dic objectForKey:@"NewsId"]];
}

- (void)loadComment:(NSString *)sernder {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = @([BaseData shareInstance].userId);
    params[@"BuildSowingType"] = @"BuildSowing_News_Detial";
    params[@"NewsId"] = sernder;
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            ZBLog(@"BuildSowing_News_Detial--%@", res);
            
            NSArray *dataArr = [res objectForKey:@"data"];
            if(!dataArr || dataArr.count == 0) {
                return ;
            }
            model = [[ZhuBoModel alloc] initWithDictionary:dataArr[0]];
            ZhuBoDetailViewController *detailVC = [[ZhuBoDetailViewController alloc] init];
            detailVC.zhuboModel = model;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
        else{
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
    }];
}


@end
