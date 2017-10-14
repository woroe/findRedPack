//
//  WebViewController.h
//  zhubo
//
//  Created by Jin on 2017/8/10.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (nonatomic, strong)NSString *webStr;
@property (nonatomic, strong)NSString *titleStr;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
