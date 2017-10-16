//
//  UIButton+lihong.m
//  Created by hong Li on 2017/10/16.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//
#import "UIButton+lihong.h"

@implementation UIButton (lihong)

// 设置背景颜色for state
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
	[self setBackgroundImage:[UIButton imageWithColor:backgroundColor] forState:state];
}
// 设置颜色
+ (UIImage *)imageWithColor:(UIColor *)color {
	CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();

	CGContextSetFillColorWithColor(context, [color CGColor]);
	CGContextFillRect(context, rect);

	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return image;
}

@end
