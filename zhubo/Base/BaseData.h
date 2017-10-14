//
//  BaseData.h
//  zhubo
//
//  Created by Jin on 2017/6/14.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseData : NSObject


@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString *headImg;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *nickName;



+ (instancetype)shareInstance;
- (void)setUser:(NSDictionary *)user;

@end
