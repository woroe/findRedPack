//
//  BaseClasss.m
//  zhubo
//
//  Created by Jin on 2017/6/13.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "BaseClasss.h"
#import "NSDate+Date.h"
#import <CommonCrypto/CommonDigest.h>

@implementation BaseClasss

+ (BOOL)validateCellPhoneNumber:(NSString *)cellNum{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,177,180,189
     22         */
    NSString * CT = @"^1((33|53|77|8[09])[0-9]|349)\\d{7}$";
    
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    // NSPredicate *regextestPHS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    if(([regextestmobile evaluateWithObject:cellNum] == YES)
       || ([regextestcm evaluateWithObject:cellNum] == YES)
       || ([regextestct evaluateWithObject:cellNum] == YES)
       || ([regextestcu evaluateWithObject:cellNum] == YES)){
        return YES;
    }else{
        return NO;
    }
}

+ (NSString *)MD5:(NSString *)mdStr {
    const char *original_str = [mdStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

+ (BOOL)isLogin {
    if([BaseData shareInstance].userId > 0) {
        return YES;
    }
    [[HomeViewController shareInstance] loadLoginVC];
    return NO;
}

// 传入一个timeStr，返回对应格式的字符串
+ (NSString *)setupCreateTime:(NSString *)timeStr {
    
    // NSDateFormatter:NSString与NSDate互转
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    
    /*
     // 如果我们得到的是其他地区时间格式，需要设置locale（我们获得的一开始是欧美时间，所以说这里写 en_US）
     fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
     
     // 设置日期格式（声明字符串里面每个数字和单词的含义）
     fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy"; // 因为我们直接获得到的_created_at是欧美时间(NSString类型，无法直接使用)，所以要先用欧美格式将我们获得到的字符串转化为NSDate，然后再设置一次格式，将NSDate转化成为字符串格式
     
     // 微博的创建日期（将_created_at字符串对象转化成为NSDate对象）
     NSDate *createDateUS = [fmt dateFromString:timeStr]; // 此时
     
     // 再次设置日期格式（然后再通过这个日期格式去处理时间字符串）
     fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
     */
    
    
    // 设置格式
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 发布日期对象
    NSDate *createDate = [fmt dateFromString:timeStr];
    
    // 处理时间(用帖子发布时间与当前时间比较)
    // 判断是否是今年 年份是否相等 => 获取日期年份 => 日历,获取日期组件
    // 获取帖子发布时间与当前时间差值
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 获取两个日期差值
    NSDateComponents *cmp = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute  fromDate:createDate toDate:[NSDate date] options:NSCalendarWrapComponents];
    
    
    if ([createDate isThisYear]) {
        if ([createDate isThisToday]) {
            
            // 获取日期差值
            if (cmp.hour >= 1) {
                timeStr = [NSString stringWithFormat:@"%ld小时前",cmp.hour];
            } else if (cmp.minute >= 2) {
                timeStr = [NSString stringWithFormat:@"%ld分钟前",cmp.minute];
            } else { // 刚刚
                timeStr = @"刚刚";
            }
            
        } else if ([createDate isThisYesterday]) { // 昨天
            // 昨天 21:10
            fmt.dateFormat = @"昨天 HH:mm";
            timeStr = [fmt stringFromDate:createDate];
            
        } else { // 今年的其他日子
            fmt.dateFormat = @"MM-dd";
            timeStr = [fmt stringFromDate:createDate];
        }
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd";
        timeStr = [fmt stringFromDate:createDate];
    }
    
    return timeStr;
    
}
@end
