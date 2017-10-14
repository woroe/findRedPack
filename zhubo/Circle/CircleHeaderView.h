//
//  CircleHeaderView.h
//  zhubo
//
//  Created by Jin on 2017/6/19.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleModel.h"

@protocol CircleHeaderViewDelegate <NSObject>

-(void)FbNewsCircle;//发布动态
-(void)shareCirle; //分享圈子

@end

@interface CircleHeaderView : UIView

@property (nonatomic, strong)CircleModel *model;

@property (nonatomic, strong) UIImageView *headBCView;
@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *membersCountLab;
@property (nonatomic, strong) UILabel *membersLab;
@property (nonatomic, strong) UILabel *newssCountLab;
@property (nonatomic, strong) UILabel *newsLab;
@property (nonatomic, strong) UIView *pubBtnView;
@property (nonatomic, strong) UIView *shareBtnView;
@property (nonatomic, strong) UILabel *introductionLab;


@property (nonatomic, strong) id<CircleHeaderViewDelegate> delegate;


- (void)loadWithModel:(CircleModel *)model;

@end
