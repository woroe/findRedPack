//
//  NSDate+Date.h
//  zhubo
//
//  Created by Jin on 2017/6/16.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Date)

// 是否是今年
- (BOOL)isThisYear;

// 是否今天
- (BOOL)isThisToday;

// 是否昨天
- (BOOL)isThisYesterday;

@end
