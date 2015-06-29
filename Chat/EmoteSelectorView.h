//
//  EmoteSelectorView.h
//  Chat
//
//  Created by qianfeng on 15/6/28.
//  Copyright (c) 2015年 ycp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EmoteSelectorViewDelegate <NSObject>

//选择表情
-(void)EmoteSelectorViewSelectEmoteString:(NSString *)Emote;

//删除字符
-(void)EmoteSelectorViewRemoveChar;
@end

@interface EmoteSelectorView : UIView

@property (nonatomic,weak) id<EmoteSelectorViewDelegate> delegate;

@end
