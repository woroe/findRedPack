//
//  CircleModel.m
//  zhubo
//
//  Created by Jin on 2017/6/19.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "CircleModel.h"

NSString *const kCircleModelBackImg = @"BackImg";
NSString *const kCircleModelCircleId = @"Id";
NSString *const kCircleModelCircleType = @"CircleType";
NSString *const kCircleModelCircleUserId = @"CircleUserId";
NSString *const kCircleModelHeadImg = @"HeadImg";
NSString *const kCircleModelIntroduction = @"Introduction";
NSString *const kCircleModelIsAdd = @"IsAdd";
NSString *const kCircleModelIsAdminSendMsg = @"IsAdminSendMsg";
NSString *const kCircleModelIsPay = @"IsPay";
NSString *const kCircleModelIsSearch = @"IsSearch";
NSString *const kCircleModelName = @"Name";
NSString *const kCircleModelNewsCount = @"NewsCount";
NSString *const kCircleModelPeopleCount = @"PeopleCount";
NSString *const kCircleModelPrice = @"Price";
NSString *const kCircleModelUserId = @"UserId";

@interface CircleModel ()
@end
@implementation CircleModel




-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kCircleModelBackImg] isKindOfClass:[NSNull class]]){
        self.backImg = dictionary[kCircleModelBackImg];
    }
    if(![dictionary[kCircleModelCircleId] isKindOfClass:[NSNull class]]){
        self.circleId = [dictionary[kCircleModelCircleId] integerValue];
    }
    
    if(![dictionary[kCircleModelCircleType] isKindOfClass:[NSNull class]]){
        self.circleType = dictionary[kCircleModelCircleType];
    }
    if(![dictionary[kCircleModelCircleUserId] isKindOfClass:[NSNull class]]){
        self.circleUserId = dictionary[kCircleModelCircleUserId];
    }
    if(![dictionary[kCircleModelHeadImg] isKindOfClass:[NSNull class]]){
        self.headImg = dictionary[kCircleModelHeadImg];
    }
    if(![dictionary[kCircleModelIntroduction] isKindOfClass:[NSNull class]]){
        self.introduction = dictionary[kCircleModelIntroduction];
    }
    if(![dictionary[kCircleModelIsAdd] isKindOfClass:[NSNull class]]){
        self.isAdd = [dictionary[kCircleModelIsAdd] boolValue];
    }
    
    if(![dictionary[kCircleModelIsAdminSendMsg] isKindOfClass:[NSNull class]]){
        self.isAdminSendMsg = [dictionary[kCircleModelIsAdminSendMsg] boolValue];
    }
    
    if(![dictionary[kCircleModelIsPay] isKindOfClass:[NSNull class]]){
        self.isPay = [dictionary[kCircleModelIsPay] boolValue];
    }
    
    if(![dictionary[kCircleModelIsSearch] isKindOfClass:[NSNull class]]){
        self.isSearch = [dictionary[kCircleModelIsSearch] boolValue];
    }
    
    if(![dictionary[kCircleModelName] isKindOfClass:[NSNull class]]){
        self.name = dictionary[kCircleModelName];
    }
    if(![dictionary[kCircleModelNewsCount] isKindOfClass:[NSNull class]]){
        self.newsCount = [dictionary[kCircleModelNewsCount] integerValue];
    }
    
    if(![dictionary[kCircleModelPeopleCount] isKindOfClass:[NSNull class]]){
        self.peopleCount = [dictionary[kCircleModelPeopleCount] integerValue];
    }
    
    if(![dictionary[kCircleModelPrice] isKindOfClass:[NSNull class]]){
        self.price = [dictionary[kCircleModelPrice] integerValue];
    }
    
    if(![dictionary[kCircleModelUserId] isKindOfClass:[NSNull class]]){
        self.userId = dictionary[kCircleModelUserId];
    }
    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    if(self.backImg != nil){
        dictionary[kCircleModelBackImg] = self.backImg;
    }
    dictionary[kCircleModelCircleId] = @(self.circleId);
    if(self.circleType != nil){
        dictionary[kCircleModelCircleType] = self.circleType;
    }
    if(self.circleUserId != nil){
        dictionary[kCircleModelCircleUserId] = self.circleUserId;
    }
    if(self.headImg != nil){
        dictionary[kCircleModelHeadImg] = self.headImg;
    }
    if(self.introduction != nil){
        dictionary[kCircleModelIntroduction] = self.introduction;
    }
    dictionary[kCircleModelIsAdd] = @(self.isAdd);
    dictionary[kCircleModelIsAdminSendMsg] = @(self.isAdminSendMsg);
    dictionary[kCircleModelIsPay] = @(self.isPay);
    dictionary[kCircleModelIsSearch] = @(self.isSearch);
    if(self.name != nil){
        dictionary[kCircleModelName] = self.name;
    }
    dictionary[kCircleModelNewsCount] = @(self.newsCount);
    dictionary[kCircleModelPeopleCount] = @(self.peopleCount);
    dictionary[kCircleModelPrice] = @(self.price);
    if(self.userId != nil){
        dictionary[kCircleModelUserId] = self.userId;
    }
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
    if(self.backImg != nil){
        [aCoder encodeObject:self.backImg forKey:kCircleModelBackImg];
    }
    [aCoder encodeObject:@(self.circleId) forKey:kCircleModelCircleId];	if(self.circleType != nil){
        [aCoder encodeObject:self.circleType forKey:kCircleModelCircleType];
    }
    if(self.circleUserId != nil){
        [aCoder encodeObject:self.circleUserId forKey:kCircleModelCircleUserId];
    }
    if(self.headImg != nil){
        [aCoder encodeObject:self.headImg forKey:kCircleModelHeadImg];
    }
    if(self.introduction != nil){
        [aCoder encodeObject:self.introduction forKey:kCircleModelIntroduction];
    }
    [aCoder encodeObject:@(self.isAdd) forKey:kCircleModelIsAdd];	[aCoder encodeObject:@(self.isAdminSendMsg) forKey:kCircleModelIsAdminSendMsg];	[aCoder encodeObject:@(self.isPay) forKey:kCircleModelIsPay];	[aCoder encodeObject:@(self.isSearch) forKey:kCircleModelIsSearch];	if(self.name != nil){
        [aCoder encodeObject:self.name forKey:kCircleModelName];
    }
    [aCoder encodeObject:@(self.newsCount) forKey:kCircleModelNewsCount];	[aCoder encodeObject:@(self.peopleCount) forKey:kCircleModelPeopleCount];	[aCoder encodeObject:@(self.price) forKey:kCircleModelPrice];	if(self.userId != nil){
        [aCoder encodeObject:self.userId forKey:kCircleModelUserId];
    }
    
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.backImg = [aDecoder decodeObjectForKey:kCircleModelBackImg];
    self.circleId = [[aDecoder decodeObjectForKey:kCircleModelCircleId] integerValue];
    self.circleType = [aDecoder decodeObjectForKey:kCircleModelCircleType];
    self.circleUserId = [aDecoder decodeObjectForKey:kCircleModelCircleUserId];
    self.headImg = [aDecoder decodeObjectForKey:kCircleModelHeadImg];
    self.introduction = [aDecoder decodeObjectForKey:kCircleModelIntroduction];
    self.isAdd = [[aDecoder decodeObjectForKey:kCircleModelIsAdd] boolValue];
    self.isAdminSendMsg = [[aDecoder decodeObjectForKey:kCircleModelIsAdminSendMsg] boolValue];
    self.isPay = [[aDecoder decodeObjectForKey:kCircleModelIsPay] boolValue];
    self.isSearch = [[aDecoder decodeObjectForKey:kCircleModelIsSearch] boolValue];
    self.name = [aDecoder decodeObjectForKey:kCircleModelName];
    self.newsCount = [[aDecoder decodeObjectForKey:kCircleModelNewsCount] integerValue];
    self.peopleCount = [[aDecoder decodeObjectForKey:kCircleModelPeopleCount] integerValue];
    self.price = [[aDecoder decodeObjectForKey:kCircleModelPrice] integerValue];
    self.userId = [aDecoder decodeObjectForKey:kCircleModelUserId];
    return self;
    
}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
    CircleModel *copy = [CircleModel new];
    
    copy.backImg = [self.backImg copy];
    copy.circleId = self.circleId;
    copy.circleType = [self.circleType copy];
    copy.circleUserId = [self.circleUserId copy];
    copy.headImg = [self.headImg copy];
    copy.introduction = [self.introduction copy];
    copy.isAdd = self.isAdd;
    copy.isAdminSendMsg = self.isAdminSendMsg;
    copy.isPay = self.isPay;
    copy.isSearch = self.isSearch;
    copy.name = [self.name copy];
    copy.newsCount = self.newsCount;
    copy.peopleCount = self.peopleCount;
    copy.price = self.price;
    copy.userId = [self.userId copy];
    
    return copy;
}
@end
