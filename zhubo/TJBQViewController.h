//
//  TJBQViewController.h
//  zhubo
//
//  Created by Jin on 2017/7/31.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HAVPlayer.h"

@interface TJBQViewController : UIViewController{
    
    NSURL *prayelUrl;
}

@property (strong, nonatomic) HAVPlayer *player;

@property(nonatomic,strong) UIImage *image;

@property(nonatomic,strong) NSURL *prayelUrl;
@property(nonatomic,strong) UIImage *selectImage;

@property(nonatomic,strong) NSMutableArray *imageMuArr;

@property(nonatomic, assign) NSInteger xiangceAndXiangjiBool;

@end
