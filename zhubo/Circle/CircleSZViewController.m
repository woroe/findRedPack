//
//  CircleSZViewController.m
//  zhubo
//
//  Created by Jin on 2017/7/15.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "CircleSZViewController.h"
#import "UpdateMyViewController.h"
#import "MyUpdataTableViewCell.h"

@interface CircleSZViewController ()<UITableViewDelegate,UITableViewDataSource,UpdateMyViewControllerDelegate>{

    NSDictionary *sheziDic;
}


@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)NSMutableArray *textFArr;

@property(nonatomic,strong)UITableView *tabView;

@end

@implementation CircleSZViewController

@synthesize  CircleDic;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"圈子设置";
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0f green:240/255.0f blue:242/255.0f alpha:1];
    
    _dataArr = [[NSMutableArray alloc] initWithObjects:@"修改头像",@"编辑名称",@"编辑简介",@"成员管理", nil];
    _textFArr = [NSMutableArray new];
    
    UITableView *tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 350)];
    [tabView registerNib:[UINib nibWithNibName:@"MyUpdataTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyUpdataTableViewCellID"];
    tabView.backgroundColor = [UIColor colorWithRed:239/255.0f green:240/255.0f blue:242/255.0f alpha:1];
    tabView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tabView.delegate = self;
    tabView.dataSource = self;
    tabView.scrollEnabled = NO;
    self.tabView = tabView;
    [self.view addSubview:self.tabView];
    
    [self loadData];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }else{
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MyUpdataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyUpdataTableViewCellID" forIndexPath:indexPath];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.nameLal.text = _dataArr[indexPath.row];
        if (indexPath.row == 0) {
            cell.valueLal.hidden = YES;
            cell.toxiangImage.hidden = NO;
            cell.toxiangImage.layer.cornerRadius = 20;
            [cell.toxiangImage.layer setMasksToBounds:YES];
            [cell.toxiangImage sd_setImageWithURL:[sheziDic objectForKey:@"HeadImg"]];
        }else{
            cell.toxiangImage.hidden = YES;
            cell.valueLal.hidden = NO;
            if (indexPath.row == 1) {
                cell.valueLal.text = [sheziDic objectForKey:@"Name"];
            }
            if (indexPath.row == 2) {
                cell.valueLal.text = [sheziDic objectForKey:@"Introduction"];
            }
            if (indexPath.row == 3) {
//                NSString *CircleUserCount = [sheziDic objectForKey:@"CircleUserCount"];
//                cell.valueLal.text = [NSString stringWithFormat:@"lb%",CircleUserCount.intValue];
                cell.valueLal.text = @"";
            }
        }
        
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }else {
            while ([cell.contentView.subviews lastObject] != nil){
                [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.textLabel.text = @"允许圈子被搜索到";
            
            NSString *ShowEmployerStr = [sheziDic objectForKey:@"IsSearch"];
            UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60, 15, 40, 20)];
            switchButton.tag = indexPath.row+1;
            if (ShowEmployerStr.intValue == 0) {
                [switchButton setOn:NO];
            }else{
                [switchButton setOn:YES];
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
            cell.textLabel.text = @"仅管理员可以发布信息";
            NSString *ShowEmployerStr = [sheziDic objectForKey:@"IsAdminSendMsg"];;
            UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60, 15, 40, 20)];
            switchButton.tag = indexPath.row+1;
            if (ShowEmployerStr.intValue == 0) {
                [switchButton setOn:NO];
            }else{
                [switchButton setOn:YES];
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
         return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            UpdateMyViewController *vc = [[UpdateMyViewController alloc]init];
            vc.CNameStr = @"Name";
            vc.UpdateLBStr = @"编辑圈子名称";
            vc.qz_myStr = @"2";
            vc.CircleIdStr = [CircleDic objectForKey:@"Id"];
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 2) {
            UpdateMyViewController *vc = [[UpdateMyViewController alloc]init];
            vc.CNameStr = @"Introduction";
            vc.UpdateLBStr = @"编辑圈子简介";
            vc.qz_myStr = @"2";
            vc.CircleIdStr = [CircleDic objectForKey:@"Id"];
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        CName = @"IsSearch";
    }
    if (switchButton.tag == 2) {
        CName = @"IsAdminSendMsg";
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"BuildSowingType"] = @"BuildSowing_EditCircle";
    params[@"CircleId"] = [CircleDic objectForKey:@"Id"];
    params[@"CName"] = CName;
    params[@"CValue"] = CValue;
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        ZBLog(@"BuildSowing_EditUserPrivacy--%@", res);
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            
            NSArray *dataArr = [res objectForKey:@"data"];
            if(!dataArr || dataArr.count == 0) {
                return ;
            }
            [SVProgressHUD showSuccessWithStatus:BaseStringSendSucc];
        }
        else{
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
    }];
}

-(void)UpdateVIew{
    [self loadData];
}
- (void)loadData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"BuildSowingType"] = @"GetCirleSetMsg";
    params[@"CircleId"] = [CircleDic objectForKey:@"Id"];
    
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            ZBLog(@"GetCirleSetMsg--%@", res);
            NSArray *dataArr = [res objectForKey:@"data"];
            if(!dataArr || dataArr.count == 0) {
                return ;
            }
            sheziDic = [NSDictionary new];
            sheziDic = dataArr[0];
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
