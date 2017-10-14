//
//  News.h
//  zhubo
//
//  Created by Jin on 2017/8/1.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject

@property (nonatomic, strong) NSArray * Files;
@property (nonatomic, assign) CGFloat Latitude;
@property (nonatomic, assign) CGFloat Longitude;
@property (nonatomic, assign) NSInteger NewsType;
@property (nonatomic, assign) NSInteger UserId;
@property (nonatomic, strong) NSString * Words;
@property (nonatomic, strong) NSString * FirstImsg;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;

@end
