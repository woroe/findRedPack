//
//  MyYSsheziViewController.m
//  zhubo
//
//  Created by Jin on 2017/7/13.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "MyYSsheziViewController.h"



@interface MyYSsheziViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    NSMutableArray *muArr;
}

@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)NSMutableArray *textFArr;

@property(nonatomic,strong)UITableView *tabView;

@end

@implementation MyYSsheziViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"隐私设置";
    self.view.backgroundColor = BaseColorhuise;
    muArr = [NSMutableArray new];
    
    _dataArr = [[NSMutableArray alloc] initWithObjects:@"显示真实姓名",@"显示单位名称",@"显示职位", nil];
    _textFArr = [NSMutableArray new];
    
    UITableView *tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    tabView.backgroundColor = [UIColor colorWithRed:239/255.0f green:240/255.0f blue:242/255.0f alpha:1];
    tabView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tabView.delegate = self;
    tabView.dataSource = self;
    tabView.scrollEnabled = NO;
    self.tabView = tabView;
    [self.view addSubview:self.tabView];
    
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = @([BaseData shareInstance].userId);
    params[@"BuildSowingType"] = @"BuildSowing_GetUserPrivacy";
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        ZBLog(@"BuildSowing_GetUserPrivacy--%@", res);
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            
            NSArray *dataArr = [res objectForKey:@"data"];
            if(!dataArr || dataArr.count == 0) {
                return ;
            }
            for (NSDictionary *dic in dataArr) {
                [muArr addObject:dic];
            }
            [self.tabView reloadData];
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
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }else {
        while ([cell.contentView.subviews lastObject] != nil){
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _dataArr[indexPath.row];
    
    if ([muArr count] != 0) {
        NSDictionary *dic = muArr[0];
        if (indexPath.row == 0) {
            NSString *ShowEmployerStr = [dic objectForKey:@"ShowRealName"];
            UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60, 15, 40, 20)];
            switchButton.tag = indexPath.row+1;
            if (ShowEmployerStr.intValue == 1) {
                [switchButton setOn:YES];
            }else{
                [switchButton setOn:NO];
            }
            switchButton.onTintColor = BaseColorPurple;
            switchButton.tintColor = BaseColorGray;//边缘
            switchButton.backgroundColor = BaseColorGray;
            switchButton.layer.cornerRadius = switchButton.bounds.size.height/2.0;
            switchButton.layer.masksToBounds = true;
            switchButton.thumbTintColor = [UIColor whiteColor];
            [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:switchButton];
        }
        if (indexPath.row == 1) {
            NSString *ShowEmployerStr = [dic objectForKey:@"ShowEmployer"];
            UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60, 15, 40, 20)];
            switchButton.tag = indexPath.row+1;
            if (ShowEmployerStr.intValue == 1) {
                [switchButton setOn:YES];
            }else{
                [switchButton setOn:NO];
            }
            switchButton.onTintColor = BaseColorPurple;
            switchButton.tintColor = BaseColorGray;//边缘
            switchButton.backgroundColor = BaseColorGray;
            switchButton.layer.cornerRadius = switchButton.bounds.size.height/2.0;
            switchButton.layer.masksToBounds = true;
            switchButton.thumbTintColor = [UIColor whiteColor];
            [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:switchButton];
        }if (indexPath.row == 2) {
            NSString *ShowEmployerStr = [dic objectForKey:@"ShowPosition"];
            UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60, 15, 40, 20)];
            switchButton.tag = indexPath.row+1;
            if (ShowEmployerStr.intValue == 1) {
                [switchButton setOn:YES];
            }else{
                [switchButton setOn:NO];
            }
            switchButton.onTintColor = BaseColorPurple;
            switchButton.tintColor = BaseColorGray;//边缘
            switchButton.backgroundColor = BaseColorGray;
            switchButton.layer.cornerRadius = switchButton.bounds.size.height/2.0;
            switchButton.layer.masksToBounds = true;
            switchButton.thumbTintColor = [UIColor whiteColor];
            [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:switchButton];
        }if (indexPath.row == 3) {
            NSString *ShowEmployerStr = [dic objectForKey:@"ShowProfessional"];
            UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60, 15, 40, 20)];
            switchButton.tag = indexPath.row+1;
            if (ShowEmployerStr.intValue == 1) {
                [switchButton setOn:YES];
            }else{
                [switchButton setOn:NO];
            }
            switchButton.onTintColor = BaseColorPurple;
            switchButton.tintColor = BaseColorGray;//边缘
            switchButton.backgroundColor = BaseColorGray;
            switchButton.layer.cornerRadius = switchButton.bounds.size.height/2.0;
            switchButton.layer.masksToBounds = true;
            switchButton.thumbTintColor = [UIColor whiteColor];
            [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:switchButton];
        }if (indexPath.row == 4) {
            NSString *ShowEmployerStr = [dic objectForKey:@"ShowProfessionalIdentity"];
            UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60, 15, 40, 20)];
            switchButton.tag = indexPath.row+1;
            if (ShowEmployerStr.intValue == 1) {
                [switchButton setOn:YES];
            }else{
                [switchButton setOn:NO];
            }
            switchButton.onTintColor = BaseColorPurple;
            switchButton.tintColor = BaseColorGray;//边缘
            switchButton.backgroundColor = BaseColorGray;
            switchButton.layer.cornerRadius = switchButton.bounds.size.height/2.0;
            switchButton.layer.masksToBounds = true;
            switchButton.thumbTintColor = [UIColor whiteColor];
            [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:switchButton];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)switchAction:(id)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    NSString *CValue;
    NSString *CName;
    if (isButtonOn) {
        CValue = @"1";
    }else {
        CValue = @"0";
    }
    if (switchButton.tag == 1) {
        CName = @"ShowRealName";
    }
    if (switchButton.tag == 2) {
        CName = @"ShowEmployer";
    }
    if (switchButton.tag == 3) {
        CName = @"ShowPosition";
    }
    if (switchButton.tag == 4) {
        CName = @"ShowProfessional";
    }
    if (switchButton.tag == 5) {
        CName = @"ShowProfessionalIdentity";
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = @([BaseData shareInstance].userId);
    params[@"BuildSowingType"] = @"BuildSowing_EditUserPrivacy";
    params[@"CName"] = CName;
    params[@"CValue"] = CValue;
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        ZBLog(@"BuildSowing_EditUserPrivacy--%@", res);
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updata_User" object:nil];
            NSArray *dataArr = [res objectForKey:@"data"];
            if(!dataArr || dataArr.count == 0) {
                return ;
            }
            for (NSDictionary *dic in dataArr) {
                [muArr addObject:dic];
            }
            [self.tabView reloadData];
        }
        else{
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
    }];
}

@end
