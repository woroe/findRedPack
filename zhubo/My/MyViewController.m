//
//  MyViewController.m
//  zhubo
//
//  Created by Jin on 2017/6/9.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "MyViewController.h"
#import "MyTableViewCell.h"

#import "MyUpdataViewController.h"
#import "MyQiaoBaoViewController.h"
#import "MySMSZViewController.h"
#import "MyYSsheziViewController.h"
#import "MyXTsheziViewController.h"
#import "CircleDetailViewController.h"
#import "ZhuBoTableViewController.h"

#import "ZhuBoDetailViewController.h"
#import "MessageViewController.h"
#import "ZhuBoGZTableViewController.h"

#import "bangzhufankuiViewController.h"

#import "UserModel.h"
#import "UserNewData.h"

#import "GrZhuYeViewController.h"
#import "tongzhiViewController.h"

#import "UIView+DKSBadge.h"

@interface MyViewController ()<UITableViewDelegate, UITableViewDataSource>{
    
    UserNewData *userData;
}

@property (nonatomic, strong) UITableView *tabView;
@property (nonatomic, strong) NSArray *menuArr;

@property (nonatomic, strong) UserModel *model;

@property (nonatomic, strong) NSMutableArray *models;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate]; // 设置状态栏字体颜色
    
    _models = [NSMutableArray new];
    userData = [UserNewData new];
    
    self.navigationItem.title = @"我的";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gohome) name:@"gohome" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updata_user) name:@"updata_User" object:nil];
    [self loadData];
    [self loadUI];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)gohome {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gohome_zuiXing" object:nil];
    HomeViewController *homeVC = self.tabBarController.viewControllers[0];
    self.tabBarController.selectedViewController = homeVC;
}
-(void)updata_user{
    [self loadData];
}
- (void)loadUI {
    
    UITableView *tabView = [[UITableView alloc] init];
    [tabView registerNib:[UINib nibWithNibName:@"MyTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyTableViewCellID"];
    tabView.delegate = self;
    tabView.dataSource = self;
    tabView.bounces = YES;
    
    UIView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"MyTabHeaderView" owner:nil options:nil] lastObject];
    CGRect frame = headerView.frame;
    frame.size.width = SCREEN_WIDTH;
    headerView.frame = frame;
    CGRect frame111;
    frame111 = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - (MARGIN_40+MARGIN_30));
    tabView.frame = frame111;
    tabView.backgroundColor = [UIColor colorWithRed:240/255.0f green:242/255.0f blue:245/255.0f alpha:1];
    self.tabView = tabView;
    [self.view addSubview:tabView];
    
    UIBlurEffect *blurEffrct =[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];//实现模糊效果
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffrct];//毛玻璃视图
    visualEffectView.frame = frame;
    visualEffectView.alpha = 1;
    [headerView addSubview:visualEffectView];
    
    UIView *viewBg = [[UIView alloc]init];
    viewBg.frame = frame;
    viewBg.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8];
    [headerView addSubview:viewBg];
    
    UIImageView *HaederimageView = [headerView viewWithTag:10];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cutPhotos:)];
    HaederimageView.userInteractionEnabled = YES;
    [HaederimageView addGestureRecognizer:tap1];
    [HaederimageView sd_setImageWithURL:[NSURL URLWithString:_model.HeadImg]];
    [headerView addSubview:HaederimageView];
    
    UIImageView *VimageView = [headerView viewWithTag:12];
    [VimageView setImage:[UIImage imageNamed:@"renzheng"]];
    if (_model.Is_Real) {
        VimageView.hidden = NO;
    }else{
        VimageView.hidden = YES;
    }
    [headerView addSubview:VimageView];
    
    UIImageView *bgImageView = [headerView viewWithTag:111];
    bgImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, headerView.frame.size.height);
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    bgImageView.clipsToBounds  = YES;
    UIImage *image = [self getImageFromUrl:[NSURL URLWithString:_model.HeadImg] imgViewWidth:SCREEN_WIDTH imgViewHeight:bgImageView.frame.size.height];
    bgImageView.image = image;
    
    UILabel *maneLal = [headerView viewWithTag:13];
    if (userData.ShowRealName == 1) {
        if ([userData.RealName isEqualToString:@""] || userData.RealName == nil) {
            maneLal.text = userData.NickName;
        }else{
            maneLal.text = userData.RealName;
        }
    }else{
        maneLal.text = userData.NickName;
    }
    
    [headerView addSubview:maneLal];
    
    UILabel *nameLal1 = [headerView viewWithTag:14];
    nameLal1.text = _model.ProfessionalIdentity;
    if (_model.ShowProfessionalIdentity || [_model.ShowProfessionalIdentity isEqualToString:@""] || _model.ShowProfessionalIdentity == nil) {
        nameLal1.hidden = YES;
    }else{
        nameLal1.hidden = NO;
    }
    [headerView addSubview:nameLal1];
    
    UILabel *gsANDzhiweiLal = [headerView viewWithTag:140];
    gsANDzhiweiLal.text = @"";
    if (userData.ShowPosition == 1) {
        if ([userData.Employer isEqualToString:@""]&& [userData.Position isEqualToString:@""] ) {
            gsANDzhiweiLal.text = @"";
        }
        if ([userData.Employer isEqualToString:@""]&& ![userData.Position isEqualToString:@""]) {
            gsANDzhiweiLal.text = [NSString stringWithFormat:@"%@",userData.Position];
        }
        if (![userData.Employer isEqualToString:@""]&& [userData.Position isEqualToString:@""]) {
            if (userData.ShowEmployer == 1) {
                gsANDzhiweiLal.text = [NSString stringWithFormat:@"%@",userData.Employer];
            }else{
                gsANDzhiweiLal.text = @"";
            }
        }
        if (![userData.Employer isEqualToString:@""]&& ![userData.Position isEqualToString:@""]) {
            if (userData.ShowEmployer == 1){
                gsANDzhiweiLal.text = [NSString stringWithFormat:@"%@ | %@",userData.Employer,userData.Position];
            }else{
                gsANDzhiweiLal.text = [NSString stringWithFormat:@"%@",userData.Position];
            }
        }
    }else{
        if (userData.ShowEmployer == 1) {
            gsANDzhiweiLal.text = userData.Employer;
        }else{
            gsANDzhiweiLal.text = @"";
        }
    }
    if (userData.Employer == nil) {
        gsANDzhiweiLal.text = @"";
    }
    [headerView addSubview:gsANDzhiweiLal];
    
    UILabel *shenfenLal = [headerView viewWithTag:150];
    if ([userData.shenfen isEqualToString:@""]&& [userData.lx isEqualToString:@""] ) {
        shenfenLal.text = @"";
    }
    if ([userData.shenfen isEqualToString:@""]&& ![userData.lx isEqualToString:@""]) {
        shenfenLal.text = [NSString stringWithFormat:@"%@",userData.lx];
    }
    if (![userData.shenfen isEqualToString:@""]&& [userData.lx isEqualToString:@""]) {
        shenfenLal.text = [NSString stringWithFormat:@"%@",userData.shenfen];
    }
    if (![userData.shenfen isEqualToString:@""]&& ![userData.lx isEqualToString:@""]) {
        shenfenLal.text = [NSString stringWithFormat:@"%@ | %@",userData.shenfen,userData.lx];
    }
    CGRect frame1111111 = shenfenLal.frame;
    if ([gsANDzhiweiLal.text isEqualToString:@""]) {
        shenfenLal.frame = gsANDzhiweiLal.frame;
    }
    if (userData.shenfen == nil) {
        shenfenLal.text = @"";
    }
    [headerView addSubview:shenfenLal];
    
    UILabel *sexANDdizhiLal = [headerView viewWithTag:160];
    if ([userData.City isEqualToString:@""]) {
        sexANDdizhiLal.text = userData.Sex;
    }else{
        sexANDdizhiLal.text = [NSString stringWithFormat:@"%@ | %@ %@",userData.Sex,userData.Province,userData.City];
    }
    if ([shenfenLal.text isEqualToString:@""]) {
        sexANDdizhiLal.frame = shenfenLal.frame;
    }
    if ([gsANDzhiweiLal.text isEqualToString:@""] && ![shenfenLal.text isEqualToString:@""]) {
        
        sexANDdizhiLal.frame = frame1111111;
    }
    if (userData.City == nil) {
        sexANDdizhiLal.text = @"";
    }
    [headerView addSubview:sexANDdizhiLal];
    
    self.tabView.tableHeaderView = headerView;
    ZBLog(@"--%@", NSStringFromCGRect(self.tabView.tableHeaderView.frame));
    
    NSArray *array1 = @[@{@"title":@"修改资料", @"image":@"xiugaiziliao"}];
    NSArray *array2 = @[@{@"title":@"筑播", @"image":@"zhubo"} , @{@"title":@"通知", @"image":@"tongzhi"}];
    NSArray *array4 = @[@{@"title":@"隐私设置", @"image":@"yinsishezhi"}, @{@"title":@"系统设置", @"image":@"xitongshezhi"}, @{@"title":@"帮助与反馈", @"image":@"bangzhufankui"}];
    self.menuArr = @[array1,array2,array4];
    
    [self.tabView reloadData];
}

#pragma mark-------根据imgView的宽高获得图片的比例
-(UIImage *)getImageFromUrl:(NSURL *)imgUrl imgViewWidth:(CGFloat)width imgViewHeight:(CGFloat)height{
    //data 转image
    UIImage * image ;
    //根据网址将图片转化成image
    NSData * data = [NSData dataWithContentsOfURL:imgUrl];
    image =[UIImage imageWithData:data];
    //图片剪切
    UIImage * newImage = [self cutImage:image imgViewWidth:width imgViewHeight:height];
    return newImage;
}
- (UIImage *)cutImage:(UIImage*)image imgViewWidth:(CGFloat)width imgViewHeight:(CGFloat)height{
    
    CGSize newSize;
    CGImageRef imageRef = nil;
    if ((image.size.width / image.size.height) < (width / height)) {
        newSize.width = image.size.width;
        newSize.height = image.size.width * height /width;
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
        
    } else {
        newSize.height = image.size.height;
        newSize.width = image.size.height * width / height;
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
    }
    return [UIImage imageWithCGImage:imageRef];
}


-(void)cutPhotos:(id *)sender{
    
    GrZhuYeViewController *userVC = [[GrZhuYeViewController alloc] init];
    userVC.userId = [BaseData shareInstance].userId;
    [self.navigationController pushViewController:userVC animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.menuArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.menuArr[section];
    
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }
    else{
        return 15;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyTableViewCellID" forIndexPath:indexPath];
    NSArray *sectionData = self.menuArr[indexPath.section];
    NSDictionary *rowData = sectionData[indexPath.row];
    UserModel *cM;
    if ([_models count] >0) {
        cM = [_models objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(indexPath.section == 1) {
        self.tabView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        if (indexPath.row == 0) {
            [cell setImage:[rowData objectForKey:@"image"] WithTitle:[rowData objectForKey:@"title"] Number:cM.NewsCount];
        }
        if (indexPath.row == 1) {
            UIImageView *imageView = [cell viewWithTag:120];
            if (self.navigationController.tabBarItem.tag == 1) {//有未读消息
                [imageView showBadge];
            }else{
                [imageView hidenBadge];
            }
            [cell setImage:[rowData objectForKey:@"image"] WithTitle:[rowData objectForKey:@"title"] Number:cM.MsgCount];
        }
    }
    else{
        [cell setImage:[rowData objectForKey:@"image"] WithTitle:[rowData objectForKey:@"title"]];
    }
    if (indexPath.section == 2 && indexPath.row == 2) {
        self.tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
    view.backgroundColor = [UIColor colorWithRed:240/255.0f green:242/255.0f blue:245/255.0f alpha:1];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MyUpdataViewController *updataVc = [[MyUpdataViewController alloc]init];
        [self.navigationController pushViewController:updataVc animated:YES];
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0 ) {
            CGRect frame = self.view.frame;
            ZhuBoTableViewController *zhuboVC = [[ZhuBoTableViewController alloc] init];
            zhuboVC.view.frame = frame;
            zhuboVC.title = @"筑播";
            zhuboVC.MyZhuboStr = @"1";// 我的筑播
            [self.navigationController pushViewController:zhuboVC animated:YES];
        }
        if (indexPath.row == 1) {
            tongzhiViewController *zhuboVC = [[tongzhiViewController alloc] init];
            [self.navigationController pushViewController:zhuboVC animated:YES];
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            MyYSsheziViewController *updataVc = [[MyYSsheziViewController alloc]init];
            [self.navigationController pushViewController:updataVc animated:YES];
        }
        if (indexPath.row == 1) {
            MyXTsheziViewController *updataVc = [[MyXTsheziViewController alloc]init];
            [self.navigationController pushViewController:updataVc animated:YES];
        }
        if (indexPath.row == 2) {//帮助与反馈
            bangzhufankuiViewController *vc = [[bangzhufankuiViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
//            NSMutableDictionary *dci = [NSMutableDictionary new];
//            [dci setObject:@"http://zhuboapp.oss-cn-shanghai.aliyuncs.com/File/image/20170711/20170711150440_2850.png" forKey:@"HeadImg"];
//            [dci setObject:@"1" forKey:@"Id"];
//            [dci setObject:@"0" forKey:@"IsPay"];
//            [dci setObject:@"官方帮助与反馈" forKey:@"Name"];
//            [dci setObject:@"57" forKey:@"PeopleCount"];
//
//            CircleModel *model11 = [[CircleModel alloc] initWithDictionary:dci];
//            
//            CircleDetailViewController *detailVC = [[CircleDetailViewController alloc] init];
//            detailVC.model = model11;
//            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
}

- (void)loadData {
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = @([BaseData shareInstance].userId);
    params[@"BuildSowingType"] = @"BuildSowing_GetUserMsg";
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        ZBLog(@"BuildSowing_GetUserMsg--%@", res);
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            
            NSArray *dataArr = [res objectForKey:@"data"];
            if(!dataArr || dataArr.count == 0) {
                [SVProgressHUD showSuccessWithStatus:@""];
                return ;
            }
            for (NSDictionary *data in dataArr) {
                UserModel *model1 = [[UserModel alloc] initWithDictionary:data];
                _model = model1;
            }
            [self loadData1111];
        }
        else{
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
    }];
}

- (void)loadData1111 {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = @([BaseData shareInstance].userId);
    params[@"BuildSowingType"] = @"BuildSowing_UserCenter";
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            ZBLog(@"BuildSowing_UserCenter--%@", res);
            
            NSArray *dataArr = [res objectForKey:@"data"];
            if(!dataArr || dataArr.count == 0) {
                [SVProgressHUD showSuccessWithStatus:@""];
                return ;
            }
            [self.models removeAllObjects];
            userData = [userData mj_setKeyValues:dataArr[0]];
            for (NSDictionary *data in dataArr) {
                UserModel *model = [[UserModel alloc] initWithDictionary:data];
                [self.models addObject:model];
            }
            [self loadUI];
            [SVProgressHUD dismiss];
        }
        else{
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
    }];
    
}
@end
