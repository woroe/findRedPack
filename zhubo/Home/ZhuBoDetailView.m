//
//  ZhuBoDetailView.m
//  zhubo
//
//  Created by Jin on 2017/6/16.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "ZhuBoDetailView.h"
#import "ZhuBoImageView.h"

#import "ZXVideoPlayerController.h"
#import "ZXVideo.h"

#import "LabelList.h"
#import "ZYTagInfo.h"
#import "ZYTagView.h"

#import "VideoPlayViewController.h"

#import "ZYTagImageView.h"

@interface ZhuBoDetailView()<ZYTagImageViewDelegate,UIAlertViewDelegate>{
    
    NSMutableArray *zyTagInFoArr;
    NSInteger indexType;
}

@property (nonatomic, strong) ZXVideoPlayerController *videoController;

@end

@implementation ZhuBoDetailView

- (void)loadWithModel:(ZhuBoModel *)model delegate:(id)delegate type:(NSInteger)type{
    _model = model;
    _delegate = delegate;
    zyTagInFoArr = [NSMutableArray new];
    indexType = type;
    
    
    //heaImg
    _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(2*MARGIN_30-MARGIN_20, 30*SCREEN_W_SCALE, 70 * SCREEN_W_SCALE, 70 * SCREEN_W_SCALE)];
    _headImgView.layer.masksToBounds = YES;
    _headImgView.contentMode = UIViewContentModeScaleAspectFill;
    _headImgView.layer.cornerRadius = 35 * SCREEN_W_SCALE;
    _headImgView.userInteractionEnabled = YES;
    [_headImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUser:)]];
    [self addSubview:_headImgView];
    
    if(_model.isReal) {
        CGFloat realW = 28 * SCREEN_W_SCALE;
        CGFloat realY = MARGIN_40 + 64 * SCREEN_W_SCALE - realW;
        CGFloat realX = MARGIN_30 + 64 * SCREEN_W_SCALE - realW;
        UIImageView *realView = [[UIImageView alloc] initWithFrame:CGRectMake(realX, realY, realW, realW)];
        realView.image = [UIImage imageNamed:@"renzheng"];
        [self addSubview:realView];
    }
    
    _nickLable = [[UILabel alloc] initWithFrame:CGRectMake(110 * SCREEN_W_SCALE+MARGIN_20, 28*SCREEN_W_SCALE, 400 * SCREEN_W_SCALE, 30 * SCREEN_W_SCALE)];
    _nickLable.font = [UIFont systemFontOfSize:28 * SCREEN_W_SCALE];
    _nickLable.textColor = BaseColorBlack3;
    [_nickLable setText:_model.nickName];
    _nickLable.userInteractionEnabled = YES;
    [_nickLable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUser:)]];
    [self addSubview:_nickLable];
    
    //dateLable
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSString *dateStr = _model.newsTime;
    NSDate *expireDate = [dateFomatter dateFromString:dateStr];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:expireDate toDate:nowDate options:0];
    NSInteger month = dateCom.year;
    NSString *date_Str;
    if (month == 0) {
        month =dateCom.month;
        date_Str = [NSString stringWithFormat:@"%ld月前",(long)month];
        if (month == 0) {
            month = dateCom.day;
            date_Str = [NSString stringWithFormat:@"%ld天前",(long)month];
            if (month== 0) {
                month = dateCom.hour;
                date_Str = [NSString stringWithFormat:@"%ld小时前",(long)month];
                if (month == 0) {
                    month = dateCom.minute;
                    date_Str = [NSString stringWithFormat:@"%ld分钟前",(long)month];
                    if (month == 0) {
                        month = dateCom.second;
                        date_Str = [NSString stringWithFormat:@"%ld秒前",(long)month];
                    }
                }
            }
        }
    }else{
        date_Str = [NSString stringWithFormat:@"%ld年前",month];
    }
    _dateLable = [[UILabel alloc] initWithFrame:CGRectMake(110 * SCREEN_W_SCALE+MARGIN_20, 2*MARGIN_40-MARGIN_20/2, 460 * SCREEN_W_SCALE, 25 * SCREEN_W_SCALE)];
    if (_model.newsContentType == 4) {
        [_dateLable setText:[NSString stringWithFormat:@"%@",date_Str]];
    }else {
        if ([_model.lx isEqualToString:@""] && [_model.shenfen isEqualToString:@""]) {
            [_dateLable setText:[NSString stringWithFormat:@"%@",date_Str]];
        }else{
            [_dateLable setText:[NSString stringWithFormat:@"%@ | %@  %@",_model.shenfen,_model.lx,date_Str]];
        }
    }
    
    _dateLable.font = [UIFont systemFontOfSize:23 * SCREEN_W_SCALE];
    _dateLable.textColor = BaseColorGray;
    [self addSubview:_dateLable];
    
    //followBtn
    if([BaseData shareInstance].userId != model.userId){
        _followBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 130 * SCREEN_W_SCALE, MARGIN_40, 100 * SCREEN_W_SCALE, 44 * SCREEN_W_SCALE)];
        [_followBtn setImage:[UIImage imageNamed:@"h_guanzhu_select"] forState:UIControlStateNormal];
        [_followBtn setImage:[UIImage imageNamed:@"h_guanzhu_default"] forState:UIControlStateSelected];
        _followBtn.backgroundColor = BaseColorYellow;
        _followBtn.titleLabel.font = [UIFont systemFontOfSize:24 * SCREEN_W_SCALE];
        _followBtn.titleLabel.textColor = [UIColor whiteColor];
        _followBtn.layer.cornerRadius = 5.0;
        if(_model.isFollowUser){
            _followBtn.selected = YES;
            _followBtn.backgroundColor = BaseColorGray2;
        }
        [_followBtn addTarget:self action:@selector(clickFollow:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_followBtn];
    }
    
    //contentLab
    CGFloat contentW = SCREEN_WIDTH - MARGIN_30 * 2;
    
    if (_model.newsContentType == 2) { // 2 是视频
        
        ZYTagImageView *imageView = [[ZYTagImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:_model.FirstImsg] placeholderImage:nil];
        imageView.isEditEnable = NO;
        imageView.exclusiveTouch = YES;
        imageView.delegate = self;
        imageView.tag = 10;
        _imageBCView = [[UIView alloc] initWithFrame:CGRectMake(0, 134 * SCREEN_W_SCALE, SCREEN_WIDTH, imageView.frame.size.height)];
        _imageBCView.tag = 100+type+2000;
        [_imageBCView addSubview:imageView];
        
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-25, imageView.frame.size.height/2-25, 50, 50)];
        [but setImage:[UIImage imageNamed:@"jc_play_normal"] forState:UIControlStateNormal];
        [but addTarget:self action:@selector(playBut:) forControlEvents:UIControlEventTouchUpInside];
        but.tag = 100+type;
        [_imageBCView addSubview:but];
        [self addSubview:_imageBCView];
        
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:_model.headImg]];
        
    }else if (_model.newsContentType == 3) {
        _imageBCView = [[UIView alloc] initWithFrame:CGRectMake(0, 90 * SCREEN_W_SCALE, SCREEN_WIDTH, 0)];
        
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:_model.headImg]];
    }else if (_model.newsContentType == 4) {
        _imageBCView = [[UIView alloc] initWithFrame:CGRectMake(0, 90 * SCREEN_W_SCALE, SCREEN_WIDTH, 0)];
        _nickLable.text = @"匿名";
        _headImgView.image = [UIImage imageNamed:@"hideName"];
        
        _followBtn.hidden = YES;
    }else{
        if (model.imgArr.count == 1) {
            ZYTagImageView *imageView = [[ZYTagImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
            imageView.backgroundColor = [UIColor whiteColor];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds  = YES;
            NSString *imgArrStr0 = _model.imgArr[0];
            NSArray *arr0 = [imgArrStr0 componentsSeparatedByString:@","];
            NSString *ulrStr ;
            for (NSString *str in arr0) {
                if (str.length > 6) {
                    ulrStr =str;
                }
            }
            [imageView sd_setImageWithURL:[NSURL URLWithString:ulrStr] placeholderImage:nil];
            imageView.isEditEnable = NO;
            UITapGestureRecognizer *photoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTap:)];
            [imageView addGestureRecognizer:photoTap];
            _imageBCView = [[UIView alloc] initWithFrame:CGRectMake(0, 134 * SCREEN_W_SCALE-5*SCREEN_W_SCALE, SCREEN_WIDTH, imageView.frame.size.height)];
            _imageBCView.backgroundColor = [UIColor blackColor];
            [_imageBCView addSubview:imageView];
            [self addSubview:_imageBCView];
            
            [_headImgView sd_setImageWithURL:[NSURL URLWithString:_model.headImg]];
        }else{
            ZhuBoImageView *imageView = [[ZhuBoImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 420  * SCREEN_W_SCALE)];
            [imageView loadWithModel:model delegate:delegate type:type];
            _imageBCView = [[UIView alloc] initWithFrame:CGRectMake(0, 134 * SCREEN_W_SCALE-5*SCREEN_W_SCALE, SCREEN_WIDTH, imageView.frame.size.height)];
            [_imageBCView addSubview:imageView];
            [self addSubview:_imageBCView];
            
            [_headImgView sd_setImageWithURL:[NSURL URLWithString:_model.headImg]];
        }
    }
    CGFloat loctionY = _imageBCView.frame.origin.y + _imageBCView.frame.size.height + MARGIN_30;
    
    CGSize contentSize = [_model.words boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30 * SCREEN_W_SCALE]} context:nil].size;
    //    contentSize = CGSizeMake(contentSize.width, ceil(contentSize.height)+1);
    
    CGSize contentSize1 = [@"我" boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30 * SCREEN_W_SCALE]} context:nil].size;
    //    contentSize1 = CGSizeMake(contentSize1.width, ceil(contentSize1.height)+1);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_model.words];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_model.words length])];
    if (type == -1) {
        //        _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN_30, loctionY, contentW, contentSize.height+(contentSize.height/(MARGIN_20/2))*3-MARGIN_20)];
        _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN_30, loctionY, contentW, ceil(contentSize.height) + ceil(contentSize.height /contentSize1.height) *6)];
        _contentLab.font = [UIFont systemFontOfSize:30 * SCREEN_W_SCALE];
        _contentLab.attributedText = attributedString;
    }else{
        if (contentSize.height >contentSize1.height*6) {
            if (_model.isAll) {
                _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN_30, loctionY, contentW, ceil(contentSize.height) + ceil(contentSize.height /contentSize1.height) *6)];
                //                _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN_30, loctionY, contentW, contentSize.height+(contentSize.height/(MARGIN_20/2))*3-MARGIN_20)];
                _contentLab.font = [UIFont systemFontOfSize:30 * SCREEN_W_SCALE];
                _contentLab.attributedText = attributedString;
            }else{
                //                _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN_30, loctionY, contentW, 60)];
                _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN_30, loctionY, contentW, ceil((contentSize1.height+6)*6))];
                _contentLab.font = [UIFont systemFontOfSize:30 * SCREEN_W_SCALE];
                _contentLab.attributedText = attributedString;
            }
        }else{
            //            _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN_30, loctionY, contentW, contentSize.height)];
            _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN_30, loctionY, contentW, ceil(contentSize.height) + ceil(contentSize.height /contentSize1.height) *6)];
            _contentLab.font = [UIFont systemFontOfSize:30 * SCREEN_W_SCALE];
            _contentLab.attributedText = attributedString;
        }
        //        _contentLab.font = [UIFont systemFontOfSize:28 * SCREEN_W_SCALE];
        //        _contentLab.text = _model.words;
    }
    _contentLab.numberOfLines = 0;
    _contentLab.textColor = [UIColor darkGrayColor];
    _contentLab.userInteractionEnabled = YES;
    _contentLab.hidden = NO;
    [self addSubview:_contentLab];
    
    //support
    CGFloat loctionY111 = _contentLab.frame.origin.y + _contentLab.frame.size.height + MARGIN_30;
    if ([_model.words isEqualToString:@""] || _model.words == nil) {
        loctionY111 = _contentLab.frame.origin.y;
    }
    if (indexType != -1) {
        if (contentSize.height >contentSize1.height*6){
            UIButton *qwBut =[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 150 * SCREEN_W_SCALE+MARGIN_30, loctionY111-MARGIN_30, 44, 44)];
            [qwBut setTitleColor:BaseColorPurple forState:UIControlStateNormal];
            qwBut.selected = NO;
            qwBut.titleLabel.font = [UIFont systemFontOfSize:28 * SCREEN_W_SCALE];
            [qwBut addTarget:self action:@selector(qwAction:) forControlEvents:UIControlEventTouchDown];
            if (_model.isAll) {
                [qwBut setTitle:@"收起" forState:UIControlStateNormal];
            }else{
                [qwBut setTitle:@"全文" forState:UIControlStateNormal];
            }
            [self addSubview:qwBut];
            loctionY111 = loctionY111 + 44-MARGIN_20;
        }
    }
    _supportBtn = [[UIButton alloc] initWithFrame:CGRectMake(MARGIN_30-11, loctionY111-15, 44, 44)];
    [_supportBtn setImage:[UIImage imageNamed:@"h_zan_default"] forState:UIControlStateNormal];
    [_supportBtn setImage:[UIImage imageNamed:@"ico_praised"] forState:UIControlStateSelected];
    if(_model.isFollowNews){
        _supportBtn.selected = YES;
    }
    [_supportBtn addTarget:self action:@selector(clickSupport:) forControlEvents:UIControlEventTouchUpInside];
    _supportLab = [[UILabel alloc] initWithFrame:CGRectMake((MARGIN_30-11)+44/2+MARGIN_20, loctionY111, 50 * SCREEN_W_SCALE, 36 * SCREEN_W_SCALE)];
    _supportLab.text = [NSString stringWithFormat:@"%ld", (long)_model.followCount];
    _supportLab.font = [UIFont systemFontOfSize:24 * SCREEN_W_SCALE];
    _supportLab.textColor = BaseColorGray;
    [self addSubview:_supportBtn];
    [self addSubview:_supportLab];
    
    //comment
    _commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(MARGIN_30 + 30 * SCREEN_W_SCALE+50 * SCREEN_W_SCALE-10, loctionY111-12, 44, 44)];
    [_commentBtn setImage:[UIImage imageNamed:@"h_pinglun_default"] forState:UIControlStateNormal];
    _commentLab = [[UILabel alloc] initWithFrame:CGRectMake((MARGIN_30 + 30 * SCREEN_W_SCALE+50 * SCREEN_W_SCALE-10)+44/2+MARGIN_20, loctionY111, 50 * SCREEN_W_SCALE, 36 * SCREEN_W_SCALE)];
    _commentLab.text = [NSString stringWithFormat:@"%ld", (long)_model.commentCount];
    _commentLab.font = [UIFont systemFontOfSize:24 * SCREEN_W_SCALE];
    _commentLab.textColor = BaseColorGray;
    [_commentBtn addTarget:self action:@selector(clickComment:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_commentBtn];
    [self addSubview:_commentLab];
    
    _gengduoBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 150 * SCREEN_W_SCALE+MARGIN_30, loctionY111-12,44, 44)];
    [_gengduoBtn setImage:[UIImage imageNamed:@"ico_more"] forState:UIControlStateNormal];
    _gengduoBtn.tag = 10;
    [_gengduoBtn addTarget:self action:@selector(clickedGengduo:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_gengduoBtn];
    
    _xiahuaxianLab = [[UILabel alloc]initWithFrame:CGRectMake(0, loctionY111+36 * SCREEN_W_SCALE+MARGIN_30, SCREEN_WIDTH, 10)];
    _xiahuaxianLab.backgroundColor = [UIColor colorWithRed:240/255.0f green:242/255.0f blue:245/255.0f alpha:1];
    if (self.qz_And_News_Str.intValue != 1) {
        [self addSubview:_xiahuaxianLab];
    }
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, loctionY111 + 65 * SCREEN_W_SCALE+MARGIN_30);
}
-(UIImage *)getImageFromUrl:(NSURL *)imgUrl imgViewWidth:(CGFloat)width imgViewHeight:(CGFloat)height{
    //data 转image
    UIImage * image ;
    //根据网址将图片转化成image
    NSData * data = [NSData dataWithContentsOfURL:imgUrl];
    image =[UIImage imageWithData:data];
    //图片剪切
    UIImage * newImage = [self cutImage:image imgViewWidth:width imgViewHeight:height];
    return newImage;
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
-(void)photoTap:(id)Sender{
    [self.delegate openPhotoBrowser:0 ZhuBoModel:self.model];
}


- (void)clickUser:(id)sender{
    
    if(![BaseClasss isLogin]) {
        return;
    }
    [self.delegate clickedUser:sender withModel:_model];
}

- (void)clickFollow:(UIButton *)sender {
    if(![BaseClasss isLogin]) {
        return;
    }
    if (sender.selected) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"是否确定取消关注？"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = @([BaseData shareInstance].userId);
    params[@"FollowUserId"] = @(_model.userId);
    
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if(btn.selected){
        params[@"BuildSowingType"] = @"FollowUser";
        btn.backgroundColor = BaseColorGray2;
    }
    else{
        params[@"BuildSowingType"] = @"DelFollowUser";
        btn.backgroundColor = BaseColorYellow;
    }
    
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            if(btn.selected){
                [SVProgressHUD showSuccessWithStatus:BaseStringFollowSucc];
            }else{
                [SVProgressHUD showSuccessWithStatus:BaseStringFollowNOSucc];
            }
        }
        else{
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
            
            btn.selected = !btn.selected;
            if(btn.selected){
                self.model.isFollowUser = YES;
                btn.backgroundColor = BaseColorGray2;
            }
            else{
                self.model.isFollowUser = NO;
                btn.backgroundColor = BaseColorYellow;
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        
        btn.selected = !btn.selected;
        if(btn.selected){
            btn.backgroundColor = BaseColorGray2;
        }
        else{
            btn.backgroundColor = BaseColorYellow;
        }
        
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"UserId"] = @([BaseData shareInstance].userId);
        params[@"FollowUserId"] = @(_model.userId);
        
        _followBtn.selected = !_followBtn.selected;
        params[@"BuildSowingType"] = @"DelFollowUser";
        _followBtn.backgroundColor = BaseColorYellow;
    
        
        [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *res = (NSDictionary *)responseObject;
            if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
                if(_followBtn.selected){
                    [SVProgressHUD showSuccessWithStatus:BaseStringFollowSucc];
                }else{
                    [SVProgressHUD showSuccessWithStatus:BaseStringFollowNOSucc];
                }
            }
            else{
                [SVProgressHUD showErrorWithStatus:BaseStringNetError];
                
                _followBtn.selected = !_followBtn.selected;
                if(_followBtn.selected){
                    self.model.isFollowUser = YES;
                    _followBtn.backgroundColor = BaseColorGray2;
                }
                else{
                    self.model.isFollowUser = NO;
                    _followBtn.backgroundColor = BaseColorYellow;
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
            
            _followBtn.selected = !_followBtn.selected;
            if(_followBtn.selected){
                _followBtn.backgroundColor = BaseColorGray2;
            }
            else{
                _followBtn.backgroundColor = BaseColorYellow;
            }
            
        }];
    }
}

- (void)clickContent:(id)sender {
    
    [self.delegate clickedContent:sender withModel:_model];
}
- (void)clickLoction:(id)sender {
    
}
- (void)clickSupport:(id)sender {
    if(![BaseClasss isLogin]) {
        return;
    }
    ZhuBoDetailView *view = (ZhuBoDetailView *)self;
    UIButton *btn = view.supportBtn;
    //取消点赞
    if(btn.selected) {
        btn.selected = !btn.selected;
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        if (_qz_And_News_Str.intValue == 2) {
            params[@"BuildSowingType"] = @"BuildSowing_DelFollowCircleNews";
        }else{
            params[@"BuildSowingType"] = @"BuildSowing_DelFollowNews";
        }
        params[@"UserId"] = @([BaseData shareInstance].userId);
        params[@"NewsId"] = @(_model.newsId);
        
        [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *res = (NSDictionary *)responseObject;
            if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
                self.model.isFollowNews = YES;
                //                [SVProgressHUD showSuccessWithStatus:@""];
                view.supportLab.text = [NSString stringWithFormat:@"%ld", view.model.followCount ];
            }
            else{
                [SVProgressHUD showErrorWithStatus:BaseStringNetError];
                
                btn.selected = !btn.selected;
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
            
            btn.selected = !btn.selected;
        }];
    }else{
        btn.selected = !btn.selected;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        if (_qz_And_News_Str.intValue == 2) {
            params[@"BuildSowingType"] = @"BuildSowing_FollowCircleNews";
        }else{
            params[@"BuildSowingType"] = @"BuildSowing_FollowNews";
        }
        params[@"UserId"] = @([BaseData shareInstance].userId);
        params[@"NewsId"] = @(_model.newsId);
        
        [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *res = (NSDictionary *)responseObject;
            if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
                self.model.isFollowNews = YES;
                //                [SVProgressHUD showSuccessWithStatus:@""];
                view.supportLab.text = [NSString stringWithFormat:@"%ld", view.model.followCount+1];
            }
            else{
                [SVProgressHUD showErrorWithStatus:BaseStringNetError];
                btn.selected = !btn.selected;
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
            btn.selected = !btn.selected;
        }];
    }
}
- (void)clickComment:(id)sender {
    [self.delegate clickedComment:sender withModel:_model];
}
-(void)clickedGengduo:(id)sender{
    [self.delegate clickedGengduo:sender withModel:_model];
}

- (void)playBut:(UIButton *)sender{
    [self.delegate startPlayVideo:_model but:sender];
}

#pragma mark -- 视频获取标签
-(void)getBiaoQIanLoadData:(ZYTagImageView *)imageView{
    CGFloat contentW = SCREEN_WIDTH - MARGIN_30 * 2;
    NSString *newsContent = _model.newsContent;
    NSArray *arr1 = [newsContent componentsSeparatedByString:@","];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"BuildSowingType"] = @"GetLabel";
    params[@"FileId"] = arr1[0];
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            ZBLog(@"BuildSowing_News--%@", res);
            NSArray *dataArr = [res objectForKey:@"data"];
            if(!dataArr || dataArr.count == 0) {
            }
            for (NSDictionary *dic in dataArr) {
                NSString *xStr = [dic objectForKey:@"x"];
                NSString *yStr = [dic objectForKey:@"y"];
                CGPoint point;
                point.x = contentW*xStr.floatValue;
                point.y = (SCREEN_WIDTH - MARGIN_30 * 2+( SCREEN_WIDTH - MARGIN_30 * 2)/2-80)*yStr.floatValue;
                [imageView addTagWithTitle:[dic objectForKey:@"Msg"] point:point object:dic];
            }
        }
        else{
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
#pragma mark -- 图片获取标签
-(void)geiBIaoQiantpAction:(ZYTagImageView *)imageView{
    CGFloat contentW = SCREEN_WIDTH - MARGIN_30 * 2;
    NSString *imgArrStr0 = _model.imgArr[0];
    NSArray *arr0 = [imgArrStr0 componentsSeparatedByString:@","];
    NSString *ulrStr ;
    for (NSString *str in arr0) {
        if (str.length > 6) {
            ulrStr =str;
        }
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"BuildSowingType"] = @"GetLabel";
    params[@"FileId"] = arr0[0];
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            ZBLog(@"BuildSowing_News--%@", res);
            NSArray *dataArr = [res objectForKey:@"data"];
            if(!dataArr || dataArr.count == 0) {
            }
            for (NSDictionary *dic in dataArr) {
                NSString *xStr = [dic objectForKey:@"x"];
                NSString *yStr = [dic objectForKey:@"y"];
                CGPoint point;
                point.x = contentW*xStr.floatValue;
                point.y = 420*SCREEN_W_SCALE*yStr.floatValue;
                [imageView addTagWithTitle:[dic objectForKey:@"Msg"] point:point object:dic];
            }
        }
        else{
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

#pragma mark -- 是否展示全文
-(void)qwAction:(UIButton *)sender{
    _contentLab.hidden = YES;
    [self.delegate qwActionTop:indexType];
}

#pragma mark - ZYTagImageViewDelegate
- (void)tagImageView:(ZYTagImageView *)tagImageView activeTapGesture:(UITapGestureRecognizer *)tapGesture
{
    NSLog(@"ni meimei mei d activeTapGesture ");
}

- (void)tagImageView:(ZYTagImageView *)tagImageView tagViewActiveTapGesture:(ZYTagView *)tagView
{
    NSDictionary *dic = tagView.tagInfo.object;
    [self.delegate selectedTagInFo:dic];
}

- (void)tagImageView:(ZYTagImageView *)tagImageView tagViewActiveLongPressGesture:(ZYTagView *)tagView
{
    /** 可自定义长按手势的反馈 */
    NSLog(@"ni meimei mei d tagViewActiveLongPressGesture ");
}

@end
