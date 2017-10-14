//
//  DetailExtendRewordView.h
//  zhubo
//
//  Created by Jin on 2017/6/21.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailExtendView.h"

@interface DetailExtendRewordView : UIView

@property (nonatomic, strong) id<DetailExtendViewDelegate> delegate;
//选中索引
@property (nonatomic, assign) NSInteger selectedIndex;

- (void)loadWith:(id)delegate;


@end
