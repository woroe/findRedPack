//
//  Created by hong Li on 2017/10/16.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#ifndef BKRConstant_h
#define BKRConstant_h

#import <Foundation/Foundation.h>

#define PATH_APP_HOME                        NSHomeDirectory()
#define PATH_OF_TEMP                         NSTemporaryDirectory()
#define PATH_DOCUMENT                        [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define SCREEN_WIDTH                         [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT                        [[UIScreen mainScreen] bounds].size.height    //屏幕高度
#define IOSVersion                           [[[UIDevice currentDevice] systemVersion] doubleValue]

#define RGBCOLOR(r,g,b)                      [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:1.f]
#define RGBACOLOR(r,g,b,a)                   [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]
#define UI_NAV_BAR_HEIGHT                    44
#define UI_TAB_BAR_HEIGHT                    49
#define UI_STATUS_BAR_HEIGHT                 20

//////////////////////////////////////////////////////////////////////
//单例类宏定义
#define Single_FOR_HEADER(className)               \
+ (className *)instance;
#define Single_FOR_CLASS(className)                \
+ (className *)instance{                           \
static className *shared##className = nil;         \
static dispatch_once_t onceToken;                  \
dispatch_once(&onceToken, ^{                       \
shared##className = [[self alloc] init];           \
});                                                \
return shared##className;                          \
}

#endif
