//
//  ChatMessageCell.h
//  Chat
//
//  Created by qianfeng on 15/6/27.
//  Copyright (c) 2015年 ycp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatMessageCell : UITableViewCell

@property (weak,nonatomic) IBOutlet UIImageView *headImageView;
@property (weak,nonatomic) IBOutlet UILabel *messageTextLabel;

@end
