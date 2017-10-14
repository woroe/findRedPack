//
//  AppDelegate.m
//  zhubo
//
//  Created by Jin on 2017/6/8.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "AppDelegate.h"
#import "myViewController.h"
#import "LaunchIntroductionView.h"

#import "UMMobClick/MobClick.h"

#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<WXApiDelegate,UNUserNotificationCenterDelegate,EMClientDelegate,EMChatManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    BaseTabBarViewController *BaseVC = [[BaseTabBarViewController alloc] init];
    self.window.rootViewController = BaseVC;
    //引导图
    [self initLauch];
    //高德
    [AMapServices sharedServices].apiKey = GaoDeMapKey;
    
    //环信
    EMOptions *options = [EMOptions optionsWithAppkey:HyphenateKey];
    options.apnsCertName = @"istore_dev";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    // 微信 （向微信注册应用。）
    [WXApi registerApp:URL_APPID];

    //如果已经获得发送通知的授权则创建本地通知，否则请求授权(注意：如果不请求授权在设置中是没有对应的通知设置项的，也就是说如果从来没有发送过请求，即使通过设置也打不开消息允许设置)
    if ([[UIApplication sharedApplication]currentUserNotificationSettings].types!=UIUserNotificationTypeNone) {
//        [self addLocalNotification];
    }else{
        [[UIApplication sharedApplication]registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    //盟友初始化
    UMConfigInstance.appKey = MengYouKey;
    UMConfigInstance.channelId = AppleIDKey;
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    
    //环信登录
    NSDictionary *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    if(user){
        [[BaseData shareInstance] setUser:user];
    }
    NSString *hxyhStr = [NSString stringWithFormat:@"askzhu_%@",@([BaseData shareInstance].userId)];
    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
    if (!isAutoLogin) {
        EMError *error1 = [[EMClient sharedClient] loginWithUsername:hxyhStr password:@"123456"];
        if (!error1) {
            ZBLog(@"登录成功");
        }else{
            ZBLog(@"登录失败____%@",error1);
        }
    }
    /**
     注册APNS离线推送  
     */
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound |
        UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    //添加监听在线推送消息
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    return YES;
}

- (void)initLauch {
    LaunchIntroductionView *lauch = [LaunchIntroductionView sharedWithStoryboard:@"Main" images:@[@"launch0.jpg",@"launch1.jpg",@"launch2.jpg"] buttonImage:@"lauch_btn" buttonFrame:CGRectMake(kScreen_width/2 - (kScreen_width * 326/750)/2, kScreen_height * 970/1334, kScreen_width*326/750, kScreen_width * 44/326)];
    lauch.currentColor = [UIColor clearColor];
    lauch.nomalColor = [UIColor clearColor];
}

//监听环信在线推送消息
- (void)messagesDidReceive:(NSArray *)aMessages{
    
    if (aMessages.count >0) {
        EMMessage *message = aMessages[0];
        NSString *str = message.from;
        EMTextMessageBody *body = (EMTextMessageBody *)message.body;
        if ([str isEqualToString:@"阿筑"]) {
            //定义本地通知对象
            UILocalNotification *notification=[[UILocalNotification alloc]init];
            //设置调用时间
            notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:1.0];//通知触发的时间，10s以后
            notification.repeatInterval=1;//通知重复次数
            //notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
            //设置通知属性
            notification.alertBody=body.text;//通知主体
            notification.applicationIconBadgeNumber=+1;//应用程序图标右上角显示的消息数
            notification.alertAction=@"打开应用";//待机界面的滑动动作提示
            notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片
            //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
            notification.soundName=@"msg.caf";//通知声音（需要真机）
            //设置用户信息
            notification.userInfo=@{@"id":@1,@"user":@"Kenshin Cui"};//绑定到通知上的其他额外信息
            //调用通知
            [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tishixiaoxi" object:nil];
        }
    }
    //aMessages是一个对象,包含了发过来的所有信息,怎么提取想要的信息我会在后面贴出来.
}
// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[EMClient sharedClient] bindDeviceToken:deviceToken];
}
// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"error -- %@",error);
}
/*! @brief 处理微信通过URL启动App时传递的数据
 *
 * 需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用。
 * url 微信启动第三方应用时传递过来的URL
 * delegate  WXApiDelegate对象，用来接收微信触发的消息。
 * @return 成功返回YES，失败返回NO。
 */
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    BOOL b;
    b = [WXApi handleOpenURL:url delegate:self];
    b = [QQApiInterface handleOpenURL:url delegate:self];
    b = [TencentOAuth HandleOpenURL:url];
    return b;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    BOOL b;
    b = [TencentOAuth HandleOpenURL:url];
    b = [WXApi handleOpenURL:url delegate:self];
    return b;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation{
    [TencentOAuth HandleOpenURL:url];
    BOOL b = [WXApi handleOpenURL:url delegate:self];
    return b;
}
/**
 处理来至QQ的请求
 */
- (void)onReq:(QQBaseReq *)req{
    NSLog(@" ----req %@",req);
}

///**
// 处理来至QQ的响应
// */
//- (void)onResp:(QQBaseResp *)resp{
//    NSLog(@" ----resp %@",resp);
//}

/**
 处理QQ在线状态的回调
 */
- (void)isOnlineResponse:(NSDictionary *)response{
    
}
/*! 微信回调，不管是登录还是分享成功与否，都是走这个方法 @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * resp具体的回应内容，是自动释放的
 */
-(void) onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[SendAuthResp class]]) {   //授权登录的类。
        if (resp.errCode == 0) {  //成功。
            //这里处理回调的方法 。 通过代理吧对应的登录消息传送过去。
            if ([_WXDelegate respondsToSelector:@selector(loginSuccessByCode:)]) {
                SendAuthResp *resp2 = (SendAuthResp *)resp;
                [_WXDelegate loginSuccessByCode:resp2.code];
            }
        }else{ //失败
            NSLog(@"error %@",resp.errStr);
        }
    }
    
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) { //微信分享 微信回应给第三方应用程序的类
        SendMessageToWXResp *response = (SendMessageToWXResp *)resp;
        NSLog(@"error code %d  error msg %@  lang %@   country %@",response.errCode,response.errStr,response.lang,response.country);
        
        if (resp.errCode == 0) {  //成功。
            //这里处理回调的方法 。 通过代理吧对应的登录消息传送过去。
            if (_WXDelegate) {
                if([_WXDelegate respondsToSelector:@selector(shareSuccessByCode:)]){
                    [_WXDelegate shareSuccessByCode:response.errCode];
                }
            }
        }else{ //失败
            NSLog(@"error %@",resp.errStr);
        }
    }
    /*
     0  展示成功页面
     -1  可能的原因：签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等。
     -2  用户取消	无需处理。发生场景：用户不支付了，点击取消，返回APP。
     */
    if ([resp isKindOfClass:[PayResp class]]) { // 微信支付
        
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case 0:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                break;
            default:
                NSLog(@"支付失败，retcode=%d  errormsg %@",resp.errCode ,resp.errStr);
                break;
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[EMClient sharedClient] applicationWillEnterForeground:application];
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];//进入前台取消应用消息图标
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark  应用打开时接收本地通知时触发
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSDictionary *userInfo=notification.userInfo;
    [userInfo writeToFile:@"/Users/kenshincui/Desktop/didReceiveLocalNotification.txt" atomically:YES];
    NSLog(@"didReceiveLocalNotification:The userInfo is %@",userInfo);
}

#pragma mark 调用过用户注册通知方法之后执行（也就是调用完registerUserNotificationSettings:方法之后执行）
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    if (notificationSettings.types!=UIUserNotificationTypeNone) {
//        [self addLocalNotification];
    }
}


//-(void)addLocalNotification{
//    //定义本地通知对象
//    UILocalNotification *notification=[[UILocalNotification alloc]init];
//    //设置调用时间
//    notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:1.0];//通知触发的时间，10s以后
//    notification.repeatInterval=1;//通知重复次数
//    //notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间//设置通知属性
//    notification.alertBody=@"最近添加了诸多有趣的特性，是否立即体验？";//通知主体
//    notification.applicationIconBadgeNumber=1;//应用程序图标右上角显示的消息数
//    notification.alertAction=@"打开应用"; //待机界面的滑动动作提示
//    notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
//    //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
//    notification.soundName=@"msg.caf";//通知声音（需要真机才能听到声音）
//    //设置用户信息
//    notification.userInfo=@{@"id":@1,@"user":@"Kenshin Cui"};//绑定到通知上的其他附加信息
//    //调用通知
//    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//}
#pragma mark 移除本地通知，在不需要此通知时记得移除
-(void)removeNotification{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}
@end
