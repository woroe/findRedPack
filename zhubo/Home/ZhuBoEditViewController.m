//
//  ZhuBoEditViewController.m
//  zhubo
//
//  Created by Jin on 2017/6/13.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "ZhuBoEditViewController.h"
#import "MyTableViewCell.h"

#import "OSSImageUploader.h"

#import "LabelList.h"
#import "FileList.h"
#import "News.h"
#import "ZYTagInfo.h"

#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface ZhuBoEditViewController ()<UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate,AMapLocationManagerDelegate>{
    
    UIImagePickerController *_imagePickerController;
    
    CGFloat Longitude;
    CGFloat Latitude;
}

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *photosBack;
@property (weak, nonatomic) IBOutlet UITableView *tabView;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *customLayout;
@property (nonatomic, assign) CGFloat collctionCellW;
@property (nonatomic, strong) NSMutableArray *choiceImages;


@property (nonatomic, strong) NSString *locationAddr;
@property (nonatomic, assign) BOOL isOpen;

@property (nonatomic, strong)CLLocationManager *cllocationManager;


@property (nonatomic, strong) UIButton *fasoBut;
@property (nonatomic, strong) UIButton *fanhuiBut;

@property (nonatomic, strong)AMapLocationManager *locationManager;

@end

static NSString *placeHolder = @"说点什么";
static NSString *tabcellId = @"MyTableViewCellID";
static NSString *collcellId = @"collectionViewID";

@implementation ZhuBoEditViewController

@synthesize model;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIBarButtonItem *ite =[[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
//    self.navigationItem.rightBarButtonItem = ite;
    _fasoBut = [self.view viewWithTag:101];
    [_fasoBut addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchDown];
    
    _fanhuiBut = [self.view viewWithTag:100];
    [_fanhuiBut addTarget:self action:@selector(fanhuiAction) forControlEvents:UIControlEventTouchDown];
    
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
    
    self.choiceImages = [NSMutableArray array];
    
//    _cllocationManager = [[CLLocationManager alloc]init];
//    _cllocationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    _cllocationManager.distanceFilter = 100;
//    if ([[UIDevice currentDevice] systemVersion].doubleValue > 8.0) {//如果iOS是8.0以上版本
//        if ([_cllocationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {//位置管理对象中
//            [_cllocationManager requestAlwaysAuthorization];
//        }
//    }
//    _cllocationManager.delegate = self;
//    [_cllocationManager startUpdatingLocation];
    [self configLocationManager];// 初始化
    [self startSerialLocation];// 开始定位
    
    if ([self.muTagInFoArr count] != 0 && self.news_And_Circle.intValue == 1) {
        for (NSDictionary *dic in self.muTagInFoArr) {
            [self.choiceImages addObject:[dic objectForKey:@"image"]];
        }
        [self.collectionView reloadData];
    }
    
    [self loadUI];
}
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
    Longitude = location.coordinate.longitude;
    Latitude = location.coordinate.latitude;
    // 停止定位
    [self stopSerialLocation];
}
- (void)loadUI {
    
    self.textView.text = placeHolder;
    self.textView.textColor = [UIColor grayColor];
    self.textView.delegate = self;
    self.textView.font = [UIFont systemFontOfSize:15.f];
    self.textView.clearsContextBeforeDrawing = NO;
    self.textView.autocorrectionType = UITextAutocorrectionTypeYes;
    self.textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textView.keyboardType = UIKeyboardTypeDefault;
    self.textView.delegate = self;
    self.textView.layer.borderWidth = 1.0f;
    self.textView.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor whiteColor]);
    
    UIToolbar * topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace, doneButton, nil];
    [topView setItems:buttonsArray];
    [self.textView setInputAccessoryView:topView];
    
    self.locationAddr = @"位置";
    self.isOpen = YES;
    
    UILabel *lal = [self.view viewWithTag:150];
    lal.frame = CGRectMake(self.photosBack.frame.size.width -127 , self.textView.frame.size.height + self.textView.frame.origin.y, 117, 21);
    [self.photosBack addSubview:lal];
    
    //collectionView
    self.collctionCellW = (SCREEN_WIDTH - 90 * SCREEN_W_SCALE ) / 4;
    CGRect collFrame = CGRectMake(MARGIN_30, self.textView.frame.size.height+20+self.textView.frame.origin.y, self.photosBack.frame.size.width - 60 * SCREEN_W_SCALE, self.collctionCellW);
    _customLayout = [[UICollectionViewFlowLayout alloc] init];
    // 自定义的布局对象
    _customLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _customLayout.itemSize = CGSizeMake(_collctionCellW, _collctionCellW);
    _customLayout.minimumLineSpacing = 10 * SCREEN_W_SCALE;
    _customLayout.minimumInteritemSpacing = 10 * SCREEN_W_SCALE;
    _collectionView = [[UICollectionView alloc] initWithFrame:collFrame collectionViewLayout:_customLayout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:collcellId];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.photosBack addSubview:self.collectionView];
    
    //重新设置frame
    [self resetViewFrame];
}
-(void)fanhuiAction{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
#pragma mark --发布动态
-(void)rightBtnClick{
//    [SVProgressHUD setStatus:@"正在提交中。。"];
//    [SVProgressHUD showInfoWithStatus:@"正在提交中。。"];
    [SVProgressHUD show];
    if (_news_And_Circle.intValue == 1) {
        [self News_rightBtnClick];
        _fasoBut.userInteractionEnabled = NO;
        _fanhuiBut.userInteractionEnabled = NO;
    }else{
        NSArray *arr = [NSArray arrayWithArray:_choiceImages];
        if ([arr count] == 0) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"BuildSowingType"] = @"BuildSowing_ReleaseCircleNews";
            params[@"UserId"] = @([BaseData shareInstance].userId);
            params[@"CircleId"] = @(model.circleId);
            params[@"Words"] = self.textView.text;
            params[@"NewsContent"] = @"";
            params[@"NewsContentType"] = @"0";
            
            
            [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *res = (NSDictionary *)responseObject;
                ZBLog(@"BuildSowing_ReleaseCircleNews--%@", res);
                if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
                    [SVProgressHUD showSuccessWithStatus:@""];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else{
                    [SVProgressHUD showErrorWithStatus:BaseStringNetError];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [SVProgressHUD showErrorWithStatus:BaseStringNetError];
            }];
        }else{
            [OSSImageUploader asyncUploadImages:arr complete:^(NSArray<NSString *> *names, UploadImageState state) {
                
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
                
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                params[@"BuildSowingType"] = @"BuildSowing_ReleaseCircleNews";
                params[@"UserId"] = @([BaseData shareInstance].userId);
                params[@"CircleId"] = @(model.circleId);
                params[@"Words"] = self.textView.text;
                params[@"NewsContent"] = mtStr;
                params[@"NewsContentType"] = @"1";
                
                
                [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSDictionary *res = (NSDictionary *)responseObject;
                    ZBLog(@"BuildSowing_ReleaseCircleNews--%@", res);
                    if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
                        [SVProgressHUD showSuccessWithStatus:@""];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else{
                        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
                    }
                    _fasoBut.userInteractionEnabled = YES;
                    _fanhuiBut.userInteractionEnabled = YES;
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [SVProgressHUD showErrorWithStatus:BaseStringNetError];
                    _fasoBut.userInteractionEnabled = YES;
                    _fanhuiBut.userInteractionEnabled = YES;
                }];
                
            }];
        }
    }
}

-(void)News_rightBtnClick{
    if (_prayelUrl != nil) {
        NSArray *arr = [NSArray arrayWithArray:_choiceImages];
        [OSSImageUploader asyncUploadImages:arr complete:^(NSArray<NSString *> *names, UploadImageState state) {
            NSString *imageStr= [NSString stringWithFormat:@"http://zhuboapp.oss-cn-shanghai.aliyuncs.com/%@",names[0]];
            [OSSImageUploader updateDataWithServerModel:_prayelUrl progress:nil success:^(NSString *responseObject, BOOL isSuccess) {
                if (isSuccess) {
                    ZBLog(@"上传成功>>>>>>>> %@",responseObject);
                    News *newS = [News new];
                    NSMutableArray *fileArr = [NSMutableArray new];
                    FileList *fileList = [FileList new];
                    NSDictionary *dic = self.muTagInFoArr[0];
                    NSArray *arr = [dic objectForKey:@"arr"];
                    LabelList *labelList = [LabelList new];
                    NSMutableArray *infoArr = [NSMutableArray new];
                    for (ZYTagInfo *tagInFo in arr) {
                        labelList.Labtxt = tagInFo.title;
                        labelList.x = tagInFo.proportion.x;
                        labelList.y = tagInFo.proportion.y;
                        labelList.lyid = tagInFo.object[@"classification"];
                        labelList.lycity = tagInFo.object[@"provice"];
                        if (tagInFo.direction ==ZYTagDirectionLeft) {
                            labelList.Position = @"left";
                        }
                        if (tagInFo.direction ==ZYTagDirectionRight) {
                            labelList.Position = @"right";
                        }
                        [infoArr addObject:labelList];
                    }
                    fileList.Url =responseObject;
                    fileList.Label = infoArr;
                    [fileArr addObject:fileList];
                    newS.Files = fileArr;
                    newS.Latitude = Latitude;
                    newS.Longitude = Longitude;
                    newS.NewsType = 2;
                    newS.UserId = [BaseData shareInstance].userId;
                    if ([self.textView.text isEqualToString:@"说点什么"]) {
                        newS.Words = @"";
                    }else{
                        newS.Words = self.textView.text;
                    }
                    newS.FirstImsg = imageStr;
                    NSString *jsonStr = [newS mj_JSONString];
                    
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    params[@"BuildSowingType"] = @"ReleaseNews";
                    params[@"Json"] = jsonStr;
                    
                    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSDictionary *res = (NSDictionary *)responseObject;
                        ZBLog(@"BuildSowing_ReleaseCircleNews--%@", res);
                        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
                            [SVProgressHUD dismiss];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"gohome" object:nil];
                            [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:^{
                            }];
                        }
                        else{
                            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
                        }
                        _fasoBut.userInteractionEnabled = YES;
                        _fanhuiBut.userInteractionEnabled = YES;
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
                        _fasoBut.userInteractionEnabled = YES;
                        _fanhuiBut.userInteractionEnabled = YES;
                    }];
                }else{
                }
            } failure:^(NSError *error) {
                
            }];
        }];
    }else{
        NSArray *arr = [NSArray arrayWithArray:_choiceImages];

        [OSSImageUploader asyncUploadImages:arr complete:^(NSArray<NSString *> *names, UploadImageState state) {
            News *newS = [News new];
            NSMutableArray *fileArr = [NSMutableArray new];
            for (int i = 0; i <[names count]; i++) {
                FileList *fileList = [FileList new];
                NSString *str111= [NSString stringWithFormat:@"http://zhuboapp.oss-cn-shanghai.aliyuncs.com/%@",names[i]];
                NSDictionary *dic = self.muTagInFoArr[i];
                NSArray *arr = [dic objectForKey:@"arr"];
                NSMutableArray *infoArr = [NSMutableArray array];
                for (ZYTagInfo *tagInFo in arr) {
                    LabelList *labelList = [LabelList new];
                    labelList.Labtxt = tagInFo.title;
                    labelList.x = tagInFo.proportion.x;
                    labelList.y = tagInFo.proportion.y;
                    labelList.lyid = tagInFo.object[@"classification"];
                    labelList.lycity = tagInFo.object[@"provice"];
                    if (tagInFo.direction ==ZYTagDirectionLeft) {
                        labelList.Position = @"left";
                    }
                    if (tagInFo.direction ==ZYTagDirectionRight) {
                        labelList.Position = @"right";
                    }
                    [infoArr addObject:labelList];
                }
                fileList.Url =str111;
                fileList.Label = infoArr;
                [fileArr addObject:fileList];
            }
            newS.Files = fileArr;
            newS.Latitude = Latitude;
            newS.Longitude = Longitude;
            newS.NewsType = 1;
            newS.UserId = [BaseData shareInstance].userId;
            if ([self.textView.text isEqualToString:@"说点什么"]) {
                newS.Words = @"";
            }else{
                newS.Words = self.textView.text;
            }
            NSString *jsonStr = [newS mj_JSONString];
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"BuildSowingType"] = @"ReleaseNews";
            params[@"Json"] = jsonStr;
            
            [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *res = (NSDictionary *)responseObject;
                ZBLog(@"BuildSowing_ReleaseCircleNews--%@", res);
                if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
                    [SVProgressHUD dismiss];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"gohome" object:nil];
                    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:^{
                    }];
                }
                else{
                    [SVProgressHUD showErrorWithStatus:BaseStringNetError];
                }
                _fasoBut.userInteractionEnabled = YES;
                _fanhuiBut.userInteractionEnabled = YES;
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [SVProgressHUD showErrorWithStatus:BaseStringNetError];
                _fasoBut.userInteractionEnabled = YES;
                _fanhuiBut.userInteractionEnabled = YES;
            }];
        }];
    }
}
//获取经纬度和详细地址
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
//    CLLocation *location = [locations lastObject];
//    NSLog(@"latitude === %g  longitude === %g",location.coordinate.latitude, location.coordinate.longitude);
//    //反向地理编码
//    Longitude = location.coordinate.longitude;
//    Latitude = location.coordinate.latitude;
//}
//创建文件目录
- (BOOL)creatDir:(NSString*)dirPath
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:dirPath])//判断dirPath路径文件夹是否已存在，此处dirPath为需要新建的文件夹的绝对路径
    {
        return NO;
    }else{
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];//创建文件夹
        if (error) {
            return NO;
        }
        return YES;
    }
    
}
#pragma mark --关闭键盘
-(void) dismissKeyBoard{
    [self.textView resignFirstResponder];
}

- (void)resetViewFrame {
    
    NSInteger lines = (NSInteger)ceil( (self.choiceImages.count + 1) / 4.0 );
    NSInteger linesIndex = (self.choiceImages.count + 1) % 4;
    CGRect collFrame = self.collectionView.frame;
    //增加行、减少行
    if(lines > 1 && ( linesIndex == 1 || linesIndex == 0)){
        collFrame.size.height = self.collctionCellW * lines + (lines - 1) * 10 * SCREEN_W_SCALE;
        self.collectionView.frame = collFrame;
        
        CGRect tabFrame = self.tabView.frame;
        tabFrame.origin.y = collFrame.size.height + collFrame.origin.y + 15 *SCREEN_W_SCALE;
        self.tabView.frame = tabFrame;
    }
    
    CGRect photoBCFrame = self.photosBack.frame;
    photoBCFrame.size.height = collFrame.size.height + collFrame.origin.y;
    self.photosBack.frame = photoBCFrame;
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_news_And_Circle.intValue == 1){
        return self.choiceImages.count;
    }else{
        return self.choiceImages.count + 1;
    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    [self resetViewFrame];
    return 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:collcellId forIndexPath:indexPath];
    
    if (_news_And_Circle.intValue == 1) {
        UIImage *image = self.choiceImages[indexPath.row];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.collctionCellW, self.collctionCellW)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.layer.masksToBounds = YES;
        imgView.userInteractionEnabled = YES;
        imgView.image = image;
        [cell addSubview:imgView];
    }else{
        if(indexPath.row == self.choiceImages.count) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.collctionCellW, self.collctionCellW)];
            [btn setImage:[UIImage imageNamed:@"tianjia"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(choiceImage:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
        }
        else {
            UIImage *image = self.choiceImages[indexPath.row];
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.collctionCellW, self.collctionCellW)];
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.layer.masksToBounds = YES;
            imgView.userInteractionEnabled = YES;
            imgView.image = image;
            [cell addSubview:imgView];
        }
    }
    return cell;
}


#pragma mark - choiceImage
- (void)choiceImage:(id)sender {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *AAfx = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"分享");
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
#pragma mark 从摄像头获取图片或视频
- (void)selectImageFromCamera
{
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    //录制视频时长，默认10s
    _imagePickerController.videoMaximumDuration = 15;
    
    //相机类型（拍照、录像...）字符串需要做相应的类型转换
    _imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
    
    //视频上传质量
    //UIImagePickerControllerQualityTypeHigh高清
    //UIImagePickerControllerQualityTypeMedium中等质量
    //UIImagePickerControllerQualityTypeLow低质量
    //UIImagePickerControllerQualityType640x480
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
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{

    ZBLog(@"---info:%@", info);
    if([[info objectForKey:UIImagePickerControllerMediaType] isEqual: (NSString *)kUTTypeImage]) {
        [self.choiceImages addObject:[info objectForKey:UIImagePickerControllerOriginalImage]];
        [self.collectionView reloadData];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = placeHolder;
        textView.textColor = [UIColor grayColor];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:placeHolder]){
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }
}
- (void)textViewDidChange:(UITextView *)textView{
    UILabel *lal = [self.view viewWithTag:150];
    NSString *str = textView.text;
    if (str.length > 150) {
        str = [str substringWithRange:NSMakeRange(0,150)];
        textView.text = str;
    }
    lal.text = [NSString stringWithFormat:@"(%ld-150)字符",str.length];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tabcellId forIndexPath:indexPath];
    if(indexPath.row == 0){
        [cell setImage:@"dingweiz" WithTitle:self.locationAddr];
    }
    else{
        NSString *str = self.isOpen ? @"公开" : @"不公开";
        [cell setImage:@"gongkai" WithTitle:str];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
@end
