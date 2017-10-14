//
//  FBNewsViewController.h
//  zhubo
//
//  Created by Jin on 2017/7/25.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^TakeOperationSureBlock)(id item);

@interface FBNewsViewController : BaseViewController

@property (copy, nonatomic) TakeOperationSureBlock takeBlock;

@property (assign, nonatomic) NSInteger HSeconds;

@end
