//
//  BiaoQIanData.h
//  zhubo
//
//  Created by Jin on 2017/8/1.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BiaoQIanData : NSObject

/*
    数字中存放Dic,  Dic中存放image和标签Arr
 */
@property(nonatomic,strong)NSMutableArray *BiaoQIanArr;

+ (instancetype)shareInstance;
/*
    添加一个image 和 image的所有标签
 */
- (void)setImageBiaoQianDic:(NSDictionary *)BiaoQianImage;
/*
    获取所有的image 和 image的所有标签
 */
- (NSMutableArray *)getImageBiaoQIanArr;

/*
    删除所有的image 和 image 标签
 */
-(void)remveBiaoQianArrAll;
/*
    删除指定的image和image标签
 */
-(void)remveBiaoQianArrDic:(NSDictionary *)dic;
@end
