//
//  UILabel+lihong.h
//  Created by hong Li on 2017/10/16.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface UILabel (lihong)

/** 设置UILabel的行间距*/
- (void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing;

/** 显示不同颜色的UILabel 文本内容  需要过滤的文字  文字颜色 文字大小 行间距*/
-(void)setTextValue:(NSString *)txt Filter:(NSString *)filter txtColor:(UIColor *)tc txtSize:(CGFloat)size txtLine:(NSInteger)line;

@end
