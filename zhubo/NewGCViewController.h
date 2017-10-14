//
//  NewGCViewController.h
//  zhubo
//
//  Created by jiangfei on 17/9/18.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "BaseViewController.h"

@interface NewGCViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextView *submitTxt;
@property (weak, nonatomic) IBOutlet UILabel *textCountLab;
@property (weak, nonatomic) IBOutlet UIView *submitTypeView;

- (IBAction)cancelAction:(UIButton *)sender;
- (IBAction)submitAction:(UIButton *)sender;
- (IBAction)changeSubmitTypeAction:(UIControl *)sender;

@end
