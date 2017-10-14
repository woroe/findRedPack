//
//  QiXianViewController.m
//  zhubo
//
//  Created by Jin on 2017/7/26.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "QiXianViewController.h"

@interface QiXianViewController ()<UITextFieldDelegate>

@end

@implementation QiXianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.468f];
    
    _tixianZhanghaoTf.delegate = self;
    _tixianZhanghaoTf.font = [UIFont systemFontOfSize:15];
    _tixianZhanghaoTf.keyboardType = UIKeyboardTypeNumberPad;
    _tixianZhanghaoTf.returnKeyType =UIReturnKeyDone;
    _tixianZhanghaoTf.text = _qixianzhanghaoStr;
    
    _tixianjineTf.delegate = self;
    _tixianjineTf.font = [UIFont systemFontOfSize:15];
    _tixianjineTf.keyboardType = UIKeyboardTypeNumberPad;
    _tixianjineTf.returnKeyType =UIReturnKeyDone;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 当点击键盘的返回键（右下角）时，执行该方法。
    // 一般用来隐藏键盘
    [textField resignFirstResponder];
    return YES;
}

- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismissViewController];
}

- (IBAction)quxiaoAction:(id)sender {
    [self dismissViewController];
}

- (IBAction)qiandingAction:(id)sender {
    [self loadData];
}
- (void)loadData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = @([BaseData shareInstance].userId);
    params[@"BuildSowingType"] = @"BuildSowing_PayMsg";
    params[@"PayWay"] = @(0);
    params[@"PayUser"] = @([BaseData shareInstance].userId);
    params[@"PayeeUser"] = @([BaseData shareInstance].userId);
    params[@"Money"] = _tixianjineTf.text;
    params[@"PayType"] = @(1);
    params[@"Msg"] = @"测试";
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        ZBLog(@"BuildSowing_PayMsg--%@", res);
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            [SVProgressHUD showSuccessWithStatus:@"提现成功"];
            [self dismissViewController];
        }if([[res objectForKey:@"StatusCode"] isEqual:@(2)]){
            [SVProgressHUD showErrorWithStatus:@"账户余额不足"];
        }else{
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
    }];
}

@end
