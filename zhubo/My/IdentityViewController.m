//
//  IdentityViewController.m
//  zhubo
//
//  Created by Jin on 2017/8/2.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "IdentityViewController.h"
#import "LXViewController.h"

@interface IdentityViewController (){
    
    UIScrollView *scrollView;
    NSMutableArray *muArr;
}

@end

@implementation IdentityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"身份";
    
    muArr = [NSMutableArray new];
    scrollView = [self.view viewWithTag:10];
    
    [self loadUserIdentityData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadUserIdentityData {//获取用户身份信息
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"BuildSowingType"] = @"UserIdentity";
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        ZBLog(@"BuildSowing_GetUserMsg--%@", res);
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            
            NSArray *dataArr = [res objectForKey:@"data"];
            if(!dataArr || dataArr.count == 0) {
                return ;
            }else{
                for (int i = 0; i < [dataArr count]; i ++) {
                    NSDictionary *dic = dataArr[i];
                    [muArr addObject:dic];
                    UIButton *but = [[UIButton alloc]init];
                    but.frame = CGRectMake(50, 30+(i*30)+i*45, self.view.frame.size.width-100, 45);
                    [but setTitle:[dic objectForKey:@"Name"] forState:UIControlStateNormal];
                    [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    but.tag = i+1;
                    but.backgroundColor = [UIColor whiteColor];
                    [but addTarget:self action:@selector(shenfenAction:) forControlEvents:UIControlEventTouchUpInside];
                    [scrollView addSubview:but];
                }
                 scrollView.contentSize = CGSizeMake(self.view.frame.size.width, ([dataArr count]*30)+([dataArr count]*45));
            }
        }
        else{
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
    }];
}

-(void)shenfenAction:(UIButton *)sender{
    sender.backgroundColor = [UIColor whiteColor];
    NSDictionary *idectityDic = muArr[sender.tag-1];
    LXViewController *vc = [[LXViewController alloc]init];
    vc.idectityDic = idectityDic;
    vc.userNewData = self.userNewData;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
