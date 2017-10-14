//
//  CommentModel.h
//  zhubo
//
//  Created by Jin on 2017/6/17.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

//评论内的评论
@property (nonatomic, strong) NSMutableArray * insideComments;
//是否展开评论
@property (nonatomic, assign) BOOL isShowInside;

@property (nonatomic, strong) NSString * commentHeadImg;
@property (nonatomic, assign) NSInteger commentId;
@property (nonatomic, strong) NSString * commentMsg;
@property (nonatomic, strong) NSString * commentName;
@property (nonatomic, strong) NSString * commentTime;
@property (nonatomic, assign) NSInteger commentUserId;
@property (nonatomic, assign) NSInteger commentCommentCount;
@property (nonatomic, assign) NSInteger commentFollowCount;
@property (nonatomic, assign) BOOL commentIsFollow;
@property (nonatomic, assign) BOOL isReal;
@property (nonatomic, assign) BOOL isAnonymous;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;

@end
