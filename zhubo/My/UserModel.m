//
//  UserModel.m
//  zhubo
//
//  Created by xiaolu on 2017/6/28.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "UserModel.h"

NSString *const userId = @"UserId";
NSString *const NickName = @"NickName";
NSString *const HeadImg = @"HeadImg";
NSString *const Is_Real = @"Is_Real";
NSString *const PurseBalance = @"PurseBalance";
NSString *const ShowProfessionalIdentity = @"ShowProfessionalIdentity";
NSString *const NewsCount = @"NewsCount";
NSString *const ColloctionCount = @"ColloctionCount";
NSString *const MsgCount = @"MsgCount";
NSString *const ProfessionalIdentity = @"ProfessionalIdentity";
NSString *const Professional = @"Professional";

@interface UserModel ()


@end
@implementation UserModel




-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[userId] isKindOfClass:[NSNull class]]){
        self.userId = dictionary[userId];
    }
    if(![dictionary[NickName] isKindOfClass:[NSNull class]]){
        self.NickName = dictionary[NickName];;
    }
    
    if(![dictionary[HeadImg] isKindOfClass:[NSNull class]]){
        self.HeadImg = dictionary[HeadImg];
    }
    if(![dictionary[Is_Real] isKindOfClass:[NSNull class]]){
        self.Is_Real = [dictionary[Is_Real] boolValue];
    }
    
    if(![dictionary[ProfessionalIdentity] isKindOfClass:[NSNull class]]){
        self.ProfessionalIdentity = dictionary[ProfessionalIdentity];
    }
    if(![dictionary[ShowProfessionalIdentity] isKindOfClass:[NSNull class]]){
        self.ShowProfessionalIdentity = dictionary[ShowProfessionalIdentity];
    }
    if(![dictionary[NewsCount] isKindOfClass:[NSNull class]]){
        self.NewsCount = [dictionary[NewsCount] integerValue];
    }
    if(![dictionary[ColloctionCount] isKindOfClass:[NSNull class]]){
        self.ColloctionCount = [dictionary[ColloctionCount] integerValue];
    }
    if(![dictionary[MsgCount] isKindOfClass:[NSNull class]]){
        self.MsgCount = [dictionary[MsgCount] integerValue];
    }
    if(![dictionary[PurseBalance] isKindOfClass:[NSNull class]]){
        self.PurseBalance = dictionary[PurseBalance];
    }
    if(![dictionary[Professional] isKindOfClass:[NSNull class]]){
        self.Professional = dictionary[Professional];
    }
    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    if(self.userId != nil){
        dictionary[userId] = self.userId;
    }
    if(self.NickName != nil){
        dictionary[NickName] = self.NickName;
    }
    if(self.HeadImg != nil){
        dictionary[HeadImg] = self.HeadImg;
    }
    dictionary[Is_Real] = @(self.Is_Real);
    if(self.ProfessionalIdentity != nil){
        dictionary[ProfessionalIdentity] = self.ProfessionalIdentity;
    }
    if(self.ShowProfessionalIdentity != nil){
        dictionary[ShowProfessionalIdentity] = self.ShowProfessionalIdentity;
    }
    if(self.PurseBalance != nil){
        dictionary[PurseBalance] = self.PurseBalance;
    }
    if(self.Professional != nil){
        dictionary[Professional] = self.Professional;
    }
    dictionary[NewsCount] = @(self.ColloctionCount);
    dictionary[NewsCount] = @(self.MsgCount);
    dictionary[NewsCount] = @(self.NewsCount);
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
    if(self.userId != nil){
        [aCoder encodeObject:self.userId forKey:userId];
    }
    [aCoder encodeObject:@(self.Is_Real) forKey:Is_Real];
    
    if(self.NickName != nil){
        [aCoder encodeObject:self.NickName forKey:NickName];
    }
    [aCoder encodeObject:@(self.NewsCount) forKey:NewsCount];
    [aCoder encodeObject:@(self.ColloctionCount) forKey:ColloctionCount];
    [aCoder encodeObject:@(self.MsgCount) forKey:MsgCount];
    
    if(self.HeadImg != nil){
        [aCoder encodeObject:self.HeadImg forKey:HeadImg];
    }
    if(self.ProfessionalIdentity != nil){
        [aCoder encodeObject:self.ProfessionalIdentity forKey:ProfessionalIdentity];
    }
    if(self.ShowProfessionalIdentity != nil){
        [aCoder encodeObject:self.ShowProfessionalIdentity forKey:ShowProfessionalIdentity];
    }
    if(self.PurseBalance != nil){
        [aCoder encodeObject:self.PurseBalance forKey:PurseBalance];
    }
    if(self.Professional != nil){
        [aCoder encodeObject:self.Professional forKey:Professional];
    }
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.userId = [aDecoder decodeObjectForKey:userId];
    self.NickName = [aDecoder decodeObjectForKey:NickName];
    self.HeadImg = [aDecoder decodeObjectForKey:HeadImg];
    self.Is_Real = [[aDecoder decodeObjectForKey:Is_Real] boolValue];
    self.ProfessionalIdentity = [aDecoder decodeObjectForKey:ProfessionalIdentity];
    self.ShowProfessionalIdentity = [aDecoder decodeObjectForKey:ShowProfessionalIdentity];
    self.PurseBalance = [aDecoder decodeObjectForKey:PurseBalance];
    self.Professional = [aDecoder decodeObjectForKey:Professional];
    self.NewsCount = [[aDecoder decodeObjectForKey:NewsCount] integerValue];
    self.ColloctionCount = [[aDecoder decodeObjectForKey:ColloctionCount] integerValue];
    self.MsgCount = [[aDecoder decodeObjectForKey:MsgCount] integerValue];
    return self;
    
}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
    UserModel *copy = [UserModel new];
    
    copy.userId = [self.userId copy];
    copy.NickName = [self.NickName copy];
    copy.HeadImg = [self.HeadImg copy];
    copy.Is_Real = self.Is_Real;
    copy.ProfessionalIdentity = [self.ProfessionalIdentity copy];
    copy.ShowProfessionalIdentity = [self.ShowProfessionalIdentity copy];
    copy.PurseBalance = [self.PurseBalance copy];
    copy.NewsCount = self.NewsCount;
    copy.ColloctionCount = self.ColloctionCount;;
    copy.MsgCount = self.MsgCount;
    
    return copy;
}

@end

