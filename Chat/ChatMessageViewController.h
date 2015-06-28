//
//  ChatMessageViewController.h
//  Chat
//
//  Created by qianfeng on 15/6/27.
//  Copyright (c) 2015年 ycp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatMessageViewController : UIViewController
// 对话方JID
@property (strong,nonatomic) NSString *bareJidStr;
// 对话方头像
@property (strong,nonatomic) UIImage *bareImage;
// 我的头像
@property (strong,nonatomic) UIImage *myImage;
@end
