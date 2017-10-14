//
//  UserDetailModel.m
//  zhubo
//
//  Created by Jin on 2017/6/21.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "UserDetailModel.h"


NSString *const kUserDetailModelEmployer = @"Employer";
NSString *const kUserDetailModelFollowMeCount = @"FollowMeCount";
NSString *const kUserDetailModelHeadImg = @"HeadImg";
NSString *const kUserDetailModelIsFollowUser = @"Is_Follow_User";
NSString *const kUserDetailModelIsReal = @"Is_Real";
NSString *const kUserDetailModelMyFollowCount = @"MyFollowCount";
NSString *const kUserDetailModelNickName = @"NickName";
NSString *const kUserDetailModelPosition = @"Position";
NSString *const kUserDetailModelProfessionalIdentity = @"ProfessionalIdentity";
NSString *const kUserDetailModelRealEmployer = @"RealEmployer";
NSString *const kUserDetailModelRealName = @"RealName";
NSString *const kUserDetailModelRealPosition = @"RealPosition";
NSString *const kUserDetailModelUserId = @"UserId";

@interface UserDetailModel ()
@end
@implementation UserDetailModel




-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kUserDetailModelEmployer] isKindOfClass:[NSNull class]]){
        self.employer = dictionary[kUserDetailModelEmployer];
    }
    if(![dictionary[kUserDetailModelFollowMeCount] isKindOfClass:[NSNull class]]){
        self.followMeCount = [dictionary[kUserDetailModelFollowMeCount] integerValue];
    }
    
    if(![dictionary[kUserDetailModelHeadImg] isKindOfClass:[NSNull class]]){
        self.headImg = dictionary[kUserDetailModelHeadImg];
    }
    if(![dictionary[kUserDetailModelIsFollowUser] isKindOfClass:[NSNull class]]){
        self.isFollowUser = [dictionary[kUserDetailModelIsFollowUser] boolValue];
    }
    
    if(![dictionary[kUserDetailModelIsReal] isKindOfClass:[NSNull class]]){
        self.isReal = [dictionary[kUserDetailModelIsReal] boolValue];
    }
    
    if(![dictionary[kUserDetailModelMyFollowCount] isKindOfClass:[NSNull class]]){
        self.myFollowCount = [dictionary[kUserDetailModelMyFollowCount] integerValue];
    }
    
    if(![dictionary[kUserDetailModelNickName] isKindOfClass:[NSNull class]]){
        self.nickName = dictionary[kUserDetailModelNickName];
    }
    if(![dictionary[kUserDetailModelPosition] isKindOfClass:[NSNull class]]){
        self.position = dictionary[kUserDetailModelPosition];
    }
    if(![dictionary[kUserDetailModelProfessionalIdentity] isKindOfClass:[NSNull class]]){
        self.professionalIdentity = dictionary[kUserDetailModelProfessionalIdentity];
    }
    if(![dictionary[kUserDetailModelRealEmployer] isKindOfClass:[NSNull class]]){
        self.realEmployer = dictionary[kUserDetailModelRealEmployer];
    }
    if(![dictionary[kUserDetailModelRealName] isKindOfClass:[NSNull class]]){
        self.realName = dictionary[kUserDetailModelRealName];
    }
    if(![dictionary[kUserDetailModelRealPosition] isKindOfClass:[NSNull class]]){
        self.realPosition = dictionary[kUserDetailModelRealPosition];
    }
    if(![dictionary[kUserDetailModelUserId] isKindOfClass:[NSNull class]]){
        self.userId = [dictionary[kUserDetailModelUserId] integerValue];
    }
    
    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    if(self.employer != nil){
        dictionary[kUserDetailModelEmployer] = self.employer;
    }
    dictionary[kUserDetailModelFollowMeCount] = @(self.followMeCount);
    if(self.headImg != nil){
        dictionary[kUserDetailModelHeadImg] = self.headImg;
    }
    dictionary[kUserDetailModelIsFollowUser] = @(self.isFollowUser);
    dictionary[kUserDetailModelIsReal] = @(self.isReal);
    dictionary[kUserDetailModelMyFollowCount] = @(self.myFollowCount);
    if(self.nickName != nil){
        dictionary[kUserDetailModelNickName] = self.nickName;
    }
    if(self.position != nil){
        dictionary[kUserDetailModelPosition] = self.position;
    }
    if(self.professionalIdentity != nil){
        dictionary[kUserDetailModelProfessionalIdentity] = self.professionalIdentity;
    }
    if(self.realEmployer != nil){
        dictionary[kUserDetailModelRealEmployer] = self.realEmployer;
    }
    if(self.realName != nil){
        dictionary[kUserDetailModelRealName] = self.realName;
    }
    if(self.realPosition != nil){
        dictionary[kUserDetailModelRealPosition] = self.realPosition;
    }
    dictionary[kUserDetailModelUserId] = @(self.userId);
    return dictionary;
    
}

/**
 * Implementation of NSCoding encoding method
 */
/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    if(self.employer != nil){
        [aCoder encodeObject:self.employer forKey:kUserDetailModelEmployer];
    }
    [aCoder encodeObject:@(self.followMeCount) forKey:kUserDetailModelFollowMeCount];	if(self.headImg != nil){
        [aCoder encodeObject:self.headImg forKey:kUserDetailModelHeadImg];
    }
    [aCoder encodeObject:@(self.isFollowUser) forKey:kUserDetailModelIsFollowUser];	[aCoder encodeObject:@(self.isReal) forKey:kUserDetailModelIsReal];	[aCoder encodeObject:@(self.myFollowCount) forKey:kUserDetailModelMyFollowCount];	if(self.nickName != nil){
        [aCoder encodeObject:self.nickName forKey:kUserDetailModelNickName];
    }
    if(self.position != nil){
        [aCoder encodeObject:self.position forKey:kUserDetailModelPosition];
    }
    if(self.professionalIdentity != nil){
        [aCoder encodeObject:self.professionalIdentity forKey:kUserDetailModelProfessionalIdentity];
    }
    if(self.realEmployer != nil){
        [aCoder encodeObject:self.realEmployer forKey:kUserDetailModelRealEmployer];
    }
    if(self.realName != nil){
        [aCoder encodeObject:self.realName forKey:kUserDetailModelRealName];
    }
    if(self.realPosition != nil){
        [aCoder encodeObject:self.realPosition forKey:kUserDetailModelRealPosition];
    }
    [aCoder encodeObject:@(self.userId) forKey:kUserDetailModelUserId];
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.employer = [aDecoder decodeObjectForKey:kUserDetailModelEmployer];
    self.followMeCount = [[aDecoder decodeObjectForKey:kUserDetailModelFollowMeCount] integerValue];
    self.headImg = [aDecoder decodeObjectForKey:kUserDetailModelHeadImg];
    self.isFollowUser = [[aDecoder decodeObjectForKey:kUserDetailModelIsFollowUser] boolValue];
    self.isReal = [[aDecoder decodeObjectForKey:kUserDetailModelIsReal] boolValue];
    self.myFollowCount = [[aDecoder decodeObjectForKey:kUserDetailModelMyFollowCount] integerValue];
    self.nickName = [aDecoder decodeObjectForKey:kUserDetailModelNickName];
    self.position = [aDecoder decodeObjectForKey:kUserDetailModelPosition];
    self.professionalIdentity = [aDecoder decodeObjectForKey:kUserDetailModelProfessionalIdentity];
    self.realEmployer = [aDecoder decodeObjectForKey:kUserDetailModelRealEmployer];
    self.realName = [aDecoder decodeObjectForKey:kUserDetailModelRealName];
    self.realPosition = [aDecoder decodeObjectForKey:kUserDetailModelRealPosition];
    self.userId = [[aDecoder decodeObjectForKey:kUserDetailModelUserId] integerValue];
    return self;
    
}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
    UserDetailModel *copy = [UserDetailModel new];
    
    copy.employer = [self.employer copy];
    copy.followMeCount = self.followMeCount;
    copy.headImg = [self.headImg copy];
    copy.isFollowUser = self.isFollowUser;
    copy.isReal = self.isReal;
    copy.myFollowCount = self.myFollowCount;
    copy.nickName = [self.nickName copy];
    copy.position = [self.position copy];
    copy.professionalIdentity = [self.professionalIdentity copy];
    copy.realEmployer = [self.realEmployer copy];
    copy.realName = [self.realName copy];
    copy.realPosition = [self.realPosition copy];
    copy.userId = self.userId;
    
    return copy;
}
@end
