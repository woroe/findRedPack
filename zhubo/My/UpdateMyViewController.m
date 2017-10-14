//
//  UpdateMyViewController.m
//  zhubo
//
//  Created by Jin on 2017/7/22.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "UpdateMyViewController.h"

@interface UpdateMyViewController ()<UITextFieldDelegate>

@end

@implementation UpdateMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BaseColorhuise;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UITextField *tf = [self.view viewWithTag:10];
    tf.delegate = self;
    tf.font = [UIFont systemFontOfSize:15];
//    if ([_UpdateLBStr isEqualToString:@"提现账号"]) {
//        tf.keyboardType = UIKeyboardTypeNumberPad;
//    }
    if ([_UpdateLBStr isEqualToString:@"地区"]) {
        self.title = @"请输入城市与所在区";
        tf.placeholder = [NSString stringWithFormat:@"例如：重庆市 渝北区"];
    }else{
        tf.placeholder = [NSString stringWithFormat:@"请输入%@",_UpdateLBStr];
    }
    tf.placeholder = self.CValueStr;
    tf.returnKeyType =UIReturnKeyDone;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 当点击键盘的返回键（右下角）时，执行该方法。
    // 一般用来隐藏键盘
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([_UpdateLBStr isEqualToString:@"昵称"]) {
        if (textField.text.length >= 12){
            textField.text = [textField.text substringWithRange:NSMakeRange(0,11)];
        }
    }
    if ([_UpdateLBStr isEqualToString:@"姓名"]) {
        if (textField.text.length >= 6){
            textField.text = [textField.text substringWithRange:NSMakeRange(0,5)];
        }
    }
    if ([_UpdateLBStr isEqualToString:@"单位"]) {
        if (textField.text.length >= 20){
            textField.text = [textField.text substringWithRange:NSMakeRange(0,19)];
        }
    }
    if ([_UpdateLBStr isEqualToString:@"职位"]) {
        if (textField.text.length >= 8){
            textField.text = [textField.text substringWithRange:NSMakeRange(0,7)];
        }
    }
    if ([_UpdateLBStr isEqualToString:@"职称"]) {
        if (textField.text.length >= 8){
            textField.text = [textField.text substringWithRange:NSMakeRange(0,7)];
        }
    }
    return YES;
}
#pragma mark - 提交
-(void)rightItemAction{
//    if (_qz_myStr.intValue == 1) {// 用户设置
//        UITextField *tf = [self.view viewWithTag:10];
//        if (tf.text == nil || [tf.text isEqualToString:@""]) {
//            [SVProgressHUD showErrorWithStatus:@"请输入修改内容！"];
//            return;
//        }
//    }
    UITextField *tf = [self.view viewWithTag:10];
    if (tf.text == nil || [tf.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入内容！"];
        return;
    }
    if ([_UpdateLBStr isEqualToString:@"姓名"]) {
        if (tf.text.length <= 1){
            [SVProgressHUD showErrorWithStatus:@"请输入完整姓名"];
            return;
        }
    }
    [self.delegate UpdateVIew:tf.text];
    [self.navigationController popViewControllerAnimated:YES];
//        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        params[@"UserId"] = @([BaseData shareInstance].userId);
//        params[@"BuildSowingType"] = @"BuildSowing_EditUserPrivacy";
//        params[@"CName"] = _CNameStr;
//        params[@"CValue"] = tf.text;
//        
//        [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
//            
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSDictionary *res = (NSDictionary *)responseObject;
//            ZBLog(@"BuildSowing_EditUserPrivacy--%@", res);
//            if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
//                [self.delegate UpdateVIew];
//                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
//                [self.navigationController popViewControllerAnimated:YES];
//            }
//            else{
//                [SVProgressHUD showErrorWithStatus:BaseStringNetError];
//            }
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
//        }];
//    }else{//圈子设置
//        UITextField *tf = [self.view viewWithTag:10];
//        if (tf.text == nil || [tf.text isEqualToString:@""]) {
//            [SVProgressHUD showErrorWithStatus:@"请输入内容！"];
//            return;
//        }
//        
//        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        params[@"BuildSowingType"] = @"BuildSowing_EditCircle";
//        params[@"CircleId"] = _CircleIdStr;
//        params[@"CName"] = _CNameStr;
//        params[@"CValue"] = tf.text;
//        
//        [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
//            
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSDictionary *res = (NSDictionary *)responseObject;
//            ZBLog(@"BuildSowing_EditUserPrivacy--%@", res);
//            if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
//                [self.delegate UpdateVIew];
//                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
//                [self.navigationController popViewControllerAnimated:YES];
//            }
//            else{
//                [SVProgressHUD showErrorWithStatus:BaseStringNetError];
//            }
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
//        }];
//    }
}
    
@end
