//
//  CommentView.m
//  zhubo
//
//  Created by Jin on 2017/6/17.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "CommentView.h"
#import "GrZhuYeViewController.h"
@implementation CommentView

- (void)loadWithModel:(CommentModel *)model delegate:(id)delegate type:(NSInteger)type{
    _model = model;
    _delegate = delegate;
    
    //分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.6)];
    lineView.backgroundColor = BaseColorGray2;
    [self addSubview:lineView];
    
    //heaImg
    _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN_30, MARGIN_40, 64 * SCREEN_W_SCALE, 64 * SCREEN_W_SCALE)];
    _headImgView.layer.masksToBounds = YES;
    _headImgView.layer.cornerRadius = 32 * SCREEN_W_SCALE;
    _headImgView.userInteractionEnabled = YES;
    [_headImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUser:)]];
    [self addSubview:_headImgView];
    
    //nickLable
    _nickLable = [[UILabel alloc] initWithFrame:CGRectMake(110 * SCREEN_W_SCALE, MARGIN_40, 400 * SCREEN_W_SCALE, 30 * SCREEN_W_SCALE)];
    _nickLable.font = [UIFont systemFontOfSize:30 * SCREEN_W_SCALE];
    _nickLable.textColor = BaseColorBlack3;
    _nickLable.userInteractionEnabled = YES;
//    [_nickLable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUser:)]];
    [self addSubview:_nickLable];
    
    //dateLable
    _dateLable = [[UILabel alloc] initWithFrame:CGRectMake(110 * SCREEN_W_SCALE, 70 * SCREEN_W_SCALE, 400 * SCREEN_W_SCALE, 30 * SCREEN_W_SCALE)];
    [_dateLable setText:[BaseClasss setupCreateTime:_model.commentTime]];
    _dateLable.font = [UIFont systemFontOfSize:20 * SCREEN_W_SCALE];
    _dateLable.textColor = BaseColorGray;
    [self addSubview:_dateLable];
    
    
    //contentLab
    CGFloat contentW = SCREEN_WIDTH - MARGIN_30 * 2;
    CGSize contentSize = [_model.commentMsg boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:28 * SCREEN_W_SCALE]} context:nil].size;
    _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN_30, 134 * SCREEN_W_SCALE, contentW, contentSize.height)];
    _contentLab.numberOfLines = 0;
    _contentLab.font = [UIFont systemFontOfSize:28 * SCREEN_W_SCALE];
    _contentLab.textColor = BaseColorBlack2;
    _contentLab.text = _model.commentMsg;
    _contentLab.userInteractionEnabled = NO;
    [_contentLab addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickContent:)]];
    [self addSubview:_contentLab];
    
    //support
    _supportBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100 * SCREEN_W_SCALE, MARGIN_40, 36 * SCREEN_W_SCALE, 36 * SCREEN_W_SCALE)];
    [_supportBtn setImage:[UIImage imageNamed:@"h_zan_default"] forState:UIControlStateNormal];
    [_supportBtn setImage:[UIImage imageNamed:@"ico_praised"] forState:UIControlStateSelected];
//    BOOL b = _model.commentIsFollow;
    if(_model.commentIsFollow){
        _supportBtn.selected = YES;
    }
    [_supportBtn addTarget:self action:@selector(clickSupport:) forControlEvents:UIControlEventTouchUpInside];
    _supportLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50 * SCREEN_W_SCALE, MARGIN_40, 50 * SCREEN_W_SCALE, 36 * SCREEN_W_SCALE)];
    _supportLab.text = [NSString stringWithFormat:@"%ld", (long)_model.commentFollowCount];
    _supportLab.font = [UIFont systemFontOfSize:24 * SCREEN_W_SCALE];
    _supportLab.textColor = BaseColorGray;
//    if ((long)_model.commentFollowCount !=0) {
//        _supportBtn.selected = YES;
//    }
    [self addSubview:_supportBtn];
    [self addSubview:_supportLab];
    
    //comment
//    _commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100 * SCREEN_W_SCALE, MARGIN_40, 36 * SCREEN_W_SCALE, 36 * SCREEN_W_SCALE)];
//    [_commentBtn setImage:[UIImage imageNamed:@"pinglun"] forState:UIControlStateNormal];
//    _commentLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50 * SCREEN_W_SCALE, MARGIN_40, 50 * SCREEN_W_SCALE, 36 * SCREEN_W_SCALE)];
//    _commentLab.text = [NSString stringWithFormat:@"%ld", (long)_model.commentCommentCount];
//    _commentLab.font = [UIFont systemFontOfSize:24 * SCREEN_W_SCALE];
//    _commentLab.textColor = BaseColorGray;
//    [_commentBtn addTarget:self action:@selector(clickComment:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_commentBtn];
//    [self addSubview:_commentLab];
    
    if (_model.isAnonymous) {
        _nickLable.text = @"匿名";
        _headImgView.image = [UIImage imageNamed:@"hideName"];
    }else {
        [_nickLable setText:_model.commentName];
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:_model.commentHeadImg]];
    }
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, _contentLab.frame.origin.y + _contentLab.frame.size.height + 25 * SCREEN_W_SCALE);
}


- (void)clickUser:(id)sender{
    
    if(![BaseClasss isLogin]) {
        return;
    }
    [self.delegate commentUser:sender withModel:_model];
//    UserDetailViewController *userVC = [[UserDetailViewController alloc] init];
//    [[HomeViewController shareInstance].navigationController pushViewController:userVC animated:YES];
    
}

- (void)clickContent:(id)sender {
    NSLog(@"_++++++++++++++++++++clickContent");
}
- (void)clickLoction:(id)sender {
     NSLog(@"_++++++++++++++++++++clickLoction");
    //    [self.delegate clickedLoction:sender withModel:_model];
}
- (void)clickSupport:(id)sender {
    //    [self.delegate clickedSupport:self withModel:_model];
    
    if(![BaseClasss isLogin]) {
        return;
    }
    UIButton *btn = self.supportBtn;
    //取消点赞
    if(btn.selected) {
        btn.selected = !btn.selected;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        if (_qz_And_News_Sre.intValue == 2) {
            params[@"BuildSowingType"] = @"BuildSowing_DelFollowCircleComment";
        }else{
            params[@"BuildSowingType"] = @"BuildSowing_DelFollowComment";
        }
        params[@"UserId"] = @([BaseData shareInstance].userId);//88
        params[@"CommentId"] = @(_model.commentId);//2049
        
        [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *res = (NSDictionary *)responseObject;
            if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
//                [SVProgressHUD showSuccessWithStatus:@""];
                NSString *supportLabStr = self.supportLab.text;
                self.supportLab.text = [NSString stringWithFormat:@"%d", self.model.commentFollowCount];
            }
            else{
                [SVProgressHUD showErrorWithStatus:BaseStringNetError];
                
                btn.selected = !btn.selected;
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
            
            btn.selected = !btn.selected;
        }];
    }else{//点赞
        btn.selected = !btn.selected;
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        if (_qz_And_News_Sre.intValue == 2) {
            params[@"BuildSowingType"] = @"BuildSowing_FollowCircleComment";
        }else{
            params[@"BuildSowingType"] = @"BuildSowing_FollowComment";
        }
        params[@"UserId"] = @([BaseData shareInstance].userId);
        params[@"CommentId"] = @(_model.commentId);
        
        [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *res = (NSDictionary *)responseObject;
            if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
//                [SVProgressHUD showSuccessWithStatus:BaseStringDZFollowSucc];
                self.supportLab.text = [NSString stringWithFormat:@"%ld", self.model.commentFollowCount + 1];
            }
            else{
//                [SVProgressHUD showErrorWithStatus:BaseStringNetError];
                
                
                btn.selected = !btn.selected;
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
            
            btn.selected = !btn.selected;
        }];
    }
}
// 回复下面的回复
- (void)clickComment:(id)sender {
    [self.delegate slickComment_Comment:sender CommentModel:_model];
}

@end
