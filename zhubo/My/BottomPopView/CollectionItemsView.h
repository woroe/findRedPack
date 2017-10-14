//
//  CollectionItemsView.h
//  MoP
//
//  Created by JF on 17/5/31.
//  Copyright © 2017年 com.me. All rights reserved.
//
#define PAGE    3

#import <UIKit/UIKit.h>

@interface CollectionItemsView : UIView

@property(nonatomic, strong)UICollectionView* collectionView;

/**
 传入图片名字 － imageName，以及图片title - name格式
 */
@property(nonatomic, strong)NSArray* items;  //@{imageName:@"",@"name":@""}

@end


/**
 collectionCell
 */
@interface collectionBtnCell : UICollectionViewCell

@property(nonatomic, strong) UIButton* titleBtn;

@end
