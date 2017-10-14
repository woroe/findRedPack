//
//  CALayer+BorderColor.m
//  zhubo
//
//  Created by Jin on 2017/6/9.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "CALayer+BorderColor.h"

@implementation CALayer (BorderColor)

- (void)setBorderColorWithUIColor:(UIColor *)color
{
    
    self.borderColor = color.CGColor;
}
@end
