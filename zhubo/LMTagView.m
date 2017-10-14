//
//  LMTagView.m
//  zhubo
//
//  Created by Jin on 2017/7/28.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "LMTagView.h"
#import "LMTagFrameInfo.h"
#import "LMTagInfo.h"
#import "UIImage+MJ.h"


@interface LMTagView ()

@property(nonatomic, weak)UIImageView *logoView;
@property(nonatomic, weak)UIImageView *textButton;
@property(nonatomic, weak)UILabel *textLabel;
@property(nonatomic, weak)UIImageView *animationView;
@property(nonatomic, assign)CGPoint beginPoint;
@property(nonatomic, assign)CGPoint beginCenter;
@end


@implementation LMTagView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *logoView = [[UIImageView alloc] init];
        [self addSubview:logoView];
        self.logoView = logoView;
        
        UIImageView *textButton = [[UIImageView alloc] init];
        textButton.userInteractionEnabled = YES;
        [self addSubview:textButton];
        self.textButton = textButton;
        
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:textLabel];
        self.textLabel = textLabel;
    }
    return self;
}

- (void)setTagFrameInfo:(LMTagFrameInfo *)tagFrameInfo
{
    _tagFrameInfo = tagFrameInfo;
    
    LMTagInfo *tagInfo  = tagFrameInfo.tagInfo;
    
    self.logoView.frame = tagFrameInfo.logoViewF;
    if (tagInfo.tagType == 0) {
        self.logoView.image = [UIImage imageNamed:@"tagpoint"];
    } else {
        self.logoView.image = [UIImage imageNamed:@"taglocation"];
    }
    
    self.textButton.frame = tagFrameInfo.textButtonF;
//    if (tagFrameInfo.isRight == 1) {
//        self.textButton.image = [UIImage resizedImageWithName:@"tag_text_bg_left" left:0.7 top:0.5];
//    } else {
//        self.textButton.image = [UIImage resizedImageWithName:@"tag_text_bg_right" left:0.3 top:0.5];
//    }
    
    self.textLabel.frame = tagFrameInfo.textLabelF;
    self.textLabel.text = tagInfo.tagText;
    
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.isTouch) {
        return;
    }
    UITouch *touch = [touches anyObject];
    self.beginPoint = [touch locationInView:self];
    self.beginCenter = self.center;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.isTouch) {
        return;
    }
    UITouch *touch = [touches anyObject];
    
    CGPoint nowPoint = [touch locationInView:self];
    
    float offsetX = nowPoint.x - self.beginPoint.x;
    float offsetY = nowPoint.y - self.beginPoint.y;
    
    CGPoint newcenter = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
    
    float halfx = CGRectGetMidX(self.bounds);
    
    newcenter.x = MAX(halfx, newcenter.x);
    newcenter.x = MIN(self.superview.bounds.size.width - halfx, newcenter.x);
    
    float halfy = CGRectGetMidY(self.bounds);
    newcenter.y = MAX(halfy, newcenter.y);
    newcenter.y = MIN(self.superview.bounds.size.height - halfy, newcenter.y);
    
    self.center = newcenter;
    
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.isTouch) {
        return;
    }
    self.tagFrameInfo.tagInfo.tagX += self.center.x - self.beginCenter.x;
    self.tagFrameInfo.tagInfo.tagY += self.center.y - self.beginCenter.y;
}



@end
