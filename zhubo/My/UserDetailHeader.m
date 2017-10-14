//
//  UserDetailHeader.m
//  zhubo
//
//  Created by Jin on 2017/6/15.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "UserDetailHeader.h"

@interface UserDetailHeader()


@end


@implementation UserDetailHeader

- (void)loadWithModel:(UserDetailModel *)model {
    _model = model;
    
    //headBCView
    self.headBCView = [[UIImageView alloc] init];
    self.headBCView.userInteractionEnabled = YES;
    self.headBCView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_headBCView];
    
    
    //_headImgView
    CGFloat w = 140*SCREEN_W_SCALE;
    CGFloat x = (SCREEN_WIDTH - w) / 2;
    _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 60*SCREEN_W_SCALE, w, w)];
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:_model.headImg]];
    _headImgView.contentMode = UIViewContentModeScaleAspectFill;
    _headImgView.layer.masksToBounds = YES;
    _headImgView.layer.cornerRadius = w * SCREEN_W_SCALE;
    [self.headBCView addSubview:_headImgView];
    
    if(_model.isReal) {
        CGFloat realW = 30 * SCREEN_W_SCALE;
        CGFloat realY = 60*SCREEN_W_SCALE + w - realW;
        CGFloat realX = x + w - realW;
        UIImageView *realView = [[UIImageView alloc] initWithFrame:CGRectMake(realX, realY, realW, realW)];
        realView.image = [UIImage imageNamed:@"renzheng"];
        [_headBCView addSubview:realView];
    }
    
    
    
    //nickLab
    CGFloat nickLabH = 36 * SCREEN_W_SCALE;
    CGSize nickLabSize = [_model.nickName boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:nickLabH]} context:nil].size;
    CGFloat nickLabX = (SCREEN_WIDTH - nickLabSize.width) / 2;
    CGFloat nickLabY = _headImgView.frame.origin.y + w + MARGIN_30;
    UILabel *nickLab = [[UILabel alloc] initWithFrame:CGRectMake(nickLabX, nickLabY, nickLabSize.width, nickLabH)];
    nickLab.text = _model.nickName;
    nickLab.textAlignment = NSTextAlignmentCenter;
    nickLab.textColor = BaseColorBlack3;
    nickLab.font = [UIFont systemFontOfSize:nickLabH];
    _nickLab = nickLab;
    [self.headBCView addSubview: _nickLab];
    
    //roleLab
    if(_model.professionalIdentity){
        UILabel *roleLab = [[UILabel alloc] initWithFrame:CGRectMake(nickLabX + nickLabSize.width + MARGIN_20, nickLabY, 92 * SCREEN_W_SCALE, nickLabH)];
        roleLab.text = _model.professionalIdentity;
        roleLab.textAlignment = NSTextAlignmentCenter;
        roleLab.textColor = [UIColor whiteColor];
        roleLab.font = [UIFont systemFontOfSize:24 * SCREEN_W_SCALE];
        roleLab.backgroundColor = BaseColorBlue;
        [self.headBCView addSubview: roleLab];
    }
    
    
    
    //companyLab
    CGFloat companyLabY = _nickLab.frame.size.height + _nickLab.frame.origin.y + 24 * SCREEN_W_SCALE;
    UILabel *companyLab = [[UILabel alloc] initWithFrame:CGRectMake(0, companyLabY, SCREEN_WIDTH, 24*SCREEN_W_SCALE)];
    NSString *companyStr;
    if(_model.isReal){
        if(_model.realEmployer){
            companyStr = [NSString stringWithFormat:@"%@",_model.realEmployer];
        }
        if(_model.realPosition){
            companyStr = [NSString stringWithFormat:@"%@  %@", companyStr, _model.realPosition];
        }
    }
    else{
        if(_model.employer){
            companyStr = [NSString stringWithFormat:@"%@",_model.employer];
        }
        if(_model.position){
            companyStr = [NSString stringWithFormat:@"%@  %@", companyStr, _model.position];
        }
    }
    companyLab.text = companyStr;
    companyLab.textAlignment = NSTextAlignmentCenter;
    companyLab.textColor = BaseColorGray;
    companyLab.font = [UIFont systemFontOfSize:24*SCREEN_W_SCALE];
    _companyLabY = companyLab;
    [_headBCView addSubview:_companyLabY];
    
    
    //关注
    CGFloat labW = 140 * SCREEN_W_SCALE;
    CGFloat labX = SCREEN_WIDTH / 2 - 140 * SCREEN_W_SCALE;
    CGFloat labY = _companyLabY.frame.origin.y + _companyLabY.frame.size.height + 23 *SCREEN_W_SCALE;
    UILabel *membersCountLab = [[UILabel alloc] initWithFrame:CGRectMake(labX, labY, labW, 36 * SCREEN_W_SCALE)];
    membersCountLab.text = [NSString stringWithFormat:@"%ld", _model.myFollowCount];
    membersCountLab.textAlignment = NSTextAlignmentCenter;
    membersCountLab.textColor = BaseColorYellow;
    membersCountLab.font = [UIFont systemFontOfSize:36 *SCREEN_W_SCALE];
    _membersCountLab = membersCountLab;
    [self.headBCView addSubview:_membersCountLab];
    
    UILabel *membersLab = [[UILabel alloc] initWithFrame:CGRectMake(labX, membersCountLab.frame.origin.y +membersCountLab.frame.size.height + 20 *SCREEN_W_SCALE, labW, 24 * SCREEN_W_SCALE)];
    if (_model.isFollowUser) {
        membersLab.text = @"已关注";
    }else{
        membersLab.text = @"关注";
    }
    membersLab.textAlignment = NSTextAlignmentCenter;
    membersLab.textColor = BaseColorGray;
    membersLab.font = [UIFont systemFontOfSize:24 *SCREEN_W_SCALE];
    _membersLab = membersLab;
    [self.headBCView addSubview:_membersLab];
    
    //分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, labY, 0.5, 70 * SCREEN_W_SCALE)];
    lineView.backgroundColor = BaseColorGray2;
    [self.headBCView addSubview:lineView];
    
    
    //粉丝
    UILabel *newssCountLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, labY, labW, 36 * SCREEN_W_SCALE)];
    newssCountLab.text = [NSString stringWithFormat:@"%ld", _model.followMeCount];
    newssCountLab.textAlignment = NSTextAlignmentCenter;
    newssCountLab.textColor = BaseColorYellow;
    newssCountLab.font = [UIFont systemFontOfSize:36 *SCREEN_W_SCALE];
    _newssCountLab = newssCountLab;
    [self.headBCView addSubview:_newssCountLab];
    
    UILabel *newsLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, newssCountLab.frame.origin.y +newssCountLab.frame.size.height + 20 *SCREEN_W_SCALE, labW, 24 * SCREEN_W_SCALE)];
    newsLab.text = @"粉丝";
    newsLab.textAlignment = NSTextAlignmentCenter;
    newsLab.textColor = BaseColorGray;
    newsLab.font = [UIFont systemFontOfSize:24 *SCREEN_W_SCALE];
    _newsLab = newsLab;
    [self.headBCView addSubview:_newsLab];
    
    
    //followBtnView
    CGFloat btnW = 211 * SCREEN_W_SCALE;
    CGFloat btnH = 64 * SCREEN_W_SCALE;
    CGFloat btnX = SCREEN_WIDTH/2 - btnW - MARGIN_20;
    CGFloat btnY = newsLab.frame.origin.y + newsLab.frame.size.height + MARGIN_30;
    UIView *followBtnView = [[UIView alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
    followBtnView.layer.borderWidth = 0.5;
    followBtnView.layer.borderColor = BaseColorGray.CGColor;
    followBtnView.layer.cornerRadius = 2;
    followBtnView.userInteractionEnabled = YES;
//    [followBtnView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPub:)]];
    _followBtnView = followBtnView;
    if ([BaseData shareInstance].userId != _model.userId){
        [self.headBCView addSubview:_followBtnView];
    }
    
    CGFloat iconY = 10 * SCREEN_W_SCALE;
    CGFloat iconH = 44 * SCREEN_W_SCALE;
    UIImageView *pubIcon = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN_40, iconY, iconH, iconH)];
    pubIcon.image = [UIImage imageNamed:@"guanzhu-1"];
    [followBtnView addSubview:pubIcon];
    
    CGFloat pubLabX = 100 * SCREEN_W_SCALE;
    CGFloat pubLabW = btnW - pubLabX;
    UILabel *pubLab = [[UILabel alloc] initWithFrame:CGRectMake(pubLabX, iconY, pubLabW, iconH)];
    pubLab.text = @"关注";
    pubLab.font = [UIFont systemFontOfSize:30 * SCREEN_W_SCALE];
    pubLab.textColor = BaseColorBlack2;
    pubLab.userInteractionEnabled = NO;
    [followBtnView addSubview:pubLab];
    
    
    //messageBtnView
    UIView *messageBtnView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 + MARGIN_20, btnY, btnW, btnH)];
    messageBtnView.layer.borderWidth = 0.5;
    messageBtnView.layer.borderColor = BaseColorGray.CGColor;
    messageBtnView.layer.cornerRadius = 2;
    messageBtnView.userInteractionEnabled = YES;
//    [messageBtnView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickShare:)]];
    _messageBtnView = messageBtnView;
    if ([BaseData shareInstance].userId != _model.userId){
        [self.headBCView addSubview:_messageBtnView];
    }
    
    UIImageView *shareIcon = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN_40, iconY, iconH, iconH)];
    shareIcon.image = [UIImage imageNamed:@"sixin"];
    shareIcon.userInteractionEnabled = NO;
    [messageBtnView addSubview:shareIcon];
    
    UILabel *shareLab = [[UILabel alloc] initWithFrame:CGRectMake(pubLabX, iconY, pubLabW, iconH)];
    shareLab.text = @"私信";
    shareLab.font = [UIFont systemFontOfSize:30 * SCREEN_W_SCALE];
    shareLab.textColor = BaseColorBlack2;
    shareLab.userInteractionEnabled = NO;
    [messageBtnView addSubview:shareLab];
    
    if ([BaseData shareInstance].userId != _model.userId){
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH,  _messageBtnView.frame.origin.y + _messageBtnView.frame.size.height + MARGIN_30);
        self.headBCView.frame = self.frame;
        self.backgroundColor = [UIColor whiteColor];
    }else{
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH,  _messageBtnView.frame.origin.y + MARGIN_30);
        self.headBCView.frame = self.frame;
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)clickPub:(UIGestureRecognizer *)sender {
    
}
- (void)clickShare:(UIGestureRecognizer *)sender {
    
}


@end
