//
//  ChatMessageCell.m
//  Chat
//
//  Created by qianfeng on 15/6/27.
//  Copyright (c) 2015年 ycp. All rights reserved.
//

#import "ChatMessageCell.h"


@interface ChatMessageCell()
{
    UIImage *_sendMessageImage;
    UIImage *_sendMessageImageHL;
    UIImage *_receiveMessageImage;
    UIImage *_receiveMessageImageHL;
}

@end

@implementation ChatMessageCell

-(UIImage *)stretcheImage:(UIImage *)img
{
    return [img stretchableImageWithLeftCapWidth:img.size.width * 0.6 topCapHeight:img.size.height * 0.5];
}

-(void)awakeFromNib
{
    //实例化表格行的图像
    _sendMessageImage = [UIImage imageNamed:@"SenderTextNodeBkg"];
    _sendMessageImageHL = [UIImage imageNamed:@"SenderTextNodeBkgHL"];
    _receiveMessageImage = [UIImage imageNamed:@"ReceiverTextNodeBkg"];
    _receiveMessageImageHL = [UIImage imageNamed:@"ReceiverTextNodeBkgHL"];
    
    // 处理图像拉伸（因为iOS 6不支持图像切片）
    _sendMessageImage = [self stretcheImage:_sendMessageImage];
    _sendMessageImageHL = [self stretcheImage:_sendMessageImageHL];
    _receiveMessageImage = [self stretcheImage:_receiveMessageImage];
    _receiveMessageImageHL = [self stretcheImage:_receiveMessageImageHL];
}

-(void)setMessage:(XMPPMessageArchiving_Message_CoreDataObject *)message isOutgoing:(BOOL)isOutgoing
{
    // 1. 根据isOutgoing判断消息是发送还是接受，依次来设置按钮的背景图片
    if (isOutgoing) {
        [_messageButton setBackgroundImage:_sendMessageImage forState:UIControlStateNormal];
        [_messageButton setBackgroundImage:_sendMessageImageHL forState:UIControlStateHighlighted];
    } else {
        [_messageButton setBackgroundImage:_receiveMessageImage forState:UIControlStateNormal];
        [_messageButton setBackgroundImage:_receiveMessageImageHL forState:UIControlStateHighlighted];
    }
    
    
    //2.设置按钮文字
    //2.1 计算文本占用的空间
    CGSize size = [message.body sizeWithFont:[UIFont systemFontOfSize:14]];
    
    //计算文本占用的空间设置约束
    _messageHeightConstraint.constant = size.height + 40;
    _messageWidthConstraint.constant = size.width + 30;
    
    //设置按钮文字
    //XMPPMessage *xmppMsg = message.message;
//    WXLog(@"%@",[xmppMsg attributeStringValueForName:@"bodyType"]);
//    WXLog(@"%@",message.body);
    //UIImage *imager= nil;
    
//    if ([message.body isEqual:@"image"] && [[xmppMsg attributeStringValueForName:@"bodyType"] isEqual:@"image"]) {
//        NSArray *child = xmppMsg.children;
//        for (XMPPElement *node in child) {
//            if([[node name] isEqualToString:@"attachment"]){
//                NSString *base64 = [node stringValue];
//                NSData *imageData = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
//                imager = [UIImage imageWithData:imageData];
//            }
//        }
////        if (isOutgoing) {
////            [_messageButton setImage:imager forState:UIControlStateNormal];
////        } else {
////            [_messageButton setImage:imager forState:UIControlStateNormal];
////        }
//        
//        
//    } else {
    
        [_messageButton setTitle:message.body forState:UIControlStateNormal];
        
    //}
    
    //重新调整布局
    [self layoutIfNeeded];
    
}

@end
