//
//  EmoteSelectorView.m
//  Chat
//
//  Created by qianfeng on 15/6/28.
//  Copyright (c) 2015年 ycp. All rights reserved.
//

#import "EmoteSelectorView.h"


static unichar emoteChars[28] = {
    0xe415, 0xe056, 0xe057, 0xe414, 0xe405, 0xe106, 0xe418,
    0xe417, 0xe40d, 0xe40a, 0xe404, 0xe105, 0xe409, 0xe40e,
    0xe402, 0xe108, 0xe403, 0xe058, 0xe407, 0xe401, 0xe416,
    0xe40c, 0xe406, 0xe413, 0xe411, 0xe412, 0xe410, 0xe059,
};

#define kRowCount 4
#define kColCount 7
#define kStartPoint CGPointMake(6, 20)
#define kButtonSize CGSizeMake(44, 44)

@implementation EmoteSelectorView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置背景颜色
        [self setBackgroundColor:[UIColor lightGrayColor]];
        
        // 使用一个临时数组
        NSMutableArray *array = [NSMutableArray array];
        
        //初始化届 main选择的表情
        for (NSInteger row = 0; row < kRowCount; row++) {
            for (NSInteger col = 0 ; col < kColCount; col++) {
                //1.计算按钮的索引（第几个按钮）
                NSInteger index = row * kColCount + col;
                
                //2. 创建按钮
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                CGFloat x = kStartPoint.x + col * kButtonSize.width;
                CGFloat y = kStartPoint.y + row * kButtonSize.height;
                [button setFrame:CGRectMake(x, y, kButtonSize.width, kButtonSize.height)];
                
                button.tag = index;
                // 添加按钮监听方法
                [button addTarget:self action:@selector(emoteClick:) forControlEvents:UIControlEventTouchUpInside];
                
                // 添加按钮到视图
                [self addSubview:button];
                
                // 添加按钮到临时数组
                [array addObject:button];
            }
        }
        
        // 遍历临时数组，设置按钮内容
        for (UIButton *button in array) {
            //最末尾的删除按钮 设置按钮的图像
            if (button.tag == 27) {
                UIImage *image = [UIImage imageNamed:@"DeleteEmoticonBtn"];
                UIImage *imageHL = [UIImage imageNamed:@"DeleteEmoticonBtnHL"];
                
                [button setImage:image forState:UIControlStateNormal];
                [button setImage:imageHL forState:UIControlStateHighlighted];
            }else {
                //设置其他按钮的文字
                NSString *emotoString = [self emoteStringwithIndex:button.tag];
                [button setTitle:emotoString forState:UIControlStateNormal];
            }
            
        }
    }
    return self;
}

#pragma mark 表情字符转化为字符串
- (NSString *)emoteStringwithIndex:(NSInteger)index{
    return [NSString stringWithFormat:@"%C",emoteChars[index]];
}

#pragma mark 表情按钮点击事情
-(void)emoteClick:(UIButton *)button
{
    NSString *emote = [self emoteStringwithIndex:button.tag];
    
    if (button.tag !=27) {
        //通知代理接受用户选择的表情字符串
        [_delegate EmoteSelectorViewSelectEmoteString:emote];
    } else {
        //通知代理处理删除字符功能
        [_delegate EmoteSelectorViewRemoveChar];
    }
}
@end
