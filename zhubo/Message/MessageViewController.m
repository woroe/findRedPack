//
//  MessageViewController.m
//  zhubo
//
//  Created by Jin on 2017/6/8.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableViewCell.h"
#import "EMessageVIewControllViewController.h"
#import "UITabBarItem+DKSBadge.h"

#import "delectMassageViewController.h"

//#import <IChatManagerConversation.h>

@interface MessageViewController ()<EMChatManagerDelegate,EMUserListViewControllerDataSource,EaseConversationListViewControllerDelegate,EaseConversationListViewControllerDataSource,delectMassageViewControllerDelegate>{
    
    NSInteger indexInt;
}

@property (nonatomic, strong) NSMutableArray *muArr;
@property (nonatomic, strong) UIView *bgView;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    
//    NSString *hxyhStr = [NSString stringWithFormat:@"askzhu_%@",@([BaseData shareInstance].userId)];
//    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
//    if (!isAutoLogin) {
//        EMError *error1 = [[EMClient sharedClient] loginWithUsername:hxyhStr password:@"123456"];
//        if (!error1) {
//            ZBLog(@"登录成功");
//        }else{
//            ZBLog(@"登录失败____%@",error1);
//        }
//    }
    [super viewDidLoad];
    
    _muArr = [NSMutableArray array];
    self.title = @"消息";
    
    [self setShowRefreshHeader:YES];
    [self setShowRefreshFooter:YES];
    [self setShowTableBlankView:YES];
    
    _bgView = [[[NSBundle mainBundle] loadNibNamed:@"MessageWuView" owner:nil options:nil] lastObject];
    _bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:_bgView];
    
    //注册消息回调
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
    EaseUsersListViewController *emv = [[EaseUsersListViewController alloc]init];
    emv.dataSource = self;
    self.delegate = self;
    self.dataSource = self;
    
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    [self.navigationController.tabBarItem hidenBadge];
    
    UIImage *photoIcon=[UIImage imageNamed: @"more"];
    photoIcon = [photoIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:photoIcon style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
    self.navigationItem.rightBarButtonItem = item;
    
}

-(void)rightBtnClick{
    delectMassageViewController *vc = [[delectMassageViewController alloc]init];
    vc.delegate = self;
    [vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    //背景透明
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        vc.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    }else{
        self.modalPresentationStyle=UIModalPresentationCurrentContext;
    }
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:^{
    }];
}

#pragma mark -- delectMassageViewControllerDelegate
- (void)delecatMessageAtion{
    NSArray  *_conversation = [[EMClient sharedClient].chatManager getAllConversations];
    [[EMClient sharedClient].chatManager deleteConversations:_conversation isDeleteMessages:NO completion:nil];

    [self tableViewDidTriggerHeaderRefresh];
    _bgView.hidden = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    NSArray  *_conversation = [[EMClient sharedClient].chatManager getAllConversations];
    
    if ([_conversation count] == 1) {
        EMConversation *con = _conversation[0];
        NSString *str = con.conversationId;
        if ([str isEqualToString:@"阿筑"]) {
            _bgView.hidden = NO;
        }else{
            _bgView.hidden = YES;
            [self loadData:_conversation];
        }
    }else{
        if (_conversation.count == 0) {
            _bgView.hidden = NO;
        }else{
            _bgView.hidden = YES;
            [self loadData:_conversation];
        }
    }
    [self loadData:_conversation];
    [self tableViewDidTriggerHeaderRefresh];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gohome) name:@"gohome" object:nil];
}
- (void)gohome {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gohome_zuiXing" object:nil];
    HomeViewController *homeVC = self.tabBarController.viewControllers[0];
    self.tabBarController.selectedViewController = homeVC;
}
-(void)tongzhiAction{
    [self viewDidLoad];
}
- (void)messagesDidReceive:(NSArray *)aMessages{
    if (aMessages.count >0) {
        EMMessage *message = aMessages[0];
        NSString *str = message.from;
//        EMTextMessageBody *body = (EMTextMessageBody *)message.body;
        if ([str isEqualToString:@"阿筑"]) {
//            NSLog(@"收到消息 +++++++++++++%@+++++++%@",str,body.text);
//            //定义本地通知对象
//           UILocalNotification *notification=[[UILocalNotification alloc]init];
//           //设置调用时间
//           notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:1.0];//通知触发的时间，10s以后
//           notification.repeatInterval=1;//通知重复次数
//          //notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
//            
//           //设置通知属性
//            notification.alertBody=body.text;//通知主体
//            notification.applicationIconBadgeNumber=+1;//应用程序图标右上角显示的消息数
//            notification.alertAction=@"打开应用";//待机界面的滑动动作提示
//            notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片
//            //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
//            notification.soundName=@"msg.caf";//通知声音（需要真机）
//            //设置用户信息
//            notification.userInfo=@{@"id":@1,@"user":@"Kenshin Cui"};//绑定到通知上的其他额外信息
//           //调用通知
//            [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
//            
//            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"消息提示" message:body.text preferredStyle:UIAlertControllerStyleActionSheet];
//            UIAlertAction *AAsc1 = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            }];
//            [ac addAction:AAsc1];
//            [self presentViewController:ac animated:YES completion:nil];
            
        }else{
            NSLog(@"收到消息 +++++++++++++");
            _bgView.hidden = YES;
            NSArray  *_conversation = [[EMClient sharedClient].chatManager getAllConversations];
            [self loadData:_conversation];
            [self tableViewDidTriggerHeaderRefresh];
            [self.navigationController.tabBarItem showBadge];
        }
    }
}

- (void)refreshAndSortView{
    [self tableViewDidTriggerHeaderRefresh];
}
- (void)setModel:(id)model{
    
}
- (void)didReceiveMessages:(NSArray *)aMessages{

}

- (id<IConversationModel>)conversationListViewController:(EaseConversationListViewController *)conversationListViewController modelForConversation:(EMConversation *)conversation{
    
    EaseConversationModel *model = [[EaseConversationModel alloc]initWithConversation:conversation];

    NSString *str = conversation.conversationId;
    if ([str isEqualToString:@"阿筑"]) {
        return nil;
    }
    NSArray *arr0 = [str componentsSeparatedByString:@"_"];
    NSDictionary *dicUser ;
    NSString *userId = arr0[1];
    for (NSDictionary *dic in _muArr) {
        NSString *muArrUaerId = [dic objectForKey:@"Id"];
        if (userId.intValue == muArrUaerId.intValue) {
            dicUser = dic;
        }
    }
    model.title =[dicUser objectForKey:@"NickName"];
    model.avatarURLPath = [dicUser objectForKey:@"HeadImg"];
    return model;
    
}
- (void)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
            didSelectConversationModel:(id<IConversationModel>)conversationModel{

    NSString *str = conversationModel.conversation.conversationId;
    if ([str isEqualToString:@"阿筑"]) {
        return ;
    }
    NSArray *arr0 = [str componentsSeparatedByString:@"_"];
    NSDictionary *dicUser ;
    NSString *userId = arr0[1];
    for (NSDictionary *dic in _muArr) {
        NSString *muArrUaerId = [dic objectForKey:@"Id"];
        if (userId.intValue == muArrUaerId.intValue) {
            dicUser = dic;
        }
    }
    EMessageVIewControllViewController *messageView = [[EMessageVIewControllViewController alloc]initWithConversationChatter:conversationModel.conversation.conversationId conversationType:EMConversationTypeChat];
    messageView.userId = userId.intValue;
    messageView.dic = dicUser;
    [self.navigationController pushViewController:messageView animated:YES];
}
-(void)loadData:(NSArray *)arr{
    NSMutableString *muStr ;
    BOOL b = YES;
    for (EMConversation * conversationin in arr) {
        NSInteger int11 =[conversationin unreadMessagesCount];
        if (int11 > 0) {
            b = NO;
        }
        NSString *str = conversationin.conversationId;
        NSArray *arr0 = [str componentsSeparatedByString:@"_"];
        if ([muStr isEqualToString:@""] || muStr ==nil) {
            if (arr0.count>1) {
                muStr = [[NSMutableString alloc]initWithFormat:@"%@",arr0[1]];
            }
        }else{
            if (arr0.count>1){
                muStr = [[NSMutableString alloc]initWithFormat:@"%@,%@",muStr,arr0[1]];
            }
        }
    }
    [self.navigationController.tabBarItem hidenBadge];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"Ids"] =muStr;
    params[@"BuildSowingType"] = @"GetHuanXinUserMsg";
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        ZBLog(@"BuildSowing_UserMsg--%@", res);
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            NSArray *dataArr = [res objectForKey:@"data"];
            if(!dataArr || dataArr.count == 0) {
                return ;
            }
            [_muArr removeAllObjects];
            if ([dataArr count] > 0) {
                for (NSDictionary *dic in dataArr) {
                    [_muArr addObject:dic];
                }
            }
            [self tableViewDidTriggerHeaderRefresh];
        }
        else{
//            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
    }];
}

@end
