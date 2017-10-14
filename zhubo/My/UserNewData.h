//
//  UserNewData.h
//  zhubo
//
//  Created by Jin on 2017/8/1.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

//UserId 用户ID  HeadImg 头像地址  Sex性别，  Province 省份 ， City 城市 ，RealName 姓名，NickName昵称，Employer单位，Position职位，IdentityCode身份代码 ，LxCode分类代码，Professional 职称
#import <Foundation/Foundation.h>

@interface UserNewData : NSObject

@property (nonatomic, strong) NSString *HeadImg;
@property (nonatomic, strong) NSString *Sex;
@property (nonatomic, strong) NSString *Province;
@property (nonatomic, strong) NSString * City;
@property (nonatomic, strong) NSString * RealName;
@property (nonatomic, strong) NSString *NickName;
@property (nonatomic, strong) NSString *Employer;
@property (nonatomic, strong) NSString *Position;
@property (nonatomic, strong) NSString * Professional;
@property (nonatomic, strong) NSString * shenfen;
@property (nonatomic, strong) NSString * lx;
@property (nonatomic, assign) NSInteger IdentityCode;
@property (nonatomic, assign) NSInteger LxCode;
@property (nonatomic, assign) NSInteger ShowEmployer;
@property (nonatomic, assign) NSInteger ShowPosition;
@property (nonatomic, assign) NSInteger ShowRealName;
@property (nonatomic, assign) NSInteger labcount;
@property (nonatomic, assign) NSInteger followcount;
@property (nonatomic, assign) NSInteger newscount;
@property (nonatomic, assign) NSInteger fanscount;

@end
