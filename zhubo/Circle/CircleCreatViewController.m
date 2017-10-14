//
//  CircleCreatViewController.m
//  zhubo
//
//  Created by Jin on 2017/6/19.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "CircleCreatViewController.h"

#import "CircleToXiangViewController.h"

#import "OSSImageUploader.h"
#import "YKPhotoCutController.h"

@interface CircleCreatViewController ()<YKCutPhotoDelegate,CircleToXiangViewControllerDelegate>{
    
    
    BOOL sfBool;
    YKPhotoCutController *cutVC;
    CircleToXiangViewController *entranceVC;
    UIView *headerView;
}

@property (nonatomic, strong)NSArray *txImageArr;

@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)NSMutableArray *dataleiBArr;
@property (nonatomic, strong)NSMutableArray *qzlbButArr;

@property (nonatomic, strong) UIButton *sfBut;
@property (nonatomic, strong) UIButton *mfBut;

@property (nonatomic, strong) UITextField *circleNameTF;
@property (nonatomic, strong) UITextField *sfTF;
@property (nonatomic, strong) UITextView *circleneirTV;

@property (nonatomic, strong) UITableView *tabView;

@end

@implementation CircleCreatViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建圈子";
    
    sfBool = NO;
    _dataleiBArr = [NSMutableArray new];
    _qzlbButArr = [NSMutableArray new];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemAction)];
    self.navigationItem.rightBarButtonItem = rightItem;

    [self.navigationItem.rightBarButtonItem setTintColor:BaseColorYellow];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(leftItemAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    _dataArr = [[NSMutableArray alloc] initWithObjects:@"免费",@"收费",@"50-100",@"项目资源",@"行业交流",@"材料设备",@"学习培训",@"资质职称",@"专家大咖",@"法律咨询",@"金融保险",@"社交职场",@"商务服务",@"兴趣爱好",@"话题闲聊",@"公益",@"地区",@"学校",@"协会",@"政务",@"其他",@"圈子名称",@"圈子简介(选填)", nil];
    
    headerView = [[[NSBundle mainBundle] loadNibNamed:@"CircleCreatHaederView" owner:nil options:nil] lastObject];
    
    UITableView *tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    tabView.backgroundColor = [UIColor colorWithRed:239/255.0f green:240/255.0f blue:242/255.0f alpha:1];
    tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabView.delegate = self;
    tabView.dataSource = self;
    self.tabView = tabView;
    [self.view addSubview:tabView];
    
    [self loadData];
}
#pragma mark - 圈子提交
-(void)rightItemAction{
    
    if (_qzlbButArr.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择圈子类别"];
        return;
    }
    
    NSString *mingchenStr = _circleNameTF.text;
    if ([mingchenStr isEqualToString:@""]||[mingchenStr isEqualToString:@" "]) {
        [SVProgressHUD showErrorWithStatus:@"请输入圈子名称"];
        return;
    }
    if (_txImageArr.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择头像"];
        return;
    }
    [OSSImageUploader asyncUploadImages:_txImageArr complete:^(NSArray<NSString *> *names, UploadImageState state) {
        
        NSMutableString *mtStr = [NSMutableString new];
        for (NSString *str in names) {
            NSString *str111= [NSString stringWithFormat:@"http://zhuboapp.oss-cn-shanghai.aliyuncs.com/%@",str];
            if (mtStr.length == 0) {
                mtStr = [NSMutableString stringWithFormat:@"%@",str111];
            }else{
                mtStr = [NSMutableString stringWithFormat:@"%@@%@",mtStr,str111];
            }
        }
        NSLog(@"names---%@", names);
        
        NSString *IsPay;
        NSString *Price;
        if (!sfBool) {
            IsPay = @"0";
            Price = @"0.00";
        }else{
            IsPay = @"1";
            Price = _sfTF.text;
        }
        
        NSString *lerStr = _circleneirTV.text;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"BuildSowingType"] = @"BuildSowing_CreateCircle";
        params[@"Name"] = _circleNameTF.text;
        params[@"CircleType"] = _qzlbButArr[0];
        params[@"HeadImg"] = mtStr;//头像
        params[@"IsPay"] = IsPay; // 0 不收费
        params[@"Price"] = Price;
        params[@"Introduction"] = lerStr;
        params[@"UserId"] = @([BaseData shareInstance].userId);
        
        [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *res = (NSDictionary *)responseObject;
            ZBLog(@"BuildSowing_CreateCircle--%@", res);
            if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
                
                [SVProgressHUD showSuccessWithStatus:@""];
                [self.delegate CircleOKRead];
                [self.navigationController popViewControllerAnimated:NO];
            }
            else{
                [SVProgressHUD showErrorWithStatus:BaseStringNetError];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }];
    }];
}

-(void)leftItemAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0;
    }
    if (section == 1) {
        return 1;
    }
    if (section == 2) {
        if (_dataleiBArr.count%3>0 && _dataleiBArr.count/3 >0) {
            return _dataleiBArr.count/3+1;
        }else{
            return 1;
        }
        return _dataleiBArr.count/3;
    }
    if (section == 3) {
        return 2;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 150;
    }else if (section == 1){
        return 50;
    }else if (section == 2){
        return 50;
    }else{
        return 50;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        headerView.backgroundColor = [UIColor colorWithRed:239/255.0f green:240/255.0f blue:242/255.0f alpha:1];
        UIButton *but = [headerView viewWithTag:10];
        but.backgroundColor = [UIColor colorWithRed:161/255.0f green:166/255.9f blue:187/255.0f alpha:1];
        [but addTarget:self action:@selector(toxiangAction) forControlEvents:UIControlEventTouchDown];
        [but.layer setMasksToBounds:YES];
        [but.layer setCornerRadius:35];
        return headerView;
    }
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 50)];
    
    UILabel *headerLal = [[UILabel alloc]initWithFrame:customView.frame];
    headerLal.opaque = NO;
    headerLal.textColor = [UIColor colorWithRed:161/255.0f green:166/255.0f blue:187/255.0f alpha:1];
    headerLal.font = [UIFont boldSystemFontOfSize:15];
    if (section == 1) {
        headerLal.text = @"选择属性";
    }
    if (section == 2) {
        headerLal.text = @"选择圈子所属类别";
    }
    if (section == 3) {
        headerLal.text = @"输入圈子资料";
    }
    [customView addSubview:headerLal];
    return customView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        if (indexPath.row == 1) {
            return 170.0f;
        }
    }
    return 50.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPat{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }else {
        while ([cell.contentView.subviews lastObject] != nil){
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    cell.backgroundColor = [UIColor colorWithRed:239/255.0f green:240/255.0f blue:242/255.0f alpha:1];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef butcolorref1 = CGColorCreate(colorSpace,(CGFloat[]){ 161/255.0f, 166/255.0f, 187/255.0f, 1 });
    
    if (indexPat.section == 1) {
        if (_dataleiBArr.count >0){
            for(int i = 0; i<3; i++){
                if (i%3 == 0) {
                    _sfBut = [cell viewWithTag:10000];
                    if (_sfBut == nil) {
                        NSString *titleStr = [_dataArr objectAtIndex:i];
                        _sfBut = [self creatBut:titleStr tag:10000 titleColor:[UIColor blackColor] butFrameW:15.f];
                        [cell addSubview:_sfBut];
                    }
                }
                if (i%3 == 1) {
                    _mfBut = [cell viewWithTag:10001];
                    if (_mfBut == nil) {
                        NSString *titleStr = [_dataArr objectAtIndex:i];
                        _mfBut = [self creatBut:titleStr tag:10001 titleColor:[UIColor blackColor] butFrameW:137.f];
                        [cell addSubview:_mfBut];
                    }
                }
                if (i%3 == 2) { // 收费金额
                    UITextField *tf = [cell viewWithTag:10003];
                    if (tf == nil) {
                        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                        CGColorRef butcolorref = CGColorCreate(colorSpace,(CGFloat[]){ 255.0f/255.0f, 174.0f/255.0f, 0/255.0f, 1 });
                        _sfTF = [[UITextField alloc]initWithFrame:CGRectMake(259, 10, 90, 30)];
                        _sfTF.tag = 10003;
                        _sfTF.delegate = self;
                        _sfTF.borderStyle = UITextBorderStyleNone;
                        [_sfTF.layer setBorderWidth:1.0];
                        [_sfTF.layer setBorderColor:butcolorref];
                        _sfTF.backgroundColor = [UIColor colorWithRed:239/255.0f green:240/255.0f blue:242/255.0f alpha:1];
                        _sfTF.placeholder = [_dataArr objectAtIndex:i];
                        _sfTF.font = [UIFont systemFontOfSize:15];
                        _sfTF.clearButtonMode = UITextFieldViewModeWhileEditing;
                        _sfTF.returnKeyType =UIReturnKeyDone;
                        _sfTF.hidden = !sfBool;
                        _sfTF.textColor = BaseColorYellow;
                        [cell addSubview:_sfTF];
                    }else{
                        tf.hidden = !sfBool;
                    }
                }
            }
        }
    }
    if (indexPat.section == 2) {
        if (_dataleiBArr.count >0) {
            for(int i = 0; i<3; i++){
                if (i+(indexPat.row*3) < _dataleiBArr.count) {
                    NSString *_qzlbButArrStr;
                    if ([_qzlbButArr count]!=0) {
                        _qzlbButArrStr = [_qzlbButArr objectAtIndex:0];
                    }
                    if (i%3 == 0) {
                        NSDictionary *dic= [_dataleiBArr objectAtIndex:i+(indexPat.row*3)];
                        NSString *str = [dic objectForKey:@"Id"];
                        UIButton *but11 = [cell viewWithTag:str.intValue];
                        if (but11 == nil) {
                            UIButton *but = [self creatBut:[dic objectForKey:@"Name"] tag:str.intValue titleColor:[UIColor blackColor] butFrameW:15.f];
                            [cell addSubview:but];
                        }else if(str.intValue != _qzlbButArrStr.intValue){
                            [but11 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                            but11.backgroundColor = [UIColor colorWithRed:239/255.0f green:240/255.0f blue:242/255.0f alpha:1];
                            [but11.layer setBorderColor:butcolorref1];
                        }
                        
                    }else if (i%3 == 1) {
                        NSDictionary *dic= [_dataleiBArr objectAtIndex:i+(indexPat.row*3)];
                        NSString *str = [dic objectForKey:@"Id"];
                        UIButton *but11 = [cell viewWithTag:str.intValue];
                        if (but11 == nil) {
                            UIButton *but = [self creatBut:[dic objectForKey:@"Name"] tag:str.intValue titleColor:[UIColor blackColor] butFrameW:137.f];
                            [cell addSubview:but];
                        }else if(str.intValue != _qzlbButArrStr.intValue){
                            [but11 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                            but11.backgroundColor = [UIColor colorWithRed:239/255.0f green:240/255.0f blue:242/255.0f alpha:1];
                            [but11.layer setBorderColor:butcolorref1];
                        }
                        
                    }else if(i%3 == 2) {
                        NSDictionary *dic= [_dataleiBArr objectAtIndex:i+(indexPat.row*3)];
                        NSString *str = [dic objectForKey:@"Id"];
                        UIButton *but11 = [cell viewWithTag:str.intValue];
                        if (but11 == nil) {
                            UIButton *but = [self creatBut:[dic objectForKey:@"Name"] tag:str.intValue titleColor:[UIColor blackColor] butFrameW:259.f];
                            [cell addSubview:but];
                        }else if(str.intValue != _qzlbButArrStr.intValue){
                            [but11 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                            but11.backgroundColor = [UIColor colorWithRed:239/255.0f green:240/255.0f blue:242/255.0f alpha:1];
                            [but11.layer setBorderColor:butcolorref1];
                        }
                    }
                }
            }
        }
    }
    if (indexPat.section == 3) {
        
        if (_dataleiBArr.count >0){
            if (indexPat.row == 0) {
                _circleNameTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 40)];
                _circleNameTF.delegate = self;
                _circleNameTF.borderStyle = UITextBorderStyleNone;
                _circleNameTF.backgroundColor = [UIColor whiteColor];
                _circleNameTF.text = @"  圈子名称";
                _circleNameTF.textColor = [UIColor colorWithRed:161/255.0f green:166/255.0f blue:187/255.0f alpha:1];
                _circleNameTF.font = [UIFont systemFontOfSize:15];
                _circleNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
                _circleNameTF.returnKeyType =UIReturnKeyDone;
                [cell addSubview:_circleNameTF];
            }
            if (indexPat.row == 1) {
                UITextView *textV = [[UITextView alloc]initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-30, 150)];
                textV.textColor = [UIColor colorWithRed:161/255.0f green:166/255.0f blue:187/255.0f alpha:1];
                textV.text = @" 圈子简介(选填)";
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
                
                [cell addSubview:textV];
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(UIButton *)creatBut:(NSString *)titleText tag:(int)tag titleColor:(UIColor *)titleColor butFrameW:    (float)w{
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef butcolorref = CGColorCreate(colorSpace,(CGFloat[]){ 161/255.0f, 166/255.0f, 187/255.0f, 1 });
    
    UIButton *but12 = [[UIButton alloc]initWithFrame:CGRectMake(w, 10, 90, 30)];
    but12.tag = tag;
    [but12.layer setMasksToBounds:YES];
    [but12 setTitle:titleText forState:UIControlStateNormal];
    but12.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    [but12 setTitleColor:titleColor forState:UIControlStateNormal];
    [but12.layer setBorderWidth:1.0];
    [but12.layer setBorderColor:butcolorref];//边框颜色
    if (tag == 10001 || tag == 10000) {
        [but12 addTarget:self action:@selector(dianji:) forControlEvents:UIControlEventTouchDown];
    }else{
        [but12 addTarget:self action:@selector(dianji111:) forControlEvents:UIControlEventTouchDown];
    }
    [but12.layer setMasksToBounds:YES];
    [but12.layer setCornerRadius:3];
    return but12;
}

-(void)dianji:(UIButton *)sender{
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef butcolorref = CGColorCreate(colorSpace,(CGFloat[]){ 161/255.0f, 166/255.0f, 187/255.0f, 1 });
    
    if(sender.tag == 10000) {
        sfBool =NO;
        [_sfBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sfBut.backgroundColor = BaseColorYellow;
        [_sfBut.layer setBorderColor:(__bridge CGColorRef _Nullable)(BaseColorYellow)];
        
        [_mfBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _mfBut.backgroundColor = [UIColor colorWithRed:239/255.0f green:240/255.0f blue:242/255.0f alpha:1];
        [_mfBut.layer setBorderColor:butcolorref];
    }
    if (sender.tag == 10001) {
        sfBool =YES;
        [_mfBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _mfBut.backgroundColor = BaseColorYellow;
        [_mfBut.layer setBorderColor:(__bridge CGColorRef _Nullable)(BaseColorYellow)];
        
        [_sfBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _sfBut.backgroundColor = [UIColor colorWithRed:239/255.0f green:240/255.0f blue:242/255.0f alpha:1];
        [_sfBut.layer setBorderColor:butcolorref];
    }
    [self.tabView reloadData];
}

-(void)dianji111:(UIButton *)sender{
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef butcolorref1 = CGColorCreate(colorSpace,(CGFloat[]){ 161/255.0f, 166/255.0f, 187/255.0f, 1 });
    
    if (_qzlbButArr.count == 0) {
        [_qzlbButArr addObject:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sender.backgroundColor = BaseColorYellow;
        [sender.layer setBorderColor:(__bridge CGColorRef _Nullable)(BaseColorYellow)];
        [self.tabView reloadData];
    }else{
        NSString *str = [NSString stringWithFormat:@"%ld",(long)sender.tag];
        [_qzlbButArr removeAllObjects];
        if (![_qzlbButArr containsObject:str]) {
            [_qzlbButArr addObject:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            sender.backgroundColor = BaseColorYellow;
            [sender.layer setBorderColor:(__bridge CGColorRef _Nullable)(BaseColorYellow)];
            
            
            
            [self.tabView reloadData];
        }else{
            [_qzlbButArr removeObject:str];
            [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            sender.backgroundColor = [UIColor colorWithRed:239/255.0f green:240/255.0f blue:242/255.0f alpha:1];
            [sender.layer setBorderColor:butcolorref1];
            [self.tabView reloadData];
        }
    }
}
#pragma mark --头像选择
-(void)toxiangAction{
    
    if (entranceVC == nil) {
        entranceVC = [[CircleToXiangViewController alloc] init];
    }
    [entranceVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    entranceVC.delegate = self;
    //背景透明
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        entranceVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    }else{
        self.modalPresentationStyle=UIModalPresentationCurrentContext;
    }
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:entranceVC animated:YES completion:^{
    }];
}
#pragma mark -- CircleToXiangViewControllerDelegate
-(void)jiequImage111:(NSArray *)imageArray{
    
    cutVC = [[YKPhotoCutController alloc] init];
    cutVC.photoArr = imageArray;
    cutVC.delegate = self;
    [self.navigationController pushViewController:cutVC animated:NO];
}
-(void)jiequImage:(NSArray *)imageArray{
    UIButton *but = [headerView viewWithTag:10];
    UIImageView *imaegView = imageArray[0];
    UIImage *image = imaegView.image;
    _txImageArr = [NSArray arrayWithObjects:image, nil];
    [but setImage:imaegView.image forState:UIControlStateNormal];
    [self.tabView reloadData];
}
#pragma mark -- 截取图片的回调方法
- (void)getBackCutPhotos:(NSArray *)photosArr
{
    NSLog(@"++++++++++%@",photosArr);
    _txImageArr = [NSArray arrayWithArray:photosArr];
    UIButton *but = [headerView viewWithTag:10];
    [but setImage:photosArr[0] forState:UIControlStateNormal];
    [self.tabView reloadData];
}

#pragma mark --UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([_circleneirTV.text isEqualToString:@" 圈子简介(选填)"]) {
        _circleneirTV.text = @"";
    }
    _circleneirTV.textColor = [UIColor blackColor];
    return YES;
}
#pragma mark --关闭键盘
-(void) dismissKeyBoard{
    if ([_circleneirTV.text isEqualToString:@""]) {
        _circleneirTV.textColor = [UIColor colorWithRed:161/255.0f green:166/255.0f blue:187/255.0f alpha:1];
        _circleneirTV.text = @" 圈子简介(选填)";
    }
    if ([_circleneirTV.text isEqualToString:@" 圈子简介(选填)"]) {
        _circleneirTV.textColor = [UIColor colorWithRed:161/255.0f green:166/255.0f blue:187/255.0f alpha:1];
        _circleneirTV.text = @" 圈子简介(选填)";
    }
    [_circleneirTV resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([_circleNameTF.text isEqualToString:@""]) {
        _circleNameTF.text = @"  圈子名称";
        _circleNameTF.textColor = [UIColor colorWithRed:161/255.0f green:166/255.0f blue:187/255.0f alpha:1];
    }
    [_circleNameTF resignFirstResponder];
    [_sfTF resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _circleNameTF.textColor = [UIColor blackColor];
    _circleNameTF.text = @"";
}
- (void)loadData {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"BuildSowingType"] = @"BuildSowing_CircleType";
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        ZBLog(@"BuildSowing_UserDetial--%@", res);
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            
            NSArray *dataArr = [res objectForKey:@"data"];
            if(!dataArr || dataArr.count == 0) {
                return ;
            }
            for (NSDictionary *data in dataArr) {
                [_dataleiBArr addObject:data];
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
