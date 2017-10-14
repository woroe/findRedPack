//
//  BottomPopView.h
//  LongxinLoan
//
//  Created by JF on 17/2/15.
//  Copyright © 2017年 com.me. All rights reserved.
//

/*
 //使用方法
 BottomPopView* vc = [[BottomPopView alloc]init];
 vc.datas = @[@{@"code":@"1",@"message":@"还款方式"}];
 [vc bottomblock:^(id obj) {
 DLog(@"----%@",obj);
 
 
 }];
 [self.view addSubview:vc];
 */

#import <UIKit/UIKit.h>

typedef void (^bottomAlert)(id obj);

@interface BottomPopView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) bottomAlert block;

-(void)bottomblock:(bottomAlert)block;

@property (nonatomic, strong) NSArray <NSDictionary*> *datas;
                                // datas的格式@{@"id":@"",@"Name":@""}
                                //对应格式－－－类型－－－－名字
@end
