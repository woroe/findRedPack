//
//  CircleModel.h
//  zhubo
//
//  Created by Jin on 2017/6/19.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CircleModel : NSObject


@property (nonatomic, strong) NSString * backImg;
@property (nonatomic, assign) NSInteger circleId;
@property (nonatomic, strong) NSString * circleType;
@property (nonatomic, strong) NSString * circleUserId;
@property (nonatomic, strong) NSString * headImg;
@property (nonatomic, strong) NSString * introduction;
@property (nonatomic, assign) BOOL isAdd;
@property (nonatomic, assign) BOOL isAdminSendMsg;
@property (nonatomic, assign) BOOL isPay;
@property (nonatomic, assign) BOOL isSearch;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) NSInteger newsCount;
@property (nonatomic, assign) NSInteger peopleCount;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, strong) NSString * userId;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;

@end
