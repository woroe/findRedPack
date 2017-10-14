//
//  CommentModel.m
//  zhubo
//
//  Created by Jin on 2017/6/17.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "CommentModel.h"


NSString *const kRootClassCommentHeadImg = @"CommentHeadImg";
NSString *const kRootClassCommentId = @"CommentId";
NSString *const kRootClassCommentMsg = @"CommentMsg";
NSString *const kRootClassCommentName = @"CommentName";
NSString *const kRootClassCommentTime = @"CommentTime";
NSString *const kRootClassCommentUserId = @"CommentUserId";
NSString *const kRootClassCommentCommentCount = @"Comment_CommentCount";
NSString *const kRootClassCommentFollowCount = @"Comment_FollowCount";
NSString *const kRootClassCommentIsFollow = @"Comment_IsFollow";
NSString *const kRootClassUserIsReal = @"Is_Real";
NSString *const kRootClassIsAnonymous = @"IsAnonymous";

@implementation CommentModel


-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    self.insideComments = [NSMutableArray array];
    
    if(![dictionary[kRootClassCommentHeadImg] isKindOfClass:[NSNull class]]){
        self.commentHeadImg = dictionary[kRootClassCommentHeadImg];
    }
    if(![dictionary[kRootClassCommentId] isKindOfClass:[NSNull class]]){
        self.commentId = [dictionary[kRootClassCommentId] integerValue];
    }
    
    if(![dictionary[kRootClassCommentMsg] isKindOfClass:[NSNull class]]){
        self.commentMsg = dictionary[kRootClassCommentMsg];
    }
    if(![dictionary[kRootClassCommentName] isKindOfClass:[NSNull class]]){
        self.commentName = dictionary[kRootClassCommentName];
    }
    if(![dictionary[kRootClassCommentTime] isKindOfClass:[NSNull class]]){
        self.commentTime = dictionary[kRootClassCommentTime];
    }
    if(![dictionary[kRootClassCommentUserId] isKindOfClass:[NSNull class]]){
        self.commentUserId = [dictionary[kRootClassCommentUserId] integerValue];
    }
    
    if(![dictionary[kRootClassCommentCommentCount] isKindOfClass:[NSNull class]]){
        self.commentCommentCount = [dictionary[kRootClassCommentCommentCount] integerValue];
    }
    
    if(![dictionary[kRootClassCommentFollowCount] isKindOfClass:[NSNull class]]){
        self.commentFollowCount = [dictionary[kRootClassCommentFollowCount] integerValue];
    }
    
    if(![dictionary[kRootClassCommentIsFollow] isKindOfClass:[NSNull class]]){
        self.commentIsFollow = [dictionary[kRootClassCommentIsFollow] boolValue];
    }
    
    if(![dictionary[kRootClassUserIsReal] isKindOfClass:[NSNull class]]){
        self.isReal = [dictionary[kRootClassUserIsReal] boolValue];
    }
    
    if(![dictionary[kRootClassIsAnonymous] isKindOfClass:[NSNull class]]){
        self.isAnonymous = [dictionary[kRootClassIsAnonymous] boolValue];
    }
    
    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    if(self.commentHeadImg != nil){
        dictionary[kRootClassCommentHeadImg] = self.commentHeadImg;
    }
    dictionary[kRootClassCommentId] = @(self.commentId);
    if(self.commentMsg != nil){
        dictionary[kRootClassCommentMsg] = self.commentMsg;
    }
    if(self.commentName != nil){
        dictionary[kRootClassCommentName] = self.commentName;
    }
    if(self.commentTime != nil){
        dictionary[kRootClassCommentTime] = self.commentTime;
    }
    dictionary[kRootClassCommentUserId] = @(self.commentUserId);
    dictionary[kRootClassCommentCommentCount] = @(self.commentCommentCount);
    dictionary[kRootClassCommentFollowCount] = @(self.commentFollowCount);
    dictionary[kRootClassCommentIsFollow] = @(self.commentIsFollow);
    dictionary[kRootClassUserIsReal] = @(self.isReal);
    dictionary[kRootClassIsAnonymous] = @(self.isAnonymous);
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
    if(self.commentHeadImg != nil){
        [aCoder encodeObject:self.commentHeadImg forKey:kRootClassCommentHeadImg];
    }
    [aCoder encodeObject:@(self.commentId) forKey:kRootClassCommentId];	if(self.commentMsg != nil){
        [aCoder encodeObject:self.commentMsg forKey:kRootClassCommentMsg];
    }
    if(self.commentName != nil){
        [aCoder encodeObject:self.commentName forKey:kRootClassCommentName];
    }
    if(self.commentTime != nil){
        [aCoder encodeObject:self.commentTime forKey:kRootClassCommentTime];
    }
    [aCoder encodeObject:@(self.commentUserId) forKey:kRootClassCommentUserId];
    [aCoder encodeObject:@(self.commentCommentCount) forKey:kRootClassCommentCommentCount];
    [aCoder encodeObject:@(self.commentFollowCount) forKey:kRootClassCommentFollowCount];
    [aCoder encodeObject:@(self.commentIsFollow) forKey:kRootClassCommentIsFollow];
    [aCoder encodeObject:@(self.isReal) forKey:kRootClassUserIsReal];
    [aCoder encodeObject:@(self.isAnonymous) forKey:kRootClassIsAnonymous];
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.commentHeadImg = [aDecoder decodeObjectForKey:kRootClassCommentHeadImg];
    self.commentId = [[aDecoder decodeObjectForKey:kRootClassCommentId] integerValue];
    self.commentMsg = [aDecoder decodeObjectForKey:kRootClassCommentMsg];
    self.commentName = [aDecoder decodeObjectForKey:kRootClassCommentName];
    self.commentTime = [aDecoder decodeObjectForKey:kRootClassCommentTime];
    self.commentUserId = [[aDecoder decodeObjectForKey:kRootClassCommentUserId] integerValue];
    self.commentCommentCount = [[aDecoder decodeObjectForKey:kRootClassCommentCommentCount] integerValue];
    self.commentFollowCount = [[aDecoder decodeObjectForKey:kRootClassCommentFollowCount] integerValue];
    self.commentIsFollow = [[aDecoder decodeObjectForKey:kRootClassCommentIsFollow] boolValue];
    self.isReal = [[aDecoder decodeObjectForKey:kRootClassUserIsReal] boolValue];
    self.isAnonymous = [[aDecoder decodeObjectForKey:kRootClassIsAnonymous] boolValue];
    return self;
    
}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
    CommentModel *copy = [CommentModel new];
    
    copy.commentHeadImg = [self.commentHeadImg copy];
    copy.commentId = self.commentId;
    copy.commentMsg = [self.commentMsg copy];
    copy.commentName = [self.commentName copy];
    copy.commentTime = [self.commentTime copy];
    copy.commentUserId = self.commentUserId;
    copy.commentCommentCount = self.commentCommentCount;
    copy.commentFollowCount = self.commentFollowCount;
    copy.commentIsFollow = self.commentIsFollow;
    copy.isReal = self.isReal;
    copy.isAnonymous = self.isAnonymous;
    
    return copy;
}
@end
