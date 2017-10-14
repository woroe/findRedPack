//
//  LXViewController.m
//  zhubo
//
//  Created by Jin on 2017/8/2.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "LXViewController.h"

#import "LXViewControllerTableViewCell.h"

@interface LXViewController ()<UITableViewDelegate,UITableViewDataSource>{

    NSMutableArray *muArr;
    
    UIScrollView *scrollView;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation LXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"分类";
    muArr = [NSMutableArray array];
    [self loadIdentityTypeData];
    
    scrollView = [self.view viewWithTag:100];
    
//    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    [self.tableView registerNib:[UINib nibWithNibName:@"LXViewControllerTableViewCell" bundle:nil] forCellReuseIdentifier:@"LXViewControllerTableViewCellID"];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    self.tableView.bounces = NO;
//    self.tableView.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadIdentityTypeData {//获取用户身份信息
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"BuildSowingType"] = @"IdentityType";
    params[@"Tid"] = [self.idectityDic objectForKey:@"Id"];
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        ZBLog(@"BuildSowing_GetUserMsg--%@", res);
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            
            NSArray *dataArr = [res objectForKey:@"data"];
            if(!dataArr || dataArr.count == 0) {
                return ;
            }else{
                for (NSDictionary *dic in dataArr) {
                    [muArr addObject:dic];
                }
                for (int i = 0; i < [dataArr count]; i ++) {
                    NSDictionary *dic = dataArr[i];
                    [muArr addObject:dic];
                    UIButton *but = [[UIButton alloc]init];
                    but.frame = CGRectMake(50, 30+(i*30)+i*45, self.view.frame.size.width-100, 45);
                    [but setTitle:[dic objectForKey:@"Name"] forState:UIControlStateNormal];
                    [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    but.tag = i+1;
                    but.backgroundColor = [UIColor whiteColor];
                    [but addTarget:self action:@selector(fanhuiAction:) forControlEvents:UIControlEventTouchUpInside];
                    [scrollView addSubview:but];
                    
                }
                scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 30+([dataArr count]*30)+45+([dataArr count]*45));
            }
        }
        else{
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
    }];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([muArr count]%3 != 0) {
        return [muArr count]/3+1;
    }else{
        return [muArr count]/3;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LXViewControllerTableViewCell *cell = [[LXViewControllerTableViewCell alloc]init];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1];
    if ((indexPath.row+1)*3 < [muArr count]) {
        for (int i =0; i <3; i++) {
            NSDictionary *dic = muArr[indexPath.row + i%3];
            if (i== 0) {
                UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH/3-10, 40)];
                but.backgroundColor = [UIColor whiteColor];
                but.titleLabel.font = [UIFont systemFontOfSize: 14.0];
                [but setTitle:[dic objectForKey:@"Name"] forState:UIControlStateNormal];
                but.tag =indexPath.row + i%3;
                [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [but addTarget:self action:@selector(fanhuiAction:) forControlEvents:UIControlEventTouchUpInside];
                but.hidden = NO;
                [cell addSubview:but];
            }
            if (i== 1) {
                UIButton *but = [[UIButton alloc]initWithFrame: CGRectMake((SCREEN_WIDTH/3-10)+20, 10, SCREEN_WIDTH/3-10, 40)];
                but.backgroundColor = [UIColor whiteColor];
                but.titleLabel.font = [UIFont systemFontOfSize: 14.0];
                but.tag =indexPath.row + i%3;
                [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [but setTitle:[dic objectForKey:@"Name"] forState:UIControlStateNormal];
                [but addTarget:self action:@selector(fanhuiAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:but];
            }
            if (i== 2) {
                UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(2*(SCREEN_WIDTH/3-10)+30, 10, SCREEN_WIDTH/3-20, 40)];
                but.titleLabel.font = [UIFont systemFontOfSize: 14.0];
                but.backgroundColor = [UIColor whiteColor];
                [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [but setTitle:[dic objectForKey:@"Name"] forState:UIControlStateNormal];
                but.tag =indexPath.row + i%3;
                [but addTarget:self action:@selector(fanhuiAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:but];
            }
        }
    }else{
        if ([muArr count]%3 == 0) {
            for (int i =0; i <3; i++) {
                NSDictionary *dic = muArr[indexPath.row + i%3];
                if (i== 0) {
                    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH/3-10, 40)];
                    but.backgroundColor = [UIColor whiteColor];
                    but.titleLabel.font = [UIFont systemFontOfSize: 14.0];
                    [but setTitle:[dic objectForKey:@"Name"] forState:UIControlStateNormal];
                    but.tag =indexPath.row + i%3;
                    [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [but addTarget:self action:@selector(fanhuiAction:) forControlEvents:UIControlEventTouchUpInside];
                    but.hidden = NO;
                    [cell addSubview:but];
                }
                if (i== 1) {
                    UIButton *but = [[UIButton alloc]initWithFrame: CGRectMake((SCREEN_WIDTH/3-10)+20, 10, SCREEN_WIDTH/3-10, 40)];
                    but.backgroundColor = [UIColor whiteColor];
                    but.titleLabel.font = [UIFont systemFontOfSize: 14.0];
                    but.tag =indexPath.row + i%3;
                    [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [but setTitle:[dic objectForKey:@"Name"] forState:UIControlStateNormal];
                    [but addTarget:self action:@selector(fanhuiAction:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:but];
                }
                if (i== 2) {
                    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(2*(SCREEN_WIDTH/3-10)+30, 10, SCREEN_WIDTH/3-20, 40)];
                    but.titleLabel.font = [UIFont systemFontOfSize: 14.0];
                    but.backgroundColor = [UIColor whiteColor];
                    [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [but setTitle:[dic objectForKey:@"Name"] forState:UIControlStateNormal];
                    but.tag =indexPath.row + i%3;
                    [but addTarget:self action:@selector(fanhuiAction:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:but];
                }
            }
        }else{
            for (int i =0; i <[muArr count]%3; i++) {
                NSDictionary *dic = muArr[indexPath.row + i%3];
                if (i== 0) {
                    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH/3-10, 40)];
                    but.backgroundColor = [UIColor whiteColor];
                    but.titleLabel.font = [UIFont systemFontOfSize: 14.0];
                    [but setTitle:[dic objectForKey:@"Name"] forState:UIControlStateNormal];
                    but.tag =indexPath.row + i%3;
                    [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [but addTarget:self action:@selector(fanhuiAction:) forControlEvents:UIControlEventTouchUpInside];
                    but.hidden = NO;
                    [cell addSubview:but];
                }
                if (i== 1) {
                    UIButton *but = [[UIButton alloc]initWithFrame: CGRectMake((SCREEN_WIDTH/3-10)+20, 10, SCREEN_WIDTH/3-10, 40)];
                    but.backgroundColor = [UIColor whiteColor];
                    but.titleLabel.font = [UIFont systemFontOfSize: 14.0];
                    but.tag =indexPath.row + i%3;
                    [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [but setTitle:[dic objectForKey:@"Name"] forState:UIControlStateNormal];
                    [but addTarget:self action:@selector(fanhuiAction:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:but];
                }
                if (i== 2) {
                    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(2*(SCREEN_WIDTH/3-10)+30, 10, SCREEN_WIDTH/3-20, 40)];
                    but.backgroundColor = [UIColor whiteColor];
                    but.titleLabel.font = [UIFont systemFontOfSize: 14.0];
                    [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [but setTitle:[dic objectForKey:@"Name"] forState:UIControlStateNormal];
                    but.tag =indexPath.row + i%3;
                    [but addTarget:self action:@selector(fanhuiAction:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:but];
                }
            }
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)fanhuiAction:(UIButton *)sender{
    NSDictionary *dic = muArr[sender.tag-1];
    [self.delegate UpdateUserData:[self.idectityDic objectForKey:@"Name"] identityCode:[self.idectityDic objectForKey:@"Id"] LXname:[dic objectForKey:@"Name"] lxId:[dic objectForKey:@"Id"]];
    NSString *shengID = [self.idectityDic objectForKey:@"Id"];
    NSString *lxId = [dic objectForKey:@"Id"];
    self.userNewData.shenfen = [self.idectityDic objectForKey:@"Name"];
    self.userNewData.IdentityCode = shengID.integerValue;
    self.userNewData.lx = [dic objectForKey:@"Name"];
    self.userNewData.LxCode = lxId.integerValue;
    
    UIViewController *viewCtl = self.navigationController.viewControllers[1];
    [self.navigationController popToViewController:viewCtl animated:YES];
}

@end
