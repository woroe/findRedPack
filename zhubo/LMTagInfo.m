//
//  LMTagInfo.m
//  zhubo
//
//  Created by Jin on 2017/7/28.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "LMTagInfo.h"

@class LMTagInfo;
@interface LMTagFrameInfo : NSObject
@property(nonatomic, strong)LMTagInfo *tagInfo;

/**
 整个View
 **/
@property(nonatomic, assign)CGRect viewF;
/**
 logoView
 **/
@property(nonatomic, assign)CGRect logoViewF;
/**
 文字按钮
 **/
@property(nonatomic, assign)CGRect textButtonF;
/**
 文字
 **/
@property(nonatomic, assign)CGRect textLabelF;
/**
 左右判断
 **/
@property(nonatomic, assign)int isRight;

@end

#define pointWH 15
#define textBGW 22
#define textBGH  27

@implementation LMTagInfo



@end
