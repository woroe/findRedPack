//
//  BottomPopView.m
//  LongxinLoan
//
//  Created by JF on 17/2/15.
//  Copyright © 2017年 com.me. All rights reserved.
//

#import "BottomPopView.h"

@implementation BottomPopView
{
    NSDictionary* selectedInfo;
    UIPickerView* picker;
}
-(id)init{
    if (self == [super init]) {
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.1];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self initBottomView];
        });
        
    }
    return self;
}

-(void)initBottomView{
    
    UIControl* bottomView = [[UIControl alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-200, SCREEN_WIDTH, 200)];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    //1.
    //工具栏
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    //取消、确定按钮
    UINavigationItem *item = [[UINavigationItem alloc] init];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelAction)];
    item.leftBarButtonItem = left;
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(onConfirmAction)];
    item.rightBarButtonItem = right;
    [bar pushNavigationItem:item animated:NO];
    
    [bottomView addSubview:bar];
    
    //2.
    picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0,44, SCREEN_WIDTH, 200 - 44)];
    picker.backgroundColor = [UIColor whiteColor];
    picker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    picker.showsSelectionIndicator = YES;
    picker.delegate = self;
    picker.dataSource = self;
    
    [bottomView addSubview:picker];
    
    [self addSubview:bottomView];
    
    //数据有无
    if (_datas.count <=0) {
        
        selectedInfo = [NSDictionary dictionary];
    }else{
        selectedInfo = [NSDictionary dictionaryWithDictionary:[_datas firstObject]];
    }
    
}

-(void)bottomblock:(bottomAlert)block{
    self.block = block;
}

-(void)onCancelAction{//取消
    [self removeFromSuperview];
}

-(void)onConfirmAction{//确定
    _block(selectedInfo);
    [self removeFromSuperview];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;{
    //数据有无
    if (_datas.count <=0) {
        
        return 0;
    }else{
        return _datas.count;
    }
    
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view __TVOS_PROHIBITED;{
    UIView* vc = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    
    NSDictionary* p = _datas[row];
    UILabel* title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    //数据有无
    if (_datas.count <=0) {
        
        title.text = @"";
    }else{
        title.text = p[@"Name"];
    }
    
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:15];
    title.textColor = HEXCOLOR(@"666666");
    [vc addSubview:title];
    
    return vc;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED;{
    
    selectedInfo = [NSDictionary dictionaryWithDictionary:_datas[row]];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
}

@end
