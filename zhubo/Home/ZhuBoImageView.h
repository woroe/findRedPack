//
//  ZhuBoImageView.h
//  zhubo
//
//  Created by Jin on 2017/6/15.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZhuBoModel.h"
#import "ZhuBoDetailView.h"


@interface ZhuBoImageView : UIView

@property (nonatomic, strong) ZhuBoModel *model;
@property (nonatomic, strong) id<ZhuBoDetailViewDelegate> delegate;


- (void)loadWithModel:(ZhuBoModel *)model delegate:(id)delegate type:(NSInteger)type;


@end
