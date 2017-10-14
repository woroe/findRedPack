//
//  HVideoViewController.m
//  Join
//
//  Created by 黄克瑾 on 2017/1/11.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import "HVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "HAVPlayer.h"
#import "HProgressView.h"
#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "WPhotoViewController.h"

#import "Utility.h"
#import "NewGCViewController.h"


typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);
@interface HVideoViewController ()<AVCaptureFileOutputRecordingDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    UIImagePickerController *_imagePickerController;
    
    AVCaptureVideoOrientation videoOrientation ;
    
    NSMutableArray *muArrImage;
}

//轻触拍照，按住摄像
@property (strong, nonatomic) IBOutlet UILabel *labelTipTitle;

//视频输出流
@property (strong,nonatomic) AVCaptureMovieFileOutput *captureMovieFileOutput;
//图片输出流
//@property (strong,nonatomic) AVCaptureStillImageOutput *captureStillImageOutput;//照片输出流
//负责从AVCaptureDevice获得输入数据
@property (strong,nonatomic) AVCaptureDeviceInput *captureDeviceInput;
//后台任务标识
@property (assign,nonatomic) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@property (assign,nonatomic) UIBackgroundTaskIdentifier lastBackgroundTaskIdentifier;

@property (weak, nonatomic) IBOutlet UIImageView *focusCursor; //聚焦光标

//@property(nonatomic, strong) CLLocationManager *motionManager;

//负责输入和输出设备之间的数据传递
@property(nonatomic)AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;
//预览层view
@property (weak, nonatomic) IBOutlet UIView *videoView;

@property (strong, nonatomic) IBOutlet UIButton *btnBack;
//重新录制
@property (strong, nonatomic) IBOutlet UIButton *btnAfresh;
//确定
@property (strong, nonatomic) IBOutlet UIButton *btnEnsure;
//摄像头切换
@property (strong, nonatomic) IBOutlet UIButton *btnCamera;

@property (strong, nonatomic) IBOutlet UIImageView *bgView;
//记录录制的时间 默认最大60秒
@property (assign, nonatomic) NSInteger seconds;

//记录需要保存视频的路径
@property (strong, nonatomic) NSURL *saveVideoUrl;

//是否在对焦
@property (assign, nonatomic) BOOL isFocus;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *afreshCenterX;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ensureCenterX;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *backCenterX;

//视频播放
@property (strong, nonatomic) HAVPlayer *player;

@property (strong, nonatomic) IBOutlet HProgressView *progressView;

//是否是摄像 YES 代表是录制  NO 表示拍照
@property (assign, nonatomic) BOOL isVideo;

@property (strong, nonatomic) UIImage *takeImage;
@property (strong, nonatomic) UIImageView *takeImageView;
@property (strong, nonatomic) IBOutlet UIImageView *imgRecord;
@property (nonatomic)UIView *focusView;


@property (strong ,nonatomic) NSString *videoMp4Url;

@end

//时间大于这个就是视频，否则为拍照
#define TimeMax 1

@implementation HVideoViewController


-(void)dealloc{
    [self removeNotification];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isBool = YES;
    muArrImage = [NSMutableArray array];
    
    UIImage *image = [UIImage imageNamed:@"sc_btn_take.png"];
    self.backCenterX.constant = -(SCREEN_WIDTH/2/2)-image.size.width/2/2;
    
    self.progressView.layer.cornerRadius = self.progressView.frame.size.width/2;
    self.bgView.contentMode = UIViewContentModeScaleAspectFit;
    
    if (self.HSeconds == 0) {
        self.HSeconds = 60;
    }
    
    [self performSelector:@selector(hiddenTipsLabel) withObject:nil afterDelay:4];
    
    UIView *view = [self.view viewWithTag:100];
    view.hidden = NO;
    
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
    videoOrientation = AVCaptureVideoOrientationPortrait;
    
    self.imgRecord.hidden = NO; //hVideo_take
    self.imgRecord.backgroundColor = [UIColor whiteColor];
    self.imgRecord.layer.cornerRadius = self.imgRecord.frame.size.width/2.0;
    self.imgRecord.layer.masksToBounds = YES;
    self.progressView.hidden = NO;
    
    _focusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    _focusView.layer.borderWidth = 1.0;
    _focusView.layer.borderColor =[UIColor yellowColor].CGColor;
    _focusView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_focusView];
    _focusView.hidden = YES;
}

- (void)hiddenTipsLabel {
    //    self.labelTipTitle.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    if ([muArrImage count] >0) {
        [self.delegate getImageArr:[[muArrImage objectAtIndex:0] objectForKey:@"image"] arr:muArrImage];
        [self dismissViewControllerAnimated:YES completion:^{
            [Utility hideProgressDialog];
        }];
        
    }
    if (self.session == nil) {
        [self customCamera];
    }
    [self.session startRunning];
    
}

//-(BOOL)prefersStatusBarHidden{
//    return YES;// 返回YES表示隐藏，返回NO表示显示
//}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.session stopRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if ([muArrImage count]>0) {
        [self wangcheng:muArrImage];
    }
}

- (void)customCamera {
    
    //初始化会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc] init];
    //设置分辨率 (设备支持的最高分辨率)
    if ([self.session canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        self.session.sessionPreset = AVCaptureSessionPresetInputPriority;
    }
    //取得后置摄像头
    AVCaptureDevice *captureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
    //添加一个音频输入设备
    AVCaptureDevice *audioCaptureDevice=[[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    
    //初始化输入设备
    NSError *error = nil;
    self.captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    if (error) {
        ZBLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    //添加音频
    error = nil;
    AVCaptureDeviceInput *audioCaptureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:audioCaptureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    
    //输出对象
    self.captureMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];//视频输出
    //将输入设备添加到会话
    if ([self.session canAddInput:self.captureDeviceInput]) {
        [self.session addInput:self.captureDeviceInput];
        [self.session addInput:audioCaptureDeviceInput];
        //设置视频防抖
        AVCaptureConnection *connection = [self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([connection isVideoStabilizationSupported]) {
            connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeCinematic;
        }
    }
    
    //将输出设备添加到会话 (刚开始 是照片为输出对象)
    if ([self.session canAddOutput:self.captureMovieFileOutput]) {
        [self.session addOutput:self.captureMovieFileOutput];
    }
    //创建视频预览层，用于实时展示摄像头状态
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;//填充模式
    
    //    [self.previewLayer removeFromSuperlayer];
    [self.bgView.layer addSublayer:self.previewLayer];
    [self addNotificationToCaptureDevice:captureDevice];
    
    [self addGenstureRecognizer];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.previewLayer.frame = self.videoView.frame;
}

#pragma mark - Private methods
// 调整设备取向
- (AVCaptureVideoOrientation)currentVideoOrientation{
    AVCaptureVideoOrientation orientation;
    switch (videoOrientation) {
        case UIDeviceOrientationPortrait:
            orientation = AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationLandscapeRight:
            orientation = AVCaptureVideoOrientationLandscapeLeft;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            orientation = AVCaptureVideoOrientationPortraitUpsideDown;
            break;
        default:
            orientation = AVCaptureVideoOrientationLandscapeRight;
            break;
    }
    return orientation;
}
// 旋转视频方向
- (CGAffineTransform)transformFromCurrentVideoOrientationToOrientation:(AVCaptureVideoOrientation)orientation
{
    
    CGFloat orientationAngleOffset = [self angleOffsetFromPortraitOrientationToOrientation:orientation];
    CGFloat videoOrientationAngleOffset = [self angleOffsetFromPortraitOrientationToOrientation:videoOrientation];
    CGFloat angleOffset;
    if (_captureDeviceInput.device.position == AVCaptureDevicePositionBack) {
        angleOffset = orientationAngleOffset - videoOrientationAngleOffset;
    }
    else{
        angleOffset = videoOrientationAngleOffset - orientationAngleOffset + M_PI_2;
    }
    CGAffineTransform transform = CGAffineTransformMakeRotation(angleOffset);
    return transform;
}

- (CGFloat)angleOffsetFromPortraitOrientationToOrientation:(AVCaptureVideoOrientation)orientation
{
    CGFloat angle = 0.0;
    switch (orientation)
    {
        case AVCaptureVideoOrientationPortrait:
            angle = 0.0;
            break;
        case AVCaptureVideoOrientationPortraitUpsideDown:
            angle = M_PI;
            break;
        case AVCaptureVideoOrientationLandscapeRight:
            angle = -M_PI_2;
            break;
        case AVCaptureVideoOrientationLandscapeLeft:
            angle = M_PI_2;
            break;
        default:
            break;
    }
    return angle;
}

#pragma mark -- 打开相册
- (IBAction)offXiangCeAction:(id)sender {
    
    [muArrImage removeAllObjects];
    [self changeLayout];
    [self removeNotification];
    [self recoverLayout];
    [Utility hideProgressDialog];
    if (_isBool) {
        WPhotoViewController *WphotoVC = [[WPhotoViewController alloc] init];
        //选择图片的最大数
        WphotoVC.selectPhotoOfMax = 9-_addtagArrayCountInt;
        WphotoVC.perAndFanhuiInt = _perAndFanhuiInt;
        [WphotoVC setSelectPhotosBack:^(NSMutableArray *phostsArr) {
            muArrImage = [NSMutableArray array];
            for (NSDictionary *dic in phostsArr) {
                [muArrImage  addObject:dic];
            }
        }];
        [self presentViewController:WphotoVC animated:YES completion:nil];
    }else{
        [self onCancelAction:nil];
    }
    
}
-(void)wangcheng:(NSMutableArray *)arr{
    self.takeImage = [[arr objectAtIndex:0] objectForKey:@"image"];
    if (_perAndFanhuiInt == 1) {
        TJBQViewController *vc = [[TJBQViewController alloc]init];
        vc.imageMuArr = arr;
        vc.selectImage = self.takeImage;
        [self presentViewController:vc animated:YES completion:^{
            [Utility hideProgressDialog];
        }];
    }else{
        [self.delegate getImage:self.takeImage];
        [self dismissViewControllerAnimated:YES completion:^{
            [Utility hideProgressDialog];
        }];
    }
}

//发布广场
- (IBAction)goNewGCAction:(UIButton *)sender {
    NewGCViewController *vc = [[NewGCViewController alloc]init];
    //    [self.navigationController pushViewController:vc animated:YES];
    [self presentViewController:vc animated:YES completion:^{
        [Utility hideProgressDialog];
    }];
}


#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    NSLog(@"选择完毕----image:%@-----info:%@",image,editingInfo);
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.takeImage = image;
    if (_perAndFanhuiInt == 1) {
        TJBQViewController *vc = [[TJBQViewController alloc]init];
        vc.selectImage = self.takeImage;
        [self presentViewController:vc animated:YES completion:^{
            [Utility hideProgressDialog];
        }];
    }else{
        [self.delegate getImage:self.takeImage];
        [self dismissViewControllerAnimated:YES completion:^{
            [Utility hideProgressDialog];
        }];
    }
}

#pragma mark -- 取消
- (IBAction)onCancelAction:(UIButton *)sender {
    [self.delegate onCancelAction];
    [self dismissViewControllerAnimated:YES completion:^{
        [Utility hideProgressDialog];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([[touches anyObject] view] == self.imgRecord) {
        ZBLog(@"开始录制");
        //根据设备输出获得连接
        AVCaptureConnection *connection = [self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeAudio];
        //根据连接取得设备输出的数据
        if (![self.captureMovieFileOutput isRecording]) {
            //如果支持多任务则开始多任务
            if ([[UIDevice currentDevice] isMultitaskingSupported]) {
                self.backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
            }
            if (self.saveVideoUrl) {
                [[NSFileManager defaultManager] removeItemAtURL:self.saveVideoUrl error:nil];
            }
            //预览图层和视频方向保持一致
            connection.videoOrientation = [self.previewLayer connection].videoOrientation;
            NSString *outputFielPath=[NSTemporaryDirectory() stringByAppendingString:@"myMovie.mov"];
            NSLog(@"save path is :%@",outputFielPath);
            NSURL *fileUrl=[NSURL fileURLWithPath:outputFielPath];
            NSLog(@"fileUrl:%@",fileUrl);
            [self.captureMovieFileOutput startRecordingToOutputFileURL:fileUrl recordingDelegate:self];
        } else {
            [self.captureMovieFileOutput stopRecording];
        }
    }
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([[touches anyObject] view] == self.imgRecord) {
        ZBLog(@"结束触摸");
        if (!self.isVideo) {
            [self performSelector:@selector(endRecord) withObject:nil afterDelay:0.3];
        } else {
            [self endRecord];
        }
    }
}

- (void)endRecord {
    [self.captureMovieFileOutput stopRecording];//停止录制
}

- (IBAction)onAfreshAction:(UIButton *)sender {
    ZBLog(@"重新录制");
    [self recoverLayout];
}

#pragma mark -- 确定 这里进行保存或者发送出去
- (IBAction)onEnsureAction:(UIButton *)sender {
    ZBLog(@"确定 这里进行保存或者发送出去");
    if (self.saveVideoUrl) {
        WS(weakSelf)
        [Utility showProgressDialogText:@"视频处理中..."];
        ALAssetsLibrary *assetsLibrary=[[ALAssetsLibrary alloc]init];
        [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:self.saveVideoUrl completionBlock:^(NSURL *assetURL, NSError *error) {
            ZBLog(@"outputUrl:%@",weakSelf.saveVideoUrl);
            if (weakSelf.lastBackgroundTaskIdentifier!= UIBackgroundTaskInvalid) {
                [[UIApplication sharedApplication] endBackgroundTask:weakSelf.lastBackgroundTaskIdentifier];
            }
            if (error) {
                ZBLog(@"保存视频到相簿过程中发生错误，错误信息：%@",error.localizedDescription);
            } else {
                if (weakSelf.takeBlock) {
                    weakSelf.takeBlock(assetURL);
                }
                
                if (_videoMp4Url == nil) {
                    [SVProgressHUD showSuccessWithStatus:@"视频处理中请稍后！"];
                }else{
                    [Utility hideProgressDialog];
                    [self recoverLayout];
                    if (_perAndFanhuiInt == 1) {
                        TJBQViewController *vc = [[TJBQViewController alloc]init];
                        vc.prayelUrl = [NSURL URLWithString:_videoMp4Url];
                        vc.selectImage = self.takeImage;
                        vc.xiangceAndXiangjiBool = 1;
                        [self presentViewController:vc animated:YES completion:^{
                            [Utility hideProgressDialog];
                        }];
                    }else{
                        if (!_isBool) {
                            [self.delegate geiPlayerUrl:_videoMp4Url image:self.takeImage];
                            [Utility hideProgressDialog];
                            UIViewController *vc =self.presentingViewController;
                            while (![vc isKindOfClass:[TJBQViewController class]]) {
                                vc = vc.presentingViewController;
                            }
                            [vc dismissViewControllerAnimated:YES completion:nil];
                        }else{
                            [self.delegate geiPlayerUrl:_videoMp4Url image:self.takeImage];
                            [self dismissViewControllerAnimated:YES completion:^{
                                [Utility hideProgressDialog];
                            }];
                        }
                    }
                }
            }
        }];
    } else {
        //照片
        UIImageWriteToSavedPhotosAlbum(self.takeImage, self, nil, nil);
        if (self.takeBlock) {
            self.takeBlock(self.takeImage);
        }
        [self recoverLayout];
        if (_perAndFanhuiInt == 1) {
            TJBQViewController *vc = [[TJBQViewController alloc]init];
            vc.selectImage = self.takeImage;
            vc.xiangceAndXiangjiBool = 1;
            [self presentViewController:vc animated:YES completion:^{
                [Utility hideProgressDialog];
            }];
        }else{
            if (!_isBool) {
                [self.delegate getImage:self.takeImage];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"backView" object:nil];
                [Utility hideProgressDialog];
                UIViewController *vc =self.presentingViewController;
                while (![vc isKindOfClass:[TJBQViewController class]]) {
                    vc = vc.presentingViewController;
                }
                [vc dismissViewControllerAnimated:YES completion:nil];
            }else{
                [self.delegate getImage:self.takeImage];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"backView" object:nil];
                [self dismissViewControllerAnimated:YES completion:^{
                    [Utility hideProgressDialog];
                }];
            }
        }
    }
}

//前后摄像头的切换
- (IBAction)onCameraAction:(UIButton *)sender {
    ZBLog(@"切换摄像头");
    AVCaptureDevice *currentDevice=[self.captureDeviceInput device];
    AVCaptureDevicePosition currentPosition=[currentDevice position];
    [self removeNotificationFromCaptureDevice:currentDevice];
    AVCaptureDevice *toChangeDevice;
    AVCaptureDevicePosition toChangePosition = AVCaptureDevicePositionFront;//前
    if (currentPosition == AVCaptureDevicePositionUnspecified || currentPosition == AVCaptureDevicePositionFront) {
        toChangePosition = AVCaptureDevicePositionBack;//后
    }
    toChangeDevice=[self getCameraDeviceWithPosition:toChangePosition];
    [self addNotificationToCaptureDevice:toChangeDevice];
    //获得要调整的设备输入对象
    AVCaptureDeviceInput *toChangeDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:toChangeDevice error:nil];
    
    //改变会话的配置前一定要先开启配置，配置完成后提交配置改变
    [self.session beginConfiguration];
    //移除原有输入对象
    [self.session removeInput:self.captureDeviceInput];
    //添加新的输入对象
    if ([self.session canAddInput:toChangeDeviceInput]) {
        [self.session addInput:toChangeDeviceInput];
        self.captureDeviceInput = toChangeDeviceInput;
    }
    //提交会话配置
    [self.session commitConfiguration];
}

- (void)onStartTranscribe:(NSURL *)fileURL {
    if ([self.captureMovieFileOutput isRecording]) {
        -- self.seconds;
        if (self.seconds > 0) {
            if (self.HSeconds - self.seconds >= TimeMax && !self.isVideo) {
                self.isVideo = YES;//长按时间超过TimeMax 表示是视频录制
                self.progressView.timeMax = self.seconds;
            }
            [self performSelector:@selector(onStartTranscribe:) withObject:fileURL afterDelay:1.0];
        } else {
            if ([self.captureMovieFileOutput isRecording]) {
                [self.captureMovieFileOutput stopRecording];
            }
        }
    }
}


#pragma mark - 视频输出代理
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections{
    ZBLog(@"开始录制...");
    self.seconds = self.HSeconds;
    [self performSelector:@selector(onStartTranscribe:) withObject:fileURL afterDelay:1.0];
}
//获得视频存放地址
- (NSString *)getVideoCachePath {
    // 保存至沙盒
    NSString *videoCache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) lastObject];
    // 创建文件夹
    [self creatDir:[videoCache stringByAppendingString:@"/smallVideo"]];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:videoCache isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) ) {
        [fileManager createDirectoryAtPath:videoCache withIntermediateDirectories:YES attributes:nil error:nil];
    };
    videoCache = [videoCache stringByAppendingString:@"/smallVideo"];
    return videoCache;
}

- (NSString *)getUploadFile_type:(NSString *)type fileType:(NSString *)fileType {
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyMMddHHmmss"];
    NSDate * NowDate = [NSDate dateWithTimeIntervalSince1970:now];
    ;
    NSString * timeStr = [formatter stringFromDate:NowDate];
    NSString *fileName = [NSString stringWithFormat:@"%@.%@",timeStr,fileType];
    return fileName;
}
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
#pragma mark -- 拍摄录制完成
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    ZBLog(@"视频录制完成.");
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"拍摄失败，请重新拍摄"];
        return;
    }
    [self changeLayout];
    if (self.isVideo) {
        [self cutVideoWithVideoUrl:outputFileURL];
        [self videoHandlePhoto:outputFileURL];
    } else {
        //照片
        self.saveVideoUrl = nil;
        [self videoHandlePhoto:outputFileURL];
    }
}

- (void)cutVideoWithVideoUrl:(NSURL *)videoUrl
{
    AVMutableComposition *composition = [[AVMutableComposition alloc] init];
    CMTime totalDuration = kCMTimeZero;
    AVAsset *asset = [AVAsset assetWithURL:videoUrl];
    AVAssetTrack *videoAssetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    
    AVMutableCompositionTrack *audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:[[asset tracksWithMediaType:AVMediaTypeAudio] firstObject] atTime:kCMTimeZero error:nil];
    AVMutableCompositionTrack *videoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:videoAssetTrack atTime:kCMTimeZero error:nil];
    
    AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    totalDuration = CMTimeAdd(totalDuration, asset.duration);
    
    
    CGSize renderSize = CGSizeMake(0, 0);
    renderSize.width = MAX(renderSize.width, videoAssetTrack.naturalSize.height);
    renderSize.height = MAX(renderSize.height, videoAssetTrack.naturalSize.width);
    CGFloat renderW = MIN(renderSize.width, renderSize.height);
    CGFloat rate;
    rate = renderW / MIN(videoAssetTrack.naturalSize.width, videoAssetTrack.naturalSize.height);
    
    CGAffineTransform layerTransform = CGAffineTransformMake(videoAssetTrack.preferredTransform.a, videoAssetTrack.preferredTransform.b, videoAssetTrack.preferredTransform.c, videoAssetTrack.preferredTransform.d, videoAssetTrack.preferredTransform.tx * rate, videoAssetTrack.preferredTransform.ty * rate);
    
    
    
    layerTransform = CGAffineTransformConcat(layerTransform, CGAffineTransformMake(1, 0, 0, 1, 0, -(videoAssetTrack.naturalSize.width - videoAssetTrack.naturalSize.height) / 2.0));
    layerTransform = CGAffineTransformScale(layerTransform, rate, rate);
    [layerInstruction setTransform:layerTransform atTime:kCMTimeZero];
    [layerInstruction setOpacity:0.0 atTime:totalDuration];
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, totalDuration);
    instruction.layerInstructions = @[layerInstruction];
    AVMutableVideoComposition *mainComposition = [AVMutableVideoComposition videoComposition];
    mainComposition.instructions = @[instruction];
    mainComposition.frameDuration = CMTimeMake(1, 30);
    //导出视频尺寸
    mainComposition.renderSize = CGSizeMake(renderW, renderW);
    
    NSString * basePath=[self getVideoCachePath];
    
    NSString *videoPath = [basePath stringByAppendingPathComponent:[self getUploadFile_type:@"" fileType:@"mp4"]];
    // 导出视频
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetMediumQuality];
    exporter.videoComposition = mainComposition;
    exporter.outputURL = [NSURL fileURLWithPath:videoPath];
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        NSURL *url = [NSURL fileURLWithPath:videoPath];
        self.saveVideoUrl = url;
        dispatch_async(dispatch_get_main_queue(), ^{
            _videoMp4Url = [NSString stringWithFormat:@"%@",url];
            [self.previewLayer removeFromSuperlayer];
            if (!self.player) {
                self.player = [[HAVPlayer alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withShowInView:self.bgView url:url];
            } else {
                if (videoUrl) {
                    self.player.videoUrl = url;
                    self.player.hidden = NO;
                }
            }
            
        });
    }];
    
}

- (void)videoHandlePhoto:(NSURL *)url {
    AVURLAsset *urlSet = [AVURLAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlSet];
    imageGenerator.appliesPreferredTrackTransform = YES;    // 截图的时候调整到正确的方向
    NSError *error = nil;
    CMTime time = CMTimeMake(0,30);//缩略图创建时间 CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要获取某一秒的第几帧可以使用CMTimeMake方法)
    CMTime actucalTime; //缩略图实际生成的时间
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:&actucalTime error:&error];
    if (error) {
        ZBLog(@"截取视频图片失败:%@",error.localizedDescription);
    }
    CMTimeShow(actucalTime);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    if (image) {
        ZBLog(@"视频截取成功");
    } else {
        ZBLog(@"视频截取失败");
    }
    CGSize newSize;
    float width = SCREEN_WIDTH;
    float height = SCREEN_WIDTH;
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
    image =  [UIImage imageWithCGImage:imageRef];
    
    //    [self.previewLayer removeFromSuperlayer];
    self.takeImage = image;
    //    self.bgView.image = image;
}
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
#pragma mark - 通知
//注册通知
- (void)setupObservers
{
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationWillResignActiveNotification object:[UIApplication sharedApplication]];
}

//进入后台就退出视频录制
- (void)applicationDidEnterBackground:(NSNotification *)notification {
    //    [self onCancelAction:nil];
    [self dismissViewControllerAnimated:YES completion:^{
        [Utility hideProgressDialog];
    }];
}

/**
 *  给输入设备添加通知
 */
-(void)addNotificationToCaptureDevice:(AVCaptureDevice *)captureDevice{
    //注意添加区域改变捕获通知必须首先设置设备允许捕获
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        captureDevice.subjectAreaChangeMonitoringEnabled=YES;
    }];
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    //捕获区域发生改变
    [notificationCenter addObserver:self selector:@selector(areaChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}
-(void)removeNotificationFromCaptureDevice:(AVCaptureDevice *)captureDevice{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}
/**
 *  移除所有通知
 */
-(void)removeNotification{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

-(void)addNotificationToCaptureSession:(AVCaptureSession *)captureSession{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    //会话出错
    [notificationCenter addObserver:self selector:@selector(sessionRuntimeError:) name:AVCaptureSessionRuntimeErrorNotification object:captureSession];
}

/**
 *  设备连接成功
 *
 *  @param notification 通知对象
 */
-(void)deviceConnected:(NSNotification *)notification{
    NSLog(@"设备已连接...");
}
/**
 *  设备连接断开
 *
 *  @param notification 通知对象
 */
-(void)deviceDisconnected:(NSNotification *)notification{
    NSLog(@"设备已断开.");
}
/**
 *  捕获区域改变
 *
 *  @param notification 通知对象
 */
-(void)areaChange:(NSNotification *)notification{
    NSLog(@"捕获区域改变...");
}

/**
 *  会话出错
 *
 *  @param notification 通知对象
 */
-(void)sessionRuntimeError:(NSNotification *)notification{
    NSLog(@"会话发生错误.");
}



/**
 *  取得指定位置的摄像头
 *
 *  @param position 摄像头位置
 *
 *  @return 摄像头设备
 */
-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position] == position) {
            return camera;
        }
    }
    return nil;
}

/**
 *  改变设备属性的统一操作方法
 *
 *  @param propertyChange 属性改变操作
 */
-(void)changeDeviceProperty:(PropertyChangeBlock)propertyChange{
    AVCaptureDevice *captureDevice= [self.captureDeviceInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        //自动白平衡
        if ([captureDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
            [captureDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
        }
        //自动根据环境条件开启闪光灯
        if ([captureDevice isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [captureDevice setFlashMode:AVCaptureFlashModeAuto];
        }
        
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    }else{
        NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}

/**
 *  设置闪光灯模式
 *
 *  @param flashMode 闪光灯模式
 */
-(void)setFlashMode:(AVCaptureFlashMode )flashMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFlashModeSupported:flashMode]) {
            [captureDevice setFlashMode:flashMode];
        }
    }];
}

/**
 *  设置聚焦模式
 *
 *  @param focusMode 聚焦模式
 */
-(void)setFocusMode:(AVCaptureFocusMode )focusMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
    }];
}
/**
 *  设置曝光模式
 *
 *  @param exposureMode 曝光模式
 */
-(void)setExposureMode:(AVCaptureExposureMode)exposureMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:exposureMode];
        }
    }];
}
/**
 *  设置聚焦点
 *
 *  @param point 聚焦点
 */
-(void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        
        NSError *error;
        //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
        if ([captureDevice lockForConfiguration:&error]) {
            if ([captureDevice isFocusPointOfInterestSupported]) {
                [captureDevice setFocusPointOfInterest:point];
            }
            if ([captureDevice isExposurePointOfInterestSupported]) {
                [captureDevice setExposurePointOfInterest:point];
            }
            if ([captureDevice isExposureModeSupported:exposureMode]) {
                [captureDevice setExposureMode:exposureMode];
            }
            if ([captureDevice isFocusModeSupported:focusMode]) {
                [captureDevice setFocusMode:focusMode];
            }
            [captureDevice unlockForConfiguration];
        }else{
            NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
        }
    }];
}

/**
 *  添加点按手势，点按时聚焦
 */
-(void)addGenstureRecognizer{
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen:)];
    [self.bgView addGestureRecognizer:tapGesture];
}

-(void)tapScreen:(UITapGestureRecognizer *)tapGesture{
    if ([self.session isRunning]) {
        CGPoint point= [tapGesture locationInView:self.bgView];
        //将UI坐标转化为摄像头坐标
        CGPoint cameraPoint= [self.previewLayer captureDevicePointOfInterestForPoint:point];
        [self setFocusCursorWithPoint:point];
        [self focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposureMode:AVCaptureExposureModeContinuousAutoExposure atPoint:cameraPoint];
    }
}

/**
 *  设置聚焦光标位置
 *
 *  @param point 光标位置
 */
-(void)setFocusCursorWithPoint:(CGPoint)point{
    if (!self.isFocus) {
        self.isFocus = YES;
        _focusView.center = point;
        _focusView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                _focusView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                _focusView.hidden = YES;
                self.isFocus = NO;
            }];
        }];
    }
}

//拍摄完成时调用
- (void)changeLayout {
    UIView *view = [self.view viewWithTag:100];
    view.hidden = YES;
    UILabel *lal = [self.view viewWithTag:101];
    lal.hidden = YES;
    self.imgRecord.hidden = NO;
    self.btnCamera.hidden = YES;
    self.btnAfresh.hidden = NO;
    self.btnEnsure.hidden = NO;
    self.btnBack.hidden = YES;
    if (self.isVideo) {
        [self.progressView clearProgress];
    }
    
    self.afreshCenterX.constant = -(SCREEN_WIDTH/2/2);
    self.ensureCenterX.constant = SCREEN_WIDTH/2/2;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    self.lastBackgroundTaskIdentifier = self.backgroundTaskIdentifier;
    self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    [self.session stopRunning];
}
#pragma mark -- 重新拍摄时调用
- (void)recoverLayout {
    
    [self.bgView.layer addSublayer:self.previewLayer];
    
    //    self.previewLayer.hidden = NO;
    self.progressView.hidden = NO;
    UIView *view = [self.view viewWithTag:100];
    view.hidden = NO;
    UILabel *lal = [self.view viewWithTag:101];
    lal.hidden = NO;
    
    if (self.isVideo) {
        self.isVideo = NO;
        [self.player stopPlayer];
        self.player.hidden = YES;
    }
    [self.session startRunning];
    
    if (!self.takeImageView.hidden) {
        self.takeImageView.hidden = YES;
    }
    self.afreshCenterX.constant = 0;
    self.ensureCenterX.constant = 0;
    self.imgRecord.hidden = NO;
    self.btnCamera.hidden = NO;
    self.btnAfresh.hidden = YES;
    self.btnEnsure.hidden = YES;
    self.btnBack.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
