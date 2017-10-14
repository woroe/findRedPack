//
//  DiscoverViewController.m
//  zhubo
//
//  Created by Jin on 2017/6/12.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "DiscoverViewController.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

#import "ZhuBoModel.h"

#import "GrZhuYeViewController.h"
#import "MapSearchViewController.h"

@interface DiscoverViewController ()<MAMapViewDelegate,AMapSearchDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,UISearchBarDelegate,UISearchResultsUpdating>{
    
    CLLocationCoordinate2D cllocation2D;
}

@property(nonatomic, strong) UISearchBar *searchBar;
@property(nonatomic, strong) MAMapView *mapView;

@property (nonatomic,retain) AMapPOI *currentPOI;
@property (nonatomic,retain) MAPointAnnotation *destinationPoint;//目标点

@property (nonatomic, assign) NSInteger Page;
@property (nonatomic, strong) NSMutableArray <ZhuBoModel *>*models;
@property (nonatomic, strong) NSMutableDictionary *marks;

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic,retain) NSMutableArray *dataList;
@property (strong,nonatomic) NSMutableArray  *searchList;

@property (nonatomic,retain) AMapSearchAPI *search;
@property (nonatomic,retain) MAUserLocation *currentLocation;//当前位置

@property (nonatomic,retain) NSString *currentCity;


@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"附近";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gohome) name:@"gohome" object:nil];
    self.models = [NSMutableArray array];
    self.marks = [NSMutableDictionary dictionary];
    [self loadMap];
}

-(void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)gohome {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gohome_zuiXing" object:nil];
    HomeViewController *homeVC = self.tabBarController.viewControllers[0];
    self.tabBarController.selectedViewController = homeVC;
}

- (void)loadSearchBar {
    
    CGRect frame = CGRectMake(15, 7.5, self.view.bounds.size.width - 30, 28);
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:frame];
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.delegate = self;
    searchBar.placeholder = @"搜索地址";
    [self.view addSubview:searchBar];
    self.searchBar = searchBar;
    
    // 返回按钮
    UIButton *backToCurrentBut = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT-180, 40, 40)];
    [backToCurrentBut addTarget:self action:@selector(backToCurrent) forControlEvents:UIControlEventTouchUpInside];
    [backToCurrentBut setImage:[UIImage imageNamed:@"fanhuidangqianweizhi"] forState:UIControlStateNormal];
    backToCurrentBut.hidden = YES;
    [self.view addSubview:backToCurrentBut];
    
}
- (void)loadMap {
//    UIView *view1212 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
//    view1212.backgroundColor = BaseColorPurple;
//    [self.view addSubview:view1212];
    
    CLLocationCoordinate2D cll2D;
    cll2D.latitude = 29.569056f;
    cll2D.longitude = 106.561331f;
    
    [AMapServices sharedServices].apiKey = GaoDeMapKey;
    CGRect frame = CGRectMake(0, 43, SCREEN_WIDTH, SCREEN_HEIGHT-60);
    MAMapView *mapView = [[MAMapView alloc] initWithFrame:frame];
    mapView.centerCoordinate = cll2D;
    mapView.showsUserLocation = YES;
    mapView.userTrackingMode = MAUserTrackingModeFollow;
    mapView.delegate = self;
    mapView.showsScale = NO;
    mapView.showsCompass = NO;
    [mapView setZoomLevel:16.1 animated:NO];
    [self.view addSubview:mapView];
    self.mapView = mapView;
    
    [self loadSearchBar];
}
- (void)closeKeyBoard {
    if(self.searchBar.isFirstResponder) {
        [self.searchBar resignFirstResponder];
    }
}
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        <#statements#>
//    }
//    return self;
//}
-(void)backToCurrent{
    
    NSMutableArray *annotations = [NSMutableArray array];
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = cllocation2D;
    [annotations addObject:annotation];
    [_mapView showAnnotations:annotations edgePadding:UIEdgeInsetsZero animated:NO];
}

- (void)loadData {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = @([BaseData shareInstance].userId);
    params[@"BuildSowingType"] = @"BuildSowing_News_Find";
    params[@"Longitude"] = @(_mapView.centerCoordinate.longitude);
    params[@"Latitude"] = @(_mapView.centerCoordinate.latitude);
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        ZBLog(@"BuildSowing_News_Find--%@", res);
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            
            NSArray *dataArr = [res objectForKey:@"data"];
            if(!dataArr || dataArr.count == 0) {
                return ;
            }
            [self.models removeAllObjects];
            for (NSDictionary *data in dataArr) {
                ZhuBoModel *model = [[ZhuBoModel alloc] initWithDictionary:data];
                if([self.marks objectForKey:[NSString stringWithFormat:@"%ld", model.userId]] == nil){
                    [self.models addObject:model];
                }
            }
            [self loadMarks];
        }
        else{
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
    }];
}

- (void)loadMarks {
    NSMutableArray *annotations = [NSMutableArray array];
    for (ZhuBoModel *model in self.models){
        MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(model.latitude.floatValue, model.longitude.floatValue);
        [annotations addObject:annotation];
        [self.marks setObject:annotation forKey:[NSString stringWithFormat:@"%ld", model.userId]];
    }
    if(annotations.count > 0){
        [_mapView addAnnotations:annotations];
    }
}

#pragma mark - MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    [self closeKeyBoard];
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [self loadData];
}


- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    mapView.userTrackingMode =  MAUserTrackingModeNone;
    if ([annotation isKindOfClass:[MAPointAnnotation class]]){
        NSString *userId = nil;
        for(NSString *key in self.marks){
            if ([annotation isEqual: self.marks[key]]) {
                userId = key;
            }
        }
        if(userId == nil){
            return nil;
        }
        ZhuBoModel *zhuboModel;
        for (ZhuBoModel *zhubo in self.models) {
            if (zhubo.userId == userId.intValue) {
                zhuboModel = zhubo;
            }
        }
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:userId];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:userId];
            annotationView.image = [self synthesizeImageWith:zhuboModel.headImg];
            CGRect frame = annotationView.frame;
            frame.size.width = frame.size.width/2-10;
            frame.size.height = frame.size.height/2-10;
            annotationView.frame = frame;
            
            //设置中心点偏移，使得标注底部中间点成为经纬度对应点
            annotationView.centerOffset = CGPointMake(0, -18);
        }
        else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    if ([annotation isKindOfClass:[MAUserLocation class]])
    {
        NSString *userId = @"user";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:userId];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:userId];
            cllocation2D.longitude = annotation.coordinate.longitude;
            cllocation2D.latitude = annotation.coordinate.latitude;
            annotationView.image = [self synthesizeImageWith:[BaseData shareInstance].headImg];
            CGRect frame = annotationView.frame;
            frame.size.width = frame.size.width/2-10;
            frame.size.height = frame.size.height/2-10;
            annotationView.frame = frame;
            //设置中心点偏移，使得标注底部中间点成为经纬度对应点
            annotationView.centerOffset = CGPointMake(0, -18);
            annotationView.hidden =YES;
        }
        else {
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    if([view.reuseIdentifier isEqual:@"user"]) {
        return;
    }
    GrZhuYeViewController *userVC = [[GrZhuYeViewController alloc] init];
    userVC.userId = view.reuseIdentifier.integerValue;
    [self.navigationController pushViewController:userVC animated:YES];
}

#pragma mark - 合成图片 

- (UIImage *)synthesizeImageWith:(NSString *)url {
    UIImage * image1 = [UIImage imageNamed:@"location_other"];
    UIImage * image2 = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    UIImage *image3 = [self circleImage:image2 withParam:0];
    //尺寸放大一倍，保证清晰度
    CGSize size = {image1.size.width * 2, image1.size.height * 2};
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context,NO);
    [image1 drawInRect:CGRectMake(0, 0, size.width, size.height)];
    CGFloat w = size.width / 2;
    CGFloat x = size.width / 4;
    CGFloat y = size.width / 7;
    [image3 drawInRect:CGRectMake(x, y, w, w)];
    UIImage *resultingImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultingImage;
}
-(UIImage*)circleImage:(UIImage*) image withParam:(CGFloat) inset {
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context,NO);
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

//实现POI搜索对应的回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if(response.pois.count == 0)
    {
        return;
    }
    //通过 AMapPOISearchResponse 对象处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"count: %ld",response.count];
    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
    NSString *strPoi = @"";
    for (AMapPOI *p in response.pois) {
        strPoi = [NSString stringWithFormat:@"%@\nPOI: %@,%@,%@", strPoi, p.description,p.name,p.type];
    }
    NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strPoi];
    NSLog(@"Place: %@", result);
}


#pragma mark -- 代理方法
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"搜索Begin");
    
    [self.searchController.searchBar endEditing:YES];
    
    MapSearchViewController *mapSearchVC = [[MapSearchViewController alloc]initWithNibName:@"MapSearchViewController" bundle:nil];
    mapSearchVC.currentCity = _currentCity;
    mapSearchVC.currentLocation = _currentLocation;
    mapSearchVC.moveBlock = ^(AMapPOI *poi){
        self.currentPOI = poi;
        [self addAnnotation];
        NSMutableArray *annotations = [NSMutableArray array];
        MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(poi.location.latitude,poi.location.longitude);
        [annotations addObject:annotation];
        [_mapView showAnnotations:annotations edgePadding:UIEdgeInsetsZero animated:NO];
    };
    [self.navigationController pushViewController:mapSearchVC animated:YES];
    
    return NO;
}

//添加大头针
- (void)addAnnotation
{
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = _currentLocation.coordinate;
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(_currentPOI.location.latitude, _currentPOI.location.longitude);
    pointAnnotation.title = _currentPOI.name;
    [_mapView addAnnotation:pointAnnotation];
    
}


@end
