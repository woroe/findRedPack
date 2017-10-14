//
//  CircleToXiangViewController.h
//  zhubo
//
//  Created by Jin on 2017/7/14.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CircleToXiangViewControllerDelegate <NSObject>

-(void)jiequImage111:(NSArray *)imageArray;
-(void)jiequImage:(NSArray *)imageArray;

@end

@interface CircleToXiangViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) id<CircleToXiangViewControllerDelegate> delegate;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end
