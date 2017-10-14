//
//  JZLProgressView.m
//  JZLPhotoBrowser
//
//  Created by allenjzl on 2017/7/14.
//  Copyright © 2017年 allenjzl. All rights reserved.
//

#import "JZLProgressView.h"

@implementation JZLProgressView

- (instancetype)initWithFrame:(CGRect)frame {
        self = [super initWithFrame:frame];
        if (self) {
            self.backgroundColor = [UIColor clearColor];
        }
        return self;
}


- (void)drawRect:(CGRect)rect {
    //画外圆
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] set];
    
    CGContextSetLineWidth(context, 2);
    CGContextAddArc(context, rect.size.width / 2, rect.size.height / 2, 22, 0, M_PI * 2, 0);
    CGContextStrokePath(context);
    //画内园
    
    CGContextSetLineWidth(context, 20);
    CGContextAddArc(context, rect.size.width / 2, rect.size.height / 2, 10, -M_PI/2, -M_PI/2 + M_PI * 2 * self.progress , 0);
    CGContextStrokePath(context);
}

- (void)setProgress:(CGFloat)progress {
    if (_progress != progress) {
        _progress = progress;
    }
    [self setNeedsDisplay];
}
    
    
    
    
    
@end
