//
//  GrZhuYeViewController.m
//  zhubo
//
//  Created by Jin on 2017/8/5.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "GrZhuYeViewController.h"

#import "zhubaoViewController.h"
#import "biaoqaianViewController.h"
#import "guanzhuViewController.h"
#import "FollowedViewController.h"

#import "EMessageVIewControllViewController.h"

#import "UserNewData.h"

@interface GrZhuYeViewController ()<UIScrollViewDelegate,guanzhuViewControllerDelegate>{
    
    UserNewData *userData;
    
    CGRect frame111;
    CGRect frame222;
    CGRect frame333;
}


@property (weak, nonatomic) IBOutlet UIButton *borkBut;
@property (weak, nonatomic) IBOutlet UIImageView *headrImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLal;
@property (weak, nonatomic) IBOutlet UILabel *gsANDzhiweiLal;

@property (weak, nonatomic) IBOutlet UILabel *shenfenLal;
@property (weak, nonatomic) IBOutlet UILabel *sexANDdizhiLal;
@property (weak, nonatomic) IBOutlet UIButton *zhuboBut;
@property (weak, nonatomic) IBOutlet UILabel *zhuboshuLal;

@property (weak, nonatomic) IBOutlet UIButton *biaoqianBut;
@property (weak, nonatomic) IBOutlet UILabel *biaoqianshulal;
@property (weak, nonatomic) IBOutlet UIButton *guanzhuBut;
@property (weak, nonatomic) IBOutlet UILabel *guanzhushuLai;
@property (weak, nonatomic) IBOutlet UIButton *follwedBtn;
@property (weak, nonatomic) IBOutlet UILabel *follwedLab;

@property (weak, nonatomic) IBOutlet UIButton *fashixinBut;

@end

@implementation GrZhuYeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNeedsStatusBarAppearanceUpdate]; // 设置状态栏字体颜色
    
    NSString *hxyhStr = [NSString stringWithFormat:@"askzhu_%@",@([BaseData shareInstance].userId)];
    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
    if (!isAutoLogin) {
        EMError *error1 = [[EMClient sharedClient] loginWithUsername:hxyhStr password:@"123456"];
        if (!error1) {
            NSLog(@"");
        }else{
            NSLog(@"登录失败____%@",error1);
        }
    }
    
    userData = [UserNewData new];
    [self loadData];
    
    [self.fashixinBut addTarget:self action:@selector(sixinAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.zhuboBut addTarget:self action:@selector(zhuboAction) forControlEvents:UIControlEventTouchUpInside];
    [self.biaoqianBut addTarget:self action:@selector(biaoqianAction) forControlEvents:UIControlEventTouchUpInside];
    [self.guanzhuBut addTarget:self action:@selector(guanzhuAction) forControlEvents:UIControlEventTouchUpInside];
    [self.follwedBtn addTarget:self action:@selector(followedAction) forControlEvents:UIControlEventTouchUpInside];
    
    frame111 = self.gsANDzhiweiLal.frame;
    frame222 = self.shenfenLal.frame;
    frame333 = self.sexANDdizhiLal.frame;
    [self zhuboAction];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (IBAction)backAction:(id)sender {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sixinAction{
    self.fashixinBut.userInteractionEnabled = NO;
    [self loadTXData];
}
- (void)loadTXData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"Ids"] = @(self.userId);
    params[@"BuildSowingType"] = @"GetHuanXinUserMsg";
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        ZBLog(@"BuildSowing_UserMsg--%@", res);
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            
            NSArray *dataArr = [res objectForKey:@"data"];
            if(!dataArr || dataArr.count == 0) {
                [SVProgressHUD showErrorWithStatus:BaseStringNetError];
                return ;
            }
            if ([dataArr count] > 0) {
                [self.navigationController setNavigationBarHidden:NO animated:YES];
                NSString *hxyhStr11 = [NSString stringWithFormat:@"askzhu_%@",@(self.userId)];
                EMessageVIewControllViewController *messageView = [[EMessageVIewControllViewController alloc]initWithConversationChatter:hxyhStr11 conversationType:EMConversationTypeChat];
                messageView.userId =  _userId;
                messageView.dic = dataArr[0];
                [self.navigationController pushViewController:messageView animated:YES];
                self.fashixinBut.userInteractionEnabled = YES;
            }
        }
        else{
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = @(self.userId);
    params[@"BuildSowingType"] = @"BuildSowing_UserMsg";
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        ZBLog(@"BuildSowing_UserMsg--%@", res);
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            
            NSArray *dataArr = [res objectForKey:@"data"];
            if(!dataArr || dataArr.count == 0) {
                [SVProgressHUD showErrorWithStatus:BaseStringNetError];
                return ;
            }
            userData = [userData mj_setKeyValues:dataArr[0]];
            [self loadUI];
        }
        else{
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
    }];
}

-(void)loadUI{
    
    UIImageView *imageView = [self.headrView viewWithTag:10];
    UIImage *image = [self getImageFromUrl:[NSURL URLWithString:userData.HeadImg] imgViewWidth:imageView.frame.size.width imgViewHeight:imageView.frame.size.height];
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds  = YES;
    
    UIBlurEffect *blurEffrct =[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];//实现模糊效果
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffrct];//毛玻璃视图
    visualEffectView.frame = self.headrView.frame;
    visualEffectView.alpha = 1;
    [self.headrView addSubview:visualEffectView];
    
    UIView *viewBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, imageView.frame.size.height)];
    viewBg.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8];
    [self.headrView addSubview:viewBg];
    
    [self.headrView addSubview:self.borkBut];
    
    [self.headrImageView sd_setImageWithURL:[NSURL URLWithString:userData.HeadImg]];
    self.headrImageView.layer.cornerRadius = self.headrImageView.frame.size.width / 2;
    self.headrImageView.layer.masksToBounds = YES;
    [self.headrView addSubview:self.headrImageView];
    
//    if ([BaseData shareInstance].userId == self.userId) {
//        if ([userData.RealName isEqualToString:@""] || userData.RealName == nil) {
//            self.nameLal.text = userData.NickName;
//        }else{
//            self.nameLal.text = userData.RealName;
//        }
//    }else{
//        if (userData.ShowRealName == 1) {
//            if ([userData.RealName isEqualToString:@""] || userData.RealName == nil) {
//                self.nameLal.text = userData.NickName;
//            }else{
//                self.nameLal.text = userData.RealName;
//            }
//        }else{
//            self.nameLal.text = userData.NickName;
//        }
//    }
    
    if (userData.ShowRealName == 1) {
        if ([userData.RealName isEqualToString:@""] || userData.RealName == nil) {
            self.nameLal.text = userData.NickName;
        }else{
            self.nameLal.text = userData.RealName;
        }
    }else{
        self.nameLal.text = userData.NickName;
    }
    [self.headrView addSubview:self.nameLal];
    
    if (userData.ShowPosition == 1) {
        if ([userData.Employer isEqualToString:@""]&& [userData.Position isEqualToString:@""] ) {
            self.gsANDzhiweiLal.text = @"";
        }
        if ([userData.Employer isEqualToString:@""]&& ![userData.Position isEqualToString:@""]) {
            self.gsANDzhiweiLal.text = [NSString stringWithFormat:@"%@",userData.Position];
        }
        if (![userData.Employer isEqualToString:@""]&& [userData.Position isEqualToString:@""]) {
            if (userData.ShowEmployer == 1) {
                self.gsANDzhiweiLal.text = [NSString stringWithFormat:@"%@",userData.Employer];
            }else{
                self.gsANDzhiweiLal.text = @"";
            }
        }
        if (![userData.Employer isEqualToString:@""]&& ![userData.Position isEqualToString:@""]) {
            if (userData.ShowEmployer == 1){
                self.gsANDzhiweiLal.text = [NSString stringWithFormat:@"%@ | %@",userData.Employer,userData.Position];
            }else{
                self.gsANDzhiweiLal.text = [NSString stringWithFormat:@"%@",userData.Position];
            }
        }
    }else{
        if (userData.ShowEmployer == 1) {
            self.gsANDzhiweiLal.text = userData.Employer;
        }else{
            self.gsANDzhiweiLal.text = @"";
        }
    }
    [self.headrView addSubview:self.gsANDzhiweiLal];
    
    if ([userData.shenfen isEqualToString:@""]&& [userData.lx isEqualToString:@""] ) {
        self.shenfenLal.text = @"";
    }
    if ([userData.shenfen isEqualToString:@""]&& ![userData.lx isEqualToString:@""]) {
        self.shenfenLal.text = [NSString stringWithFormat:@"%@",userData.lx];
    }
    if (![userData.shenfen isEqualToString:@""]&& [userData.lx isEqualToString:@""]) {
        self.shenfenLal.text = [NSString stringWithFormat:@"%@",userData.shenfen];
    }
    if (![userData.shenfen isEqualToString:@""]&& ![userData.lx isEqualToString:@""]) {
        self.shenfenLal.text = [NSString stringWithFormat:@"%@ | %@",userData.shenfen,userData.lx];
    }
    if ([self.gsANDzhiweiLal.text isEqualToString:@""]) {
        self.shenfenLal.frame = self.gsANDzhiweiLal.frame;
    }else{
        CGRect frame = self.gsANDzhiweiLal.frame;
        frame.origin.y =self.gsANDzhiweiLal.frame.size.height+self.gsANDzhiweiLal.frame.origin.y;
        self.shenfenLal.frame = frame;
    }
    [self.headrView addSubview:self.shenfenLal];
    if ([userData.City isEqualToString:@""]) {
        self.sexANDdizhiLal.text = userData.Sex;
    }else{
        self.sexANDdizhiLal.text = [NSString stringWithFormat:@"%@ | %@  %@",userData.Sex,userData.Province,userData.City];
    }
    if (![self.shenfenLal.text isEqualToString:@""] && [self.gsANDzhiweiLal.text isEqualToString:@""]) {
        CGRect frame = self.shenfenLal.frame;
        frame.origin.y =  self.shenfenLal.frame.origin.y+self.shenfenLal.frame.size.height;
        self.sexANDdizhiLal.frame = frame;
    }
    if ([self.shenfenLal.text isEqualToString:@""] && ![self.gsANDzhiweiLal.text isEqualToString:@""]) {
        CGRect frame = self.gsANDzhiweiLal.frame;
        frame.origin.y =  self.gsANDzhiweiLal.frame.origin.y+self.gsANDzhiweiLal.frame.size.height;
        self.sexANDdizhiLal.frame = frame;
    }
    if (![self.shenfenLal.text isEqualToString:@""] && ![self.gsANDzhiweiLal.text isEqualToString:@""]){
        CGRect frame = self.shenfenLal.frame;
        frame.origin.y =self.shenfenLal.frame.size.height+self.shenfenLal.frame.origin.y;
        self.sexANDdizhiLal.frame = frame;
    }
    if ([self.shenfenLal.text isEqualToString:@""] && [self.gsANDzhiweiLal.text isEqualToString:@""]) {
        self.sexANDdizhiLal.frame = self.gsANDzhiweiLal.frame;
    }
    [self.headrView addSubview:self.sexANDdizhiLal];
    
    self.BarTenView.hidden = NO;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 4, CONTENT_HEIGHT-self.headrView.frame.size.height-self.scrollView.frame.size.height);
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    self.zhuboshuLal.text = [NSString stringWithFormat:@"%@",@(userData.newscount)];
    self.biaoqianshulal.text = [NSString stringWithFormat:@"%@",@(userData.labcount)];
    self.guanzhushuLai.text = [NSString stringWithFormat:@"%@",@(userData.followcount)];
    self.follwedLab.text = [NSString stringWithFormat:@"%@",@(userData.followcount)];
    self.follwedLab.text = [NSString stringWithFormat:@"%@",@(userData.fanscount)];
    self.zhuboshuLal.textColor = [UIColor blackColor];
//    self.biaoqianshulal.textColor = [UIColor colorWithRed:170/255.0f green:170/255.0f blue:179/255.0f alpha:1] ;
//    self.guanzhushuLai.textColor = [UIColor colorWithRed:170/255.0f green:170/255.0f blue:179/255.0f alpha:1] ;
//    self.follwedLab.textColor = [UIColor colorWithRed:170/255.0f green:170/255.0f blue:179/255.0f alpha:1] ;
//    [self.BarTenView addSubview:self.zhuboshuLal];
//    [self.BarTenView addSubview:self.biaoqianshulal];
//    [self.BarTenView addSubview:self.guanzhushuLai];
//    [self.BarTenView addSubview:self.follwedLab];
    
    if (self.userId == [BaseData shareInstance].userId) {
        self.fashixinBut.hidden = YES;
        UIImageView *imageView = [self.view viewWithTag:1050];
        imageView.hidden = YES;
        self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, SCREEN_WIDTH, self.scrollView.frame.size.height+40);
    }else{
        self.fashixinBut.hidden = NO;
        UIImageView *imageView = [self.view viewWithTag:1050];
        imageView.hidden = NO;
        self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, SCREEN_WIDTH, self.scrollView.frame.size.height);
    }
    
    CGRect frame = self.scrollView.frame;
    frame.origin.y = 0;
    frame.size.height = self.scrollView.frame.size.height;
    zhubaoViewController *vc = [[zhubaoViewController alloc]init];
    vc.userId = self.userId;
    vc.view.frame = frame;
    [self addChildViewController:vc];
    [self.scrollView addSubview:vc.view];
    
    frame.size.height = self.scrollView.frame.size.height;
    frame.origin.x = frame.size.width;
    frame.origin.y = 0;
    frame.size.height = self.scrollView.frame.size.height-40*SCREEN_W_SCALE;
    biaoqaianViewController *vc11 = [[biaoqaianViewController alloc]init];
    vc11.userId = self.userId;
    vc11.view.frame = frame;
    [self addChildViewController:vc11];
    [self.scrollView addSubview:vc11.view];
    
    frame.origin.x = 2*frame.size.width;
    frame.origin.y = 0;
    frame.size.height = self.scrollView.frame.size.height;
    guanzhuViewController *vc22 = [[guanzhuViewController alloc]init];
    vc22.delegate = self;
    vc22.userId = self.userId;
    vc22.view.frame = frame;
    [self addChildViewController:vc22];
    [self.scrollView addSubview:vc22.view];
    
    frame.origin.x = 3*frame.size.width;
    frame.origin.y = 0;
    frame.size.height = self.scrollView.frame.size.height;
    FollowedViewController *followedVc = [[FollowedViewController alloc]init];
    followedVc.userId = self.userId;
    followedVc.view.frame = frame;
    [self addChildViewController:followedVc];
    [self.scrollView addSubview:followedVc.view];
}

#pragma mark - delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"%f",self.scrollView.contentOffset.x);
    NSInteger index = self.scrollView.contentOffset.x / SCREEN_WIDTH;
    if (index == 0) {
        self.biaoqianBut.selected = NO;
        self.zhuboBut.selected = YES;
        self.guanzhuBut.selected = NO;
        self.follwedBtn.selected = NO;
        
        self.zhuboshuLal.textColor = [UIColor blackColor];
        self.biaoqianshulal.textColor = [UIColor colorWithRed:170/255.0f green:170/255.0f blue:179/255.0f alpha:1] ;
        self.guanzhushuLai.textColor = [UIColor colorWithRed:170/255.0f green:170/255.0f blue:179/255.0f alpha:1] ;
        self.follwedLab.textColor = [UIColor colorWithRed:170/255.0f green:170/255.0f blue:179/255.0f alpha:1] ;
    }
    if (index == 1) {
        self.biaoqianBut.selected = YES;
        self.zhuboBut.selected = NO;
        self.guanzhuBut.selected = NO;
        self.follwedBtn.selected = NO;
        
        self.biaoqianshulal.textColor = [UIColor blackColor];
        self.zhuboshuLal.textColor = [UIColor colorWithRed:170/255.0f green:170/255.0f blue:179/255.0f alpha:1];
        self.guanzhushuLai.textColor = [UIColor colorWithRed:170/255.0f green:170/255.0f blue:179/255.0f alpha:1];
        self.follwedLab.textColor = [UIColor colorWithRed:170/255.0f green:170/255.0f blue:179/255.0f alpha:1] ;
    }
    if (index == 2) {
        self.biaoqianBut.selected = NO;
        self.zhuboBut.selected = NO;
        self.guanzhuBut.selected = YES;
        self.follwedBtn.selected = NO;
        
        self.guanzhushuLai.textColor = [UIColor blackColor];
        self.zhuboshuLal.textColor = [UIColor colorWithRed:170/255.0f green:170/255.0f blue:179/255.0f alpha:1] ;
        self.biaoqianshulal.textColor = [UIColor colorWithRed:170/255.0f green:170/255.0f blue:179/255.0f alpha:1];
        self.follwedLab.textColor = [UIColor colorWithRed:170/255.0f green:170/255.0f blue:179/255.0f alpha:1] ;
    }
    if (index == 3) {
        self.biaoqianBut.selected = NO;
        self.zhuboBut.selected = NO;
        self.guanzhuBut.selected = NO;
        self.follwedBtn.selected = YES;
        
        self.follwedLab.textColor = [UIColor blackColor];
        self.zhuboshuLal.textColor = [UIColor colorWithRed:170/255.0f green:170/255.0f blue:179/255.0f alpha:1] ;
        self.biaoqianshulal.textColor = [UIColor colorWithRed:170/255.0f green:170/255.0f blue:179/255.0f alpha:1];
        self.guanzhushuLai.textColor = [UIColor colorWithRed:170/255.0f green:170/255.0f blue:179/255.0f alpha:1] ;
    }
}

-(void)zhuboAction{
    [self selectedBtn:0];
    self.biaoqianBut.selected = NO;
    self.zhuboBut.selected = YES;
    self.guanzhuBut.selected = NO;
    self.follwedBtn.selected = NO;
    
    self.zhuboshuLal.textColor = [UIColor blackColor];
    self.biaoqianshulal.textColor = [UIColor colorWithRed:170/255.0f green:170/255.0f blue:179/255.0f alpha:1] ;
    self.guanzhushuLai.textColor = [UIColor colorWithRed:170/255.0f green:170/255.0f blue:179/255.0f alpha:1] ;
    self.follwedLab.textColor = [UIColor colorWithRed:170/255.0f green:170/255.0f blue:179/255.0f alpha:1] ;
}

-(void)biaoqianAction{
    [self selectedBtn:1];
    self.biaoqianBut.selected = YES;
    self.zhuboBut.selected = NO;
    self.guanzhuBut.selected = NO;
    self.follwedBtn.selected = NO;
    
    self.biaoqianshulal.textColor = [UIColor blackColor];
    self.zhuboshuLal.textColor = [UIColor colorWithRed:170/255.0f green:170/255.0f blue:179/255.0f alpha:1] ;
    self.guanzhushuLai.textColor = [UIColor colorWithRed:170/255.0f green:170/255.0f blue:179/255.0f alpha:1] ;
    self.follwedLab.textColor = [UIColor colorWithRed:170/255.0f green:170/255.0f blue:179/255.0f alpha:1] ;
    
}
-(void)guanzhuAction{
    [self selectedBtn:2];
    self.biaoqianBut.selected = NO;
    self.zhuboBut.selected = NO;
    self.guanzhuBut.selected = YES;
    self.follwedBtn.selected = NO;
    
    self.guanzhushuLai.textColor = [UIColor blackColor];
    self.zhuboshuLal.textColor = [UIColor colorWithRed:170/255.0f green:170/255.0f blue:179/255.0f alpha:1] ;
    self.biaoqianshulal.textColor = [UIColor colorWithRed:170/255.0f green:170/255.0f blue:179/255.0f alpha:1] ;
    self.follwedLab.textColor = [UIColor colorWithRed:170/255.0f green:170/255.0f blue:179/255.0f alpha:1] ;
}

-(void)followedAction{
    [self selectedBtn:3];
    self.biaoqianBut.selected = NO;
    self.zhuboBut.selected = NO;
    self.guanzhuBut.selected = NO;
    self.follwedBtn.selected = YES;
    
    self.follwedLab.textColor = [UIColor blackColor];
    self.guanzhushuLai.textColor = [UIColor colorWithRed:170/255.0f green:170/255.0f blue:179/255.0f alpha:1] ;
    self.zhuboshuLal.textColor = [UIColor colorWithRed:170/255.0f green:170/255.0f blue:179/255.0f alpha:1] ;
    self.biaoqianshulal.textColor = [UIColor colorWithRed:170/255.0f green:170/255.0f blue:179/255.0f alpha:1] ;
}

- (void)selectedBtn:(NSInteger)index {
    CGPoint point = self.scrollView.contentOffset;
    point.x = index * self.scrollView.frame.size.width;
    self.scrollView.contentOffset = point;
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

#pragma mark  --- guanzhuViewControllerDelegate
-(void)gengxinyonghu:(NSDictionary *)dic index:(NSInteger)index{
    
//    NSString *userStr = [dic objectForKey:@"Id"];
//    self.userId = userStr.intValue;
    [self loadData];
    [self guanzhuAction];
//    [self zhuboAction];
}

@end
