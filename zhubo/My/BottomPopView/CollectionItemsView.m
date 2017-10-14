//
//  CollectionItemsView.m
//  MoP
//
//  Created by JF on 17/5/31.
//  Copyright © 2017年 com.me. All rights reserved.
//

#import "CollectionItemsView.h"

@interface CollectionItemsView()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation CollectionItemsView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.1];
        
        [self initContentView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    float w = (SCREEN_WIDTH-5*(1+PAGE))/PAGE;
    float count = self.items.count%PAGE ? 1:0;
    count += self.items.count/PAGE;
    self.collectionView.contentSize = CGSizeMake(0, w*count + 5*(count+1));

    [self.collectionView reloadData];
}

-(void)initContentView{
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
    //同一行相邻两个cell的最小间距
    layout.minimumInteritemSpacing = 0;
    //最小两行之间的间距
    layout.minimumLineSpacing = 5;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-350, SCREEN_WIDTH, 350) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.collectionView];
    
    [self.collectionView registerClass:[collectionBtnCell class] forCellWithReuseIdentifier:@"CollectionBtnCell"];
    
}


//一共有多少个组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//每一组有多少个cell
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}
//每一个cell是什么
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* p = self.items[indexPath.row];
    
    collectionBtnCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionBtnCell" forIndexPath:indexPath];
    
    [cell.titleBtn setTitle:p[@"name"] forState:UIControlStateNormal];
//    [cell.titleBtn setImage:[UIImage imageNamed:p[@"imageName"]] forState:UIControlStateNormal];
    
    return cell;
}

//每一个分组的上左下右间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float w = (SCREEN_WIDTH-5*(1+PAGE))/PAGE;
    return CGSizeMake(w, w);
}

//cell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //cell被电击后移动的动画
    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionTop];
}

@end

@implementation collectionBtnCell

-(id)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        float w = (SCREEN_WIDTH-5*(1+PAGE))/PAGE;
        self.titleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, w, w)];
        self.titleBtn.layer.borderWidth = 1;
        self.titleBtn.layer.borderColor = HEXCOLOR(@"efeff4").CGColor;
        self.titleBtn.layer.cornerRadius = 5;
        [self.titleBtn setTitleColor:HEXCOLOR(@"333333") forState:UIControlStateNormal];
        self.titleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        self.titleBtn.backgroundColor = [UIColor grayColor];
        
        [self.contentView addSubview:self.titleBtn];
    }
    
    return self;
}

@end

