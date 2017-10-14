//
//  CircleToXiangViewController.m
//  zhubo
//
//  Created by Jin on 2017/7/14.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//


#import <AssetsLibrary/AssetsLibrary.h>
//#import <Photos/Photos.h>

#import "CircleToXiangViewController.h"


@interface CircleToXiangViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    UIImagePickerController *_imagePickerController;
    
}

@property (nonatomic,strong)NSMutableArray *mtArr;

@property (nonatomic,strong)NSMutableArray *AllImageArr;

@end

@implementation CircleToXiangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.468f];
    
    [self loadData];
    
    _AllImageArr = [NSMutableArray new];
    UIImage *image0 = [UIImage imageNamed:@"Photo"];
    [_AllImageArr addObject:image0];
    
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismissViewController];
}

- (void)loadData {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];;
    params[@"BuildSowingType"] = @"Guide_Imgs";
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            ZBLog(@"BuildSowing_SelectMyCircle--%@", res);
            NSArray *dataArr = [NSArray new];
            dataArr = [res objectForKey:@"data"];
            for (NSDictionary *dic in dataArr) {
                UIImageView *imageView = [[UIImageView alloc]init];
                [imageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"ImgHttpUrl"]]];
                [_AllImageArr addObject:imageView];
            }
            [self creadImageBut:_AllImageArr];
//            UIImage *image = [UIImage imageNamed:@"1"];
//            UIImage *image1 = [UIImage imageNamed:@"2"];
//            UIImage *image2 = [UIImage imageNamed:@"3"];
//            [_AllImageArr addObject:image];
//            [_AllImageArr addObject:image1];
//            [_AllImageArr addObject:image2];
        }
        else{
            [self creadImageBut:_AllImageArr];
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
    }];
}
- (void)getOriginalImages
{
    // 获得所有的自定义相簿
//    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
//    // 遍历所有的自定义相簿
//    for (PHAssetCollection *assetCollection in assetCollections) {
//        [self enumerateAssetsInAssetCollection:assetCollection original:YES];
//    }
//    // 获得相机胶卷
//    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
     //遍历相机胶卷,获取大图
//    [self enumerateAssetsInAssetCollection:cameraRoll original:YES];
}
//- (void)getThumbnailImages
//{
//    // 获得所有的自定义相簿
//    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
////    // 遍历所有的自定义相簿
//    for (PHAssetCollection *assetCollection in assetCollections) {
//        [self enumerateAssetsInAssetCollection:assetCollection original:NO];
//    }
//    // 获得相机胶卷
//    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
//    [self enumerateAssetsInAssetCollection:cameraRoll original:NO];
//}
/**
 * 遍历相簿中的所有图片
 * @param assetCollection 相簿
 * @param original    是否要原图
 */
- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original
{
    NSLog(@"相簿名:%@", assetCollection.localizedTitle);
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    // 获得某个相簿中的所有PHAsset对象
    //加入默认的3张图片
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    for (PHAsset *asset in assets) {
        // 是否要原图
        CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
        // 从asset中获得图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            [_AllImageArr addObject:result];
            NSLog(@"%@", result);
        }];
    }
    [self creadImageBut:_AllImageArr];
}

-(void)creadImageBut:(NSMutableArray *)sender{
    
    
    if (_AllImageArr.count >2) {
        for (int i =0; i <_AllImageArr.count ; i ++) {
            if (i == 0) {
                UIButton *but1111 = [[UIButton alloc]initWithFrame:CGRectMake(12, 12, 110, 110)];
                but1111.tag = i+1;
                UIImage *image = _AllImageArr[i];
                [but1111 setImage:image forState:UIControlStateNormal];
                [but1111 addTarget:self action:@selector(paizhaoAction:) forControlEvents:UIControlEventTouchDown];
                [self.scrollView addSubview:but1111];
            }else{
                UIButton *but1111 = [[UIButton alloc]initWithFrame:CGRectMake(110*i+12*i, 12, 110, 110)];
                but1111.tag = i+1;
//                UIImage *image = _AllImageArr[i];
//                [but1111 setImage:image forState:UIControlStateNormal];
                [but1111 addTarget:self action:@selector(bubbleViewTapAction:) forControlEvents:UIControlEventTouchDown];
                
                UIImageView *imageView = _AllImageArr[i];
                imageView.frame = CGRectMake(110*i+12*i, 12, 110, 110);
                [self.scrollView addSubview:imageView];
                [self.scrollView addSubview:but1111];
            }
        }
    }
    self.scrollView.contentSize = CGSizeMake(_AllImageArr.count*110+12*_AllImageArr.count, 135);
    self.scrollView.backgroundColor = [UIColor whiteColor];
}
-(void)bubbleViewTapAction:(UIButton *)sender{
    UIImageView *image = [_AllImageArr objectAtIndex:sender.tag-1];
    NSArray *imageArray = [NSArray arrayWithObject:image];
    [self.delegate jiequImage:imageArray];
    [self dismissViewController];
}
#pragma mark - 裁剪
-(void)jiequImage:(UIButton *)sender{
    
    UIImage *image = [_AllImageArr objectAtIndex:sender.tag-1];
    NSArray *imageArray = [NSArray arrayWithObject:image];
    [self.delegate jiequImage111:imageArray];
    [self dismissViewController];
}

-(void)paizhaoAction:(id)sender{
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
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    NSLog(@"选择完毕----image:%@-----info:%@",image,editingInfo);
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSArray *imageArray = [NSArray arrayWithObject:image];
    [self.delegate jiequImage111:imageArray];
    [self dismissViewController];
}

@end
