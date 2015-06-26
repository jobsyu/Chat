//
//  LoginUser.m
//  Chat
//
//  Created by qianfeng on 15/6/25.
//  Copyright (c) 2015年 ycp. All rights reserved.
//

#import "LoginUser.h"


#define kXMPPUserNameKey @"xmppUserName"
#define kXMPPPasswordKey @"xmppPassword"
#define kXMPPHostNameKey @"xmppHostName"

static NSString *xmppHostIP = @"192.168.84.112";

@implementation LoginUser
single_implementation(LoginUser)

#pragma mark －私有方法
//从系统偏好里面加载数据
-(NSString *)loadStringFromDefaultsWithKey:(NSString *)key
{
    NSString *str = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    return (str) ? str : @"";
}

#pragma mark -getter & setter
-(NSString *)userName
{
    return [self loadStringFromDefaultsWithKey:kXMPPUserNameKey];
}

-(void)setUserName:(NSString *)userName
{
    [userName saveToNSDefaultsWithKey:kXMPPUserNameKey];
}

-(NSString *)password
{
    return [self loadStringFromDefaultsWithKey:kXMPPPasswordKey];
}

-(void)setPassword:(NSString *)password
{
    [password saveToNSDefaultsWithKey:kXMPPPasswordKey];
}

-(NSString *)hostName
{
    return [self loadStringFromDefaultsWithKey:kXMPPHostNameKey];
}

-(void)setHostName:(NSString *)hostName
{
    [hostName saveToNSDefaultsWithKey:kXMPPHostNameKey];
}

-(NSString *)myJIDName
{
    //return [NSString stringWithFormat:@"%@@%@",[[NSUserDefaults standardUserDefaults] stringForKey:kXMPPUserNameKey],[[NSUserDefaults standardUserDefaults] stringForKey:kXMPPHostNameKey]];
    return [NSString stringWithFormat:@"%@@%@",self.userName,self.hostName];
}

@end
