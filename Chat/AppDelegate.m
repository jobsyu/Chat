//
//  AppDelegate.m
//  Chat
//
//  Created by qianfeng on 15/6/24.
//  Copyright (c) 2015年 ycp. All rights reserved.
//

#import "AppDelegate.h"

/**
 *  XMPP的特点，所有的请求都是通过代理的方式实现的。
 *
 *  因为XMPP是经由网络服务器进行数据通讯的，因此所有的请求都是提交给服务器处理，
 *
 *  服务器处理完毕之后，以代理的方式告诉客户端处理结果。
 *
 *  官方推荐在AppDelegate中处理所有来自XMPP服务器的代理响应。
 *
 *  用户注册的流程
 *  1.  使用myJID连接到hostName指定服务器
 *  2.  连接成功后，使用用户密码，注册新用户
 *  3.  在代理方法中判断用户是否注册成功
 */

// 提示，此处不遵守XMPPStreamDelegate协议，程序仍然能够正常运行
// 但是如果遵守了协议，可以方便编写代码
@interface AppDelegate () <XMPPStreamDelegate>
{
    CompletionBlock  _completionBlock;    //成功的块代码
    CompletionBlock _faildBlock;          //失败的块代码
}

/**
 *  设置XMPPStream
 */
-(void)setupStream;

/**
 *  通知服务器用户上线
 */
-(void)goOnline;

/**
 *  通知服务器用户下线
 */
-(void)goOffline;

/**
 *  连接到服务器
 */
-(void)connect;

/**
 *  与服务器断开连接
 */
-(void)disConnect;

@end

@implementation AppDelegate

#pragma mark - 通知中心
#pragma mark 注册通知中心监控用户登录状态
-(void)registerNotification
{
    NSNotificationCenter *center  = [NSNotificationCenter defaultCenter];
    /*
     参数说明
     1. 通知中心的监听者
     2. 发生通知时，调用的选择器方法
     3. 发生的通知名称
     4. 传递给选择器方法的对象
     */
    [center addObserver:self selector:@selector(loginStateChanged) name:kNotificationUserLoginState object:nil];

}

#pragma mark 用户登录状态变化（登录，注销）
-(void)loginStateChanged
{
    UIStoryboard *storyboard = nil;
    
    if (self.isUserLogin) {
        //显示Main.storyboard
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    }
    
    //把Storyboard的初始视图控制器设置为window的rootViewController
    [self.window setRootViewController:storyboard.instantiateInitialViewController];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self registerNotification];
    // Override point for customization after application launch.
    return YES;
}

-(void)applicationWillResignActive:(UIApplication *)application
{
    [self disConnect];
}

-(void)dealloc
{
 
}


#pragma mark - XMPP相关方法
#pragma mark 设置XMPPStream
-(void)setupStream
{
    //避免_xmppStream被重复实例化
    if (_xmppStream == nil) {
        // 1. 实例化XMPPStream
        _xmppStream = [[XMPPStream alloc] init];
        // 2. 添加代理
        // 因为所有网络请求都是做基于网络的数据处理，跟界面UI无关，因此可以让代理方法在其他线城中执行
        // 从而提高程序的运行性能
        [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
}


#pragma mark 通知服务器用户上线
-(void)goOnline
{
    //1.实例化一个“展现”，上线的报告
    XMPPPresence *presence = [XMPPPresence presence];
    // 2. 发送Presence给服务器
    // 服务器知道“我”上线后，只需要通知我的好友，而无需通知我，因此，此方法没有回调
    [_xmppStream sendElement:presence];
}

#pragma mark 通知服务器用户下线
-(void)goOffline
{
    NSLog(@"用户下线");
    
    // 1. 实例化一个”展现“，下线的报告
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    // 2. 发送Presence给服务器，通知服务器客户端下线
    [_xmppStream sendElement:presence];
}

#pragma mark 连接
-(void)connect
{
    // 1. 设置XMPPStream
    [self setupStream];
    
    // 2. 指定用户名，主机（服务器），连接时不需要password
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *hostName = [defaults stringForKey:kXMPPHostNameKey];
    NSString *userName = [NSString stringWithFormat:@"%@@%@",[defaults stringForKey:kXMPPUserNameKey],[defaults stringForKey:kXMPPHostNameKey]];
    
    // 3. 设置XMPPStream的JID和主机
    [_xmppStream setMyJID:[XMPPJID jidWithString:userName]];
    [_xmppStream setHostName:hostName];
    
    // 4. 开始连接
    NSError *error = nil;
    [_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    
    // 提示：如果没有指定JID和hostName，才会出错，其他都不出错。
    if (error) {
        NSLog(@"连接请求发送出错 －%@",error);
    } else {
        NSLog(@"连接请求发送成功！");
    }
}


#pragma mark 连接到服务器
-(void)connectionWithCompletion:(CompletionBlock)completion failed:(CompletionBlock)faild
{
    // 1.记录块代码
    _completionBlock = completion;
    _faildBlock = faild;
    
    // 2.如果已经存在连接，先断开连接，然后再次连接
    if ([_xmppStream isConnected]) {
        [_xmppStream disconnect];
    }
    
    // 3.连接到服务器
    [self connect];
}

#pragma mark 断开连接
-(void)disConnect
{
    // 1. 通知服务器下线
    [self goOffline];
    // 2. XMPPStream断开连接
    [_xmppStream disconnect];
}


#pragma mark - 代理方法
#pragma mark 连接完成（如果服务器地址不对，就不会调用此方法）
-(void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"连接建立");
    
    //从系统偏好读取用户密码
    NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPPasswordKey];
    
    if (self.isRegisterUser) {
        // 用户注册，发送注册请求
        [_xmppStream  registerWithPassword:password error:nil];
    } else {
        // 用户登录，发送身份验证请求
        [_xmppStream authenticateWithPassword:password error:nil];
    }
}

#pragma mark 注册成功
-(void)xmppStreamDidRegister:(XMPPStream *)sender
{
     self.isRegisterUser = NO;
    
    // 提示：以为紧接着会再次发送验证请求，验证用户登录
    // 而在验证通过后，会执行_completionBlock块代码，
    // 因此，此处不应该执行_completionBlock
    //    if (_completionBlock != nil) {
    //        _completionBlock();
    //    }
    [self xmppStreamDidConnect:_xmppStream];
}

#pragma mark 注册失败(用户名已经存在)
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    self.isRegisterUser = NO;
    if (_faildBlock != nil) {
        _faildBlock();
    }
}

#pragma mark 身份验证通过
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    _isUserLogin = YES;
    
    if (_completionBlock != nil) {
        _completionBlock();
    }
    // 通知服务器用户上线
    [self goOnline];
}

#pragma mark 密码错误，身份验证失败
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    if (_faildBlock != nil) {
        _faildBlock();
    }
}

@end