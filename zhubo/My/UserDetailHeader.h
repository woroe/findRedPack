//
//  UserDetailHeader.h
//  zhubo
//
//  Created by Jin on 2017/6/15.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDetailModel.h"

@interface UserDetailHeader : UIView

@property (nonatomic, strong)UserDetailModel *model;

@property (nonatomic, strong) UIImageView *headBCView;
@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UILabel *nickLab;
@property (nonatomic, strong) UILabel *companyLabY;
@property (nonatomic, strong) UILabel *membersCountLab;
@property (nonatomic, strong) UILabel *membersLab;
@property (nonatomic, strong) UILabel *newssCountLab;
@property (nonatomic, strong) UILabel *newsLab;
@property (nonatomic, strong) UIView *followBtnView;
@property (nonatomic, strong) UIView *messageBtnView;
@property (nonatomic, strong) UILabel *introductionLab;

- (void)loadWithModel:(UserDetailModel *)model;

@end
