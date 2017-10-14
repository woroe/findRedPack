//
//  DetailExtendShareView.h
//  zhubo
//
//  Created by Jin on 2017/6/22.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailExtendView.h"


@interface DetailExtendShareView : UIView

@property (nonatomic, strong) id<DetailExtendViewDelegate> delegate;


- (void)loadWith:(id)delegate;

@end
