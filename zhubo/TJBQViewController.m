//
//  TJBQViewController.m
//  zhubo
//
//  Created by Jin on 2017/7/31.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "TJBQViewController.h"

#import "ZhuBoEditViewController.h"
#import "BQNRViewController.h"

#import "UIView+ZYTagView.h"
#import "ZYTagImageView.h"

#import "HVideoViewController.h"
#import "HomeViewController.h"


#import "UIImage+Color.h"
#import "UIImage+Rotate.h"
#import "UIImage+SubImage.h"
#import "UIImage+Gif.h"

#import "WPhotoViewController.h"


@interface TJBQViewController ()<ZYTagImageViewDelegate,BQNRViewControllerDelegate,HVideoViewControllerDelegate>{
    
    UIScrollView *scrollView;
    
    CGPoint point;
    UITapGestureRecognizer *tapGesture1;
    ZYTagView *zyTagView;
    
    NSInteger xzInt;
    BOOL paizhaoAndPaisheisB;
    
    NSMutableArray *muArrImage;
    UIImage *sltImagr;
}

@property (nonatomic,strong)NSMutableArray *addtagArray;// 数字中存放Dic,  Dic中存放image和标签Arr
@property (nonatomic,strong)NSMutableArray *addButArray;

@property (nonatomic, weak) ZYTagImageView *imageView;



@end

@implementation TJBQViewController

@synthesize prayelUrl;

- (void)viewWillAppear:(BOOL)animated {
    xzInt = 1;
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gohome) name:@"backView" object:nil];
}
-(void)gohome{
    _xiangceAndXiangjiBool = 1;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _addtagArray = [NSMutableArray new];
    _addButArray = [NSMutableArray new];
    
    scrollView = [self.view viewWithTag:11];

    UIButton *FHBut = [self.view viewWithTag:10];
    [FHBut addTarget:self action:@selector(bookView) forControlEvents:UIControlEventTouchDown];
    
    UIButton *TJBut = [self.view viewWithTag:12];
    [TJBut addTarget:self action:@selector(TJAction) forControlEvents:UIControlEventTouchDown];
    
    UIButton *xiayibuBut= [self.view viewWithTag:13];
    [xiayibuBut addTarget:self action:@selector(xiayibuAction) forControlEvents:UIControlEventTouchDown];
    
    
    if (prayelUrl == nil) {
        [self getImage:_selectImage];
    }else{
        [self geiPlayerUrl:prayelUrl.absoluteString image:_selectImage];
    }
    
    UIButton *xzBut = [self.view viewWithTag:120];
    [xzBut addTarget:self action:@selector(xzAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:xzBut];
}
-(void)bookView{
    if([_addtagArray count] == 9){
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:@"您确定要放弃所选择图片吗" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *AAfx = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self TJAction];
//            [self dismissViewControllerAnimated:YES completion:^{
//            }];
        }];
        [ac addAction:AAfx];
        UIAlertAction *AAsc1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [ac addAction:AAsc1];
        [self presentViewController:ac animated:NO completion:nil];
    }else if(paizhaoAndPaisheisB){
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:@"您确定要放弃所拍摄视频吗" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *AAfx = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self TJAction];
//            [self dismissViewControllerAnimated:YES completion:^{
//            }];
        }];
        [ac addAction:AAfx];
        UIAlertAction *AAsc1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [ac addAction:AAsc1];
        [self presentViewController:ac animated:NO completion:nil];
    }else{
        [self TJAction];
//        [self dismissViewControllerAnimated:YES completion:^{
//        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- 旋转
-(void)xzAction{
    
    NSDictionary *dic;
    BOOL b = NO;
    for (int i = 0; i < [_addtagArray count]; i++) {
        NSDictionary *dic11 = _addtagArray[i];
        if ([dic11 objectForKey:@"image"] == self.imageView.image) {
            dic = dic11;
            b = YES;
        }
    }
    if (b) {
        [_addtagArray removeObject:dic];
    }
    
    UIImage *image111 = [self.imageView.image rotate:UIImageOrientationRight];
    
    CGFloat ratio = (double)image111.size.height / (double)image111.size.width;
    CGFloat photoWidth = SCREEN_WIDTH;
    CGFloat photoHeight = SCREEN_WIDTH * ratio;
    
    if (photoHeight < SCREEN_HEIGHT) {
        self.imageView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
        self.imageView.bounds = CGRectMake(0, 0, photoWidth, photoHeight);
    }else {//长图的处理
        self.imageView.frame = CGRectMake(0, 0, photoWidth, photoHeight);
    }
    self.imageView.image = image111;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.tabBarController.tabBar.hidden = 0;
}

-(void)TJAction{//添加照片
    if (self.imageView.image == nil) {
        [self.player stopPlayer];
        [self.player removeFromSuperview];
        self.player = nil;
        self.prayelUrl = nil;
        HVideoViewController *ctrl = [[NSBundle mainBundle] loadNibNamed:@"HVideoViewController" owner:nil options:nil].lastObject;
        ctrl.delegate = self;
        ctrl.perAndFanhuiInt = 2;
        ctrl.addtagArrayCountInt = [_addtagArray count];
        ctrl.HSeconds = 30;//设置可录制最长时间
        [self presentViewController:ctrl animated:NO completion:nil];
    }else{
        if ([_addtagArray count] < 8) {
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:self.imageView.image forKey:@"image"];
            NSArray *arr = [self.imageView getAllTagInfos];
            [dic setObject:arr forKey:@"arr"];
            BOOL b = YES;
            for (int i = 0; i < [_addtagArray count]; i++) {
                NSDictionary *dic11 = _addtagArray[i];
                if ([dic11 objectForKey:@"image"] == self.imageView.image) {
                    [_addtagArray replaceObjectAtIndex:i withObject:dic];
                    b = NO;
                }
            }
            if (b) {
                [_addtagArray addObject:dic];
            }
            
            UIButton *xzBut = [self.view viewWithTag:120];
            [xzBut addTarget:self action:@selector(xzAction) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:xzBut];
            
            if (_xiangceAndXiangjiBool == 2) {
                muArrImage = [NSMutableArray array];
                WPhotoViewController *WphotoVC = [[WPhotoViewController alloc] init];
                //选择图片的最大数
                WphotoVC.delegate = self;
                WphotoVC.selectPhotoOfMax = 9-[_addtagArray count];
                WphotoVC.perAndFanhuiInt = 2;
                WphotoVC.addtagArrayCountInt = [_addtagArray count];
                [WphotoVC setSelectPhotosBack:^(NSMutableArray *phostsArr) {
                    muArrImage = phostsArr;
                    [self getImageArr:[[muArrImage objectAtIndex:0] objectForKey:@"image"] arr:muArrImage];
                }];
                [self presentViewController:WphotoVC animated:NO completion:nil];
            }else{
                HVideoViewController *ctrl = [[NSBundle mainBundle] loadNibNamed:@"HVideoViewController" owner:nil options:nil].lastObject;
                ctrl.delegate = self;
                ctrl.perAndFanhuiInt = 2;
                ctrl.xiangceAndXiangjiBool = self.xiangceAndXiangjiBool;
                ctrl.HSeconds = 30;//设置可录制最长时间
                ctrl.addtagArrayCountInt = [_addtagArray count];
                [self presentViewController:ctrl animated:NO completion:nil];
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"最多只能9张图片"];
            return;
        }
    }
}
#pragma mark --- HVideoViewControllerDelegate
- (void)geiPlayerUrl:(NSString *)url image:(UIImage *)image{
    for (UIButton *but in _addButArray) {
        [but removeFromSuperview];
    }
    [_addButArray removeAllObjects];
    
    if (prayelUrl == nil) {
        prayelUrl = [NSURL URLWithString:url];
    }
    paizhaoAndPaisheisB = YES;
    UIButton *xzBut = [self.view viewWithTag:120];
    xzBut.hidden = YES;
    
    UILabel *lal = [self.view viewWithTag:15];
    lal.text = @"点击视频任意位置添加标签";
    [self.view addSubview:lal];
    
    UIButton *but11 = [self.view viewWithTag:12];
    but11.hidden = YES;
    
    ZYTagImageView *imageView = [[ZYTagImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    imageView.delegate = self;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
//    imageView.image = image;
    sltImagr = image;
//    CGFloat ratio = (double)_selectImage.size.height / (double)_selectImage.size.width;
//    CGFloat photoWidth = SCREEN_WIDTH;
//    CGFloat photoHeight = SCREEN_WIDTH * ratio;
//    
//    if (photoHeight < SCREEN_HEIGHT) {
//        imageView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
//        imageView.bounds = CGRectMake(0, 0, photoWidth, photoHeight);
//    }else {//长图的处理
//        imageView.frame = CGRectMake(0, 0, photoWidth, photoHeight);
//    }
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    if (!self.player) {
        self.player = [[HAVPlayer alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withShowInView:self.imageView url:prayelUrl];
    } else {
        if (prayelUrl) {
            self.player.videoUrl = prayelUrl;
            self.player.hidden = NO;
        }
    }
    
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(5, 3, 30, 30)];
    [but setImage:image forState:UIControlStateNormal];
    [but addTarget:self action:@selector(selelctImageView:) forControlEvents:UIControlEventTouchDown];
    [scrollView addSubview:but];
    [_addButArray addObject:but];
    [_addtagArray removeAllObjects];
//    for (int i = 0; i < [_addtagArray count]; i++) {
//        NSDictionary *dic = _addtagArray[i];
//        UIButton *but1 = [[UIButton alloc]initWithFrame:CGRectMake((i+1)*30+(i+1+1)*5, 3, 30, 30)];
//        [but1 setImage:[dic objectForKey:@"image"] forState:UIControlStateNormal];
//        [but1 addTarget:self action:@selector(selelctImageView:) forControlEvents:UIControlEventTouchUpInside];
//        [scrollView addSubview:but1];
//        [_addButArray addObject:but1];
//    }
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width+(([_addtagArray count] +1)*35 - scrollView.frame.size.width), scrollView.frame.size.height);
    
    UIView *view = [self.view viewWithTag:100];
    [self.view addSubview:view];
    
    [self.view addSubview:lal];
}
#pragma mark -- 图片处理，不让图片变形
- (UIImage *)cutImage:(UIImage*)image imgViewWidth:(CGFloat)width imgViewHeight:(CGFloat)height{
    
    CGSize newSize;
    CGImageRef imageRef = nil;
    if ((image.size.width / image.size.height) < (width / height)) {
        newSize.width = image.size.width;
        newSize.height = image.size.width * height /width;
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
        
    } else {
        newSize.height = image.size.height;
        newSize.width = image.size.height * width / height;
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
    }
    return [UIImage imageWithCGImage:imageRef];
}

#pragma  mark -- 将图片添加到imageView上
- (void)getImageArr:(UIImage *)image arr:(NSMutableArray *)arr{
    _xiangceAndXiangjiBool = 2;
    self.imageMuArr = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        [self.imageMuArr addObject:dic];
    }
    [self getImage:image];
}
#pragma Mark -- 将图片添加到imageView上
- (void)getImage:(UIImage *)image{
    
    for (UIButton *but in _addButArray) {
        [but removeFromSuperview];
    }
    [_addButArray removeAllObjects];

    if ([_imageMuArr count] != 0 ) {
        _xiangceAndXiangjiBool = 2;
        for (NSDictionary *dic111 in _imageMuArr) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:[dic111 objectForKey:@"image"] forKey:@"image"];
            [dic setObject:@[] forKey:@"arr"];
            [_addtagArray addObject:dic];
        }
    }else{
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:image forKey:@"image"];
        [dic setObject:@[] forKey:@"arr"];
        BOOL isbool = [_addtagArray containsObject: dic];
        if (!isbool) {
            [_addtagArray addObject:dic];
        }
    }
    [_imageMuArr removeAllObjects];
    
    paizhaoAndPaisheisB = NO;
    UIButton *xzBut = [self.view viewWithTag:120];
    xzBut.hidden = NO;
    if (self.imageView == nil) {
        ZYTagImageView *imageView = [[ZYTagImageView alloc] initWithImage:_selectImage];
        imageView.delegate = self;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        CGFloat ratio = (double)_selectImage.size.height / (double)_selectImage.size.width;
        CGFloat photoWidth = SCREEN_WIDTH;
        CGFloat photoHeight = SCREEN_WIDTH * ratio;
        
        if (photoHeight < SCREEN_HEIGHT) {
            imageView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
            imageView.bounds = CGRectMake(0, 0, photoWidth, photoHeight);
        }else {//长图的处理
            imageView.frame = CGRectMake(0, 0, photoWidth, photoHeight);
        }
        [self.view addSubview:imageView];
        self.imageView = imageView;
    }else{
        [self.imageView removeAllTags];
        UIImage *iamge11 ;
        if ([_addtagArray count] > 0 ) {
            NSDictionary *dic = [_addtagArray lastObject];
            iamge11 = [dic objectForKey:@"image"];
            NSArray *arr = [dic objectForKey:@"arr"];
            [self.imageView addTagsWithTagInfoArray:arr];
        }
        CGFloat ratio = (double)iamge11.size.height / (double)iamge11.size.width;
        CGFloat photoWidth = SCREEN_WIDTH;
        CGFloat photoHeight = SCREEN_WIDTH * ratio;
        
        if (photoHeight < SCREEN_HEIGHT) {
            self.imageView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
            self.imageView.bounds = CGRectMake(0, 0, photoWidth, photoHeight);
        }else {//长图的处理
            self.imageView.frame = CGRectMake(0, 0, photoWidth, photoHeight);
        }
        self.imageView.image = iamge11;
        
    }
    
    for (int i = 0; i < [_addtagArray count]; i++) {
        NSDictionary *dic = _addtagArray[i];
        UIButton *but1 = [[UIButton alloc]initWithFrame:CGRectMake(i*30+(i+1)*5, 3, 30, 30)];
        [but1 setImage:[dic objectForKey:@"image"] forState:UIControlStateNormal];
        [but1 addTarget:self action:@selector(selelctImageView:) forControlEvents:UIControlEventTouchUpInside];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
        longPress.minimumPressDuration = 0.8; //定义按的时间
        [but1 addGestureRecognizer:longPress];
        [scrollView addSubview:but1];
        [_addButArray addObject:but1];
    }
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width+(([_addtagArray count] +1)*35 - scrollView.frame.size.width), scrollView.frame.size.height);
    
    UIView *view = [self.view viewWithTag:100];
    [self.view addSubview:view];
    
    UIView *add = [self.view viewWithTag:12];
    add.hidden = NO;
    
    UILabel *lal = [self.view viewWithTag:15];
    [self.view addSubview:lal];

}
-(void)btnLong:(UILongPressGestureRecognizer *)sender{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *AAsc = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        if ([_addButArray count] >1) {
            UIButton *but = (UIButton *)sender.view;
            NSDictionary *dic111 = [NSDictionary new];
            UIImage *imageqqqqq = but.imageView.image;
            for (NSDictionary *dic in _addtagArray) {
                if ([[dic objectForKey:@"image"] isEqual:imageqqqqq]) {
                    dic111 = dic;
                }
            }
            [_addtagArray removeObject:dic111];
            [self.imageView removeAllTags];
            if ([imageqqqqq isEqual:self.imageView.image]) {
                NSDictionary *dic = _addtagArray[0];
                self.imageView.image = [dic objectForKey:@"image"];
                NSArray *arr = [dic objectForKey:@"arr"];
                [self.imageView addTagsWithTagInfoArray:arr];
            }
            for (UIButton *but in _addButArray) {
                [but removeFromSuperview];
            }
            [_addButArray removeAllObjects];
            for (int i = 0; i < [_addtagArray count]; i++) {
                NSDictionary *dic = _addtagArray[i];
                UIButton *but1 = [[UIButton alloc]initWithFrame:CGRectMake(i*30+(i+1)*5, 3, 30, 30)];
                [but1 setImage:[dic objectForKey:@"image"] forState:UIControlStateNormal];
                [but1 addTarget:self action:@selector(selelctImageView:) forControlEvents:UIControlEventTouchUpInside];
                UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
                longPress.minimumPressDuration = 0.8; //定义按的时间
                [but1 addGestureRecognizer:longPress];
                [scrollView addSubview:but1];
                [_addButArray addObject:but1];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"至少保留一张图片"];
        }
    }];
    [ac addAction:AAsc];
    UIAlertAction *AAsc1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [ac addAction:AAsc1];
    [self presentViewController:ac animated:NO completion:nil];
    
}
-(void)onCancelAction{
    prayelUrl = [NSURL URLWithString:@""];
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:NO completion:^{
    }];
}

-(void)selelctImageView:(UIButton *)sender{
    if (prayelUrl != nil) {
        return;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:self.imageView.image forKey:@"image"];
    
    NSArray *arr11 = [self.imageView getAllTagInfos];
    [dic setObject:arr11 forKey:@"arr"];
    
    BOOL isbool = NO;
    for (NSDictionary *dic1111 in _addtagArray) {
        if ([dic1111 objectForKey:@"image"] == self.imageView.image) {
            isbool = YES;
        }
    }
    if (isbool) {
        for (int i = 0 ; i < [_addtagArray count]; i++) {
            NSDictionary *dic11 = _addtagArray[i];
            if ([dic11 objectForKey:@"image"] == self.imageView.image) {
                [_addtagArray replaceObjectAtIndex:i withObject:dic];
            }
        }
    }else{
        [_addtagArray addObject:dic];
    }
    [self.imageView removeAllTags];
    
    self.imageView.image = sender.imageView.image;
    CGFloat ratio = (double)sender.imageView.image.size.height / (double)sender.imageView.image.size.width;
    CGFloat photoWidth = SCREEN_WIDTH;
    CGFloat photoHeight = SCREEN_WIDTH * ratio;
    
    if (photoHeight < SCREEN_HEIGHT) {
        self.imageView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
        self.imageView.bounds = CGRectMake(0, 0, photoWidth, photoHeight);
    }else {//长图的处理
        self.imageView.frame = CGRectMake(0, 0, photoWidth, photoHeight);
    }
    NSArray *arr ;
    for (NSDictionary *dic in _addtagArray) {
        if (self.imageView.image == [dic objectForKey:@"image"]) {
            arr = [dic objectForKey:@"arr"];
        }
    }
    [self.imageView addTagsWithTagInfoArray:arr];
}
-(void)xiayibuAction{//到发布页面
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    if (prayelUrl != nil) {
        [dic setObject:sltImagr forKey:@"image"];
    }else{
        [dic setObject:self.imageView.image forKey:@"image"];
    }
    NSArray *arr = [self.imageView getAllTagInfos];
    [dic setObject:arr forKey:@"arr"];
    BOOL b = YES;
    for (int i = 0; i < [_addtagArray count]; i++) {
        NSDictionary *dic11 = _addtagArray[i];
        if ([dic11 objectForKey:@"image"] == self.imageView.image) {
            [_addtagArray replaceObjectAtIndex:i withObject:dic];
            b = NO;
        }
    }
    if (b) {
        [_addtagArray addObject:dic];
    }
    ZhuBoEditViewController *VC = [[ZhuBoEditViewController alloc]init];
    VC.news_And_Circle = @"1";
    if (prayelUrl != nil) {
        VC.prayelUrl = [NSString stringWithFormat:@"%@",prayelUrl];
    }
    VC.muTagInFoArr = _addtagArray;
    [self presentViewController:VC animated:NO completion:nil];
}
#pragma mark -- BQNRViewControllerDelegate
- (void)BQTextFStr:(NSDictionary *)info xgaihaishixinjian:(NSString *)str{
    
    if (str.intValue == 1) {
        [self.imageView  addTagWithTitle:[info objectForKey:@"title"] point:point object:info];
    }else{
        [zyTagView updateTitle:info];
    }
}
#pragma mark - ZYTagImageViewDelegate
- (void)tagImageView:(ZYTagImageView *)tagImageView activeTapGesture:(UITapGestureRecognizer *)tapGesture
{
    
    CGPoint tapPoint = [tapGesture locationInView:tagImageView];
//    tapPoint.y = tapPoint.y+tagImageView.frame.origin.y;
    point = tapPoint;
    NSArray *arr = [tagImageView getAllTagInfos];
    if ([arr count] >5) {
        [SVProgressHUD showErrorWithStatus:@"最多添加6个标签"];;
        return;
    }else{
        BQNRViewController *vc = [[BQNRViewController alloc]init];
        vc.delegate = self;
        vc.str = @"1";
        [self presentViewController:vc animated:NO completion:nil];
    }
}

- (void)tagImageView:(ZYTagImageView *)tagImageView tagViewActiveTapGesture:(ZYTagView *)tagView
{
    /** 可自定义点击手势的反馈 */
    if (tagView.isEditEnabled) {
        NSLog(@"编辑模式 -- 轻触");
        zyTagView = tagView;
        BQNRViewController *vc = [[BQNRViewController alloc]init];
        vc.delegate = self;
        vc.str = @"2";
        [self presentViewController:vc animated:NO completion:nil];
        
    }else{
        NSLog(@"预览模式 -- 轻触");
    }
}

- (void)tagImageView:(ZYTagImageView *)tagImageView tagViewActiveLongPressGesture:(ZYTagView *)tagView
{
    /** 可自定义长按手势的反馈 */
    if (tagView.isEditEnabled) { //长按删除
        if ([_addtagArray count] == 0) {
            [tagView switchDeleteState];
        }else{
            [tagView switchDeleteState];
        }
    }else{
        NSLog(@"预览模式 -- 长按");
    }
}


#pragma mark - WPhotoViewControllerDelegate
- (void)getWPHPlayerUrl:(NSString *)url image:(UIImage *)image{
    [self geiPlayerUrl:url image:image];
}
- (void)getWPHImage:(UIImage *)image{
    [self getImage:image];
}


@end
