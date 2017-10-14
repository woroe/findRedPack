//
//  MySMSZViewController.m
//  zhubo
//
//  Created by Jin on 2017/7/13.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "MySMSZViewController.h"
#import "OSSImageUploader.h"

@interface MySMSZViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    UIImagePickerController *_imagePickerController;
    UIView *view;
    UIImage *zmImage;
    UIImage *fmImage;
    
    NSDictionary *userXXDic;
}


@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)NSMutableArray *textFArr;

@property(nonatomic,strong)UITableView *tabView;

@end

@implementation MySMSZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"实名认证";
    self.view.backgroundColor = BaseColorhuise;
    
    _dataArr = [[NSMutableArray alloc] initWithObjects:@"职业身份",@"真实姓名",@"单位",@"职位",@"职称", nil];
    _textFArr = [NSMutableArray new];
    userXXDic = [NSDictionary new];
    
    UITableView *tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250)];
    tabView.backgroundColor = [UIColor colorWithRed:239/255.0f green:240/255.0f blue:242/255.0f alpha:1];
    tabView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tabView.delegate = self;
    tabView.dataSource = self;
    tabView.scrollEnabled = NO;
    self.tabView = tabView;
    [self.view addSubview:self.tabView];
    
    view = [[[NSBundle mainBundle] loadNibNamed:@"SMRZView" owner:nil options:nil] lastObject];
    view.frame = CGRectMake(0, 250, self.view.frame.size.width, self.view.frame.size.height-250);
    UIButton *zmBut =[view viewWithTag:12];
    [zmBut addTarget:self action:@selector(paizhao:) forControlEvents:UIControlEventTouchDown];
    UIButton *fmBut =[view viewWithTag:13];
    [fmBut addTarget:self action:@selector(paizhao:) forControlEvents:UIControlEventTouchDown];
    UILabel *lal =[view viewWithTag:14];
    lal.numberOfLines = 0;
    
    UIButton *tjBut = [view viewWithTag:100];
    [tjBut addTarget:self action:@selector(tjAction) forControlEvents:UIControlEventTouchDown];
    
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
    
    [self loadData];
    [self.view addSubview:view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- 确认认证
-(void)xgTJAction{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"确认认证" message:@"您已经认证过，是否提交修改？" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *AAfx = [UIAlertAction actionWithTitle:@"提交" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self requestAction:YES];
    }];
    [ac addAction:AAfx];
    UIAlertAction *AAsc = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [ac addAction:AAsc];
    [self presentViewController:ac animated:YES completion:nil];
}
#pragma mark -- 提交实名认证
-(void)tjAction{
    
    if (userXXDic != nil) {
        [self xgTJAction];
        return;
    }
    BOOL b = [self YZXXZAtion];
    if (!b) {
        return;
    }
    [self requestAction:NO];
}
-(void)requestAction:(BOOL)updataAndInset{ //no 表示添加 yes 表示修改
    if (updataAndInset) {
        NSString *IdCardImgStr = [userXXDic objectForKey:@"IdCardImg"];
        if (zmImage == nil && fmImage == nil) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"UserId"] = @([BaseData shareInstance].userId);
            params[@"BuildSowingType"] = @"BuildSowing_UserAduit";
            UITextField *zysfTf = _textFArr[0];
            params[@"ProfessionalIdentity"] = zysfTf.text;
            UITextField *zsxmTf = _textFArr[1];
            params[@"RealName"] = zsxmTf.text;
            UITextField *dwTf = _textFArr[2];
            params[@"RealEmployer"] = dwTf.text;
            UITextField *zyTf = _textFArr[3];
            params[@"RealPosition"] = zyTf.text;
            UITextField *zcTf = _textFArr[4];
            params[@"RealProfessional"] = zcTf.text;
            params[@"IdCardImg"] = IdCardImgStr;
            
            [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *res = (NSDictionary *)responseObject;
                ZBLog(@"BuildSowing_UserAduit--%@", res);
                if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
                    [SVProgressHUD showSuccessWithStatus:@"认证成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else{
                    [SVProgressHUD showErrorWithStatus:BaseStringNetError];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [SVProgressHUD showErrorWithStatus:BaseStringNetError];
            }];
        }else{
            if (zmImage != nil && fmImage == nil) {
                NSArray *photosArr = [[NSArray alloc]initWithObjects:zmImage, nil];
                [OSSImageUploader asyncUploadImages:photosArr complete:^(NSArray<NSString *> *names, UploadImageState state) {
                    NSString *IdCardImgStr = [userXXDic objectForKey:@"IdCardImg"];
                    NSArray *arr0 = [IdCardImgStr componentsSeparatedByString:@"&"];
                    NSMutableString *mtStr = [NSMutableString new];
                    NSString *str111= [NSString stringWithFormat:@"http://zhuboapp.oss-cn-shanghai.aliyuncs.com/%@",names[0]];
                     mtStr = [NSMutableString stringWithFormat:@"%@&%@",arr0[0],str111];
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    params[@"UserId"] = @([BaseData shareInstance].userId);
                    params[@"BuildSowingType"] = @"BuildSowing_UserAduit";
                    UITextField *zysfTf = _textFArr[0];
                    params[@"ProfessionalIdentity"] = zysfTf.text;
                    UITextField *zsxmTf = _textFArr[1];
                    params[@"RealName"] = zsxmTf.text;
                    UITextField *dwTf = _textFArr[2];
                    params[@"RealEmployer"] = dwTf.text;
                    UITextField *zyTf = _textFArr[3];
                    params[@"RealPosition"] = zyTf.text;
                    UITextField *zcTf = _textFArr[4];
                    params[@"RealProfessional"] = zcTf.text;
                    params[@"IdCardImg"] = mtStr;
                    
                    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                        
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSDictionary *res = (NSDictionary *)responseObject;
                        ZBLog(@"BuildSowing_UserAduit--%@", res);
                        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
                            [SVProgressHUD showSuccessWithStatus:@"认证成功"];
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        else{
                            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
                    }];
                }];
            }else{
                NSArray *photosArr = [[NSArray alloc]initWithObjects:zmImage, nil];
                [OSSImageUploader asyncUploadImages:photosArr complete:^(NSArray<NSString *> *names, UploadImageState state) {
                    NSString *IdCardImgStr = [userXXDic objectForKey:@"IdCardImg"];
                    NSArray *arr0 = [IdCardImgStr componentsSeparatedByString:@"&"];
                    NSMutableString *mtStr = [NSMutableString new];
                    NSString *str111= [NSString stringWithFormat:@"http://zhuboapp.oss-cn-shanghai.aliyuncs.com/%@",names[0]];
                    mtStr = [NSMutableString stringWithFormat:@"%@&%@",str111,arr0[0]];
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    params[@"UserId"] = @([BaseData shareInstance].userId);
                    params[@"BuildSowingType"] = @"BuildSowing_UserAduit";
                    UITextField *zysfTf = _textFArr[0];
                    params[@"ProfessionalIdentity"] = zysfTf.text;
                    UITextField *zsxmTf = _textFArr[1];
                    params[@"RealName"] = zsxmTf.text;
                    UITextField *dwTf = _textFArr[2];
                    params[@"RealEmployer"] = dwTf.text;
                    UITextField *zyTf = _textFArr[3];
                    params[@"RealPosition"] = zyTf.text;
                    UITextField *zcTf = _textFArr[4];
                    params[@"RealProfessional"] = zcTf.text;
                    params[@"IdCardImg"] = mtStr;
                    
                    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                        
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSDictionary *res = (NSDictionary *)responseObject;
                        ZBLog(@"BuildSowing_UserAduit--%@", res);
                        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
                            [SVProgressHUD showSuccessWithStatus:@"认证成功"];
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        else{
                            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
                    }];
                }];
            }
        }
        
    }else{
        NSArray *photosArr = [[NSArray alloc]initWithObjects:zmImage,fmImage, nil];
        [OSSImageUploader asyncUploadImages:photosArr complete:^(NSArray<NSString *> *names, UploadImageState state) {
            
            NSMutableString *mtStr = [NSMutableString new];
            for (NSString *str in names) {
                NSString *str111= [NSString stringWithFormat:@"http://zhuboapp.oss-cn-shanghai.aliyuncs.com/%@",str];
                if (mtStr.length == 0) {
                    mtStr = [NSMutableString stringWithFormat:@"%@",str111];
                }else{
                    mtStr = [NSMutableString stringWithFormat:@"%@&%@",mtStr,str111];
                }
            }
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"UserId"] = @([BaseData shareInstance].userId);
            params[@"BuildSowingType"] = @"BuildSowing_UserAduit";
            UITextField *zysfTf = _textFArr[0];
            params[@"ProfessionalIdentity"] = zysfTf.text;
            UITextField *zsxmTf = _textFArr[1];
            params[@"RealName"] = zsxmTf.text;
            UITextField *dwTf = _textFArr[2];
            params[@"RealEmployer"] = dwTf.text;
            UITextField *zyTf = _textFArr[3];
            params[@"RealPosition"] = zyTf.text;
            UITextField *zcTf = _textFArr[4];
            params[@"RealProfessional"] = zcTf.text;
            params[@"IdCardImg"] = mtStr;
            
            [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *res = (NSDictionary *)responseObject;
                ZBLog(@"BuildSowing_UserAduit--%@", res);
                if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
                    [SVProgressHUD showSuccessWithStatus:@"认证成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else{
                    [SVProgressHUD showErrorWithStatus:BaseStringNetError];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [SVProgressHUD showErrorWithStatus:BaseStringNetError];
            }];
        }];
    }
}
-(BOOL)YZXXZAtion{
    for (int i =0; i<_textFArr.count; i++) {
        UITextField *tf = _textFArr[i];
        if (i == 0) {
            if ([tf.text isEqualToString:@""]) {
                [SVProgressHUD showErrorWithStatus:@"请输入职业身份"];
                return NO;
            }
        }
        if (i == 1) {
            if ([tf.text isEqualToString:@""]) {
                [SVProgressHUD showErrorWithStatus:@"请输入真实姓名"];
                return NO;
            }
        }
        if (i == 2) {
            if ([tf.text isEqualToString:@""]) {
                [SVProgressHUD showErrorWithStatus:@"请输入单位"];
                return NO;
            }
        }
        if (i == 3) {
            if ([tf.text isEqualToString:@""]) {
                [SVProgressHUD showErrorWithStatus:@"请输入职业"];
                return NO;
            }
        }
        if (i == 4) {
            if ([tf.text isEqualToString:@""]) {
                [SVProgressHUD showErrorWithStatus:@"请输入职称"];
                return NO;
            }
        }
    }
    if (zmImage == nil) {
        [SVProgressHUD showErrorWithStatus:@"请拍摄身份证正面照"];
        return NO;
    }
    if (fmImage == nil) {
        [SVProgressHUD showErrorWithStatus:@"请拍摄身份证反面照"];
        return NO;
    }
    return YES;
}
-(void)paizhao:(UIButton *)sender{
    sender.selected = YES;
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    //录制视频时长，默认10s
    _imagePickerController.videoMaximumDuration = 15;
    //相机类型（拍照、录像...）字符串需要做相应的类型转换
    _imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
    _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    
    //设置摄像头模式（拍照，录制视频）为录像模式
    _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    [self dismissViewControllerAnimated:YES completion:nil];
    UIButton *zmBut =[view viewWithTag:12];
    UIButton *fmBut =[view viewWithTag:13];
    if (zmBut.selected) {
        zmBut.selected = NO;
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = zmBut.frame;
        imageView.image = image;
        zmImage = image;
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zmAction)];
        [imageView addGestureRecognizer:tapGesturRecognizer];
        
        [view addSubview:imageView];
    }
    if (fmBut.selected) {
        fmBut.selected = NO;
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = fmBut.frame;
        imageView.image = image;
        fmImage = image;
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fmAction)];
        [imageView addGestureRecognizer:tapGesturRecognizer];
        
        [view addSubview:imageView];
    }
}
-(void)zmAction{
    UIButton *zmBut =[view viewWithTag:12];
    [self paizhao:zmBut];
}-(void)fmAction{
    UIButton *fmBut =[view viewWithTag:13];
    [self paizhao:fmBut];
}

-(UITextField *)creatTextField:(NSString *)indexPathRow{
    
    UITextField *textF = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width-150-30, 5, 150, 40)];
    textF.textAlignment = NSTextAlignmentRight;
    textF.placeholder = @"请输入";
    textF.delegate = self;
    textF.tag = indexPathRow.intValue+1;
    textF.returnKeyType =UIReturnKeyDone;
    textF.font = [UIFont systemFontOfSize:15];
    return textF;
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 当点击键盘的返回键（右下角）时，执行该方法。
    // 一般用来隐藏键盘
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - 回填数据
- (void)loadData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = @([BaseData shareInstance].userId);
    params[@"BuildSowingType"] = @"BuildSowing_GetUserAduit";
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        ZBLog(@"BuildSowing_GetUserMsg--%@", res);
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            NSArray *dataArr = [res objectForKey:@"data"];
            if ([dataArr count] != 0) {
                userXXDic =  dataArr[0];
                [self.tabView reloadData];
                NSString *IdCardImgStr = [userXXDic objectForKey:@"IdCardImg"];
                NSArray *arr0 = [IdCardImgStr componentsSeparatedByString:@"&"];
                UIButton *zmBut =[view viewWithTag:12];
                UIButton *fmBut =[view viewWithTag:13];
                UIImageView *imageView = [[UIImageView alloc]init];
                imageView.frame = zmBut.frame;
                [imageView sd_setImageWithURL:[NSURL URLWithString:arr0[0]]];
                imageView.tag = 100;
                UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zmAction)];
                [imageView addGestureRecognizer:tapGesturRecognizer];
                
                UIImageView *imageView1 = [[UIImageView alloc]init];
                imageView1.frame = fmBut.frame;
                [imageView1 sd_setImageWithURL:[NSURL URLWithString:arr0[1]]];
                imageView1.tag = 101;
                UITapGestureRecognizer *tapGesturRecognizer1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fmAction)];
                [imageView1 addGestureRecognizer:tapGesturRecognizer1];
                
                [view addSubview:imageView];
                [view addSubview:imageView1];
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
      return 5;
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
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _dataArr[indexPath.row];
    if ([_textFArr count]==5) {
        UITextField*textF = _textFArr[indexPath.row];
        if (indexPath.row == 0) {
            textF.text = [userXXDic objectForKey:@"ProfessionalIdentity"];
        }
        if (indexPath.row == 1) {
            textF.text = [userXXDic objectForKey:@"RealName"];
        }
        if (indexPath.row == 2) {
            textF.text = [userXXDic objectForKey:@"RealEmployer"];
        }
        if (indexPath.row == 3) {
            textF.text = [userXXDic objectForKey:@"RealPosition"];
        }
        if (indexPath.row == 4) {
            textF.text = [userXXDic objectForKey:@"RealProfessional"];
        }
    }else{
        UITextField *textF = [self creatTextField:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        if (indexPath.row == 0) {
            textF.text = [userXXDic objectForKey:@"ProfessionalIdentity"];
        }
        if (indexPath.row == 1) {
            textF.text = [userXXDic objectForKey:@"RealName"];
        }
        if (indexPath.row == 2) {
            textF.text = [userXXDic objectForKey:@"RealEmployer"];
        }
        if (indexPath.row == 3) {
            textF.text = [userXXDic objectForKey:@"RealPosition"];
        }
        if (indexPath.row == 4) {
            textF.text = [userXXDic objectForKey:@"RealProfessional"];
        }
        [_textFArr addObject:textF];
        [cell addSubview:textF];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
