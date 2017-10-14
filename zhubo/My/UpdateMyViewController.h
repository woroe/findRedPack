//
//  UpdateMyViewController.h
//  zhubo
//
//  Created by Jin on 2017/7/22.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UpdateMyViewControllerDelegate <NSObject>

- (void)UpdateVIew:(NSString *)str;

@end

@interface UpdateMyViewController : UIViewController

@property (nonatomic, strong) id<UpdateMyViewControllerDelegate> delegate;

@property(nonatomic,strong)NSString *UpdateLBStr;
@property(nonatomic,strong)NSString *CNameStr;
@property(nonatomic,strong)NSString *CValueStr;

@property(nonatomic,strong)NSString *qz_myStr;
@property(nonatomic,strong)NSString *CircleIdStr;

@end
