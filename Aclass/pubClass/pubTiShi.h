//
//  pubTiShi.h
//  Created by hong Li on 2017/10/16.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "UILabel+lihong.h"
#import "pubConfig.h"

/** 通用底部提示类 */
@interface pubTiShi : NSObject{
	UIView    *txtView;
}
Single_FOR_HEADER(pubTiShi);

//显示 提示内容
-(void)LHShow:(NSString *)txt;

@end
