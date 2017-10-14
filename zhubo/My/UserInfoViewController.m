//
//  UserInfoViewController.m
//  zhubo
//
//  Created by Jiao on 17/9/20.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "UserInfoViewController.h"

@interface UserInfoViewController () {
    NSInteger genderType;
}

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
}

- (void)initView {
    
    self.titleLab.font = [UIFont systemFontOfSize:42.0 * SCREEN_W_SCALE];
    self.subTitle1.font = [UIFont systemFontOfSize:22.0 * SCREEN_W_SCALE];
    self.nickNameField.font = [UIFont systemFontOfSize:32.0 * SCREEN_W_SCALE];
    self.subTitle2.font = [UIFont systemFontOfSize:22.0 * SCREEN_W_SCALE];
    self.manLab.font = [UIFont systemFontOfSize:32.0 * SCREEN_W_SCALE];
    self.womenLab.font = [UIFont systemFontOfSize:32.0 * SCREEN_W_SCALE];
    self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:30.0 * SCREEN_W_SCALE];
    genderType = 1;
    
    if ([BaseData shareInstance].nickName && ![@"" isEqualToString:[BaseData shareInstance].nickName]) {
        self.nickNameField.text = [BaseData shareInstance].nickName;
    }
}

- (IBAction)changeGenderAction:(UIControl *)sender {
    if (genderType == sender.tag) {
        return;
    }
    genderType = sender.tag;
    switch (genderType) {
        case 0:
            _womenLab.textColor = [UIColor blackColor];
            _manLab.textColor = [UIColor lightGrayColor];
            break;
        case 1:
            _manLab.textColor = [UIColor blackColor];
            _womenLab.textColor = [UIColor lightGrayColor];
            break;
        default:
            break;
    }

}

- (IBAction)submitAction:(UIButton *)sender {
    if ([_nickNameField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入昵称"];
        return;
    }
    [self.view endEditing:YES];
//  UserId 用户ID,NickName 昵称,Sex 1男0女,IdentityCode 身份ID,LxCode 类型ID
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"BuildSowingType"] = @"BuildSowing_SetUserLoginMsg";
    params[@"UserId"] = @([BaseData shareInstance].userId);
    params[@"NickName"] = _nickNameField.text;
    params[@"Sex"] = @(genderType);
    params[@"IdentityCode"] = _info[@"IdentityCode"];
    params[@"LxCode"] = _info[@"LxCode"];
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            BaseTabBarViewController *BaseVC = [[BaseTabBarViewController alloc] init];
            self.view.window.rootViewController = BaseVC;
            [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
        }
        else if ([[res objectForKey:@"StatusCode"] isEqual:@(-1)]) {
            [SVProgressHUD showErrorWithStatus:BaseStringNickNameExits];
        }
        else{
            [SVProgressHUD showErrorWithStatus:BaseStringAddFail];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringLoginFail];
    }];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
