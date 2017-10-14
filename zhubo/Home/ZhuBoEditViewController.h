//
//  ZhuBoEditViewController.h
//  zhubo
//
//  Created by Jin on 2017/6/13.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleModel.h"

@interface ZhuBoEditViewController : BaseViewController{
    
    CircleModel *model;
}

@property (nonatomic, strong)CircleModel *model;

@property (nonatomic, assign) NSInteger photoType;

@property (nonatomic, strong) NSMutableArray *muTagInFoArr;

@property (nonatomic, strong)NSString *news_And_Circle; // 1是新闻发布 2 是圈子发布动态

@property (nonatomic, strong) NSString *prayelUrl;



@end
