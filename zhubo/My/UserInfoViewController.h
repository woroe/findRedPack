//
//  UserInfoViewController.h
//  zhubo
//
//  Created by Jiao on 17/9/20.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "BaseViewController.h"

@interface UserInfoViewController : BaseViewController

@property (strong, nonatomic) NSDictionary *info;

@property (weak, nonatomic) IBOutlet UITextField *nickNameField;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *subTitle1;
@property (weak, nonatomic) IBOutlet UILabel *subTitle2;
@property (weak, nonatomic) IBOutlet UILabel *manLab;
@property (weak, nonatomic) IBOutlet UILabel *womenLab;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
- (IBAction)changeGenderAction:(UIControl *)sender;
- (IBAction)submitAction:(UIButton *)sender;

@end
