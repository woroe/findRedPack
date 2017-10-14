//
//  MyTableViewCell.h
//  zhubo
//
//  Created by Jin on 2017/6/9.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewCell : UITableViewCell


- (void)setImage:(NSString *)image WithTitle:(NSString *)title;
- (void)setImage:(NSString *)image WithTitle:(NSString *)title Number: (NSInteger)number;

@end
