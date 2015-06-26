//
//  LoginUser.h
//  Chat
//
//  Created by qianfeng on 15/6/25.
//  Copyright (c) 2015年 ycp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface LoginUser : NSObject

single_interface(LoginUser)
/**
 *  用户名
 */
@property (strong,nonatomic) NSString *userName;
/**
 *  用户密码
 */
@property (strong,nonatomic) NSString *password;
/**
 *  主机名
 */
@property (strong,nonatomic) NSString *hostName;

/**
 *  jid
 */
@property (strong,nonatomic,readonly) NSString *myJIDName;

@end
