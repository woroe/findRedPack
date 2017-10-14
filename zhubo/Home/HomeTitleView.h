//
//  HomeTitleView.h
//  zhubo
//
//  Created by Jin on 2017/6/12.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeTitleViewDelegate <NSObject>

- (void)selectedBtn:(NSInteger)index;

@end


@interface HomeTitleView : UIView

+ (HomeTitleView *)instanceView;
- (void)setSelectedBtn:(NSInteger)index;

@property (weak, nonatomic) IBOutlet UIButton *zhuboBtn;
@property (weak, nonatomic) IBOutlet UIButton *discoverBtn;
@property (weak, nonatomic) IBOutlet UIButton *guanchanBtn;
@property (weak, nonatomic) IBOutlet UIButton *guanzhuBtn;



@property (nonatomic, strong) id<HomeTitleViewDelegate> delegate;


@end
