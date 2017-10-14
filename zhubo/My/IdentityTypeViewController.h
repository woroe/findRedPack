//
//  IdentityTypeViewController.h
//  zhubo
//
//  Created by Jiao on 17/9/20.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "BaseViewController.h"

@interface IdentityTypeViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *subTitle1;
@property (weak, nonatomic) IBOutlet UILabel *subTitle2;
@property (weak, nonatomic) IBOutlet UILabel *identityLab;
@property (weak, nonatomic) IBOutlet UILabel *secondIdentityLab;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

- (IBAction)identityAction:(UIControl *)sender;
- (IBAction)secondIdentityAction:(UIControl *)sender;

- (IBAction)submitAction:(UIButton *)sender;

@end
