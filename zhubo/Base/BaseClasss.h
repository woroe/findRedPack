//
//  BaseClasss.h
//  zhubo
//
//  Created by Jin on 2017/6/13.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseClasss : NSObject

+ (BOOL)validateCellPhoneNumber:(NSString *)cellNum;
+ (NSString *)MD5:(NSString *)mdStr;
+ (NSString *)setupCreateTime:(NSString *)timeStr;
+ (BOOL)isLogin;

@end
