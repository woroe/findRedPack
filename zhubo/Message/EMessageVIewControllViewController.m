//
//  EMessageVIewControllViewController.m
//  zhubo
//
//  Created by Jin on 2017/7/16.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "EMessageVIewControllViewController.h"



@interface EMessageVIewControllViewController ()<EaseMessageViewControllerDelegate,EaseMessageViewControllerDataSource>{
    
    NSMutableDictionary *muDic;
}

@end

@implementation EMessageVIewControllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    muDic = [NSMutableDictionary new];
    
    self.delegate = self;
    self.dataSource = self;
    
    self.title = [self.dic objectForKey:@"NickName"];
    
    UIImage *photoIcon=[UIImage imageNamed: @"ease_mm_title_remove"];
    photoIcon = [photoIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:photoIcon style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
    self.navigationItem.rightBarButtonItem = item;
}

-(void)rightBtnClick{
    
    [self.conversation deleteAllMessages:nil];
    
    [self.messsagesSource removeAllObjects];
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - EaseMessageViewControllerDataSource
- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController
                           modelForMessage:(EMMessage *)message
{
    id<IMessageModel> model = nil;
    model = [[EaseMessageModel alloc] initWithMessage:message];
    if (model.isSender) {
        NSLog(@"自己发送");
        
        model.message.ext = @{@"avatar":[BaseData shareInstance].headImg,@"nick":[BaseData shareInstance].nickName};
        model.avatarURLPath = [BaseData shareInstance].headImg;
        model.nickname = @"";//[BaseData shareInstance].nickName;
        model.failImageName = @"sunlei.jpg";
        
    }else{
        NSLog(@"对方发送");
        //头像
        model.message.ext = @{@"avatar":[self.dic objectForKey:@"HeadImg"],@"nick":[self.dic objectForKey:@"NickName"]};
        model.avatarURLPath = [self.dic objectForKey:@"HeadImg"];
        model.nickname = @"";
        model.failImageName = @"sunlei.jpg";
//        self.title = @"";
    }
    return model;
}
#pragma mark - 发送文本消息，对消息进行扩展
- (void)sendTextMessage:(NSString *)text
{
    NSDictionary *ext =  @{@"avatar":[BaseData shareInstance].headImg,@"nick":[BaseData shareInstance].nickName};
    [self sendTextMessage:text withExt:ext];

}

#pragma mark - 发送图片消息
//- (void)sendImageMessage:(UIImage *)image{
//    NSLog(@"发送图片消息");
////    [self sendImageMessage:image];
//    NSDictionary *ext =  @{@"avatar":[self.dic objectForKey:@"HeadImg"],@"nick":[self.dic objectForKey:@"NickName"]};
//
//    EMMessage *message = [EaseSDKHelper sendImageMessageWithImage:image to:self.conversation.conversationId  messageType:NO messageExt:ext];
//
//    [self addMessageToDataSource:message progress:nil];
//}

#pragma mark - 发送位置消息
//- (void)sendLocationMessageLatitude:(double)latitude longitude:(double)longitude andAddress:(NSString *)address{
//    NSLog(@"发送位置消息");
//    
//    NSDictionary *ext =  @{@"avatar":[self.dic objectForKey:@"HeadImg"],@"nick":[self.dic objectForKey:@"NickName"]};
//    
//    EMMessage *message = [EaseSDKHelper sendLocationMessageWithLatitude:latitude longitude:longitude address:address to:self.conversation.conversationId messageType:EMChatTypeChatRoom messageExt:ext];
//    
//    [self addMessageToDataSource:message
//                        progress:nil];
//}

//- (void)messageViewController:(EaseMessageViewController *)viewController didSelectAvatarMessageModel:(id<IMessageModel>)messageModel {
//    //UserProfileViewController用户自定义的个人信息视图
//    //样例的逻辑是选中消息头像后，进入该消息发送者的个人信息
//    NSLog(@"进入该消息发送者的个人信");
//}



@end
