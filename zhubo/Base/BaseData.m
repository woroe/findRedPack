//
//  BaseData.m
//  zhubo
//
//  Created by Jin on 2017/6/14.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "BaseData.h"

@implementation BaseData

static BaseData *_share;

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _share = [super allocWithZone:zone];
    });
    
    return _share;
}
+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _share = [[self alloc] init];
    });
    
    return _share;
}
- (id)copyWithZone:(NSZone *)zone{
    return _share;
}

- (NSInteger)userId {
    if(!_userId) {
        return 0;
    }
    return _userId;
}

- (void)setUser:(NSDictionary *)user {
    self.userId = [[user objectForKey:@"Id"] integerValue];
    self.headImg = [user objectForKey:@"HeadImg"];
    self.phone = [user objectForKey:@"Phone"];
    self.nickName = [user objectForKey:@"NickName"];
}

@end
