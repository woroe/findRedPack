//
//  MyQiaoBaoViewController.m
//  zhubo
//
//  Created by Jin on 2017/7/13.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "MyQiaoBaoViewController.h"
#import "QiXianViewController.h"
#import "mingxiViewController.h"

@interface MyQiaoBaoViewController (){
    
    NSDictionary *dic;
}

@end

@implementation MyQiaoBaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"钱包";
    self.view.backgroundColor = BaseColorhuise;
    
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"MyqianbaoView" owner:nil options:nil] lastObject];
    self.view = view;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"明细" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
    self.navigationItem.rightBarButtonItem = item;
    
    UIButton *tixianBut = [view viewWithTag:11];
    [tixianBut addTarget:self action:@selector(tixianAction:) forControlEvents:UIControlEventTouchDown];
    
    [self loadData];
}

-(void)rightBtnClick{
    mingxiViewController *vc = [[mingxiViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tixianAction:(UIButton *)sender{
    QiXianViewController *entranceVC = [[QiXianViewController alloc] init];
    entranceVC.qixianzhanghaoStr = [dic objectForKey:@"ExpressiveCode"];
    [entranceVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    //背景透明
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        entranceVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    }else{
        self.modalPresentationStyle=UIModalPresentationCurrentContext;
    }
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:entranceVC animated:YES completion:^{
    }];
}

- (void)loadData {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = @([BaseData shareInstance].userId);
    params[@"BuildSowingType"] = @"PurseBalance";
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        ZBLog(@"PurseBalance--%@", res);
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            
            NSArray *dataArr = [res objectForKey:@"data"];
            if(!dataArr || dataArr.count == 0) {
                return ;
            }else{
                dic = [NSDictionary new];
                dic = dataArr[0];
                UILabel *lqlal = [self.view viewWithTag:10];
                lqlal.text = [NSString stringWithFormat:@"￥%@",[dic objectForKey:@"PurseBalance"]];
                
                UILabel *cslal = [self.view viewWithTag:12];
                cslal.text = [NSString stringWithFormat:@"每天限提现%@次，金额介于%@-%@元",[dic objectForKey:@"LimitNumber"],[dic objectForKey:@"LimitNumber1"],[dic objectForKey:@"LimitNumber2"]];
            }
        }
        else{
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
    }];
}

@end
