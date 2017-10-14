//
//  ZhuBoModel.m
//  zhubo
//
//  Created by Jin on 2017/6/14.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "ZhuBoModel.h"

NSString *const kRootClassAddress = @"Address";
NSString *const kRootClassCommentCount = @"CommentCount";
NSString *const kRootClassFollowCount = @"FollowCount";
NSString *const kRootClassHeadImg = @"HeadImg";
NSString *const kRootClassIsFollowNews = @"Is_Follow_News";
NSString *const kRootClassIsFollowUser = @"Is_Follow_User";
NSString *const kRootClassIsReal = @"Is_Real";
NSString *const kRootClassNewsContent = @"NewsContent";
NSString *const kRootClassNewsContentType = @"NewsContentType";
NSString *const kRootClassNewsId = @"NewsId";
NSString *const kRootClassNewsTime = @"NewsTime";
NSString *const kRootClassNickName = @"NickName";
NSString *const kRootClassUserId = @"UserId";
NSString *const kRootClassWords = @"Words";
NSString *const kRootClassLatitude = @"Latitude";
NSString *const kRootClassLongitude = @"Longitude";

NSString *const kRootClassshenfen = @"shenfen";
NSString *const kRootClasslx = @"lx";
NSString *const kRootClassFirstImsg = @"FirstImsg";

@implementation ZhuBoModel


-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kRootClassAddress] isKindOfClass:[NSNull class]]){
        self.address = dictionary[kRootClassAddress];
    }
    if(![dictionary[kRootClassCommentCount] isKindOfClass:[NSNull class]]){
        self.commentCount = [dictionary[kRootClassCommentCount] integerValue];
    }
    
    if(![dictionary[kRootClassFollowCount] isKindOfClass:[NSNull class]]){
        self.followCount = [dictionary[kRootClassFollowCount] integerValue];
    }
    
    if(![dictionary[kRootClassHeadImg] isKindOfClass:[NSNull class]]){
        self.headImg = dictionary[kRootClassHeadImg];
    }
    if(![dictionary[kRootClassIsFollowNews] isKindOfClass:[NSNull class]]){
        self.isFollowNews = [dictionary[kRootClassIsFollowNews] boolValue];
    }
    
    if(![dictionary[kRootClassIsFollowUser] isKindOfClass:[NSNull class]]){
        self.isFollowUser = [dictionary[kRootClassIsFollowUser] boolValue];
    }
    
    if(![dictionary[kRootClassIsReal] isKindOfClass:[NSNull class]]){
        self.isReal = [dictionary[kRootClassIsReal] boolValue];
    }
    
    if(![dictionary[kRootClassNewsContent] isKindOfClass:[NSNull class]]){
        self.newsContent = dictionary[kRootClassNewsContent];
        self.imgArr = [dictionary[kRootClassNewsContent] componentsSeparatedByString:@"@"];
    }
    if(![dictionary[kRootClassNewsContentType] isKindOfClass:[NSNull class]]){
        self.newsContentType = [dictionary[kRootClassNewsContentType] integerValue];
    }
    
    if(![dictionary[kRootClassNewsId] isKindOfClass:[NSNull class]]){
        self.newsId = [dictionary[kRootClassNewsId] integerValue];
    }
    
    if(![dictionary[kRootClassNewsTime] isKindOfClass:[NSNull class]]){
        self.newsTime = dictionary[kRootClassNewsTime];
    }
    if(![dictionary[kRootClassNickName] isKindOfClass:[NSNull class]]){
        self.nickName = dictionary[kRootClassNickName];
    }
    if(![dictionary[kRootClassUserId] isKindOfClass:[NSNull class]]){
        self.userId = [dictionary[kRootClassUserId] integerValue];
    }
    
    if(![dictionary[kRootClassWords] isKindOfClass:[NSNull class]]){
        self.words = dictionary[kRootClassWords];
    }
    if(![dictionary[kRootClassLatitude] isKindOfClass:[NSNull class]]){
        self.latitude = dictionary[kRootClassLatitude];
    }
    if(![dictionary[kRootClassLongitude] isKindOfClass:[NSNull class]]){
        self.longitude = dictionary[kRootClassLongitude];
    }
    if(![dictionary[kRootClasslx] isKindOfClass:[NSNull class]]){
        self.lx = dictionary[kRootClasslx];
    }
    if(![dictionary[kRootClassshenfen] isKindOfClass:[NSNull class]]){
        self.shenfen = dictionary[kRootClassshenfen];
    }
    if(![dictionary[kRootClassFirstImsg] isKindOfClass:[NSNull class]]){
        self.FirstImsg = dictionary[kRootClassFirstImsg];
    }
    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    if(self.address != nil){
        dictionary[kRootClassAddress] = self.address;
    }
    dictionary[kRootClassCommentCount] = @(self.commentCount);
    dictionary[kRootClassFollowCount] = @(self.followCount);
    if(self.headImg != nil){
        dictionary[kRootClassHeadImg] = self.headImg;
    }
    dictionary[kRootClassIsFollowNews] = @(self.isFollowNews);
    dictionary[kRootClassIsFollowUser] = @(self.isFollowUser);
    dictionary[kRootClassIsReal] = @(self.isReal);
    if(self.newsContent != nil){
        dictionary[kRootClassNewsContent] = self.newsContent;
    }
    dictionary[kRootClassNewsContentType] = @(self.newsContentType);
    dictionary[kRootClassNewsId] = @(self.newsId);
    if(self.newsTime != nil){
        dictionary[kRootClassNewsTime] = self.newsTime;
    }
    if(self.nickName != nil){
        dictionary[kRootClassNickName] = self.nickName;
    }
    dictionary[kRootClassUserId] = @(self.userId);
    if(self.words != nil){
        dictionary[kRootClassWords] = self.words;
    }
    if(self.latitude != nil){
        dictionary[kRootClassLatitude] = self.latitude;
    }
    if(self.longitude != nil){
        dictionary[kRootClassLongitude] = self.longitude;
    }
    if(self.shenfen != nil){
        dictionary[kRootClassshenfen] = self.shenfen;
    }
    if(self.lx != nil){
        dictionary[kRootClasslx] = self.lx;
    }
    if(self.FirstImsg != nil){
        dictionary[kRootClassFirstImsg] = self.FirstImsg;
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
    if(self.address != nil){
        [aCoder encodeObject:self.address forKey:kRootClassAddress];
    }
    [aCoder encodeObject:@(self.commentCount) forKey:kRootClassCommentCount];	[aCoder encodeObject:@(self.followCount) forKey:kRootClassFollowCount];	if(self.headImg != nil){
        [aCoder encodeObject:self.headImg forKey:kRootClassHeadImg];
    }
    [aCoder encodeObject:@(self.isFollowNews) forKey:kRootClassIsFollowNews];	[aCoder encodeObject:@(self.isFollowUser) forKey:kRootClassIsFollowUser];	[aCoder encodeObject:@(self.isReal) forKey:kRootClassIsReal];	if(self.newsContent != nil){
        [aCoder encodeObject:self.newsContent forKey:kRootClassNewsContent];
    }
    [aCoder encodeObject:@(self.newsContentType) forKey:kRootClassNewsContentType];	[aCoder encodeObject:@(self.newsId) forKey:kRootClassNewsId];	if(self.newsTime != nil){
        [aCoder encodeObject:self.newsTime forKey:kRootClassNewsTime];
    }
    if(self.nickName != nil){
        [aCoder encodeObject:self.nickName forKey:kRootClassNickName];
    }
    [aCoder encodeObject:@(self.userId) forKey:kRootClassUserId];	if(self.words != nil){
        [aCoder encodeObject:self.words forKey:kRootClassWords];
    }
    
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.address = [aDecoder decodeObjectForKey:kRootClassAddress];
    self.commentCount = [[aDecoder decodeObjectForKey:kRootClassCommentCount] integerValue];
    self.followCount = [[aDecoder decodeObjectForKey:kRootClassFollowCount] integerValue];
    self.headImg = [aDecoder decodeObjectForKey:kRootClassHeadImg];
    self.isFollowNews = [[aDecoder decodeObjectForKey:kRootClassIsFollowNews] boolValue];
    self.isFollowUser = [[aDecoder decodeObjectForKey:kRootClassIsFollowUser] boolValue];
    self.isReal = [[aDecoder decodeObjectForKey:kRootClassIsReal] boolValue];
    self.newsContent = [aDecoder decodeObjectForKey:kRootClassNewsContent];
    self.newsContentType = [[aDecoder decodeObjectForKey:kRootClassNewsContentType] integerValue];
    self.newsId = [[aDecoder decodeObjectForKey:kRootClassNewsId] integerValue];
    self.newsTime = [aDecoder decodeObjectForKey:kRootClassNewsTime];
    self.nickName = [aDecoder decodeObjectForKey:kRootClassNickName];
    self.userId = [[aDecoder decodeObjectForKey:kRootClassUserId] integerValue];
    self.words = [aDecoder decodeObjectForKey:kRootClassWords];
    self.latitude = [aDecoder decodeObjectForKey:kRootClassLatitude];
    self.longitude = [aDecoder decodeObjectForKey:kRootClassLongitude];
    self.shenfen = [aDecoder decodeObjectForKey:kRootClassshenfen];
    self.lx = [aDecoder decodeObjectForKey:kRootClasslx];
    self.FirstImsg = [aDecoder decodeObjectForKey:kRootClassFirstImsg];
    return self;
    
}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
    ZhuBoModel *copy = [ZhuBoModel new];
    
    copy.address = [self.address copy];
    copy.commentCount = self.commentCount;
    copy.followCount = self.followCount;
    copy.headImg = [self.headImg copy];
    copy.isFollowNews = self.isFollowNews;
    copy.isFollowUser = self.isFollowUser;
    copy.isReal = self.isReal;
    copy.newsContent = [self.newsContent copy];
    copy.newsContentType = self.newsContentType;
    copy.newsId = self.newsId;
    copy.newsTime = [self.newsTime copy];
    copy.nickName = [self.nickName copy];
    copy.userId = self.userId;
    copy.words = [self.words copy];
    copy.latitude = [self.latitude copy];
    copy.longitude = [self.longitude copy];
    copy.shenfen = [self.shenfen copy];
    copy.lx = [self.lx copy];
    copy.FirstImsg = [self.FirstImsg copy];
    
    return copy;
}
@end
