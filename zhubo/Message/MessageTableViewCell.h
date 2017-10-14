//
//  MessageTableViewCell.h
//  zhubo
//
//  Created by Jin on 2017/7/13.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *toxiangImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLal;
@property (weak, nonatomic) IBOutlet UILabel *messageLal;
@property (weak, nonatomic) IBOutlet UILabel *shijianLal;

@end
