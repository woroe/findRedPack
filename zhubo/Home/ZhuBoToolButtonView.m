//
//  ZhuBoToolButtonView.m
//  zhubo
//
//  Created by Jin on 2017/6/17.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "ZhuBoToolButtonView.h"

@implementation ZhuBoToolButtonView

-(void)loadButtonWith:(NSString *)image selectedImage:(NSString *)selected title:(NSString *)title index:(NSInteger)index {
    self.tag = 10000 + index;
    
    UIButton *imageBtn = [[UIButton alloc] initWithFrame:CGRectMake(11, 5, 22, 22)];
    [imageBtn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [imageBtn setImage:[UIImage imageNamed:selected] forState:UIControlStateSelected];
    imageBtn.userInteractionEnabled = NO;
    self.imageBtn = imageBtn;
    [self addSubview:imageBtn];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, 44, 14)];
    titleLab.text = title;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor grayColor];
    titleLab.font = [UIFont systemFontOfSize:10];
    titleLab.userInteractionEnabled = NO;
    self.titleLab = titleLab;
    [self addSubview:titleLab];
    
}

@end
