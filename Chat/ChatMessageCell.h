//
//  ChatMessageCell.h
//  Chat
//
//  Created by qianfeng on 15/6/27.
//  Copyright (c) 2015年 ycp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ChatMessageCell : UITableViewCell

@property (weak,nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageWidthConstraint;

-(void)setMessage:(XMPPMessageArchiving_Message_CoreDataObject *)message isOutgoing:(BOOL)isOutgoing;
@end
