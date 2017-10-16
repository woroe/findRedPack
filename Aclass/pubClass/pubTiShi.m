//
//  pubTiShi.m
//  Created by hong Li on 2017/10/16.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//
#import "pubTiShi.h"
#import "Masonry.h"

@implementation pubTiShi
Single_FOR_CLASS(pubTiShi)

//显示 提示内容
-(void)LHShow:(NSString *)txt{
	dispatch_async(dispatch_get_main_queue(), ^{
		if (txtView) {
			[txtView removeFromSuperview];
			txtView=nil;
		}
		[[self class] cancelPreviousPerformRequestsWithTarget:self];

		UIWindow *thisWindow =[[UIApplication sharedApplication].windows lastObject];//加在键盘视图上
		if(thisWindow.hidden){
			thisWindow =[UIApplication sharedApplication].keyWindow;
		}
		txtView=[UIView new];
		txtView.backgroundColor=RGBCOLOR(0x33,0x33,0x33);
		txtView.layer.cornerRadius=5.0;
		txtView.layer.masksToBounds=YES;
		[thisWindow addSubview:txtView];/* <= */
		[txtView mas_makeConstraints:^(MASConstraintMaker *make){
			make.width.lessThanOrEqualTo(@(SCREEN_WIDTH-40.0));
			make.centerX.mas_equalTo(thisWindow);
			make.bottom.mas_equalTo(-20.0);
		}];

		UILabel *lbTiShi=[UILabel new];
		lbTiShi.textColor= [UIColor whiteColor];
		lbTiShi.font=[UIFont systemFontOfSize:15.0];
		lbTiShi.numberOfLines=0;
		[lbTiShi setText:txt lineSpacing:3.0];
		[txtView addSubview:lbTiShi];
		[lbTiShi mas_makeConstraints:^(MASConstraintMaker *make){
			make.top.leading.mas_equalTo(10.0);
			make.trailing.bottom.mas_equalTo(-10.0);
		}];

		[self performSelector:@selector(deleteLabel) withObject:nil afterDelay:1.5f];
	});
}
- (void)deleteLabel{
	[UIView animateWithDuration:0.2 animations:^{
		txtView.transform= CGAffineTransformScale(txtView.transform,0.5,0.5);
	} completion:^(BOOL finished){
		[txtView removeFromSuperview];
		txtView=nil;
	}];
}

@end
