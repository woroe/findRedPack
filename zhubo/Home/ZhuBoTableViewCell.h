//
//  ZhuBoTableViewCell.h
//  zhubo
//
//  Created by Jin on 2017/6/12.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZhuBoModel.h"

@protocol ZhuBoCellDelegate <NSObject>

@optional
- (void)clickedUser:(id)sender withModel:(ZhuBoModel *)model;
- (void)clickedFollow:(id)sender withModel:(ZhuBoModel *)model;
- (void)clickedContent:(id)sender withModel:(ZhuBoModel *)model;
- (void)clickedLoction:(id)sender withModel:(ZhuBoModel *)model;
- (void)clickedSupport:(id)sender withModel:(ZhuBoModel *)model;
- (void)clickedComment:(id)sender withModel:(ZhuBoModel *)model;
- (void)clickedImage:(id)sender withModel:(ZhuBoModel *)model;
- (void)clickedImageBtn:(id)sender withModel:(ZhuBoModel *)model;
- (void)clickedGengduo:(id)sender withModel:(ZhuBoModel *)model;

- (void)openPhotoBrowser:(NSInteger)index ZhuBoModel:(ZhuBoModel *)model;

- (void)startPlayVideo:(ZhuBoModel *)model but:(UIButton *)sender;

@end

@interface ZhuBoTableViewCell : UITableViewCell


@property (nonatomic, strong) ZhuBoModel *model;
@property (nonatomic, strong) id<ZhuBoCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *PlayBut;

@property (weak, nonatomic) IBOutlet UIButton *headrImageView;
@property (weak, nonatomic) IBOutlet UIButton *nameLal;
@property (weak, nonatomic) IBOutlet UIButton *danweiMCLal;
@property (weak, nonatomic) IBOutlet UIButton *guanzhuBut;
@property (weak, nonatomic) IBOutlet UILabel *neirLal;
@property (weak, nonatomic) IBOutlet UIView *imageVC;
@property (weak, nonatomic) IBOutlet UIButton *huihuBut;
@property (weak, nonatomic) IBOutlet UIButton *zanBut;
@property (weak, nonatomic) IBOutlet UILabel *zanShuLal;
@property (weak, nonatomic) IBOutlet UILabel *huihuShuLal;
@property (weak, nonatomic) IBOutlet UIButton *genduoBut;


@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UIImageView *authImgView;
@property (nonatomic, strong) UILabel *nickLable;
@property (nonatomic, strong) UILabel *dateLable;
@property (nonatomic, strong) UIButton *followBtn;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UIView *imageBCView;
@property (nonatomic, strong) UIImageView *loctionImgView;
@property (nonatomic, strong) UILabel *locationLab;
@property (nonatomic, strong) UIButton *supportBtn;
@property (nonatomic, strong) UILabel *supportLab;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UILabel *commentLab;

@property (nonatomic, strong) UIButton *gengduoBtn;
@property (nonatomic, strong) NSString *qz_And_News_Str; // 1的时候是新闻，2的时候是圈子动态
@property (nonatomic, assign) NSInteger indexPathRow;

- (void)loadWithModel:(ZhuBoModel *)model delegate:(id)delegate type:(NSInteger)type;

@end
