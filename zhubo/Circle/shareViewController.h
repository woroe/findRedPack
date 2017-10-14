//
//  shareViewController.h
//  zhubo
//
//  Created by Jin on 2017/7/15.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface shareViewController : UIViewController

- (IBAction)quxiaoAction:(id)sender;
- (IBAction)wxShareAction:(id)sender;
- (IBAction)pyqShareAction:(id)sender;
- (IBAction)wbShareAction:(id)sender;
- (IBAction)kjShareAction:(id)sender;
- (IBAction)jubaoAction:(id)sender;
- (IBAction)schuAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *schuLal;

@property(nonatomic, strong)NSString *newsId;
@property(nonatomic, strong)NSString *titStr;
@property(nonatomic, strong)NSString *nameStr;
@property(nonatomic, strong)NSString *HeadImgStr;



@end
