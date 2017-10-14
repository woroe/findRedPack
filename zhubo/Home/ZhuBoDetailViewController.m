//
//  ZhuBoDetailViewController.m
//  zhubo
//
//  Created by Jin on 2017/6/15.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "ZhuBoDetailViewController.h"
#import "ZhuBoDetailView.h"
#import "ZhuBoToolButtonView.h"
#import "CommentModel.h"
#import "CommentView.h"
#import "DetailExtendView.h"
#import "DetailExtendRewordView.h"
#import "DetailExtendShareView.h"
#import "DetailExtendMoreView.h"
#import "TextInputView.h"

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


@interface ZhuBoDetailViewController ()<UITextFieldDelegate,ZhuBoDetailViewDelegate, DetailExtendViewDelegate,CommentViewDelegate,FMGVideoPlayViewDelegate,UITableViewDelegate,UITableViewDataSource>{

    float  jpHEIGHT ;
    UITapGestureRecognizer *tap1;
    BOOL commet_Bool;
    
    CommentModel *cModel;
    NSInteger indexInt;
}

//头部视图
@property (nonatomic, strong)ZhuBoDetailView *headerView;

//被选中index
@property (nonatomic, assign)NSInteger toolbarIndex;
@property (nonatomic, strong)NSMutableArray <UIBarButtonItem *>*toolbarItemArr;
@property (nonatomic, strong)UIView *extendView;

//评论数据
@property (nonatomic, strong)NSMutableArray<CommentModel *> *commentModels;

//评论输入框
@property (nonatomic, strong)UITextField *textView;

@property (nonatomic, strong)UIView *plView;

@property (nonatomic, strong) FMGVideoPlayView * fmVideoPlayer; // 播放器
/* 全屏控制器 */
@property (nonatomic, strong) FullViewController *fullVc;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *commentBut;

@end

static NSInteger page = 1;
@implementation ZhuBoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btnLeft1 = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 30, 30)];
    [btnLeft1 setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btnLeft1 addTarget:self action:@selector(deleteFile) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bbiLeft12 = [[UIBarButtonItem alloc] initWithCustomView:btnLeft1];
    self.navigationItem.leftBarButtonItem = bbiLeft12;
    
    self.fmVideoPlayer = [FMGVideoPlayView videoPlayView];
    self.fmVideoPlayer.delegate = self;
    
    jpHEIGHT = 0.0f;
    commet_Bool = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [self loadUI];
    self.commentModels = [NSMutableArray array];
    page = 1;
    [self loadComment];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.toolbarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController.view.window addSubview:_plView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
//    self.navigationController.toolbarHidden = NO;
}
-(void)deleteFile{
    [_plView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)keyboardWillShow:(NSNotification *)notification{
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    jpHEIGHT = frame.size.height;
    _plView.frame = CGRectMake(0, SCREEN_HEIGHT-50-jpHEIGHT, SCREEN_WIDTH, 50);
}
- (void)keyboardWillHidden:(NSNotification *)notification{
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    jpHEIGHT = frame.size.height;
    _plView.frame = CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50);
}
-(void)cutPhotos{
    [_textView resignFirstResponder];
    _plView.frame = CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50);
    [self.navigationController.view.window removeGestureRecognizer:tap1];
}
- (void)loadUI {
    
    self.title = @"正文";
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    self.tableView = [[UITableView alloc]init];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-120);
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    [self.view addSubview:self.tableView];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [self loadComment];
    }];
    
    ZhuBoDetailView *headerView;// = [[ZhuBoDetailView alloc] init];
    if (headerView == nil) {
        headerView = [[ZhuBoDetailView alloc] init];
    }
    headerView.qz_And_News_Str = @"1";
    [headerView loadWithModel:self.zhuboModel delegate:self type:-1];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = headerView;
    self.headerView = headerView;
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, headerView.frame.size.height-MARGIN_30);
    
    //toolbar
    NSMutableArray *items = [NSMutableArray array];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *item0 = [self loadButtonWith:@"star" selectedImage:@"star_f" title:@"收藏" index:0];
    [items addObject:item0];
    UIBarButtonItem *item1 = [self loadButtonWith:@"ds" selectedImage:@"ds_f" title:@"打赏" index:1];
    [items addObject:item1];
    UIBarButtonItem *item2 = [self loadButtonWith:@"share" selectedImage:@"share_f" title:@"分享" index:2];
    [items addObject:item2];
    UIBarButtonItem *item3 = [self loadButtonWith:@"gd" selectedImage:@"gd_f" title:@"更多" index:3];
    [items addObject:item3];
    
    self.toolbarItems = [NSArray arrayWithObjects: item0, spaceItem, item1, spaceItem, item2, spaceItem, item3,  nil];
    self.toolbarIndex = 0;
    self.toolbarItemArr = items;
    
    if (_plView == nil) {
        _plView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
        _plView.backgroundColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:241.0f/255.0f alpha:1];
    }
    
    if (_textView == nil) {
        _textView = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-60, 40)];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.returnKeyType =UIReturnKeyDone;
        _textView.placeholder = @"添加评论";
        [_plView addSubview:_textView];
        [_textView addTarget:self action:@selector(textChangeAction:) forControlEvents:UIControlEventEditingChanged];
    }
    
    if (_commentBut == nil) {
        _commentBut = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60+10+5, 10, 40, 30)];
        [_commentBut setImage:[UIImage imageNamed:@"xie_select"] forState:UIControlStateNormal];
        [_commentBut addTarget:self action:@selector(fabuPLAction:) forControlEvents:UIControlEventTouchDown];
        [_plView addSubview:_commentBut];
    }
}

-(UIBarButtonItem *)loadButtonWith:(NSString *)image selectedImage:(NSString *)selected title:(NSString *)title index:(NSInteger)index {
    ZhuBoToolButtonView *view = [[ZhuBoToolButtonView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [view loadButtonWith:image selectedImage:selected title:title index:index];
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClicked:)]];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
    item.style = UIBarButtonSystemItemFixedSpace;
    return item;
}
- (void)itemClicked:(UIGestureRecognizer *)sender {
    
    ZhuBoToolButtonView *view = (ZhuBoToolButtonView *)sender.view;
    if(view.imageBtn.selected){
        view.imageBtn.selected = NO;
        view.titleLab.textColor = [UIColor grayColor];
        
        [self closeExtendView];
        return;
    }
    [self closeExtendView];
    
    view.imageBtn.selected = YES;
    view.titleLab.textColor = BaseColorYellow;
    self.toolbarIndex = view.tag - 10000;
    
    [self openExtendView:self.toolbarIndex];
}

- (void)openExtendView:(NSInteger)index {
    UIView *extend;
    if(index == 1){
        extend = [[DetailExtendRewordView alloc] init];
        [(DetailExtendRewordView *)extend loadWith:self];
    }
    else if(index == 2){
        extend = [[DetailExtendMoreView alloc] init];
        [(DetailExtendMoreView *)extend loadWith:self];
    }
    else if (index == 3){
        extend = [[DetailExtendMoreView alloc] init];
        [(DetailExtendMoreView *)extend loadWith:self];
    }
    [self addAnimation: 1 toView: extend];
    [[UIApplication sharedApplication].keyWindow addSubview: extend];
    self.extendView = extend;
}
- (void)closeExtendView {
    if(self.extendView){
        [self.extendView removeFromSuperview];
        self.extendView = nil;
    }
    [self cancelSelectToolbar];
}
- (void)cancelSelectToolbar {
    ZhuBoToolButtonView *lastView = self.toolbarItemArr[self.toolbarIndex].customView;
    if(self.toolbarIndex > 0 && lastView.imageBtn.selected == YES){
        lastView.imageBtn.selected = NO;
        lastView.titleLab.textColor = [UIColor grayColor];
    }
}

//添加动画
- (void)addAnimation:(NSInteger)animId toView:(UIView *)view{
    
    [view.layer removeAllAnimations];
    if(!animId){
        return;
    }
    
    CATransition *animation = [CATransition animation];
    animation.duration = 260.0 / 1000.0;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.type = kCATransitionPush;
    
    switch (animId) {
        case 1:
            animation.subtype = kCATransitionFromTop;
            break;
        case 2:
            //从上往下
            animation.subtype = kCATransitionFromBottom;
            break;
    }
    [view.layer addAnimation:animation forKey:nil];
    
}

-(void)fabuPLAction:(id)sender{
    [_textView resignFirstResponder];
    _commentBut.userInteractionEnabled = NO;
    if (!commet_Bool) {//正文评论
        [self addComment];
    }else{//评论下的评论
        if (cModel == nil) {
            [self addComment];
        }else{
            [self addComment_Commect];
        }
    }
}
#pragma mark - Comment
- (void)loadComment {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = @([BaseData shareInstance].userId);
    if (_qz_And_News_Str.intValue == 2) {
        params[@"BuildSowingType"] = @"BuildSowing_CircleNewsComment_Detial";
    }else{
        params[@"BuildSowingType"] = @"BuildSowing_NewsComment_Detial";
    }
    params[@"NewsId"] = @(self.zhuboModel.newsId);
    params[@"Page"] = @(page);
    params[@"PageSize"] = @(PageSize);
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            ZBLog(@"BuildSowing_NewsComment_Detial--%@", res);
            
            NSArray *dataArr = [res objectForKey:@"data"];
            if(!dataArr || dataArr.count == 0) {
                _commentBut.userInteractionEnabled = YES;
                [self.tableView.mj_footer endRefreshing];
                return ;
            }
            if (page == 1) {
                [self.commentModels removeAllObjects];
            }
            for (NSDictionary *data in dataArr) {
                CommentModel *model = [[CommentModel alloc] initWithDictionary:data];
                if (_qz_And_News_Str.intValue == 2){
                    [model setCommentHeadImg:[data objectForKey:@"HeadImg"]];
                    [model setCommentName:[data objectForKey:@"NickName"]];
                }
                [self.commentModels addObject:model];
            }
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        }
        else{
            [self.tableView.mj_footer endRefreshing];
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
        _commentBut.userInteractionEnabled = YES;
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        _commentBut.userInteractionEnabled = YES;
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }];
}
#pragma mark -- 筑播下的评论发布
- (void)addComment {
    
    if (_textView.text == nil || [_textView.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入评论内容"];
        _commentBut.userInteractionEnabled = YES;
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = @([BaseData shareInstance].userId);
    params[@"NewsId"] = @(self.zhuboModel.newsId);
    if (_qz_And_News_Str.intValue == 2) {
        params[@"BuildSowingType"] = @"BuildSowing_ReleaseCircleNewsComment";
    }else{
        params[@"BuildSowingType"] = @"BuildSowing_ReleaseNewsComment";
    }
    params[@"CommentMsg"] = _textView.text;
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            ZBLog(@"BuildSowing_NewsComment_Detial--%@", res);
            page = 1;
            [self loadComment];
            self.zhuboModel.commentCount =  self.zhuboModel.commentCount+1;
            [self loadUI];
            _plView.frame = CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50);
            _textView.text = @"";
            [self.navigationController.view.window removeGestureRecognizer:tap1];
        }
        else{
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
        _commentBut.userInteractionEnabled = YES;
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        [self.tableView.mj_header endRefreshing];
        _commentBut.userInteractionEnabled = YES;
    }];
}
#pragma mark -- 筑播评论下的评论发布
- (void)addComment_Commect {
    
    if (_textView.text == nil || [_textView.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入评论内容"];
        _commentBut.userInteractionEnabled = YES;
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = @([BaseData shareInstance].userId);
    params[@"NewsId"] = @(self.zhuboModel.newsId);
    if (_qz_And_News_Str.intValue == 2) {
        params[@"BuildSowingType"] = @"BuildSowing_ReleaseCircleNewsComment";
    }else{
        params[@"BuildSowingType"] = @"BuildSowing_ReleaseCommen_Comment";
        params[@"CommentId"] = @(cModel.commentId);
        params[@"CommentMsgUserId"] = @(cModel.commentUserId);
    }
    params[@"CommentMsg"] = [NSString stringWithFormat:@"回复%@: %@",cModel.commentName,_textView.text];
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            commet_Bool = NO;
            _textView.placeholder = [NSString stringWithFormat:@"添加评论"];
            ZBLog(@"BuildSowing_NewsComment_Detial--%@", res);
            page = 1;
            [self loadComment];
            self.zhuboModel.commentCount =  self.zhuboModel.commentCount+1;
            [self loadUI];
            _plView.frame = CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50);
            _textView.text = @"";
            [self.navigationController.view.window removeGestureRecognizer:tap1];
        }
        else{
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
        _commentBut.userInteractionEnabled = YES;
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        [self.tableView.mj_header endRefreshing];
        _commentBut.userInteractionEnabled = YES;
    }];
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    // 当输入框获得焦点时，执行该方法 （光标出现时）。
    //开始编辑时触发，文本字段将成为first responder
    tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cutPhotos)];
    [self.navigationController.view.window addGestureRecognizer:tap1];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 当点击键盘的返回键（右下角）时，执行该方法。
    // 一般用来隐藏键盘
    [textField resignFirstResponder];
    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    _plView.frame = CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50);
    [self.navigationController.view.window removeGestureRecognizer:tap1];
    return YES;
}

- (void)textChangeAction:(UITextField *)textField {
    if (textField.text.length > 100) {
        textField.text = [textField.text substringToIndex:100];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger num = self.commentModels.count ? self.commentModels.count : 1;
    return num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger num = 1;
    if(self.commentModels.count && self.commentModels[section].isShowInside){
        num += self.commentModels[section].insideComments.count;
    }
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(self.commentModels.count == 0){
        UIView *noneComentView = [self loadNoneCommentView];
        [cell addSubview:noneComentView];
    }
    else {
        CommentView *commentView = [[CommentView alloc] init];
        commentView.qz_And_News_Sre = @"1";
        [commentView loadWithModel:self.commentModels[indexPath.section] delegate:self type:1];
        [cell addSubview:commentView];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    commet_Bool = YES;
    if ([self.commentModels count] >0) {
        if (self.commentModels[indexPath.section].commentUserId != [BaseData shareInstance].userId) {
            cModel = self.commentModels[indexPath.section];
            _textView.placeholder = [NSString stringWithFormat:@"回复%@:",cModel.commentName];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.commentModels.count == 0){
        return 200;
    }
    else {
        NSString *content = self.commentModels[indexPath.section].commentMsg;
        CGSize contentSize = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - MARGIN_30 * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize: 28 * SCREEN_W_SCALE]} context:nil].size;
        
        return 180 * SCREEN_W_SCALE + contentSize.height - 28 * SCREEN_W_SCALE;
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (UIView *)loadNoneCommentView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    
    CGFloat w = 80;
    CGFloat h = 70;
    CGFloat x = (SCREEN_WIDTH - w) / 2;
    CGFloat y = 40;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    imgView.image = [UIImage imageNamed:@"wu"];
    [view addSubview:imgView];
    
    
    UILabel *pointLab = [[UILabel alloc] initWithFrame:CGRectMake(0, h + y + 20, SCREEN_WIDTH, 20)];
    pointLab.text = @"暂时还没有人评论哦";
    pointLab.font = [UIFont systemFontOfSize:14];
    pointLab.textColor = BaseColorGray2;
    pointLab.textAlignment = NSTextAlignmentCenter;
    [view addSubview:pointLab];
    
    return view;
}

- (void)commentUser:(id)sender withModel:(CommentModel *)model{
    [_plView removeFromSuperview];
    GrZhuYeViewController *userVC = [[GrZhuYeViewController alloc] init];
    userVC.userId = model.commentUserId;
    [self.navigationController pushViewController:userVC animated:YES];
}

#pragma mark - ZhuBoDetailViewDelegate
- (void)clickedUser:(id)sender withModel:(ZhuBoModel *)model{
    [_plView removeFromSuperview];
    GrZhuYeViewController *userVC = [[GrZhuYeViewController alloc] init];
    userVC.userId = model.userId;
    [self.navigationController pushViewController:userVC animated:YES];
}
- (void)clickedFollow:(id)sender withModel:(ZhuBoModel *)model{

}
- (void)clickedContent:(id)sender withModel:(ZhuBoModel *)model{
    
}
- (void)clickedLoction:(id)sender withModel:(ZhuBoModel *)model{

}
- (void)clickedSupport:(id)sender withModel:(ZhuBoModel *)model{

}
- (void)clickedComment:(id)sender withModel:(ZhuBoModel *)model{
    commet_Bool = NO;
    [_textView becomeFirstResponder];
}
- (void)slickComment_Comment:(id)sender CommentModel:(CommentModel *)model{
    commet_Bool = YES;
    cModel = model;
    if ( cModel.commentUserId == [BaseData shareInstance].userId){
        _textView.placeholder = [NSString stringWithFormat:@"发表评论"];
    }else{
        _textView.placeholder = [NSString stringWithFormat:@"回复%@:",model.commentName];
    }
}
- (void)clickedImage:(id)sender withModel:(ZhuBoModel *)model{

}
- (void)clickedImageBtn:(id)sender withModel:(ZhuBoModel *)model{

}
- (void)openPhotoBrowser:(NSInteger)index ZhuBoModel:(ZhuBoModel *)model{
    NSMutableArray *photos = [NSMutableArray new];
    NSMutableArray *urlArr = [NSMutableArray new];
    for (int i =0; i<[model.imgArr count]; i++) {
        NSString *url = model.imgArr[i];
        NSArray *arr0 = [url componentsSeparatedByString:@","];
        [urlArr addObject:arr0[1]];
        [photos addObject:arr0[0]];
    }
    [JZLPhotoBrowser showPhotoBrowserWithUrlArr:urlArr currentIndex:index originalImageViewArr:urlArr BQIdArr:photos];
}

- (void)clickedGengduo:(id)sender withModel:(ZhuBoModel *)model{
    [_plView removeFromSuperview];
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
                    [SVProgressHUD showSuccessWithStatus:@""];
                    [self deleteFile];
                }else{
                    [SVProgressHUD showSuccessWithStatus:@""];
                    [self deleteFile];
                }
            }else{
                [SVProgressHUD showErrorWithStatus:BaseStringNetError];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"失败"];
        }];
        [self.navigationController.view.window addSubview:_plView];
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
                [SVProgressHUD showSuccessWithStatus:@""];
            }
            else{
                [SVProgressHUD showErrorWithStatus:BaseStringNetError];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"举报失败"];
        }];
        [self.navigationController.view.window addSubview:_plView];
    }];
    [ac addAction:AAjb];
    UIAlertAction *AAjb1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
        [self.navigationController.view.window addSubview:_plView];
    }];
    [ac addAction:AAjb1];
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
    
    [_fmVideoPlayer.player pause];
    _fmVideoPlayer.hidden = YES;
    
    indexInt = 0;
    
    NSString *newsContent = _zhuboModel.newsContent;
    NSArray *arr1 = [newsContent componentsSeparatedByString:@","];
    _fmVideoPlayer.index = sender.tag - 100;
    _fmVideoPlayer.backgroundColor = [UIColor blackColor];
    [_fmVideoPlayer setUrlString:arr1[1]];
    _fmVideoPlayer.frame = CGRectMake(10, 95, SCREEN_WIDTH-20+5, SCREEN_WIDTH - MARGIN_30 * 2+(SCREEN_WIDTH - MARGIN_30 * 2)/2-80+5);
    [self.view addSubview:_fmVideoPlayer];
    _fmVideoPlayer.contrainerViewController = self;
    [_fmVideoPlayer.player play];
    [_fmVideoPlayer showToolView:NO];
    _fmVideoPlayer.playOrPauseBtn.selected = YES;
    _fmVideoPlayer.hidden = NO;
}

#pragma mark - 视频delegate
- (void)videoplayViewSwitchOrientation:(BOOL)isFull{
    if (isFull) {
        [_plView removeFromSuperview];
        [self presentViewController:self.fullVc animated:NO completion:^{
            [self.fullVc.view addSubview:self.fmVideoPlayer];
            _fmVideoPlayer.center = self.fullVc.view.center;
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{ _fmVideoPlayer.frame = self.fullVc.view.bounds; }
                             completion:nil];
        }];
    } else {
        [self.fullVc dismissViewControllerAnimated:NO completion:^{
            [self.view addSubview:_fmVideoPlayer];
            _fmVideoPlayer.frame = CGRectMake(10, 95, SCREEN_WIDTH-20+5, SCREEN_WIDTH - MARGIN_30 * 2+(SCREEN_WIDTH - MARGIN_30 * 2)/2-80+5);
        }];
    }
    
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