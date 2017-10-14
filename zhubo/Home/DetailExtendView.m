//
//  DetailExtendView.m
//  zhubo
//
//  Created by Jin on 2017/6/21.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "DetailExtendView.h"

@implementation DetailExtendView



- (void)drawRect:(CGRect)rect {
    CGFloat h = SCREEN_HEIGHT - 44;
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, h);
    self.frame = frame;
    self.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.468f];
    
    
    CGFloat viewH = 380 * SCREEN_W_SCALE;
    CGFloat viewY = frame.size.height - viewH;
    UIView *bcView = [[UIView alloc] initWithFrame:CGRectMake(0, viewY, SCREEN_WIDTH, viewH)];
    bcView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bcView];
}

@end
