//
//  bangzhufankuiViewController.m
//  zhubo
//
//  Created by Jin on 2017/8/4.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "bangzhufankuiViewController.h"

@interface bangzhufankuiViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *circleneirTV;

@end

@implementation bangzhufankuiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"帮助与反馈";
    
    UITextView *textV = [[UITextView alloc]initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH-20, 200)];
    textV.textColor = [UIColor colorWithRed:161/255.0f green:166/255.0f blue:187/255.0f alpha:1];
    textV.text = @"请输入内容！";
    textV.font = [UIFont systemFontOfSize:15.f];
    textV.clearsContextBeforeDrawing = NO;
    textV.autocorrectionType = UITextAutocorrectionTypeYes;
    textV.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textV.keyboardType = UIKeyboardTypeDefault;
    textV.delegate = self;
    textV.layer.borderWidth = 1.0f;
    textV.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor whiteColor]);
    
    UIToolbar * topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace, doneButton, nil];
    [topView setItems:buttonsArray];
    [textV setInputAccessoryView:topView];
    _circleneirTV = textV;
    
    [self.view addSubview:_circleneirTV];
    
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(subimtActio)];
//    self.navigationItem.rightBarButtonItem = rightItem;
    UIButton *but = [self.view viewWithTag:10];
    [but addTarget:self action:@selector(subimtActio) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([_circleneirTV.text isEqualToString:@"请输入内容！"]) {
        _circleneirTV.text = @"";
    }
    _circleneirTV.textColor = [UIColor blackColor];
    return YES;
}
#pragma mark --关闭键盘
-(void) dismissKeyBoard{
    if ([_circleneirTV.text isEqualToString:@""]) {
        _circleneirTV.textColor = [UIColor colorWithRed:161/255.0f green:166/255.0f blue:187/255.0f alpha:1];
        _circleneirTV.text = @"请输入内容！";
    }
    if ([_circleneirTV.text isEqualToString:@"请输入内容！"]) {
        _circleneirTV.textColor = [UIColor colorWithRed:161/255.0f green:166/255.0f blue:187/255.0f alpha:1];
        _circleneirTV.text = @"请输入内容！";
    }
    [_circleneirTV resignFirstResponder];
}

-(void)subimtActio{
    
    if ([_circleneirTV.text isEqualToString:@""] || [_circleneirTV.text isEqualToString:@"请输入内容！"] ||[_circleneirTV.text isEqualToString:@" "]) {
        [SVProgressHUD showErrorWithStatus:@"请先输入内容，在提交！"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = @([BaseData shareInstance].userId);
    params[@"BuildSowingType"] = @"Feedback";
    params[@"Content"] = _circleneirTV.text ;
    [SVProgressHUD show];
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        ZBLog(@"BuildSowing_GetUserMsg--%@", res);
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else{
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
    }];
}

@end
