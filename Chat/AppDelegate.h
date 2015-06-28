//
//  AppDelegate.h
//  Chat
//
//  Created by qianfeng on 15/6/24.
//  Copyright (c) 2015年 ycp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"

#define xmppDelegate (AppDelegate *)[[UIApplication sharedApplication] delegate]

typedef void(^CompletionBlock)();

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


#pragma mark - XMPP相关的属性和方法定义
/**
 *  全局的XMPPStream，只读属性
 */
@property (strong,nonatomic,readonly) XMPPStream *xmppStream;

/**
 *  全局的xmppvCard模块，只读属性
 */
@property (strong,nonatomic,readonly) XMPPvCardTempModule *xmppvCardTempModule;
/**
 *  全局的xmppvCardAvatar模块，只读属性
 */
@property (strong,nonatomic,readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;

/**
 *  全局的xmppRoster模块，只读属性
 */
@property (strong,nonatomic,readonly) XMPPRoster *xmppRoster;
/**
 *  全局的XMPPRosterCoreDataStorage模块，只读属性
 */
@property (strong,nonatomic,readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;

/**
 *  消息存档（归档）模块，只读属性
 */
@property (strong,nonatomic,readonly) XMPPMessageArchiving *xmppMessageArchiving;
@property (strong,nonatomic,readonly) XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingStorage;

/**
 *  是否注册用户标示
 */
@property (assign,nonatomic) BOOL isRegisterUser;


/**
 *  连接到服务器
 *
 *  注释：用户信息保存在系统偏好中
 *
 *  @param completion 连接正确的块代码
 *  @param faild      连接错误的块代码
 */
-(void)connectionWithCompletion:(CompletionBlock)completion failed:(CompletionBlock)faild;

/**
 *  注销用户登录
 */
-(void)logout;

@end
