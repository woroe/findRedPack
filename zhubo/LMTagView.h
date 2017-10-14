//
//  LMTagView.h
//  zhubo
//
//  Created by Jin on 2017/7/28.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMTagFrameInfo.h"

@interface LMTagView : UIImageView

@property(nonatomic, strong)LMTagFrameInfo *tagFrameInfo;
//用来判断这个标签是否可以移动改变其位置
@property(nonatomic, assign)BOOL isTouch;

@end
