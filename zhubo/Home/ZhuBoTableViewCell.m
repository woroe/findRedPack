//
//  ZhuBoTableViewCell.m
//  zhubo
//
//  Created by Jin on 2017/6/12.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "ZhuBoTableViewCell.h"
#import "ZhuBoImageView.h"

@interface ZhuBoTableViewCell(){
    
    NSMutableArray *zyTagInFoArr;
}


@end

@implementation ZhuBoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(ZhuBoModel *)model {
    _model = model;
    
    _delegate = self.delegate;
    zyTagInFoArr = [NSMutableArray new];
    
    //heaImg
    _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN_30, MARGIN_40, 64 * SCREEN_W_SCALE, 64 * SCREEN_W_SCALE)];
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:_model.headImg]];
    _headImgView.layer.masksToBounds = YES;
    _headImgView.contentMode = UIViewContentModeScaleAspectFill;
    _headImgView.layer.cornerRadius = 32 * SCREEN_W_SCALE;
    _headImgView.userInteractionEnabled = YES;
    [_headImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUser:)]];
    [self addSubview:_headImgView];
    
//    if(_model.isReal) {
//        CGFloat realW = 28 * SCREEN_W_SCALE;
//        CGFloat realY = MARGIN_40 + 64 * SCREEN_W_SCALE - realW;
//        CGFloat realX = MARGIN_30 + 64 * SCREEN_W_SCALE - realW;
//        UIImageView *realView = [[UIImageView alloc] initWithFrame:CGRectMake(realX, realY, realW, realW)];
//        realView.image = [UIImage imageNamed:@"renzheng"];
//        [self addSubview:realView];
//    }
    
    //nickLable
//    _nickLable = [[UILabel alloc] initWithFrame:CGRectMake(110 * SCREEN_W_SCALE, MARGIN_40, 400 * SCREEN_W_SCALE, 30 * SCREEN_W_SCALE)];
//    _nickLable.font = [UIFont systemFontOfSize:30 * SCREEN_W_SCALE];
//    _nickLable.textColor = BaseColorBlack3;
//    [_nickLable setText:_model.nickName];
//    _nickLable.userInteractionEnabled = YES;
//    [_nickLable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUser:)]];
//    [self addSubview:_nickLable];
    
    
    //dateLable
    _dateLable = [[UILabel alloc] initWithFrame:CGRectMake(110 * SCREEN_W_SCALE, 70 * SCREEN_W_SCALE, 400 * SCREEN_W_SCALE, 30 * SCREEN_W_SCALE)];
    if (_qz_And_News_Str.intValue == 2) {
        [_dateLable setText:_model.newsTime];
    }else{
        if ([_model.lx isEqualToString:@""] && [_model.shenfen isEqualToString:@""]) {
            [_dateLable setText:@""];
        }else{
            [_dateLable setText:[NSString stringWithFormat:@"%@ | %@",_model.lx,_model.shenfen]];
        }
    }
    
    _dateLable.font = [UIFont systemFontOfSize:20 * SCREEN_W_SCALE];
    _dateLable.textColor = BaseColorGray;
    [self addSubview:_dateLable];
    
    //followBtn
    if([BaseData shareInstance].userId != model.userId){
        _followBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 130 * SCREEN_W_SCALE, MARGIN_40, 100 * SCREEN_W_SCALE, 44 * SCREEN_W_SCALE)];
        [_followBtn setTitle:@"+关注" forState:UIControlStateNormal];
        [_followBtn setTitle:@"已关注" forState:UIControlStateSelected];
        _followBtn.backgroundColor = BaseColorYellow;
        _followBtn.titleLabel.font = [UIFont systemFontOfSize:24 * SCREEN_W_SCALE];
        _followBtn.titleLabel.textColor = [UIColor whiteColor];
        _followBtn.layer.cornerRadius = 2.0;
        if(_model.isFollowUser){
            _followBtn.selected = YES;
            _followBtn.backgroundColor = BaseColorGray2;
        }
        
        [_followBtn addTarget:self action:@selector(clickFollow:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_followBtn];
    }
    
    //contentLab
    CGFloat contentW = SCREEN_WIDTH - MARGIN_30 * 2;
    
    if (model.newsContentType == 2) { // 2 是视频
        ZhuBoImageView *imageView = [[ZhuBoImageView alloc] initWithFrame:CGRectMake(0, 0, contentW, 420  * SCREEN_W_SCALE)];
        [imageView loadWithModel:model delegate:_delegate type:1];
        
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(contentW/2-25, (420  * SCREEN_W_SCALE)/2-25, 50, 50)];
        [but setImage:[UIImage imageNamed:@"play1111111"] forState:UIControlStateNormal];
        but.tag = _indexPathRow;
        [but addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:but];
        
        _imageBCView = [[UIView alloc] initWithFrame:CGRectMake(0, 134 * SCREEN_W_SCALE, contentW, imageView.frame.size.height)];
        [_imageBCView addSubview:imageView];
        
        [self addSubview:_imageBCView];
        
    }else if (model.newsContentType == 3 || model.newsContentType == 4) {
        _imageBCView = [[UIView alloc] initWithFrame:CGRectMake(MARGIN_30, 134 * SCREEN_W_SCALE, 0, 0)];
        [self addSubview:_imageBCView];
    
    }else{
        
        ZhuBoImageView *imageView = [[ZhuBoImageView alloc] initWithFrame:CGRectMake(0, 0, contentW, 420  * SCREEN_W_SCALE)];
        [imageView loadWithModel:model delegate:_delegate type:1];
        _imageBCView = [[UIView alloc] initWithFrame:CGRectMake(MARGIN_30, 134 * SCREEN_W_SCALE, contentW, imageView.frame.size.height)];
        [_imageBCView addSubview:imageView];
        [self addSubview:_imageBCView];
    }
    
    CGSize contentSize = [_model.words boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:28 * SCREEN_W_SCALE]} context:nil].size;
    _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN_30, _imageBCView.frame.origin.y + _imageBCView.frame.size.height + MARGIN_30, contentW, contentSize.height)];
    _contentLab.numberOfLines = 0;
    _contentLab.font = [UIFont systemFontOfSize:28 * SCREEN_W_SCALE];
    _contentLab.textColor = BaseColorBlack2;
    _contentLab.text = _model.words;
    _contentLab.userInteractionEnabled = YES;
    [self addSubview:_contentLab];
    
    
    //loction
    CGFloat loctionY = _contentLab.frame.origin.y + _contentLab.frame.size.height + MARGIN_30;
    //support
    _supportBtn = [[UIButton alloc] initWithFrame:CGRectMake(MARGIN_30, loctionY, 36 * SCREEN_W_SCALE, 36 * SCREEN_W_SCALE)];
    [_supportBtn setImage:[UIImage imageNamed:@"zan"] forState:UIControlStateNormal];
    [_supportBtn setImage:[UIImage imageNamed:@"zan_f"] forState:UIControlStateSelected];
    if(_model.isFollowNews){
        _supportBtn.selected = YES;
    }
    [_supportBtn addTarget:self action:@selector(clickSupport:) forControlEvents:UIControlEventTouchUpInside];
    _supportLab = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN_30 + 36 * SCREEN_W_SCALE, loctionY, 50 * SCREEN_W_SCALE, 36 * SCREEN_W_SCALE)];
    _supportLab.text = [NSString stringWithFormat:@"%ld", (long)_model.followCount];
    _supportLab.font = [UIFont systemFontOfSize:24 * SCREEN_W_SCALE];
    _supportLab.textColor = BaseColorGray;
    [self addSubview:_supportBtn];
    [self addSubview:_supportLab];
    
    //comment
    _commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(MARGIN_30 + 36 * SCREEN_W_SCALE+50 * SCREEN_W_SCALE+10, loctionY, 36 * SCREEN_W_SCALE, 36 * SCREEN_W_SCALE)];
    [_commentBtn setImage:[UIImage imageNamed:@"pinglun"] forState:UIControlStateNormal];
    _commentLab = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN_30 + 36 * SCREEN_W_SCALE+50 * SCREEN_W_SCALE+36 * SCREEN_W_SCALE+10, loctionY, 50 * SCREEN_W_SCALE, 36 * SCREEN_W_SCALE)];
    _commentLab.text = [NSString stringWithFormat:@"%ld", (long)_model.commentCount];
    _commentLab.font = [UIFont systemFontOfSize:24 * SCREEN_W_SCALE];
    _commentLab.textColor = BaseColorGray;
    [_commentBtn addTarget:self action:@selector(clickComment:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_commentBtn];
    [self addSubview:_commentLab];
    
    _gengduoBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 150 * SCREEN_W_SCALE+30, loctionY, 36 * SCREEN_W_SCALE, 36 * SCREEN_W_SCALE)];
    [_gengduoBtn setImage:[UIImage imageNamed:@"ico_more"] forState:UIControlStateNormal];
    _gengduoBtn.tag = 10;
    [_gengduoBtn addTarget:self action:@selector(clickedGengduo:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_gengduoBtn];
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, loctionY + 65 * SCREEN_W_SCALE);
}


- (void)clickUser:(id)sender{
    
    if(![BaseClasss isLogin]) {
        return;
    }
    [self.delegate clickedUser:sender withModel:_model];
}

- (void)clickFollow:(id)sender {
    
    if(![BaseClasss isLogin]) {
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
                [SVProgressHUD showSuccessWithStatus:@""];
                view.supportLab.text = [NSString stringWithFormat:@"%ld", view.model.followCount - 1];
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
                [SVProgressHUD showSuccessWithStatus:@""];
                view.supportLab.text = [NSString stringWithFormat:@"%ld", view.model.followCount + 1];
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

- (void)loadData {
}

-(void)playAction:(UIButton *)sender{
    [self.delegate startPlayVideo:_model but:sender];
}


@end
