//
//  BQNRViewController.h
//  zhubo
//
//  Created by Jin on 2017/7/31.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BQNRViewControllerDelegate <NSObject>

- (void)BQTextFStr:(NSDictionary *)info xgaihaishixinjian:(NSString *)str;

@end

@interface BQNRViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *firstTagField;//标签分类
@property (weak, nonatomic) IBOutlet UITextField *secondTagField;//标签所在区域
@property (weak, nonatomic) IBOutlet UITextField *textFleld;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, strong) id<BQNRViewControllerDelegate> delegate;


@property (nonatomic, strong) NSString *str;
- (IBAction)firstTagInfoSelectAction:(UIControl *)sender;
- (IBAction)secondTagInfoSelectAction:(UIControl *)sender;

@end
