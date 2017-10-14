//
//  UserDetailModel.h
//  zhubo
//
//  Created by Jin on 2017/6/21.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDetailModel : NSObject

@property (nonatomic, strong) NSString * employer;
@property (nonatomic, assign) NSInteger followMeCount;
@property (nonatomic, strong) NSString * headImg;
@property (nonatomic, assign) BOOL isFollowUser;
@property (nonatomic, assign) BOOL isReal;
@property (nonatomic, assign) NSInteger myFollowCount;
@property (nonatomic, strong) NSString * nickName;
@property (nonatomic, strong) NSString * position;
@property (nonatomic, strong) NSString * professionalIdentity;
@property (nonatomic, strong) NSString * realEmployer;
@property (nonatomic, strong) NSString * realName;
@property (nonatomic, strong) NSString * realPosition;
@property (nonatomic, assign) NSInteger userId;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
