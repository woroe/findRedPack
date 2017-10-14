//
//  LMTagFrameInfo.m
//  zhubo
//
//  Created by Jin on 2017/7/28.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "LMTagInfo.h"
#import "LMTagFrameInfo.h"

#define pointWH 15
#define textBGW 22
#define textBGH  27
@implementation LMTagFrameInfo

- (void)setTagInfo:(LMTagInfo *)tagInfo
{
    _tagInfo = tagInfo;
    
    CGSize textSize = [tagInfo.tagText sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    
    CGFloat viewX;
    CGFloat viewY = tagInfo.tagY - textBGH * 0.5;
    CGFloat viewW = textBGW + textSize.width + pointWH;
    CGFloat viewH = textBGH;
    
    CGFloat logoViewX;
    CGFloat logoViewWH = pointWH;
    CGFloat logoViewY = (viewH - logoViewWH) * 0.5;
    
    CGFloat textButtonX;
    CGFloat textButtonY = 0;
    CGFloat textButtonW = textBGW + textSize.width;
    CGFloat textButtonH = textBGH;
    
    CGFloat textLabelX;
    CGFloat textLabelY = (textButtonH - textSize.height) * 0.5;
    CGFloat textLabelW = textSize.width;
    CGFloat textLabelH = textSize.height;
    
    if (textSize.width + textBGW + pointWH + tagInfo.tagX >= SCREEN_WIDTH) {
        //文字朝左
        _isRight = 0;
        viewX = tagInfo.tagX - textSize.width - textBGW - pointWH * 0.5;
        logoViewX = textButtonW;
        textButtonX = 0;
        textLabelX = 0.3 * textBGW;
    } else {
        //文字朝右
        _isRight = 1;
        viewX = tagInfo.tagX - pointWH * 0.5;
        logoViewX = 0;
        textButtonX = logoViewWH;
        textLabelX = textButtonX + 0.7 *textBGW;
    }
    _viewF = CGRectMake(viewX, viewY, viewW, viewH);
    _logoViewF = CGRectMake(logoViewX, logoViewY, logoViewWH, logoViewWH);
    _textButtonF = CGRectMake(textButtonX, textButtonY, textButtonW, textButtonH);
    _textLabelF = CGRectMake(textLabelX, textLabelY, textLabelW, textLabelH);
}


@end
