//
//  IdentityTypeViewController.m
//  zhubo
//
//  Created by Jiao on 17/9/20.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "IdentityTypeViewController.h"
#import "UserInfoViewController.h"
#import "BottomPopView.h"

@interface IdentityTypeViewController ()

@property (strong, nonatomic) NSMutableArray *identityFisrtArray;
@property (strong, nonatomic) NSMutableArray *identitySecondArray;

@property (strong, nonatomic) NSString *firstId;
@property (strong, nonatomic) NSString *secondId;

@end

@implementation IdentityTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
    [self loadUserIdentityData];
}

- (void)initView {
    _firstId = @"";
    _secondId = @"";
    self.titleLab.font = [UIFont systemFontOfSize:42.0 * SCREEN_W_SCALE];
    self.subTitle1.font = [UIFont systemFontOfSize:22.0 * SCREEN_W_SCALE];
    self.identityLab.font = [UIFont systemFontOfSize:32.0 * SCREEN_W_SCALE];
    self.subTitle2.font = [UIFont systemFontOfSize:22.0 * SCREEN_W_SCALE];
    self.secondIdentityLab.font = [UIFont systemFontOfSize:32.0 * SCREEN_W_SCALE];
    self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:30.0 * SCREEN_W_SCALE];
    
}

- (void)loadUserIdentityData {//获取用户身份信息
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"BuildSowingType"] = @"UserIdentity";
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if([[responseObject objectForKey:@"StatusCode"] isEqual:@(1)]){
            _identityFisrtArray = [NSMutableArray arrayWithArray:responseObject[@"data"]];
        }
        else{
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
    }];
}

- (void)loadIdentityTypeData {//获取用户身份信息
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"BuildSowingType"] = @"IdentityType";
    params[@"Tid"] = _firstId;
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if([[responseObject objectForKey:@"StatusCode"] isEqual:@(1)]){
            _identitySecondArray = [NSMutableArray arrayWithArray:responseObject[@"data"]];
            [self secondBottomView];
        }
        else{
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
    }];
}

#pragma mark - Action

- (IBAction)identityAction:(UIControl *)sender {
    BottomPopView *btPopView = [[BottomPopView alloc]init];
    btPopView.datas = _identityFisrtArray;
    __weak typeof(self) weakSelf = self;
    btPopView.block = ^(id obj) {
        weakSelf.identityLab.textColor = [UIColor blackColor];
        weakSelf.identityLab.text = obj[@"Name"];
        weakSelf.firstId = obj[@"Id"];
    };
    [self.view addSubview:btPopView];
}

- (IBAction)secondIdentityAction:(UIControl *)sender {
    if ([@"" isEqualToString:_firstId]) {
        [SVProgressHUD showErrorWithStatus:@"请先选择身份"];
        return;
    }
    [self loadIdentityTypeData];
}

- (void)secondBottomView {
    BottomPopView *btPopView = [[BottomPopView alloc]init];
    btPopView.datas = _identitySecondArray;
    __weak typeof(self) weakSelf = self;
    btPopView.block = ^(id obj) {
        weakSelf.secondIdentityLab.textColor = [UIColor blackColor];
        weakSelf.secondIdentityLab.text = obj[@"Name"];
        weakSelf.secondId = obj[@"Id"];
    };
    [self.view addSubview:btPopView];
}

- (IBAction)submitAction:(UIButton *)sender {
    [self.view endEditing:YES];
    if ([@"" isEqualToString:_firstId]) {
        [SVProgressHUD showErrorWithStatus:@"请先选择身份"];
        return;
    }
    if ([@"" isEqualToString:_secondId]) {
        [SVProgressHUD showErrorWithStatus:@"请先选择分类"];
        return;
    }
//  IdentityCode 身份ID,LxCode 类型ID
    UserInfoViewController *vc = [[UserInfoViewController alloc]init];
    vc.info = @{@"IdentityCode":_firstId,@"LxCode":_secondId};
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Set

- (NSMutableArray *)identityFisrtArray {
    if (_identityFisrtArray) {
        _identityFisrtArray = [[NSMutableArray alloc]init];
    }
    return _identityFisrtArray;
}

- (NSMutableArray *)identitySecondArray {
    if (_identitySecondArray) {
        _identitySecondArray = [[NSMutableArray alloc]init];
    }
    return _identitySecondArray;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
