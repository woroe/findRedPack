//
//  LXViewController.h
//  zhubo
//
//  Created by Jin on 2017/8/2.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserNewData.h"

@protocol LXViewControllerDelegate <NSObject>

- (void)UpdateUserData:(NSString *)identityCodeStr identityCode:(NSString *)code LXname:(NSString *)name lxId:(NSString *)lxId;

@end

@interface LXViewController : UIViewController

@property(nonatomic,strong)NSDictionary *idectityDic;
@property(nonatomic,strong)UserNewData *userNewData;

@property (nonatomic, strong) id<LXViewControllerDelegate> delegate;

@end
