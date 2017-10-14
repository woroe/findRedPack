//
//  ZhuBoModel.h
//  zhubo
//
//  Created by Jin on 2017/6/14.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

/*
 {
 "Address": "a",
 "CommentCount": 0,
 "FollowCount": 0,
 "HeadImg": "1.jpg",
 "Is_Follow_News": false,
 "Is_Follow_User": false,
 "Is_Real": 0,
 "NewsContent": "1.jpg",
 "NewsContentType": 1,
 "NewsId": 2,
 "NewsTime": "",
 "NickName": "a",
 "UserId": 1,
 "Words": "a"
 }
*/

#import <Foundation/Foundation.h>

@interface ZhuBoModel : NSObject

@property (nonatomic, strong) NSString * address;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, assign) NSInteger followCount;
@property (nonatomic, strong) NSString * headImg;
@property (nonatomic, assign) BOOL isFollowNews;
@property (nonatomic, assign) BOOL isFollowUser;
@property (nonatomic, assign) BOOL isReal;
@property (nonatomic, strong) NSString * newsContent;
@property (nonatomic, assign) NSInteger newsContentType;//1图2视频3实名4匿名
@property (nonatomic, assign) NSInteger newsId;
@property (nonatomic, strong) NSString * newsTime;
@property (nonatomic, strong) NSString * nickName;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString * words;
@property (nonatomic, strong) NSArray *imgArr;
@property (nonatomic, strong) NSString * latitude;
@property (nonatomic, strong) NSString * longitude;
@property (nonatomic, strong) NSString * shenfen;
@property (nonatomic, strong) NSString * lx;
@property (nonatomic, strong) NSString * FirstImsg;
@property (nonatomic, assign) BOOL isAll;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
