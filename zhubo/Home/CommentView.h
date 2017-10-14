//
//  CommentView.h
//  zhubo
//
//  Created by Jin on 2017/6/17.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@protocol CommentViewDelegate <NSObject>

//@optional
- (void)clickedUser:(id)sender withModel:(CommentModel *)model;
- (void)slickComment_Comment:(id)sender  CommentModel:(CommentModel *)model;
- (void)commentUser:(id)sender withModel:(CommentModel *)model;

@end

@interface CommentView : UIView

@property (nonatomic, strong) CommentModel *model;
@property (nonatomic, strong) id<CommentViewDelegate> delegate;

@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UIImageView *authImgView;
@property (nonatomic, strong) UILabel *nickLable;
@property (nonatomic, strong) UILabel *dateLable;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UIButton *supportBtn;
@property (nonatomic, strong) UILabel *supportLab;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UILabel *commentLab;
@property (nonatomic, strong) NSString *qz_And_News_Sre;//1 新闻评论 2圈子新闻评论

//type: 1普通评论 2评论内评论
- (void)loadWithModel:(CommentModel *)model delegate:(id)delegate type:(NSInteger)type;
@end
