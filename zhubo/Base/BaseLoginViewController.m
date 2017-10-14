//
//  BaseLoginViewController.m
//  zhubo
//
//  Created by Jin on 2017/6/9.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "BaseLoginViewController.h"
#import "CALayer+BorderColor.h"

#import "WXApi.h"
#import "AppDelegate.h"
#import "WeixinPayHelper.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "yhxyiViewController.h"
#import "IdentityTypeViewController.h"

#import <EaseUserModel.h>

@interface BaseLoginViewController ()<WXDelegate,TencentSessionDelegate,TencentLoginDelegate,UITextFieldDelegate>{
    
    AppDelegate *appdelegate;
    WeixinPayHelper *helper;
    
    TencentOAuth *tencentOAuth;
    UILabel *resultLable;
    UILabel *tokenLable;
    UIButton *qqLoginBtn;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *smsLab;

@property (weak, nonatomic) IBOutlet UITextField *phoneInput;
@property (weak, nonatomic) IBOutlet UIButton *smsBtn;
@property (weak, nonatomic) IBOutlet UITextField *smsInput;
@property (weak, nonatomic) IBOutlet UIButton *agreementBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (nonatomic, strong) NSTimer *smsTimer;
@property (nonatomic, assign) NSInteger timerTime;

@end

@implementation BaseLoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView {
    self.agreementBtn.selected = YES;
    self.phoneInput.delegate = self;
    self.smsInput.delegate = self;
    
    self.titleLab.font = [UIFont systemFontOfSize:46.0 * SCREEN_W_SCALE];
    self.phoneLab.font = [UIFont systemFontOfSize:26.0 * SCREEN_W_SCALE];
    self.phoneInput.font = [UIFont systemFontOfSize:36.0 * SCREEN_W_SCALE];
    self.smsLab.font = [UIFont systemFontOfSize:26.0 * SCREEN_W_SCALE];
    self.smsInput.font = [UIFont systemFontOfSize:36.0 * SCREEN_W_SCALE];
    self.smsBtn.titleLabel.font = [UIFont systemFontOfSize:26.0 * SCREEN_W_SCALE];
    self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:30.0 * SCREEN_W_SCALE];
    UILabel *phoneLeftLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80* SCREEN_W_SCALE, self.phoneInput.frame.size.height)];
    phoneLeftLab.text = @"+86";
    phoneLeftLab.font = [UIFont systemFontOfSize:36.0 * SCREEN_W_SCALE];
    self.phoneInput.leftView = phoneLeftLab;
    self.phoneInput.leftViewMode = UITextFieldViewModeAlways;
}

// 用户协议
- (IBAction)yhxyAction:(id)sender {
    yhxyiViewController *vc = [[yhxyiViewController alloc]init];
    vc.str = @"1";
    [self presentViewController:vc animated:YES completion:nil];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(self.phoneInput.isFirstResponder) {
        [self.phoneInput resignFirstResponder];
    }
    if(self.smsInput.isFirstResponder) {
        [self.smsInput resignFirstResponder];
    }
}
//登录按钮
- (IBAction)loginAction:(id)sender {
    
    if(!self.agreementBtn.selected){
        [SVProgressHUD showErrorWithStatus:BaseStringYHXYFail];
        return;
    }
    NSString *phone = self.phoneInput.text;
    if(!phone || [BaseClasss validateCellPhoneNumber:phone] == NO) {
        [SVProgressHUD showErrorWithStatus:BaseStringphoneInputFail];
        return;
    }
    NSString *code = self.smsInput.text;
    if(code.length != 4){
        [SVProgressHUD showErrorWithStatus:BaseStringcodeFail];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"BuildSowingType"] = @"Sms_Login";
    params[@"Phone"] = phone;
    params[@"Code"] = code;
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)] || [[res objectForKey:@"StatusCode"] isEqual:@(-2)]){
            [self loginSuccess:res];
        }
        else{
            [SVProgressHUD showErrorWithStatus:BaseStringLoginFail];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringLoginFail];
    }];
}
- (void)loginSuccess:(NSDictionary *)data {
    NSUserDefaults *userDe = [NSUserDefaults standardUserDefaults];
    NSDictionary *user = ((NSArray *)[data objectForKey:@"data"])[0];
    
    if(user){
        [userDe setObject:user forKey:@"user"];
        [userDe synchronize];
        [[BaseData shareInstance] setUser:user];
    }
    
    //环信...
    NSString *hxyhStr = [NSString stringWithFormat:@"askzhu_%@",@([BaseData shareInstance].userId)];
    EMError *error = [[EMClient sharedClient] registerWithUsername:hxyhStr password:@"123456"];
    if (error==nil) {
        NSLog(@"环信账号注册成功");
    }else{
        NSLog(@"环信账号注册失败___%@",error);
    }
    NSString *hxyhStr111 = [NSString stringWithFormat:@"askzhu_%@",@([BaseData shareInstance].userId)];
    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
    if (!isAutoLogin) {
        EMError *error1 = [[EMClient sharedClient] loginWithUsername:hxyhStr111 password:@"123456"];
        if (!error1) {
            NSLog(@"登录成功");
        }else{
            NSLog(@"登录失败____%@",error1);
        }
    }
    [SVProgressHUD dismiss];
    if ([[data objectForKey:@"StatusCode"] isEqual:@(1)]) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
        BaseTabBarViewController *BaseVC = [[BaseTabBarViewController alloc] init];
        self.view.window.rootViewController = BaseVC;
    }else if ([[data objectForKey:@"StatusCode"] isEqual:@(-2)]) {
        IdentityTypeViewController *vc = [[IdentityTypeViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }
    
}
//逛逛按钮
- (IBAction)goninAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    
    BaseTabBarViewController *BaseVC = [[BaseTabBarViewController alloc] init];
    self.view.window.rootViewController = BaseVC;
}
//获取按钮
- (IBAction)smsAction:(id)sender {
    NSString *phone = self.phoneInput.text;
    if(!phone || [BaseClasss validateCellPhoneNumber:phone] == NO) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"BuildSowingType"] = @"Sms_Send";
    params[@"Phone"] = phone;
    params[@"CodeType"] = @"1";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            
            NSDictionary *data = ((NSArray *)[res objectForKey:@"data"])[0];
            if([[data objectForKey:@"Code"] isEqual:@"4391"]){
                [SVProgressHUD showSuccessWithStatus:@"验证码未过期,请勿重复发送"];
                return;
            }
            [SVProgressHUD showSuccessWithStatus:BaseStringSendSucc];
            [self runSmsTimer];
        }else{
            if ([[res objectForKey:@"StatusCode"] isEqual:@(-1)]) {
                [SVProgressHUD showErrorWithStatus:@"您的账号被禁用，不能登录！"];
            }else{
                [SVProgressHUD showErrorWithStatus:BaseStringSendFail];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZBLog(@"error--%@", error);
        [SVProgressHUD showErrorWithStatus:BaseStringSendFail];
    }];
}
- (void)runSmsTimer {
    if(!self.smsTimer){
        self.smsTimer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            self.timerTime --;
            if(self.timerTime == 0){
                [self.smsBtn setTitle:@"获取" forState:UIControlStateNormal];
                [self.smsBtn setTitleColor:BaseColorYellow forState:UIControlStateNormal];
                [self.smsBtn setUserInteractionEnabled:YES];
                [self.smsTimer invalidate];
                self.smsTimer = nil;
                
                return ;
            }
            [self.smsBtn setTitle:[NSString stringWithFormat:@"%lds", (long)self.timerTime] forState:UIControlStateNormal];
        }];
    }
    
    self.timerTime = 60;
    [self.smsBtn setUserInteractionEnabled:NO];
    [self.smsBtn setTitle:@"60s" forState:UIControlStateNormal];
    [self.smsBtn setTitleColor:BaseColorGray forState:UIControlStateNormal];
    
    [[NSRunLoop currentRunLoop] addTimer:self.smsTimer forMode:NSDefaultRunLoopMode];
}

//国家按钮
- (IBAction)countryChoiceAction:(id)sender {
    
}
//协议按钮
- (IBAction)agreeChoiceAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
}

//微信登录
- (IBAction)wxlognAction:(id)sender {
    if (_agreementBtn.selected == YES){
        if ([WXApi isWXAppInstalled]) {
            SendAuthReq *req = [[SendAuthReq alloc]init];
            req.scope = @"snsapi_userinfo";
            req.openID = URL_APPID;
            appdelegate = [UIApplication sharedApplication].delegate;
            appdelegate.WXDelegate = self;
            BOOL b =  [WXApi sendReq:req];
            if (b) {
                NSLog(@"成功");
            }else{
                NSLog(@"失败");
            }
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"请同意用户协议"];
    }
}

#pragma mark 微信登录回调。
-(void)shareSuccessByCode:(int) code{
    NSLog(@"shareSuccessByCode ");
}
-(void)loginSuccessByCode:(NSString *)code{
//    [SVProgressHUD showInfoWithStatus:@"努力加载中。。"];
    [SVProgressHUD show];
    NSLog(@"code %@",code);
    __weak typeof(*&self) weakSelf = self;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json",@"text/plain", nil];
    //通过 appid  secret 认证code . 来发送获取 access_token的请求
    [manager GET:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",URL_APPID,URL_SECRET,code] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {  //获得access_token，然后根据access_token获取用户信息请求。
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic %@",dic);
        
        /*
         access_token	接口调用凭证
         expires_in	access_token接口调用凭证超时时间，单位（秒）
         refresh_token	用户刷新access_token
         openid	授权用户唯一标识
         scope	用户授权的作用域，使用逗号（,）分隔
         unionid	 当且仅当该移动应用已获得该用户的userinfo授权时，才会出现该字段
         */
        NSString* accessToken=[dic valueForKey:@"access_token"];
        NSString* openID=[dic valueForKey:@"openid"];
        [weakSelf requestUserInfoByToken:accessToken andOpenid:openID];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %@",error.localizedFailureReason);
    }];
    
}
-(void)requestUserInfoByToken:(NSString *)token andOpenid:(NSString *)openID{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",token,openID] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //开发人员拿到相关微信用户信息后， 需要与后台对接，进行登录
        NSLog(@"login success dic  ==== %@",dic);
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"BuildSowingType"] = @"Face_Login";
        params[@"Guid"] = [dic objectForKey:@"openid"];
        params[@"LoginType"] = @"1";
        params[@"NickName"] = [dic objectForKey:@"nickname"];
        params[@"HeadImg"] = [dic objectForKey:@"headimgurl"];
        
        [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *res = (NSDictionary *)responseObject;
            if([[res objectForKey:@"StatusCode"] isEqual:@(1)] || [[res objectForKey:@"StatusCode"] isEqual:@(-2)]){
                [self loginSuccess:res];
            }
            else{
                if ([[res objectForKey:@"StatusCode"] isEqual:@(-1)]) {
                    [SVProgressHUD showErrorWithStatus:@"您的账号被禁用，不能登录！"];
                }else{
                    [SVProgressHUD showErrorWithStatus:BaseStringSendFail];
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:BaseStringLoginFail];
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %ld",(long)error.code);
    }];
}

//QQ登录
- (IBAction)QQlognAction:(id)sender {
    
    if (_agreementBtn.selected == YES) {
        tencentOAuth=[[TencentOAuth alloc]initWithAppId:@"1106261617"andDelegate:self];
        tencentOAuth.sessionDelegate = self;
        NSArray *permissions= [NSArray arrayWithObjects:@"get_user_info",@"get_simple_userinfo",@"add_t",nil];
        [tencentOAuth authorize:permissions inSafari:NO];
    }else{
        [SVProgressHUD showErrorWithStatus:@"请同意用户协议"];
    }
}

#pragma mark -- TencentSessionDelegate
- (void)tencentDidLogin{
    [SVProgressHUD show];
    if (tencentOAuth.accessToken &&0 != [tencentOAuth.accessToken length]){
        [tencentOAuth getUserInfo];
    }
}
/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled{
    if (cancelled) {
        NSLog(@" 用户点击取消按键,主动退出登录");
    }else{
        NSLog(@"其他原因， 导致登录失败");
    }
}
/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork{
    NSLog(@"没有网络了， 怎么登录成功呢");
}
/**
 * 获取用户个人信息回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/getUserInfoResponse.exp success
 *          错误返回示例: \snippet example/getUserInfoResponse.exp fail
 */
-(void)getUserInfoResponse:(APIResponse *)response{
    NSLog(@"respons:%@",response.jsonResponse);
    NSDictionary *dic  = response.jsonResponse;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"BuildSowingType"] = @"Face_Login";
    params[@"Guid"] = [tencentOAuth openId] ;;
    params[@"LoginType"] = @"2";
    params[@"NickName"] = [dic objectForKey:@"nickname"];
    if ([[dic objectForKey:@"headimgurl"]isEqualToString:@"/0"]) {
        params[@"HeadImg"] = @"";
    }else{
        params[@"HeadImg"] = [dic objectForKey:@"figureurl_qq_2"];
    }
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)] || [[res objectForKey:@"StatusCode"] isEqual:@(-2)]){
            [self loginSuccess:res];
        }
        else{
            [SVProgressHUD showErrorWithStatus:BaseStringLoginFail];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringLoginFail];
    }];
}

@end
