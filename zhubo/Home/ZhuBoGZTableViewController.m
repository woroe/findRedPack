//
//  ZhuBoTableViewController.m
//  zhubo
//
//  Created by Jin on 2017/6/12.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "ZhuBoGZTableViewController.h"
#import "ZhuBoTableViewCell.h"
#import "ZhuBoModel.h"
#import "ZhuBoDetailViewController.h"
#import "UserDetailViewController.h"
#import "ZhuBoDetailView.h"

#import "shareViewController.h"
#import "GrZhuYeViewController.h"

#import "ZXVideo.h"
#import "VideoPlayViewController.h"
#import "JZLPhotoBrowser.h"

#import "biaoqianXQViewController.h"

#import "FullViewController.h"
#import "FMGVideoPlayView.h"
#import "VideoSid.h"
#import "Video.h"
#import "ZYTagImageView.h"

#import "CommonUtil.h"


@interface ZhuBoGZTableViewController ()< ZhuBoDetailViewDelegate,JZLPhotoBrowserDelegate,FMGVideoPlayViewDelegate,ZYTagImageViewDelegate>{
    
    NSInteger indexInt;
    
    NSInteger indexSelectInt; // 更新index cell的高度
    BOOL isGengxinB;// 是否更新
}

@property (nonatomic, assign) NSInteger Page;
@property (nonatomic, strong) NSMutableArray *models;

@property (nonatomic, strong) FMGVideoPlayView * fmVideoPlayer; // 播放器
/* 全屏控制器 */
@property (nonatomic, strong) FullViewController *fullVc;

@end


static NSInteger page = 1;
@implementation ZhuBoGZTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    indexInt= 0;
    
    self.fmVideoPlayer = [FMGVideoPlayView videoPlayView];
    self.fmVideoPlayer.delegate = self;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(leftAction:)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newsSubmitSuccess) name:@"gohome" object:nil];
    self.models = [NSMutableArray array];
    [self loadUI];
}
- (void)leftAction:(UIBarButtonItem *)sender{
    [_fmVideoPlayer.player pause];
    [_fmVideoPlayer.player setRate:0];
    _fmVideoPlayer.playOrPauseBtn.selected = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [self loadData];
}

- (void)newsSubmitSuccess {
    self.tableView.contentOffset = CGPointMake(0, 0);
}

- (void)loadUI {
    
//    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight
//    | UIViewAutoresizingFlexibleWidth;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZhuBoTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZhuBoTableViewCellID"];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
         page = 1;
        [self loadData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [self loadData];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadData {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = @([BaseData shareInstance].userId);
    params[@"BuildSowingType"] = @"BuildSowing_News";
    params[@"Page"] = @(page);
    params[@"PageSize"] = @(PageSize);
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            ZBLog(@"BuildSowing_News--%@", res);
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
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        else{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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
    if (indexSelectInt > -1) {
        view.isGengxinB = isGengxinB;
    }
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
    if ( zhuboM.newsContentType == 2) {
        if (contentSize.height >contentSize1.height*6){
            if (indexSelectInt > -1) {
                if (zhuboM.isAll) {
                    return 134 * SCREEN_W_SCALE + SCREEN_WIDTH + MARGIN_30 +  ceil(contentSize.height) + ceil(contentSize.height /contentSize1.height) *6 + MARGIN_30 +44 -MARGIN_20 + 65 * SCREEN_W_SCALE+MARGIN_30;
                }else{
                    return 134 * SCREEN_W_SCALE + SCREEN_WIDTH + MARGIN_30 + ceil((contentSize1.height+6)*6) + MARGIN_30 +44 -MARGIN_20 + 65 * SCREEN_W_SCALE+MARGIN_30;
                }
            }
            return 134 * SCREEN_W_SCALE + SCREEN_WIDTH + MARGIN_30 +  ceil((contentSize1.height+6)*6) + MARGIN_30 +44 -MARGIN_20 + 65 * SCREEN_W_SCALE+MARGIN_30;
        }else{
            if ([zhuboM.words isEqualToString:@""] || zhuboM.words == nil ) {
                return 134 * SCREEN_W_SCALE + SCREEN_WIDTH + MARGIN_30 + 65 * SCREEN_W_SCALE+MARGIN_30;
            }
            return 134 * SCREEN_W_SCALE + SCREEN_WIDTH + MARGIN_30 + ceil(contentSize.height) + ceil(contentSize.height /contentSize1.height) *6 + MARGIN_30 + 65 * SCREEN_W_SCALE+MARGIN_30;
        }
    }
    if (zhuboM.newsContentType == 1 && [zhuboM.imgArr count]==1) {
        if (contentSize.height >contentSize1.height*6){
            if (indexSelectInt > -1) {
                if (zhuboM.isAll) {
                    return 134 * SCREEN_W_SCALE-5*SCREEN_W_SCALE + SCREEN_WIDTH + MARGIN_30 +  ceil(contentSize.height) + ceil(contentSize.height /contentSize1.height) *6 + MARGIN_30 +44 -MARGIN_20 + 65 * SCREEN_W_SCALE+MARGIN_30;
                }else{
                    return 134 * SCREEN_W_SCALE-5*SCREEN_W_SCALE + SCREEN_WIDTH + MARGIN_30 +  ceil((contentSize1.height+6)*6) + MARGIN_30 +44 -MARGIN_20 + 65 * SCREEN_W_SCALE+MARGIN_30;
                }
            }
            return 134 * SCREEN_W_SCALE-5*SCREEN_W_SCALE + SCREEN_WIDTH + MARGIN_30 +  ceil((contentSize1.height+6)*6) + MARGIN_30 +44 -MARGIN_20 + 65 * SCREEN_W_SCALE+MARGIN_30;
        }else{
            if ([zhuboM.words isEqualToString:@""] || zhuboM.words == nil ) {
                return 134 * SCREEN_W_SCALE-5*SCREEN_W_SCALE + SCREEN_WIDTH + MARGIN_30 + 65 * SCREEN_W_SCALE+MARGIN_30;
            }
            return 134 * SCREEN_W_SCALE-5*SCREEN_W_SCALE + SCREEN_WIDTH + MARGIN_30 +  ceil(contentSize.height) + ceil(contentSize.height /contentSize1.height) *6 + MARGIN_30 + 65 * SCREEN_W_SCALE+MARGIN_30;
        }
    }
    if (zhuboM.newsContentType == 1 && [zhuboM.imgArr count]==2){
        if ([zhuboM.words isEqualToString:@""] || zhuboM.words == nil ) {
            return 134 * SCREEN_W_SCALE-5*SCREEN_W_SCALE  + 420  * SCREEN_W_SCALE + MARGIN_30 + 65 * SCREEN_W_SCALE+MARGIN_30;
        }
        if (contentSize.height >contentSize1.height*6){
            if (indexSelectInt > -1){
                if (zhuboM.isAll) {
                    return 134 * SCREEN_W_SCALE-5*SCREEN_W_SCALE  + 420  * SCREEN_W_SCALE + MARGIN_30 +  ceil(contentSize.height) + ceil(contentSize.height /contentSize1.height) *6  + MARGIN_30 +44 -MARGIN_20 + 65 * SCREEN_W_SCALE+MARGIN_30;
                }else{
                    return 134 * SCREEN_W_SCALE-5*SCREEN_W_SCALE + 420 * SCREEN_W_SCALE + MARGIN_30 + ceil((contentSize1.height+6)*6) + MARGIN_30 +44 -MARGIN_20 + 65 * SCREEN_W_SCALE+MARGIN_30;
                }
            }
            return 134 * SCREEN_W_SCALE-5*SCREEN_W_SCALE + 420 * SCREEN_W_SCALE + MARGIN_30 + ceil((contentSize1.height+6)*6) + MARGIN_30 +44 -MARGIN_20 + 65 * SCREEN_W_SCALE+MARGIN_30;
        }else{
            return  134 * SCREEN_W_SCALE-5*SCREEN_W_SCALE  + 420  * SCREEN_W_SCALE + MARGIN_30 +  ceil(contentSize.height) + ceil(contentSize.height /contentSize1.height) *6  + MARGIN_30 + 65 * SCREEN_W_SCALE+MARGIN_30;
        }
    }else{
        if ([zhuboM.words isEqualToString:@""] || zhuboM.words == nil ) {
            return 134 * SCREEN_W_SCALE-5*SCREEN_W_SCALE  + 420  * SCREEN_W_SCALE + MARGIN_30 + 65 * SCREEN_W_SCALE+MARGIN_30;
        }
        if (contentSize.height >contentSize1.height*6){
            if (indexSelectInt > -1){
                if (zhuboM.isAll) {
                    return 134 * SCREEN_W_SCALE-5*SCREEN_W_SCALE  + 420  * SCREEN_W_SCALE + MARGIN_30 +  ceil(contentSize.height) + ceil(contentSize.height /contentSize1.height) *6  + MARGIN_30 +44 -MARGIN_20 + 65 * SCREEN_W_SCALE+MARGIN_30;
                }else{
                    return 134 * SCREEN_W_SCALE-5*SCREEN_W_SCALE  + 420  * SCREEN_W_SCALE + MARGIN_30 +  ceil((contentSize1.height+6)*6)  + MARGIN_30 +44 -MARGIN_20 + 65 * SCREEN_W_SCALE+MARGIN_30;
                }
            }
            return 134 * SCREEN_W_SCALE-5*SCREEN_W_SCALE  + 420  * SCREEN_W_SCALE + MARGIN_30 +  ceil((contentSize1.height+6)*6) +44 -MARGIN_20 + MARGIN_30 + 65 * SCREEN_W_SCALE+MARGIN_30;
        }else{
            return  134 * SCREEN_W_SCALE-5*SCREEN_W_SCALE  + 420  * SCREEN_W_SCALE + MARGIN_30 +  ceil(contentSize.height) + ceil(contentSize.height /contentSize1.height) *6  + MARGIN_30 + 65 * SCREEN_W_SCALE+MARGIN_30;
        }
    }
}
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _fmVideoPlayer.index) {
        [_fmVideoPlayer.player pause];
        _fmVideoPlayer.hidden = YES;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZhuBoModel *model = self.models[indexPath.row];
    [self openZhuBoDetail:model];
}


#pragma mark - ZhuBoCellDelegate
- (void)openPhotoBrowser:(NSInteger)index ZhuBoModel:(ZhuBoModel *)model{
    NSMutableArray *photos = [NSMutableArray new];
    NSMutableArray *urlArr = [NSMutableArray new];
    for (int i =0; i<[model.imgArr count]; i++) {
        NSString *url = model.imgArr[i];
        NSArray *arr0 = [url componentsSeparatedByString:@","];
        [urlArr addObject:arr0[1]];
        [photos addObject:arr0[0]];
    }
    [JZLPhotoBrowser showPhotoBrowserWithUrlArr:urlArr currentIndex:index originalImageViewArr:urlArr BQIdArr:photos].delegate = self;
}
- (void)clickedUser:(id)sender withModel:(ZhuBoModel *)model {
    if(![BaseClasss isLogin]) {
        return;
    }
    
    GrZhuYeViewController *userVC = [[GrZhuYeViewController alloc] init];
    userVC.userId = model.userId;
    [self.navigationController pushViewController:userVC animated:YES];
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
    ZhuBoDetailViewController *detailVC = [[ZhuBoDetailViewController alloc] init];
    detailVC.zhuboModel = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)clickedImage:(id)sender withModel:(ZhuBoModel *)model {
    
    NSInteger index = ((UIImageView *)sender).tag - 10000;
    
    [self openPhotoBrowser:index model:model];
}
- (void)openPhotoBrowser:(NSInteger)index model:(ZhuBoModel *)model {
    NSMutableArray *photos = [NSMutableArray array];
    for (NSString *url in model.imgArr) {
        MWPhoto *photo = [[MWPhoto alloc] initWithURL:[NSURL URLWithString:url]];
        [photos addObject:photo];
    }
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithPhotos:photos];
    [browser setCurrentPhotoIndex:index];
    
    [self.navigationController pushViewController:browser animated:YES];
}

- (void)openZhuBoDetail:(ZhuBoModel *)model {
    
    ZhuBoDetailViewController *detailVC = [[ZhuBoDetailViewController alloc] init];
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

-(void)shunxinLiaoBiaoAction:(ZhuBoModel *)model{
    
    NSString *newsContent = model.newsContent;
    NSArray *arr1 = [newsContent componentsSeparatedByString:@","];
    NSString *newsContentUrl;
    if ([arr1 count]>1) {
        newsContentUrl = arr1[1];
    }
    
    ZXVideo *video = [[ZXVideo alloc] init];
    video.playUrl = newsContentUrl;
    video.title = @"";
    
    VideoPlayViewController *vc = [[VideoPlayViewController alloc] init];
    vc.video = video;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)startPlayVideo:(ZhuBoModel *)model but:(UIButton *)sender{
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:sender.tag - 100 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
    UIView *imageView = [cell viewWithTag:sender.tag+2000];
    UIImageView *imageView111 = [imageView viewWithTag:10];
    
    indexInt = sender.tag - 100;
    ZhuBoModel *zhubo = self.models[indexInt];
    NSString *newsContent = zhubo.newsContent;
    NSArray *arr1 = [newsContent componentsSeparatedByString:@","];
    _fmVideoPlayer.index = sender.tag - 100;
    _fmVideoPlayer.backgroundColor = [UIColor blackColor];
    [_fmVideoPlayer setUrlString:arr1[1]];
    _fmVideoPlayer.imageView.image = imageView111.image;
    _fmVideoPlayer.frame = CGRectMake(0,cell.frame.origin.y+imageView.frame.origin.y, SCREEN_WIDTH ,SCREEN_WIDTH);
    [self.view addSubview:_fmVideoPlayer];
    _fmVideoPlayer.contrainerViewController = self;
    [_fmVideoPlayer.player play];
    [_fmVideoPlayer showToolView:NO];
    _fmVideoPlayer.playOrPauseBtn.selected = YES;
    _fmVideoPlayer.hidden = NO;
}
-(void)qwActionTop:(NSInteger)index{
    ZhuBoModel *model = _models[index];
    model.isAll = !model.isAll;
    [_models replaceObjectAtIndex:index withObject:model];
    indexSelectInt = index;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - 视频delegate
- (void)videoplayViewSwitchOrientation:(BOOL)isFull{
    if (isFull) {
        [self.navigationController presentViewController:self.fullVc animated:NO completion:^{
            [self.fullVc.view addSubview:self.fmVideoPlayer];
            _fmVideoPlayer.center = self.fullVc.view.center;
            _fmVideoPlayer.imageView.image = [UIImage imageNamed:@"bg_media_default"];
            
            CGRect frame = self.fullVc.view.frame;
            frame.size.height = frame.size.height-30 ;
            ZYTagImageView *tagImageView = [[ZYTagImageView alloc]initWithFrame:frame];
            tagImageView.tag = 1590;
            tagImageView.delegate = self;
            tagImageView.isEditEnable = NO;
            tagImageView.exclusiveTouch = YES;
            [self getBiaoQIanLoadData:tagImageView];
            tagImageView.alpha = 0.9f;
            [_fmVideoPlayer addSubview:tagImageView];
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{ _fmVideoPlayer.frame = self.fullVc.view.bounds; }
            completion:nil];
        }];
    } else {
        [self.fullVc dismissViewControllerAnimated:NO completion:^{
            [self.view addSubview:_fmVideoPlayer];
            NSIndexPath *index = [NSIndexPath indexPathForRow:indexInt - 100 inSection:0];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
            UIView *imageView = [cell viewWithTag:indexInt+2000];
            _fmVideoPlayer.frame = CGRectMake(0,cell.frame.origin.y+imageView.frame.origin.y, SCREEN_WIDTH ,SCREEN_WIDTH);
            ZYTagImageView *tagImageView = [_fmVideoPlayer viewWithTag:1590];
            [tagImageView removeFromSuperview];
        }];
    }
}
#pragma mark - ZYTagImageViewDelegate
- (void)tagImageView:(ZYTagImageView *)tagImageView activeTapGesture:(UITapGestureRecognizer *)tapGesture
{
    NSLog(@"ni meimei mei d activeTapGesture ");
}

- (void)tagImageView:(ZYTagImageView *)tagImageView tagViewActiveTapGesture:(ZYTagView *)tagView
{
    [self.fullVc dismissViewControllerAnimated:NO completion:^{
        [self.view addSubview:_fmVideoPlayer];
        NSIndexPath *index = [NSIndexPath indexPathForRow:indexInt - 100 inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
        UIView *imageView = [cell viewWithTag:indexInt+2000];
        _fmVideoPlayer.frame = CGRectMake(0,cell.frame.origin.y+imageView.frame.origin.y, SCREEN_WIDTH ,SCREEN_WIDTH - MARGIN_30 * 2+( SCREEN_WIDTH - MARGIN_30 * 2)/2-80);
        ZYTagImageView *tagImageView = [_fmVideoPlayer viewWithTag:1590];
        [tagImageView removeFromSuperview];
    }];
    NSDictionary *dic = tagView.tagInfo.object;
    biaoqianXQViewController *vc = [[biaoqianXQViewController alloc]init];
    vc.biaoqianText = [dic objectForKey:@"Msg"];
    vc.zhangshuText = [dic objectForKey:@"lcount"];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tagImageView:(ZYTagImageView *)tagImageView tagViewActiveLongPressGesture:(ZYTagView *)tagView
{
    /** 可自定义长按手势的反馈 */
    NSLog(@"ni meimei mei d tagViewActiveLongPressGesture ");
}
#pragma mark -- 视频获取标签
-(void)getBiaoQIanLoadData:(ZYTagImageView *)imageView{
    ZhuBoModel *zhubo = self.models[indexInt];
    NSString *newsContent = zhubo.newsContent;
    NSArray *arr1 = [newsContent componentsSeparatedByString:@","];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"BuildSowingType"] = @"GetLabel";
    params[@"FileId"] = arr1[0];
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            ZBLog(@"BuildSowing_News--%@", res);
            NSArray *dataArr = [res objectForKey:@"data"];
            if(!dataArr || dataArr.count == 0) {
            }
            for (NSDictionary *dic in dataArr) {
                NSString *xStr = [dic objectForKey:@"x"];
                NSString *yStr = [dic objectForKey:@"y"];
                CGPoint point;
                point.x = SCREEN_WIDTH*xStr.floatValue;
                point.y = imageView.frame.size.height*yStr.floatValue;
                [imageView addTagWithTitle:[dic objectForKey:@"Msg"] point:point object:dic];
            }
        }
        else{
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
#pragma mark - 懒加载代码
- (FullViewController *)fullVc
{
    if (_fullVc == nil) {
        _fullVc = [[FullViewController alloc] init];
    }
    return _fullVc;
}


#pragma mark -- JZLPhotoBrowserDelegate
- (void)selectedTagInFo:(NSDictionary *)dic{
    biaoqianXQViewController *vc = [[biaoqianXQViewController alloc]init];
    vc.biaoqianText = [dic objectForKey:@"Msg"];
    vc.zhangshuText = @"1";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
