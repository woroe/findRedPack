//
//  CircleGridView.h
//  zhubo
//
//  Created by Jin on 2017/6/19.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleModel.h"

@interface CircleGridView : UIView

@property (nonatomic, strong)CircleModel *model;

@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UIImageView *payImgView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *membersLab;

- (void)loadWithModel:(CircleModel *)model;
@end
