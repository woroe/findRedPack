//
//  MyUpdataViewController.m
//  zhubo
//
//  Created by Jin on 2017/7/13.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "MyUpdataViewController.h"

#import "MyUpdataTableViewCell.h"

#import "YKPhotoCutController.h"
#import "OSSImageUploader.h"
#import "UpdateMyViewController.h"

#import "UserNewData.h"
#import "IdentityViewController.h"
#import "LXViewController.h"
#import "FYLCityPickView.h"

@interface MyUpdataViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,YKCutPhotoDelegate,UpdateMyViewControllerDelegate,LXViewControllerDelegate>{
    
    YKPhotoCutController *cutVC;
    UIImagePickerController *_imagePickerController;
    BOOL IsReviewBool;
    
    NSString *strIndex;
    
    NSMutableDictionary *muUserDic;
    
    UserNewData*userData;
}

@property (strong, nonatomic) NSMutableArray *menuArr;
@property (strong, nonatomic) NSMutableArray *dataArr;

@property (strong, nonatomic) NSMutableArray *strArr;

@property (strong, nonatomic) UITableView *tabView;


@end

@implementation MyUpdataViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (userData != nil) {
        [self.tabView reloadData];
    }
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改资料";
    _menuArr = [NSMutableArray new];
    _strArr = [NSMutableArray new];
    muUserDic = [NSMutableDictionary new];
    userData = [UserNewData new];
    
    self.view.backgroundColor =  BaseColorhuise;
    UITableView *tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 480)];
    [tabView registerNib:[UINib nibWithNibName:@"MyUpdataTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyUpdataTableViewCellID"];
    tabView.delegate = self;
    tabView.dataSource = self;
    tabView.scrollEnabled = NO;
    self.tabView = tabView;
    [self.view addSubview:tabView];
    
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    NSArray *array1;
    array1 = @[@{@"title":@"头像"},@{@"title":@"性别"},@{@"title":@"地区"}];
    [self.menuArr addObject:array1];
    NSArray *array2 = @[@{@"title":@"昵称"}, @{@"title":@"姓名"},@{@"title":@"单位"}, @{@"title":@"职位",},@{@"title":@"身份 | 分类"}, @{@"title":@"职称"}];
    [self.menuArr addObject:array2];
    
    [self.tabView reloadData];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - 提交修改信息
-(void)rightItemAction{
    //UserId 用户ID  HeadImg 头像地址  Sex性别，  Province 省份 ， City 城市 ，RealName 姓名，NickName昵称，Employer单位，Position职位，IdentityCode身份代码 ，LxCode分类代码，Professional 职称  ?BuildSowingType=?BuildSowingType=BuildSowing_EditUser
    if (userData.HeadImg == nil || [userData.HeadImg isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请选择头像"];
        return;
    }
    if (userData.Sex == nil || [userData.Sex isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请选择性别"];
        return;
    }
    if ([userData.Province isEqualToString:@""] || [userData.City isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入地区"];
        return;
    }
//    if (userData.RealName == nil || [userData.RealName isEqualToString:@""]) {
//        [SVProgressHUD showErrorWithStatus:@"请输入真实姓名"];
//        return;
//    }
    if (userData.NickName == nil || [userData.NickName isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入昵称"];
        return;
    }
//    if (userData.Employer == nil || [userData.Employer isEqualToString:@""]) {
//        [SVProgressHUD showErrorWithStatus:@"请输入单位"];
//        return;
//    }
//    if (userData.Position == nil || [userData.Position isEqualToString:@""]) {
//        [SVProgressHUD showErrorWithStatus:@"请输入职位"];
//        return;
//    }
    if ([userData.shenfen isEqualToString:@""]||[userData.lx isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请选择身份分类"];
        return;
    }
//    if (userData.Professional == nil || [userData.Professional isEqualToString:@""]) {
//        [SVProgressHUD showErrorWithStatus:@"请输入职称"];
//        return;
//    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"BuildSowingType"] = @"BuildSowing_EditUser";
    params[@"UserId"] = @([BaseData shareInstance].userId);
    params[@"HeadImg"] = userData.HeadImg;
    if ([userData.Sex isEqualToString:@"男"]) {
        params[@"Sex"] = @(1);
    }else{
        params[@"Sex"] = @(0);
    }
    params[@"Province"] = userData.Province;
    params[@"City"] = userData.City;
    params[@"RealName"] = userData.RealName;
    params[@"NickName"] = userData.NickName;
    params[@"Employer"] = userData.Employer;
    params[@"Position"] = userData.Position;
    params[@"IdentityCode"] = @(userData.IdentityCode);
    params[@"LxCode"] = @(userData.LxCode);
    params[@"Professional"] = userData.Professional;
//    [SVProgressHUD show];
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        ZBLog(@"BuildSowing_EditUser--%@", res);
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            NSArray *dataArr = [res objectForKey:@"data"];
            if(!dataArr || dataArr.count == 0) {
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                [[BaseData shareInstance] setHeadImg:userData.HeadImg];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updata_User" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                NSDictionary *dic = dataArr[0];
                userData = [UserNewData mj_objectWithKeyValues:dic];
                NSLog(@"%@",userData);
                [self.tabView reloadData];
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
    
    return self.menuArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.menuArr[section];
    
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }
    else{
        return 15;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyUpdataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyUpdataTableViewCellID" forIndexPath:indexPath];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSArray *arr = self.menuArr[indexPath.section];
    cell.nameLal.text = [arr[indexPath.row] objectForKey:@"title"];
    if (indexPath.section == 0 ) {
        if (indexPath.row == 0) {
            cell.valueLal.hidden = YES;
            cell.toxiangImage.hidden = NO;
            cell.toxiangImage.layer.cornerRadius = 20;
            [cell.toxiangImage.layer setMasksToBounds:YES];
            [cell.toxiangImage sd_setImageWithURL:[NSURL URLWithString:userData.HeadImg]];
        }
        if (indexPath.row == 1) {
            cell.toxiangImage.hidden = YES;
            cell.valueLal.hidden = NO;
            cell.valueLal.text = userData.Sex;
        }
        if (indexPath.row == 2) {
            cell.toxiangImage.hidden = YES;
            cell.valueLal.hidden = NO;
            cell.valueLal.text = [NSString stringWithFormat:@"%@ %@",userData.Province,userData.City];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.toxiangImage.hidden = YES;
            cell.valueLal.hidden = NO;
            cell.valueLal.text = userData.NickName;
        }
        if (indexPath.row == 1) {
            cell.toxiangImage.hidden = YES;
            cell.valueLal.hidden = NO;
            cell.valueLal.text = userData.RealName;
        }
        if (indexPath.row == 2) {
            cell.toxiangImage.hidden = YES;
            cell.valueLal.hidden = NO;
            cell.valueLal.text = userData.Employer;
        }
        if (indexPath.row == 3) {
            cell.toxiangImage.hidden = YES;
            cell.valueLal.hidden = NO;
            cell.valueLal.text = userData.Position;
        }
        if (indexPath.row == 4) {
            cell.toxiangImage.hidden = YES;
            cell.valueLal.hidden = NO;
            if ([userData.shenfen isEqualToString:@""] && [userData.lx isEqualToString:@""]) {
                cell.valueLal.text = @"";
            }
            if (![userData.shenfen isEqualToString:@""] && [userData.lx isEqualToString:@""]) {
                cell.valueLal.text = [NSString stringWithFormat:@"%@",userData.shenfen];
            }
            if ([userData.shenfen isEqualToString:@""] && ![userData.lx isEqualToString:@""]) {
                cell.valueLal.text = [NSString stringWithFormat:@"%@",userData.lx];
            }
            if (![userData.shenfen isEqualToString:@""] && ![userData.lx isEqualToString:@""]) {
                cell.valueLal.text = [NSString stringWithFormat:@"%@ | %@",userData.shenfen,userData.lx];
            }
        }
        if (indexPath.row == 5) {
            cell.toxiangImage.hidden = YES;
            cell.valueLal.hidden = NO;
            cell.valueLal.text = userData.Professional;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) { // 头像
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *AAfx = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self selectImageFromCamera];
            }];
            [ac addAction:AAfx];
            UIAlertAction *AAsc = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self selectImageFromAlbum];
            }];
            [ac addAction:AAsc];
            UIAlertAction *AAsc1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [ac addAction:AAsc1];
            [self presentViewController:ac animated:YES completion:nil];
        }
        if (indexPath.row == 1) {// 性别
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *AAfx = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                userData.Sex = @"男";
                [self.tabView reloadData];
            }];
            [ac addAction:AAfx];
            UIAlertAction *AAsc = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                userData.Sex = @"女";
                [self.tabView reloadData];
            }];
            [ac addAction:AAsc];
            UIAlertAction *AAsc1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [ac addAction:AAsc1];
            [self presentViewController:ac animated:YES completion:nil];
        }
        if(indexPath.row ==2){
            [FYLCityPickView showPickViewWithDefaultProvince:@"重庆市" complete:^(NSArray *arr){
                NSLog(@"%@",arr);
                userData.Province = arr[1];
                userData.City = arr[2];
                [self.tabView reloadData];
            }];
        }
    }
    if (indexPath.section == 1){
        if (indexPath.row == 0) {
            _strArr = [[NSMutableArray alloc]initWithObjects:@(indexPath.section),@(indexPath.row), nil];
            UpdateMyViewController *vc = [[UpdateMyViewController alloc]init];
            vc.CNameStr = @"NickName";
            vc.CValueStr = userData.NickName;
            vc.UpdateLBStr = @"昵称";
            vc.qz_myStr = @"1";
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 1) {
            _strArr = [[NSMutableArray alloc]initWithObjects:@(indexPath.section),@(indexPath.row), nil];
            UpdateMyViewController *vc = [[UpdateMyViewController alloc]init];
            vc.CNameStr = @"Employer";
            vc.UpdateLBStr = @"姓名";
            vc.CValueStr = userData.RealName;
            vc.qz_myStr = @"1";
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 2) {
            _strArr = [[NSMutableArray alloc]initWithObjects:@(indexPath.section),@(indexPath.row), nil];
            UpdateMyViewController *vc = [[UpdateMyViewController alloc]init];
            vc.CNameStr = @"Position";
            vc.UpdateLBStr = @"单位";
            vc.CValueStr = userData.Employer;
            vc.qz_myStr = @"1";
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 3) {
            _strArr = [[NSMutableArray alloc]initWithObjects:@(indexPath.section),@(indexPath.row), nil];
            UpdateMyViewController *vc = [[UpdateMyViewController alloc]init];
            vc.CNameStr = @"Professional";
            vc.UpdateLBStr = @"职位";
            vc.CValueStr = userData.Position;
            vc.qz_myStr = @"1";
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 4) {
            _strArr = [[NSMutableArray alloc]initWithObjects:@(indexPath.section),@(indexPath.row), nil];
            LXViewController *lx = [[LXViewController alloc] init];
            lx.delegate = self;
            
            IdentityViewController *vc = [[IdentityViewController alloc]init];
            vc.userNewData = userData;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 5) {
            _strArr = [[NSMutableArray alloc]initWithObjects:@(indexPath.section),@(indexPath.row), nil];
            UpdateMyViewController *vc = [[UpdateMyViewController alloc]init];
            vc.CNameStr = @"Professional";
            vc.UpdateLBStr = @"职称";
            vc.CValueStr = userData.Professional;
            vc.qz_myStr = @"1";
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
#pragma mark 修改性别
-(void)updateXBAction:(NSString *)BuildSowingType CName:(NSString *)CName CValue:(NSString *)CValue{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = @([BaseData shareInstance].userId);
    params[@"BuildSowingType"] = BuildSowingType;
    params[@"CName"] = CName;
    params[@"CValue"] = CValue;
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        ZBLog(@"BuildSowing_EditUserPrivacy--%@", res);
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            [self loadData];
        }
        else{
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
    }];
}

#pragma mark -- UpdateMyViewControllerDelegate
-(void)UpdateVIew:(NSString *)str{
    strIndex = str;
    NSString *strSection = _strArr[0];
    NSString *strRow = _strArr[1];
    if (strSection.intValue == 0 && strRow.intValue ==2) {
        NSArray *arr0 = [str componentsSeparatedByString:@" "];
        if ([arr0 count]>1) {
            userData.Province = arr0[0];
            userData.City = arr0[1];
        }
    }
    if (strSection.intValue == 1 && strRow.intValue ==0) {
        userData.NickName = str;
    }
    if (strSection.intValue == 1 && strRow.intValue ==1) {
        userData.RealName = str;
    }
    if (strSection.intValue == 1 && strRow.intValue ==2) {
        userData.Employer = str;
    }
    if (strSection.intValue == 1 && strRow.intValue ==3) {
        userData.Position = str;
    }
    if (strSection.intValue == 1 && strRow.intValue ==5) {
        userData.Professional = str;
    }
    [self.tabView reloadData];
}
#pragma mark -- LXViewControllerDelegate
- (void)UpdateUserData:(NSString *)identityCodeStr identityCode:(NSString *)code LXname:(NSString *)name lxId:(NSString *)lxId{
    userData.shenfen = identityCodeStr;
    userData.IdentityCode = code.integerValue;
    userData.lx = name;
    userData.LxCode = lxId.integerValue;
    [self.tabView reloadData];
}
#pragma mark 从摄像头获取图片或视频
- (void)selectImageFromCamera
{
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    _imagePickerController.videoMaximumDuration = 15;
    _imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
    _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    
    //设置摄像头模式（拍照，录制视频）为录像模式
    _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}
#pragma mark 从相册获取图片或视频
- (void)selectImageFromAlbum
{
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    NSLog(@"选择完毕----image:%@-----info:%@",image,editingInfo);
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSArray *imageArray = [[NSArray alloc]initWithObjects:image, nil];
    cutVC = [[YKPhotoCutController alloc] init];
    cutVC.photoArr = imageArray;
    cutVC.delegate = self;
    [self.navigationController pushViewController:cutVC animated:NO];
}
#pragma mark -- 截取图片的回调方法
- (void)getBackCutPhotos:(NSArray *)photosArr
{
    NSLog(@"++++++++++%@",photosArr);
    [OSSImageUploader asyncUploadImages:photosArr complete:^(NSArray<NSString *> *names, UploadImageState state) {
        [self loadData];
        NSMutableString *mtStr = [NSMutableString new];
        for (NSString *str in names) {
            NSString *str111= [NSString stringWithFormat:@"http://zhuboapp.oss-cn-shanghai.aliyuncs.com/%@",str];
            if (mtStr.length == 0) {
                mtStr = [NSMutableString stringWithFormat:@"%@",str111];
            }else{
                mtStr = [NSMutableString stringWithFormat:@"%@@%@",mtStr,str111];
            }
        }
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"UserId"] = @([BaseData shareInstance].userId);
        params[@"BuildSowingType"] = @"BuildSowing_EditUserPrivacy";
        params[@"CName"] = @"HeadImg";
        params[@"CValue"] = mtStr;
        
        [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *res = (NSDictionary *)responseObject;
            ZBLog(@"BuildSowing_GetUserMsg--%@", res);
            if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
                [self loadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updata_User" object:nil];
            }
            else{
                [SVProgressHUD showErrorWithStatus:BaseStringNetError];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }];
    }];
}

- (void)loadData {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = @([BaseData shareInstance].userId);
    params[@"BuildSowingType"] = @"BuildSowing_GetUserMsg";
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        ZBLog(@"BuildSowing_GetUserMsg--%@", res);
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            
            NSArray *dataArr = [res objectForKey:@"data"];
            if(!dataArr || dataArr.count == 0) {
                return ;
            }else{
                NSDictionary *dic = dataArr[0];
                userData = [UserNewData mj_objectWithKeyValues:dic];
                NSLog(@"%@",userData);
                [self.tabView reloadData];
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
