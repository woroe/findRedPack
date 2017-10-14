//
//  LMTagInfo.h
//  zhubo
//
//  Created by Jin on 2017/7/28.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMTagInfo : NSObject

@property(nonatomic, assign)CGFloat tagX;
@property(nonatomic, assign)CGFloat tagY;
/**
 0表示文字标签
 1表示位置标签
 **/
@property(nonatomic, assign)int tagType;
@property(nonatomic, copy)NSString *tagText;

@end



