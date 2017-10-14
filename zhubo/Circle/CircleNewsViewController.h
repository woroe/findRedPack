//
//  CircleNewsViewController.h
//  zhubo
//
//  Created by Jin on 2017/7/15.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleModel.h"

@interface CircleNewsViewController : UIViewController{
    
    CircleModel *model;
}

@property (nonatomic, strong)CircleModel *model;

@property (nonatomic, assign) NSInteger photoType;

@end
