//
//  HomeTitleView.m
//  zhubo
//
//  Created by Jin on 2017/6/12.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "HomeTitleView.h"

@implementation HomeTitleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)zhuboClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    if(button.selected){
        return;
    }
    [self setSelectedBtn:0];
    [self.delegate selectedBtn:0];
}
- (IBAction)discoverClick:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    if(button.selected){
        return;
    }
    [self setSelectedBtn:1];
    [self.delegate selectedBtn:1];
}
- (IBAction)guanzhuCLick:(id)sender {
    UIButton *button = (UIButton *)sender;
    if(button.selected){
        return;
    }
    [self setSelectedBtn:3];
    [self.delegate selectedBtn:3];
}
- (IBAction)guanchangClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    if(button.selected){
        return;
    }
    [self setSelectedBtn:2];
    [self.delegate selectedBtn:2];
}

- (void)setSelectedBtn:(NSInteger)index {
    if(index == 0){
        self.discoverBtn.selected = NO;
        self.zhuboBtn.selected = YES;
        self.guanchanBtn.selected = NO;
        self.guanzhuBtn.selected = NO;
    }
    if (index == 1) {
        self.discoverBtn.selected = YES;
        self.zhuboBtn.selected = NO;
        self.guanchanBtn.selected = NO;
        self.guanzhuBtn.selected = NO;
    }
    if (index == 2) {
        self.discoverBtn.selected = NO;
        self.zhuboBtn.selected = NO;
        self.guanchanBtn.selected = YES;
        self.guanzhuBtn.selected = NO;
    }
    if (index == 3) {
        self.discoverBtn.selected = NO;
        self.zhuboBtn.selected = NO;
        self.guanchanBtn.selected = NO;
        self.guanzhuBtn.selected = YES;
    }
}

+ (HomeTitleView *)instanceView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HomeTitleView" owner:nil options:nil] lastObject];
}
@end
