//
//  zhubaoViewController.m
//  zhubo
//
//  Created by Jin on 2017/8/5.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "zhubaoViewController.h"

#import "zhuboGrZhuYeTableViewCell.h"

#import "ZXVideo.h"
#import "VideoPlayViewController.h"
#import "HZPhotoBrowser.h"

#import "JZLPhotoBrowser.h"

#import "FullViewController.h"
#import "FMGVideoPlayView.h"
#import "VideoSid.h"
#import "Video.h"

#import "biaoqianXQViewController.h"
#import "ZhuBoDetailViewController.h"
#import "ZhuBoModel.h"
//#import "ZYTagImageView.h"

static NSString *const LocalCollectionViewCellReuseID = @"LocalCollectionViewCellReuseID";

@interface zhubaoViewController ()<FMGVideoPlayViewDelegate,JZLPhotoBrowserDelegate>{
    
    
    NSInteger page;
    NSMutableArray *muArr;
    ZhuBoModel *model;
}

@property (nonatomic, strong) FMGVideoPlayView * fmVideoPlayer; // 播放器
/* 全屏控制器 */
@property (nonatomic, strong) FullViewController *fullVc;

@end

@implementation zhubaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     muArr = [NSMutableArray array];
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height);
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self loadData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.fmVideoPlayer = [FMGVideoPlayView videoPlayView];
    self.fmVideoPlayer.delegate = self;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(leftAction:)];
    
}
- (void)leftAction:(UIBarButtonItem *)sender{
    [_fmVideoPlayer.player pause];
    [_fmVideoPlayer.player setRate:0];
    _fmVideoPlayer.playOrPauseBtn.selected = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = @(self.userId);
    params[@"BuildSowingType"] = @"BuildSowing_UserNews";
    params[@"Page"] = @(page);
    params[@"PageSize"] = @(9);
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        ZBLog(@"BuildSowing_UserNews--%@", res);
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            
            NSArray *dataArr = [res objectForKey:@"data"];
            if(!dataArr || dataArr.count == 0) {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
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
                self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    page++;
                    [self loadData];
                }];
            }
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
        }
        else{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
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
    
    if ((indexPath.row+1)*3 < [muArr count] || (indexPath.row+1)*3 == [muArr count]) {
        for (int i =0; i <3; i++) {
            NSDictionary *dic = muArr[indexPath.row*3 + i%3];
            NSString *NewsContentType = [dic objectForKey:@"NewsContentType"];
            NSString *str1111;
            if (NewsContentType.intValue == 2) {
                str1111 = [dic objectForKey:@"FirstImsg"];
            }else{
                NSString *str = [dic objectForKey:@"NewsContent"];
                NSArray *arr1 = [str componentsSeparatedByString:@"@"];
                NSArray *arr0 = [arr1[0] componentsSeparatedByString:@","];
                str1111 = arr0[1];
            }
            if (i== 0) {
                CGRect frame = CGRectMake(0, 1, SCREEN_WIDTH/3-6, SCREEN_WIDTH/3-6);
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
                [imageView sd_setImageWithURL:[NSURL URLWithString:str1111]];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.clipsToBounds  = YES;
                
                UILabel *lal = [[UILabel alloc]init];
                lal.frame =CGRectMake(imageView.frame.size.width-20, imageView.frame.size.height-20, 20, 20) ;
                lal.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"filecount"]];
                lal.textColor = [UIColor whiteColor];
                [cell addSubview:imageView];
                NSString *filecount = [dic objectForKey:@"filecount"];
                if (filecount.intValue > 1) {
                    [cell addSubview:lal];
                }
                
                UIButton *but = [[UIButton alloc]initWithFrame:frame];
                but.tag = indexPath.row*3 + i%3;
                [but addTarget:self action:@selector(chakandatuAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:but];
            }
            if (i== 1) {
                CGRect frame =CGRectMake(3+(SCREEN_WIDTH/3-6), 1, SCREEN_WIDTH/3-6, SCREEN_WIDTH/3-6);
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
                [imageView sd_setImageWithURL:[NSURL URLWithString:str1111]];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.clipsToBounds  = YES;
                
                UILabel *lal = [[UILabel alloc]init];
                lal.frame =CGRectMake((10+(self.view.frame.size.width/3-5))+(imageView.frame.size.width-20), imageView.frame.size.height-20, 20, 20) ;
                lal.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"filecount"]];
                lal.textColor = [UIColor whiteColor];
                [cell addSubview:imageView];
                NSString *filecount = [dic objectForKey:@"filecount"];
                if (filecount.intValue > 1) {
                    [cell addSubview:lal];
                }
                
                UIButton *but = [[UIButton alloc]initWithFrame:frame];
                but.tag = indexPath.row*3 + i%3;
                [but addTarget:self action:@selector(chakandatuAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:but];
            }
            if (i== 2) {
                CGRect frame =CGRectMake(6+2*(SCREEN_WIDTH/3-6), 1, SCREEN_WIDTH/3+10, SCREEN_WIDTH/3-6);
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
                [imageView sd_setImageWithURL:[NSURL URLWithString:str1111]];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.clipsToBounds  = YES;
                
                UILabel *lal = [[UILabel alloc]init];
                lal.frame =CGRectMake((15+2*(SCREEN_WIDTH/3-6))+(imageView.frame.size.width-30), imageView.frame.size.height-30, 20, 20) ;
                lal.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"filecount"]];
                lal.textColor = [UIColor whiteColor];
                [cell.contentView addSubview:imageView];
                NSString *filecount = [dic objectForKey:@"filecount"];
                if (filecount.intValue > 1) {
                    [cell addSubview:lal];
                }
                
                UIButton *but = [[UIButton alloc]initWithFrame:frame];
                but.tag = indexPath.row*3+ i%3;
                [but addTarget:self action:@selector(chakandatuAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:but];
            }
        }
    }else{
        for (int i =0; i <[muArr count]%3; i++) {
            NSDictionary *dic = muArr[indexPath.row*3+ i%3];
            NSString *NewsContentType = [dic objectForKey:@"NewsContentType"];
            NSString *str1111;
            if (NewsContentType.intValue == 2) {
                str1111 = [dic objectForKey:@"FirstImsg"];
            }else{
                NSString *str = [dic objectForKey:@"NewsContent"];
                NSArray *arr1 = [str componentsSeparatedByString:@"@"];
                NSArray *arr0 = [arr1[0] componentsSeparatedByString:@","];
                str1111 = arr0[1];
            }
            if (i== 0) {
                CGRect frame = CGRectMake(0, 1, SCREEN_WIDTH/3-6, SCREEN_WIDTH/3-6);
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
                [imageView sd_setImageWithURL:[NSURL URLWithString:str1111]];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.clipsToBounds  = YES;
                
                UILabel *lal = [[UILabel alloc]init];
                lal.frame =CGRectMake(imageView.frame.size.width-20, imageView.frame.size.height-20, 20, 20) ;
                lal.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"filecount"]];
                lal.textColor = [UIColor whiteColor];
                [cell addSubview:imageView];
                NSString *filecount = [dic objectForKey:@"filecount"];
                if (filecount.intValue > 1) {
                    [cell addSubview:lal];
                }
                
                UIButton *but = [[UIButton alloc]initWithFrame:frame];
                but.tag = indexPath.row*3 + i%3;
                [but addTarget:self action:@selector(chakandatuAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:but];
            }
            if (i== 1) {
                CGRect frame =CGRectMake(3+(SCREEN_WIDTH/3-6), 1, SCREEN_WIDTH/3-6, SCREEN_WIDTH/3-6);
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
                [imageView sd_setImageWithURL:[NSURL URLWithString:str1111]];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.clipsToBounds  = YES;
                
                UILabel *lal = [[UILabel alloc]init];
                lal.frame =CGRectMake((1+(self.view.frame.size.width/3-5))+(imageView.frame.size.width-20), imageView.frame.size.height-20, 20, 20) ;
                lal.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"filecount"]];
                lal.textColor = [UIColor whiteColor];
                [cell addSubview:imageView];
                NSString *filecount = [dic objectForKey:@"filecount"];
                if (filecount.intValue > 1) {
                    [cell addSubview:lal];
                }
                
                UIButton *but = [[UIButton alloc]initWithFrame:frame];
                but.tag = indexPath.row*3 + i%3;
                [but addTarget:self action:@selector(chakandatuAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:but];
            }
            if (i== 2) {
                CGRect frame =CGRectMake(6+2*(SCREEN_WIDTH/3-6), 1, SCREEN_WIDTH/3-6, SCREEN_WIDTH/3-6);
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
                [imageView sd_setImageWithURL:[NSURL URLWithString:str1111]];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.clipsToBounds  = YES;
                
                UILabel *lal = [[UILabel alloc]init];
                lal.frame =CGRectMake((15+2*(self.view.frame.size.width/3-5))+(imageView.frame.size.width-20), imageView.frame.size.height-20, 20, 20) ;
                lal.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"filecount"]];
                lal.textColor = [UIColor whiteColor];
                [cell addSubview:imageView];
                NSString *filecount = [dic objectForKey:@"filecount"];
                if (filecount.intValue > 1) {
                    [cell addSubview:lal];
                }
                
                UIButton *but = [[UIButton alloc]initWithFrame:frame];
                but.tag = indexPath.row*3 + i%3;
                [but addTarget:self action:@selector(chakandatuAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:but];
            }
        }
    }

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_WIDTH/3-3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)chakandatuAction:(UIButton *)sender{
    NSDictionary *dic = muArr[sender.tag];
    [self loadComment:[dic objectForKey:@"Id"]];
//    NSString *NewsContentType = [dic objectForKey:@"NewsContentType"];
//    if (NewsContentType.intValue == 2) {
//        NSString *str = [dic objectForKey:@"NewsContent"];
//        NSArray *arr0 = [str componentsSeparatedByString:@","];
//        ZXVideo *video = [[ZXVideo alloc] init];
//        video.playUrl = arr0[1];
//        video.title = @"";
//        
//        VideoPlayViewController *vc = [[VideoPlayViewController alloc] init];
//        vc.video = video;
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    }else{
//        NSMutableArray *mutpAr = [NSMutableArray array];
//        NSString *str = [dic objectForKey:@"NewsContent"];
//        NSArray *arr1 = [str componentsSeparatedByString:@"@"];
//        NSMutableArray *photos = [NSMutableArray new];
//        for (NSString *str in arr1) {
//            NSArray *arr0 = [str componentsSeparatedByString:@","];
//            [mutpAr addObject:arr0[1]];
//            [photos addObject:arr0[0]];
//        }
//        [JZLPhotoBrowser showPhotoBrowserWithUrlArr:mutpAr currentIndex:0 originalImageViewArr:mutpAr BQIdArr:photos].delegate = self;
//    }
    
//    ZhuBoDetailViewController *detailVC = [[ZhuBoDetailViewController alloc] init];
//    detailVC.zhuboModel = model;
//    [self.navigationController pushViewController:detailVC animated:YES];
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
#pragma mark -- JZLPhotoBrowserDelegate
- (void)selectedTagInFo:(NSDictionary *)dic{
    biaoqianXQViewController *vc = [[biaoqianXQViewController alloc]init];
    vc.biaoqianText = [dic objectForKey:@"Msg"];
    vc.zhangshuText = @"2";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController pushViewController:vc animated:YES];
}
    
- (void)videoplayViewSwitchOrientation:(BOOL)isFull{
    if (isFull) {
        [self.navigationController presentViewController:self.fullVc animated:NO completion:^{
            [self.fullVc.view addSubview:self.fmVideoPlayer];
            _fmVideoPlayer.center = self.fullVc.view.center;
            
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{ _fmVideoPlayer.frame = self.fullVc.view.bounds; }
                             completion:nil];
        }];
    } else {
        [self.fullVc dismissViewControllerAnimated:NO completion:^{
        }];
    }
    
}

@end
