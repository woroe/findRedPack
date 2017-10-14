//
//  DetailExtendShareView.m
//  zhubo
//
//  Created by Jin on 2017/6/22.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "DetailExtendShareView.h"

@interface DetailExtendShareView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *customLayout;
@property (nonatomic, assign) CGFloat collctionCellW;
@property (nonatomic, strong) NSArray *images;

@end

static NSString *collcellId = @"collectionViewShareId";
@implementation DetailExtendShareView

- (void)loadWith:(id)delegate {
    self.delegate = delegate;
    
    
    CGFloat h = SCREEN_HEIGHT - 44;
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, h);
    self.frame = frame;
    self.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.468f];
    
    
    CGFloat viewH = 380 * SCREEN_W_SCALE;
    CGFloat viewY = frame.size.height - viewH;
    UIView *bcView = [[UIView alloc] initWithFrame:CGRectMake(0, viewY, SCREEN_WIDTH, viewH)];
    bcView.backgroundColor = BaseColorBackGround;
    [self addSubview:bcView];
    
    
    CGFloat collY = 80 * SCREEN_W_SCALE;
    CGFloat collX = 60 *SCREEN_W_SCALE;
    self.collctionCellW = 120*SCREEN_W_SCALE;
    CGRect collFrame = CGRectMake(collX, collY, SCREEN_WIDTH - 2*collX, self.collctionCellW);
    _customLayout = [[UICollectionViewFlowLayout alloc] init];
    // 自定义的布局对象
    _customLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _customLayout.itemSize = CGSizeMake(_collctionCellW, _collctionCellW);
    _customLayout.minimumInteritemSpacing = 130 * SCREEN_W_SCALE;
    _collectionView = [[UICollectionView alloc] initWithFrame:collFrame collectionViewLayout:_customLayout];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:collcellId];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [bcView addSubview:_collectionView];
    
    
    CGFloat cancelH = 95 * SCREEN_W_SCALE;
    CGFloat cancelY = viewH - cancelH - 1;
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, cancelY, SCREEN_WIDTH, cancelH)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:28*SCREEN_W_SCALE];
    [cancelBtn setTitleColor:BaseColorGray forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    [bcView addSubview:cancelBtn];
}

- (UIButton *)loadButton:(NSInteger)index {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _collctionCellW, _collctionCellW)];
    NSString *imageNmae = [NSString stringWithFormat:@"share_bc%ld", index + 1];
    [btn setImage:[UIImage imageNamed:imageNmae] forState:UIControlStateNormal];
    btn.layer.cornerRadius = _collctionCellW / 2;
    
    return btn;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //关闭视图
    [self.delegate closeExtendView];
}
- (void)cancelClick:(id)sender {
    [self.delegate closeExtendView];
}
#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 3;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:collcellId forIndexPath:indexPath];
    
    UIButton *btn = [self loadButton:indexPath.row];
    [cell addSubview:btn];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
