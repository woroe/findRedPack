//
//  CircleHeaderView.m
//  zhubo
//
//  Created by Jin on 2017/6/19.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "CircleHeaderView.h"
#import "CircleNewsViewController.h"
#import "CircleDetailViewController.h"


@implementation CircleHeaderView

- (void)loadWithModel:(CircleModel *)model {
    _model = model;
    
    //headBCView
    self.headBCView = [[UIImageView alloc] init];
    self.headBCView.userInteractionEnabled = YES;
    if(_model.backImg  && ![_model.backImg isEqual:@""]){
        [self.headBCView sd_setImageWithURL:[NSURL URLWithString:_model.backImg]];
    }
    else{
        self.headBCView.backgroundColor = [UIColor whiteColor];
    }
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
    
    
    //titLab
    UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _headImgView.frame.origin.y + w + 30*SCREEN_W_SCALE, SCREEN_WIDTH, 36 * SCREEN_W_SCALE)];
    titLab.text = _model.name;
    titLab.textAlignment = NSTextAlignmentCenter;
    titLab.textColor = BaseColorBlack3;
    titLab.font = [UIFont systemFontOfSize:36 *SCREEN_W_SCALE];
    _titleLab = titLab;
    [self.headBCView addSubview: _titleLab];
    
    
    //members
    CGFloat labW = 140 * SCREEN_W_SCALE;
    CGFloat labX = SCREEN_WIDTH / 2 - 140 * SCREEN_W_SCALE;
    CGFloat labY = titLab.frame.origin.y +titLab.frame.size.height + 23 *SCREEN_W_SCALE;
    UILabel *membersCountLab = [[UILabel alloc] initWithFrame:CGRectMake(labX, labY, labW, 36 * SCREEN_W_SCALE)];
    membersCountLab.text = [NSString stringWithFormat:@"%ld", _model.peopleCount];
    membersCountLab.textAlignment = NSTextAlignmentCenter;
    membersCountLab.textColor = BaseColorYellow;
    membersCountLab.font = [UIFont systemFontOfSize:36 *SCREEN_W_SCALE];
    _membersCountLab = membersCountLab;
    [self.headBCView addSubview: _membersCountLab];
    
    UILabel *membersLab = [[UILabel alloc] initWithFrame:CGRectMake(labX, membersCountLab.frame.origin.y +membersCountLab.frame.size.height + 20 *SCREEN_W_SCALE, labW, 24 * SCREEN_W_SCALE)];
    membersLab.text = @"成员";
    membersLab.textAlignment = NSTextAlignmentCenter;
    membersLab.textColor = BaseColorGray;
    membersLab.font = [UIFont systemFontOfSize:24 *SCREEN_W_SCALE];
    _membersLab = membersLab;
    [self.headBCView addSubview: _membersLab];
    
    
    //分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, titLab.frame.origin.y +titLab.frame.size.height + 23 *SCREEN_W_SCALE, 0.5, 70 * SCREEN_W_SCALE)];
    lineView.backgroundColor = BaseColorGray2;
    [self.headBCView addSubview:lineView];
    
    
    //newss
    UILabel *newssCountLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, labY, labW, 36 * SCREEN_W_SCALE)];
    newssCountLab.text = [NSString stringWithFormat:@"%ld", _model.newsCount];
    newssCountLab.textAlignment = NSTextAlignmentCenter;
    newssCountLab.textColor = BaseColorYellow;
    newssCountLab.font = [UIFont systemFontOfSize:36 *SCREEN_W_SCALE];
    _newssCountLab = newssCountLab;
    [self.headBCView addSubview: _newssCountLab];
    
    UILabel *newsLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, newssCountLab.frame.origin.y +newssCountLab.frame.size.height + 20 *SCREEN_W_SCALE, labW, 24 * SCREEN_W_SCALE)];
    newsLab.text = @"动态";
    newsLab.textAlignment = NSTextAlignmentCenter;
    newsLab.textColor = BaseColorGray;
    newsLab.font = [UIFont systemFontOfSize:24 *SCREEN_W_SCALE];
    _newsLab = newsLab;
    [self.headBCView addSubview: _newsLab];
    
    
    //pubBtnView
    CGFloat btnW = 211 * SCREEN_W_SCALE;
    CGFloat btnH = 64 * SCREEN_W_SCALE;
    CGFloat btnX = SCREEN_WIDTH/2 - btnW - MARGIN_20;
    CGFloat btnY = newsLab.frame.origin.y + newsLab.frame.size.height + MARGIN_30;
    UIView *pubBtnView = [[UIView alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
    pubBtnView.layer.borderWidth = 0.5;
    pubBtnView.layer.borderColor = BaseColorGray.CGColor;
    pubBtnView.layer.cornerRadius = 2;
    pubBtnView.userInteractionEnabled = YES;
    [pubBtnView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPub:)]];
    _pubBtnView = pubBtnView;
    [self.headBCView addSubview: _pubBtnView];
    
    CGFloat iconY = 10 * SCREEN_W_SCALE;
    CGFloat iconH = 44 * SCREEN_W_SCALE;
    UIImageView *pubIcon = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN_20, iconY, iconH, iconH)];
    pubIcon.image = [UIImage imageNamed:@"fabu"];
    [pubBtnView addSubview:pubIcon];
    
    CGFloat pubLabX = 70 * SCREEN_W_SCALE;
    CGFloat pubLabW = btnW - pubLabX;
    UILabel *pubLab = [[UILabel alloc] initWithFrame:CGRectMake(pubLabX, iconY, pubLabW, iconH)];
    pubLab.text = @"发布动态";
    pubLab.font = [UIFont systemFontOfSize:30 * SCREEN_W_SCALE];
    pubLab.textColor = BaseColorBlack2;
    pubLab.userInteractionEnabled = NO;
    [pubBtnView addSubview:pubLab];
    
    
    //shareBtnView
    UIView *shareBtnView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 + MARGIN_20, btnY, btnW, btnH)];
    shareBtnView.layer.borderWidth = 0.5;
    shareBtnView.layer.borderColor = BaseColorGray.CGColor;
    shareBtnView.layer.cornerRadius = 2;
    shareBtnView.userInteractionEnabled = YES;
    [shareBtnView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickShare:)]];
    _shareBtnView = shareBtnView;
    [self.headBCView addSubview: _shareBtnView];
    
    UIImageView *shareIcon = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN_20, iconY, iconH, iconH)];
    shareIcon.image = [UIImage imageNamed:@"share_f"];
    shareIcon.userInteractionEnabled = NO;
    [shareBtnView addSubview:shareIcon];
    
    UILabel *shareLab = [[UILabel alloc] initWithFrame:CGRectMake(pubLabX, iconY, pubLabW, iconH)];
    shareLab.text = @"分享圈子";
    shareLab.font = [UIFont systemFontOfSize:30 * SCREEN_W_SCALE];
    shareLab.textColor = BaseColorBlack2;
    shareLab.userInteractionEnabled = NO;
    [shareBtnView addSubview:shareLab];
    
    
    
    //分割线
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, shareBtnView.frame.origin.y + shareBtnView.frame.size.height + MARGIN_30, SCREEN_WIDTH, 0.5)];
    lineView2.backgroundColor = BaseColorGray2;
    [self addSubview:lineView2];
    
    CGFloat contentW = SCREEN_WIDTH - 20 * SCREEN_W_SCALE;
    CGSize contentSize = [_model.introduction boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:28 * SCREEN_W_SCALE]} context:nil].size;
    UILabel *introductionLab = [[UILabel alloc] initWithFrame:CGRectMake(10 * SCREEN_W_SCALE, lineView2.frame.origin.y + MARGIN_30, contentW, contentSize.height)];
    introductionLab.text = _model.introduction;
    introductionLab.textAlignment = NSTextAlignmentLeft;
    introductionLab.textColor = BaseColorGray;
    introductionLab.font = [UIFont systemFontOfSize:30 *SCREEN_W_SCALE];
    _introductionLab = introductionLab;
    
    self.headBCView.frame = CGRectMake(0, 0, SCREEN_WIDTH,  lineView2.frame.origin.y);
    self.backgroundColor = [UIColor whiteColor];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH,  introductionLab.frame.origin.y + introductionLab.frame.size.height  );
    
}

- (void)clickPub:(UIGestureRecognizer *)sender {
    
    [self.delegate FbNewsCircle];
//    CircleNewsViewController *userVC = [[CircleNewsViewController alloc] init];
//    userVC.model = self.model;
//    [[CircleDetailViewController shareInstance].navigationController pushViewController:userVC animated:YES];
}
- (void)clickShare:(UIGestureRecognizer *)sender {
    
    [self.delegate shareCirle];
}
@end
