//
//  ZhuBoToolButtonView.h
//  zhubo
//
//  Created by Jin on 2017/6/17.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhuBoToolButtonView : UIView

@property (nonatomic, strong) UIButton *imageBtn;
@property (nonatomic, strong) UILabel *titleLab;

-(void)loadButtonWith:(NSString *)image selectedImage:(NSString *)selected title:(NSString *)title index:(NSInteger)index;

@end
