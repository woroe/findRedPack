//
//  NewGCViewController.m
//  zhubo
//
//  Created by jiangfei on 17/9/18.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "NewGCViewController.h"
#import "BaseTabBarViewController.h"

#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

#import "CommonUtil.h"

@interface NewGCViewController ()<UITextViewDelegate,AMapLocationManagerDelegate> {
    CGFloat longitude;
    CGFloat latitude;
}

@property (nonatomic, assign) NSInteger isAnonymous;

@property (nonatomic, strong)AMapLocationManager *locationManager;

@end

@implementation NewGCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"广场";
    self.isAnonymous = 3;
    [self initView];
    [self configLocationManager];// 初始化
    [self startSerialLocation];// 开始定位
}

- (void)initView {
    _submitTxt.delegate = self;
}

#pragma mark - Location

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
}
- (void)startSerialLocation
{
    //开始定位
    [self.locationManager startUpdatingLocation];
}
- (void)stopSerialLocation
{
    //停止定位
    [self.locationManager stopUpdatingLocation];
}
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    // 定位结果
    ZBLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    longitude = location.coordinate.longitude;
    latitude = location.coordinate.latitude;
    // 停止定位
    [self stopSerialLocation];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    NSString *str = textView.text;
    if (str.length > 1500) {
        str = [str substringWithRange:NSMakeRange(0,1500)];
        textView.text = str;
    }
    _textCountLab.text = [NSString stringWithFormat:@"%li/1500",textView.text.length];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length < 14) {
        [SVProgressHUD showErrorWithStatus:@"发布内容字数不得少于14字"];
    }
}

#pragma mark - Action

- (void)setIsAnonymous:(NSInteger)isAnonymous {
    _isAnonymous = isAnonymous;
    UIView *selectView = [_submitTypeView viewWithTag:isAnonymous];
    UIView *selectSubView = [selectView viewWithTag:100];
    if ([selectSubView isKindOfClass:[UIImageView class]]) {
        UIImageView *imgView = (UIImageView *)selectSubView;
        imgView.image = [UIImage imageNamed:@"fasong"];
    }
    
    UIView *unselectView1 = [_submitTypeView viewWithTag:7 - isAnonymous];
    UIView *unselectSubView = [unselectView1 viewWithTag:100];
    if ([unselectSubView isKindOfClass:[UIImageView class]]) {
        UIImageView *imgView = (UIImageView *)unselectSubView;
        imgView.image = [UIImage imageNamed:@""];
    }
    
}

- (IBAction)cancelAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changeSubmitTypeAction:(UIControl *)sender {
    self.isAnonymous = sender.tag;
}

- (IBAction)submitAction:(UIButton *)sender {
    sender.enabled = NO;
    if (_submitTxt.text.length < 14) {
        [SVProgressHUD showErrorWithStatus:@"发布内容字数不得少于14字"];
        sender.enabled = YES;
        return;
    }

    NSString *words = [CommonUtil encodeBase64String:_submitTxt.text];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = @([BaseData shareInstance].userId);
    params[@"Words"] = words;
    params[@"BuildSowingType"] = @"SquareReleaseNews";
    params[@"NewsType"] = @(_isAnonymous);
    params[@"Longitude"] = @(longitude);
    params[@"Latitude"] = @(latitude);
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            [SVProgressHUD showSuccessWithStatus:@"发布成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GC_SUSSCESS" object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:^{
                }];
            });
        }
        else{
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
        sender.enabled = YES;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        sender.enabled = YES;
    }];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
