//
//  DetailExtendRewordView.m
//  zhubo
//
//  Created by Jin on 2017/6/21.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "DetailExtendRewordView.h"

@interface DetailExtendRewordView()<UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *customLayout;
@property (nonatomic, assign) CGFloat collctionCellW;


@property (nonatomic, strong) NSArray *rewardsNums;
//所有UITextField，key是rewardsNums
@property (nonatomic, strong) NSMutableDictionary *textFields;
@property (nonatomic, strong) UITextField *editTextField;


@end

static NSString *collcellId = @"collectionViewRewardId";
@implementation DetailExtendRewordView

- (void)drawRect:(CGRect)rect {
    
}
- (void)loadWith:(id)delegate {
    self.delegate = delegate;
    
    
    CGFloat h = SCREEN_HEIGHT - 44;
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, h);
    self.frame = frame;
    self.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.468f];
    
    
    CGFloat viewH = 380 * SCREEN_W_SCALE;
    CGFloat viewY = frame.size.height - viewH;
    UIView *bcView = [[UIView alloc] initWithFrame:CGRectMake(0, viewY, SCREEN_WIDTH, viewH)];
    bcView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bcView];
    
    
    self.selectedIndex = -1;
    self.textFields = [NSMutableDictionary dictionary];
    self.rewardsNums = @[@(1), @(5), @(10), @(20), @(50), @(10000)];
    self.collctionCellW = 160*SCREEN_W_SCALE;
    CGRect collFrame = CGRectMake(MARGIN_30, MARGIN_30, SCREEN_WIDTH - 2*MARGIN_30, 260*SCREEN_W_SCALE);
    _customLayout = [[UICollectionViewFlowLayout alloc] init];
    // 自定义的布局对象
    _customLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _customLayout.itemSize = CGSizeMake(_collctionCellW, 64 * SCREEN_W_SCALE);
    _customLayout.minimumLineSpacing = MARGIN_30;
    _collectionView = [[UICollectionView alloc] initWithFrame:collFrame collectionViewLayout:_customLayout];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:collcellId];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [bcView addSubview:_collectionView];
    
    
    CGFloat btnY = 220 * SCREEN_W_SCALE;
    CGFloat btnW = 130 * SCREEN_W_SCALE;
    CGFloat btnX = (SCREEN_WIDTH - btnW) / 2;
    UIButton *rewardBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnW)];
    [rewardBtn setTitle:@"赏" forState:UIControlStateNormal];
    rewardBtn.titleLabel.textColor = [UIColor whiteColor];
    rewardBtn.titleLabel.font = [UIFont systemFontOfSize: 45*SCREEN_W_SCALE];
    rewardBtn.backgroundColor = BaseColorYellow;
    rewardBtn.layer.cornerRadius = btnW / 2;
    [bcView addSubview:rewardBtn];
    
}
/*
- (UIButton *)buttonWith:(NSInteger)number {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160*SCREEN_W_SCALE, 64*SCREEN_W_SCALE)];
    [btn setTitle:[NSString stringWithFormat:@"%ld元", number] forState: UIControlStateNormal];
    [btn setTitle:[NSString stringWithFormat:@"%ld元", number] forState: UIControlStateSelected];
    [btn setTitleColor:BaseColorGray forState:UIControlStateNormal];
    [btn setTitleColor:BaseColorYellow forState:UIControlStateSelected];
    btn.layer.borderWidth = 0.8;
    btn.layer.borderColor = BaseColorGray.CGColor;
    btn.layer.cornerRadius = 2.0;
    btn.tag = number;
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}
- (void)clickBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    if(sender.selected) {
        sender.layer.borderColor = BaseColorYellow.CGColor;
    }
    else {
        sender.layer.borderColor = BaseColorGray.CGColor;
        
    }
    self.selectedIndex = sender.tag;
}
*/
- (UITextField *)textFieldWith:(NSInteger)number {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 160*SCREEN_W_SCALE, 64*SCREEN_W_SCALE)];
    textField.layer.borderWidth = 0.8;
    textField.layer.borderColor = BaseColorGray.CGColor;
    textField.layer.cornerRadius = 2.0;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.font = [UIFont systemFontOfSize: 30 * SCREEN_W_SCALE];
    textField.textColor = BaseColorGray;
    textField.delegate = self;
    textField.tag = number;
    
    if([@(number) isEqual: self.rewardsNums[5]]){
        textField.placeholder = @"输入金额";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        self.editTextField = textField;
        
    }
    else {
        NSString *text = [NSString stringWithFormat:@"%ld元", number];
        textField.text = text;
    }
    
    [self.textFields setObject:textField forKey:[NSString stringWithFormat:@"%ld", number]];
    return textField;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    textField.selected = !textField.selected;
    if(!textField.selected) {
        textField.layer.borderColor = BaseColorGray.CGColor;
        textField.textColor = BaseColorGray;
        self.selectedIndex = -1;
    }
    else {
        textField.layer.borderColor = BaseColorYellow.CGColor;
        textField.textColor = BaseColorYellow;
        if(self.selectedIndex != -1){
            UITextField *lastTextField = [self.textFields objectForKey:[NSString stringWithFormat:@"%ld", self.selectedIndex]];
            lastTextField.layer.borderColor = BaseColorGray.CGColor;
            lastTextField.textColor = BaseColorGray;
            lastTextField.selected = NO;
        }
        
        self.selectedIndex = textField.tag;
    }
    
    if([@(textField.tag) isEqual: self.rewardsNums[5]]){
        return YES;
    }
    else {
        return NO;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //输入框
    if(self.editTextField.isFirstResponder){
        [self.editTextField resignFirstResponder];
        return;
    }
    //关闭视图
    [self.delegate closeExtendView];
}


#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 6;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:collcellId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
//    if(indexPath.row == 5) {
//        
//    }
//    else {
//        UIButton *btn = [self buttonWith:((NSNumber *)self.rewardsNums[indexPath.row]).integerValue];
//        [cell addSubview: btn];
//    }
    
    
    NSNumber *num = self.rewardsNums[indexPath.row];
    UITextField *btn = [self textFieldWith: num.integerValue];
    [cell addSubview: btn];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
@end
