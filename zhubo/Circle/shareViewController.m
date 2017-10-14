//
//  shareViewController.m
//  zhubo
//
//  Created by Jin on 2017/7/15.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "shareViewController.h"

#import "WXApi.h"

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboSDK.h"

@interface shareViewController ()<TencentSessionDelegate>

@end

@implementation shareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.468f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)wxShareAction:(id)sender {
    // 发送到聊天界面  WXSceneSession
    // 发送到朋友圈    WXSceneTimeline
    // 发送到微信收藏  WXSceneFavorite
    NSString *str =[NSString stringWithFormat:@"http://www.askzhu.com/web/share/share.html?ids=%@",self.newsId];
    WXMediaMessage *mediaMsg = [WXMediaMessage message];
    mediaMsg.title = self.titStr;
    mediaMsg.description = [NSString stringWithFormat:@"来自%@的主题",self.nameStr];
    [mediaMsg setThumbImage: [UIImage imageNamed:@"logo_lcon"]];
    
    WXWebpageObject *pageObj = [WXWebpageObject object];
    pageObj.webpageUrl = str;
    mediaMsg.mediaObject = pageObj;
    
    SendMessageToWXReq *send = [[SendMessageToWXReq alloc] init];
    send.bText = NO;
    send.message = mediaMsg;
    send.scene = WXSceneSession;
    [WXApi sendReq:send];
}

- (IBAction)pyqShareAction:(id)sender {
    NSString *str =[NSString stringWithFormat:@"http://www.askzhu.com/web/share/share.html?ids=%@",self.newsId];
    WXMediaMessage *mediaMsg = [WXMediaMessage message];
    if ([self.titStr isEqualToString:@""]) {
        mediaMsg.title = [NSString stringWithFormat:@"来自%@的主题",self.nameStr];
    }else {
        mediaMsg.title = self.titStr;
    }
    mediaMsg.description = [NSString stringWithFormat:@"来自%@的主题",self.nameStr];
    [mediaMsg setThumbImage: [UIImage imageNamed:@"logo_lcon"]];
    
    WXWebpageObject *pageObj = [WXWebpageObject object];
    pageObj.webpageUrl = str;
    mediaMsg.mediaObject = pageObj;
    
    SendMessageToWXReq *send = [[SendMessageToWXReq alloc] init];
    send.bText = NO;
    send.message = mediaMsg;
    send.scene = WXSceneTimeline;
    [WXApi sendReq:send];
}

- (IBAction)wbShareAction:(id)sender {
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:@"1168191518"];
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = @"http://www.jianshu.com/u/ce13fa1e87f8";
    request.scope = @"all";
    
    WBMessageObject *message = [WBMessageObject message];
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = self.newsId;
    webpage.title = [NSString stringWithFormat:@"来自%@的主题",self.nameStr];//NSLocalizedString(self.titStr, nil);
    webpage.description = [NSString stringWithFormat:@"来自%@的主题",self.nameStr];
    UIImage *image = [UIImage imageNamed:@"180.png"];
    webpage.thumbnailData = UIImageJPEGRepresentation(image, 0.3);
    webpage.webpageUrl = [NSString stringWithFormat:@"http://www.askzhu.com/web/share/share.html?ids=%@",self.newsId];
    message.mediaObject = webpage;
    
    WBSendMessageToWeiboRequest *sendMessagerequest = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:request access_token:nil];
    sendMessagerequest.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                                    @"Other_Info_1": [NSNumber numberWithInt:123],
                                    @"Other_Info_2": @[@"obj1", @"obj2"],
                                    @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:sendMessagerequest];
}

- (IBAction)kjShareAction:(id)sender {
    TencentOAuth *_tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1106261617" andDelegate:self];
    UIButton *but = sender;
    if (but.tag == 10) {// qq空间分享
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.askzhu.com/web/share/share.html?ids=%@",self.newsId]];
        UIImage *image = [UIImage imageNamed:@"180.png"];
        NSData *data = UIImageJPEGRepresentation(image, 0.3);
        QQApiNewsObject* img = [QQApiNewsObject objectWithURL:url title:[NSString stringWithFormat:@"来自%@的主题",self.nameStr] description:self.titStr previewImageData:data];
        
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:img];
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
        NSLog(@"%d",sent);
    }else if (but.tag == 12){//qq分享
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.askzhu.com/web/share/share.html?ids=%@",self.newsId]];
        UIImage *image = [UIImage imageNamed:@"180.png"];
        NSData *data = UIImageJPEGRepresentation(image, 0.3);
        QQApiNewsObject* img = [QQApiNewsObject objectWithURL:url title:[NSString stringWithFormat:@"来自%@的主题",self.nameStr] description:self.titStr previewImageData:data];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:img];
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        NSLog(@"%d",sent);
    }
}

- (IBAction)jubaoAction:(id)sender {
    
}

- (IBAction)schuAction:(id)sender {
    
}

- (IBAction)quxiaoAction:(id)sender {
    [self dismissViewController];
}

- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismissViewController];
}



@end
