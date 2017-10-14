//
//  UserModel.h
//  zhubo
//
//  Created by xiaolu on 2017/6/28.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *NickName;
@property (nonatomic, strong) NSString *HeadImg;
@property (nonatomic, assign) BOOL Is_Real;
@property (nonatomic, strong) NSString * ProfessionalIdentity;
@property (nonatomic, strong) NSString * ShowProfessionalIdentity;
@property (nonatomic, assign) NSInteger NewsCount;
@property (nonatomic, assign) NSInteger ColloctionCount;
@property (nonatomic, assign) NSInteger MsgCount;
@property (nonatomic, strong) NSString * PurseBalance;
@property (nonatomic, strong) NSString * Professional;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;

@end
