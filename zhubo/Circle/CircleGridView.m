//
//  CircleGridView.m
//  zhubo
//
//  Created by Jin on 2017/6/19.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "CircleGridView.h"

@implementation CircleGridView

- (void)loadWithModel:(CircleModel *)model {
    _model = model;
    
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat collctionCellW = self.frame.size.width;
    CGFloat w = 130*SCREEN_W_SCALE;
    CGFloat x = (collctionCellW - w) / 2;
    _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 35*SCREEN_W_SCALE, w, w)];
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:_model.headImg]];
    _headImgView.contentMode = UIViewContentModeScaleAspectFill;
    _headImgView.layer.masksToBounds = YES;
    _headImgView.layer.cornerRadius = w * SCREEN_W_SCALE;
    [self addSubview:_headImgView];
    
    if(_model.isPay) {
        CGFloat payViewW = 80 * SCREEN_W_SCALE;
        _payImgView = [[UIImageView alloc] initWithFrame:CGRectMake(collctionCellW - payViewW, 0, payViewW, payViewW)];
        _payImgView.image = [UIImage imageNamed:@"fufei"];
        [self addSubview:_payImgView];
    }
    
    UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(0, w + 75*SCREEN_W_SCALE, collctionCellW, 30 * SCREEN_W_SCALE)];
    titLab.text = _model.name;
    titLab.textAlignment = NSTextAlignmentCenter;
    titLab.textColor = BaseColorBlack3;
    titLab.font = [UIFont systemFontOfSize:30 *SCREEN_W_SCALE];
    _titleLab = titLab;
    [self addSubview: titLab];
    
    UILabel *membersLab = [[UILabel alloc] initWithFrame:CGRectMake(0, titLab.frame.origin.y +titLab.frame.size.height + 20 *SCREEN_W_SCALE, collctionCellW, 24 * SCREEN_W_SCALE)];
    membersLab.text = [NSString stringWithFormat:@"%ld人", _model.peopleCount];
    membersLab.textAlignment = NSTextAlignmentCenter;
    membersLab.textColor = BaseColorGray;
    membersLab.font = [UIFont systemFontOfSize:24 *SCREEN_W_SCALE];
    _membersLab = membersLab;
    [self addSubview:membersLab];
}

@end
