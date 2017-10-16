//
//  UILabel+lihong.m
//  Created by hong Li on 2017/10/16.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//
#import "UILabel+lihong.h"

@implementation UILabel (lihong)
#pragma mark - /** 设置UILabel的行间距*/
- (void)setText:(NSString*)txt lineSpacing:(CGFloat)lineSpacing {
	if (lineSpacing < 0.01 || !txt) {
		self.text = txt;
		return;
	}
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:txt];
	[attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, [txt length])];

	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	[paragraphStyle setLineSpacing:lineSpacing];
	[paragraphStyle setLineBreakMode:self.lineBreakMode];
	[paragraphStyle setAlignment:self.textAlignment];
	[attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [txt length])];

	self.attributedText = attributedString;
}

#pragma mark -显示不同颜色的UILabel 文本内容  需要过滤的文字  文字颜色 文字大小 行间距
-(void)setTextValue:(NSString *)txt Filter:(NSString *)filter txtColor:(UIColor *)tc txtSize:(CGFloat)size txtLine:(NSInteger)line{
	if (!txt) {
		self.text = txt;
		return;
	}
	self.attributedText =nil;
	NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
	[paragrapStyle setLineSpacing:line];//调整行间距
	NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragrapStyle};
	NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:txt attributes:attributes];

	if (filter&&filter.length>0) {
		NSRange redRange;NSInteger num=txt.length;
		for (NSInteger i = 0; i < num; i++) {
			redRange=NSMakeRange(i,1);
			if([filter rangeOfString:[txt substringWithRange:redRange]].location !=NSNotFound){
				[noteStr addAttribute:NSForegroundColorAttributeName value:tc range:redRange];
				[noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:size] range:redRange];
			}
		}
	}
	[self setAttributedText:noteStr];
}
@end
