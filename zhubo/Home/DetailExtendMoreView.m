//
//  DetailExtendMoreView.m
//  zhubo
//
//  Created by Jin on 2017/6/22.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "DetailExtendMoreView.h"

@implementation DetailExtendMoreView

- (void)loadWith:(id)delegate {
    self.delegate = delegate;
    
    
    CGFloat h = SCREEN_HEIGHT - 44;
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, h);
    self.frame = frame;
    self.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.468f];
    
    
    CGFloat viewH = 380 * SCREEN_W_SCALE;
    CGFloat viewY = frame.size.height - viewH;
    UIView *bcView = [[UIView alloc] initWithFrame:CGRectMake(0, viewY, SCREEN_WIDTH, viewH)];
    bcView.backgroundColor = BaseColorBackGround;
    [self addSubview:bcView];
    
    
    UIButton *btn0 = [self loadButton:0 title:@"屏蔽用户" color:BaseColorBlack2];
    [bcView addSubview:btn0];
    UIButton *btn1 = [self loadButton:1 title:@"不看此条" color:BaseColorBlack2];
    [bcView addSubview:btn1];
    UIButton *btn2 = [self loadButton:2 title:@"举报" color:BaseColorBlack2];
    [bcView addSubview:btn2];
    UIButton *btn3 = [self loadButton:3 title:@"取消" color:BaseColorGray];
    [bcView addSubview:btn3];
    
}
- (UIButton *)loadButton:(NSInteger)index title:(NSString *)title color:(UIColor *)color {
    CGFloat cancelH = 95 * SCREEN_W_SCALE;
    CGFloat cancelY = index * cancelH;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, cancelY, SCREEN_WIDTH, cancelH - 1)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    btn.backgroundColor = [UIColor whiteColor];
    btn.tag = index;
    btn.titleLabel.font = [UIFont systemFontOfSize:28*SCREEN_W_SCALE];
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}
- (void)buttonClick:(UIButton *)sender {
    if(sender.tag == 3){
        [self removeFromSuperview];
    }
    
    
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //关闭视图
    [self.delegate closeExtendView];
}
@end
