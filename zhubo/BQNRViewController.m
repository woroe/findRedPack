//
//  BQNRViewController.m
//  zhubo
//
//  Created by Jin on 2017/7/31.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "BQNRViewController.h"


//#import <MapKit/MapKit.h>
//#import <CoreLocation/CoreLocation.h>

#import "BQNRViewCell.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

#import "BottomPopView.h"
#import "FYLCityModel.h"
#import "YYModel.h"

@interface BQNRViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,AMapLocationManagerDelegate,AMapSearchDelegate>
{

    
    NSMutableArray *mxArr;
}

@property (nonatomic, strong)CLLocationManager *cllocationManager;

@property (nonatomic, strong)AMapLocationManager *locationManager;
@property (nonatomic, strong)CLLocation *location;
@property (nonatomic, strong)AMapSearchAPI *search;

@property (strong, nonatomic) NSMutableArray *firstTagArray;
@property (strong, nonatomic) NSMutableArray *secondTagArray;

@property (strong, nonatomic) NSString *firstId;

@end

@implementation BQNRViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    mxArr = [[NSMutableArray alloc]init];
    
//    _cllocationManager = [[CLLocationManager alloc]init];
//    _cllocationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    _cllocationManager.distanceFilter = 100;
//    if ([[UIDevice currentDevice] systemVersion].doubleValue > 8.0) {//如果iOS是8.0以上版本
//       if ([_cllocationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {//位置管理对象中
//           [_cllocationManager requestAlwaysAuthorization];
//        }
//    }
//    _cllocationManager.delegate = self;
//    [_cllocationManager setDistanceFilter:kCLDistanceFilterNone];
//    [_cllocationManager startUpdatingLocation];
    
    _firstId = @"";
    _firstTagArray = [NSMutableArray array];
    _secondTagArray = [NSMutableArray array];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"BQNRViewCell" bundle:nil] forCellReuseIdentifier:@"BQNRViewCellID"];
    
    self.textFleld.clearsContextBeforeDrawing = NO;
    self.textFleld.autocorrectionType = UITextAutocorrectionTypeYes;
    self.textFleld.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textFleld.keyboardType = UIKeyboardTypeDefault;
    self.textFleld.delegate = self;
    
    UIButton *but = [self.view viewWithTag:101];
    [but addTarget:self action:@selector(rightItemAction) forControlEvents:UIControlEventTouchDown];
    
    UIButton *bockBut = [self.view viewWithTag:100];
    [bockBut addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchDown];
    
    [AMapServices sharedServices].apiKey = GaoDeMapKey;
    
    [self configLocationManager];// 初始化
    [self startSerialLocation];// 开始定位
    [self loadSecondTagData];
    [self loadFirstTagData];
}

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
//    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
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
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    // 赋值给全局变量
    self.location = location;
    // 发起周边搜索
    [self searchAround];
    // 停止定位
    [self stopSerialLocation];
}
/** 根据定位坐标进行周边搜索 */
- (void)searchAround{
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:self.location.coordinate.latitude longitude:self.location.coordinate.longitude];
    request.types = @"商务住宅|交通设施服务|金融保险服务|风景名胜|道路附属设施|地名地址信息|公共设施";
    request.sortrule = 0;
    request.requireExtension = YES;
    request.radius =  5000;
    
    NSLog(@"周边搜索");
    //发起周边搜索
    [self.search AMapPOIAroundSearch: request];
}
// 实现POI搜索对应的回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    NSLog(@"周边搜索回调");
    if(response.pois.count == 0)
    {
        return;
    }
    NSLog(@"%@",response.pois);
    NSArray *arr11 = response.pois;
    for (AMapPOI *poi111 in arr11) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        NSString *xxdzStr = [NSString stringWithFormat:@"%@%@%@",poi111.city,poi111.district,poi111.address];
        [dic setObject:poi111.name forKey:@"Name"];
        [dic setObject:xxdzStr forKey:@"xxdzStr"];
        [mxArr addObject:dic];
    }
//    if ([mxArr count] < 6) {
//        self.tableView.frame = CGRectMake(0, 149, SCREEN_WIDTH, 75*[mxArr count]-MARGIN_40);
//    }else{
//        self.tableView.frame = CGRectMake(0, 149, SCREEN_WIDTH, SCREEN_HEIGHT-149-MARGIN_20);
//    }
    if ([mxArr count] == 0){
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    // 周边搜索完成后，刷新tableview
    [self.tableView reloadData];
    
}
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 20)
        return NO;
    return YES;
}

- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)rightItemAction{
    [self.textFleld resignFirstResponder];
    if ([self.firstTagField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请选择标签内容分类"];
        return;
    }
    if ([self.secondTagField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请选择标签内容所在地域"];
        return;
    }
    
    if ([self.textFleld.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入建筑，事件，心情或地点"];
        return;
    }
    
    NSDictionary *info = @{@"classification":_firstId,
                           @"provice":_secondTagField.text,
                           @"title":_textFleld.text};
    
    [self.delegate BQTextFStr:info xgaihaishixinjian:_str];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
#pragma mark -- textFieldDeleget
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return mxArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BQNRViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BQNRViewCellID" forIndexPath:indexPath];
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([mxArr count] !=0 ) {
        NSDictionary *dic = [mxArr objectAtIndex:indexPath.row];
        UILabel *shijianLai = [cell viewWithTag:10];
        shijianLai.text = [dic objectForKey:@"Name"];
        
        UILabel *qianLai = [cell viewWithTag:12];
        qianLai.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"xxdzStr"]];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [mxArr objectAtIndex:indexPath.row];
    if ([self.firstTagField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请选择标签内容分类"];
        return;
    }
    if ([self.secondTagField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请选择标签内容所在地域"];
        return;
    }
    NSDictionary *info = @{@"classification":_firstId,
                           @"provice":_secondTagField.text,
                           @"title":[dic objectForKey:@"Name"]};
    
    [self.delegate BQTextFStr:info xgaihaishixinjian:_str];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    
}

//获取经纬度和详细地址
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations lastObject];
    NSLog(@"latitude === %g  longitude === %g",location.coordinate.latitude, location.coordinate.longitude);
    //反向地理编码
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    CLLocation *cl = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    [clGeoCoder reverseGeocodeLocation:cl completionHandler: ^(NSArray *placemarks,NSError *error) {
        for (CLPlacemark *placeMark in placemarks) {
            NSDictionary *addressDic = placeMark.addressDictionary;
            NSString *state=[addressDic objectForKey:@"State"];
            NSString *city=[addressDic objectForKey:@"SubLocality"];
            NSString *subLocality=[addressDic objectForKey:@"Name"];
            NSString *xxdzStr = [NSString stringWithFormat:@"%@%@%@",state,city,subLocality];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:subLocality forKey:@"Name"];
            [dic setObject:xxdzStr forKey:@"xxdzStr"];
            [mxArr addObject:dic];
            [_cllocationManager stopUpdatingLocation];
          }
        if ([mxArr count] < 6) {
            self.tableView.frame = CGRectMake(0, 149, SCREEN_WIDTH, 75*[mxArr count]-MARGIN_40);
        }else{
            self.tableView.frame = CGRectMake(0, 149, SCREEN_WIDTH, CONTENT_HEIGHT-MARGIN_40);
        }
        if ([mxArr count] == 0){
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        [self.tableView reloadData];
    }];
    
}

#pragma mark - 获取标签选择数据源

- (void)loadFirstTagData {//获取标签内容分类
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"BuildSowingType"] = @"GetLabelTypeList";
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if([[responseObject objectForKey:@"StatusCode"] isEqual:@(1)]){
            _firstTagArray = [NSMutableArray arrayWithArray:responseObject[@"data"]];
        }
        else{
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
    }];
}

- (void)loadSecondTagData {//获取标签内容所在区域
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"FYLCity" ofType:@"plist"];
    
    NSArray *arrData = [NSArray arrayWithContentsOfFile:filePath];

    for (NSDictionary *dic in arrData) {
        ///此处用到底 "YYModel"
        FYLProvince *provice = [FYLProvince yy_modelWithDictionary:dic];
        [self.secondTagArray addObject:@{@"Id":@"",@"Name":provice.name}];
    }
}

- (IBAction)firstTagInfoSelectAction:(UIControl *)sender {
    BottomPopView *btPopView = [[BottomPopView alloc]init];
    btPopView.datas = _firstTagArray;
    __weak typeof(self) weakSelf = self;
    btPopView.block = ^(id obj) {
        weakSelf.firstTagField.text = obj[@"Name"];
        weakSelf.firstId = obj[@"Id"];
    };
    [self.view addSubview:btPopView];
}

- (IBAction)secondTagInfoSelectAction:(UIControl *)sender {
    BottomPopView *btPopView = [[BottomPopView alloc]init];
    btPopView.datas = _secondTagArray;
    __weak typeof(self) weakSelf = self;
    btPopView.block = ^(id obj) {
        weakSelf.secondTagField.text = obj[@"Name"];
    };
    [self.view addSubview:btPopView];
}

@end
