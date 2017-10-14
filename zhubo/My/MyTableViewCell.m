//
//  MyTableViewCell.m
//  zhubo
//
//  Created by Jin on 2017/6/9.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "MyTableViewCell.h"

@interface MyTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *number;

@end

@implementation MyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

- (void)setImage:(NSString *)image WithTitle:(NSString *)title {
    self.leftImage.image = [UIImage imageNamed:image];
    self.title.text = title;
}
- (void)setImage:(NSString *)image WithTitle:(NSString *)title Number: (NSInteger)number{
    [self setImage:image WithTitle:title];
    self.number.text = [NSString stringWithFormat:@"%ld", (long)number];
}

@end
