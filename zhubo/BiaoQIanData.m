//
//  BiaoQIanData.m
//  zhubo
//
//  Created by Jin on 2017/8/1.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "BiaoQIanData.h"

@implementation BiaoQIanData

static BiaoQIanData *_share;

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

- (NSMutableArray *)getImageBiaoQIanArr {
    
    return self.BiaoQIanArr;
}

- (void)setImageBiaoQianDic:(NSDictionary *)BiaoQianImage{
    [self.BiaoQIanArr addObject:BiaoQianImage];
}

-(void)remveBiaoQianArrAll{
    [self.BiaoQIanArr removeAllObjects];
}

-(void)remveBiaoQianArrDic:(NSDictionary *)dic{
    [self.BiaoQIanArr removeObject:dic];
}

@end
