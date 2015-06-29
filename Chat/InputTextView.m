//
//  InputTextView.m
//  Chat
//
//  Created by qianfeng on 15/6/28.
//  Copyright (c) 2015年 ycp. All rights reserved.
//

#import "InputTextView.h"
#import "EmoteSelectorView.h"

@interface InputTextView () <EmoteSelectorViewDelegate>

//表情选择视图
@property (strong,nonatomic) EmoteSelectorView *emoteView;

// 输入文本
@property (weak,nonatomic) IBOutlet UITextField *inputText;
//录音按钮
@property (weak,nonatomic) IBOutlet UIButton *recorderButton;

@property (weak,nonatomic) IBOutlet UIButton *voiceButton;

//点击声音切换按钮
-(IBAction)clickVoice:(UIButton *)button;
//点击表情切换按钮
-(IBAction)clickEmote:(UIButton *)button;
@end

@implementation InputTextView


-(void)awakeFromNib
{
    // 设置录音按钮的背景图片拉伸效果
    UIImage *image = [UIImage  imageNamed:@"VoiceBtn_Black"];
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.6 topCapHeight:image.size.height *0.6];
    
    UIImage *imageHL = [UIImage imageNamed:@"VoiceBtn_BlackHL"];
    imageHL = [imageHL stretchableImageWithLeftCapWidth:imageHL.size.width * 0.5 topCapHeight:imageHL.size.height * 0.5];
    
    [_recorderButton setBackgroundImage:image forState:UIControlStateNormal];
    [_recorderButton setBackgroundImage:imageHL forState:UIControlStateHighlighted];
    
    //实例化表情选择视图
    _emoteView = [[EmoteSelectorView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    _emoteView.delegate = self;
}


#pragma mark 显示按钮，设置按钮
-(void)setBtn:(UIButton *)button image:(NSString *)imageBtn imageHL:(NSString *)imageHLBtn
{
    UIImage *image = [UIImage imageNamed:imageBtn];
    UIImage *imageHL = [UIImage imageNamed:imageHLBtn];
    
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:imageHL forState:UIControlStateHighlighted];
}

//点击声音切换按钮
-(IBAction)clickVoice:(UIButton *)button{
    //1.设置按钮的tag
    button.tag = !button.tag;
    //2.显示录音按钮
    _recorderButton.hidden = !button.tag;
    //3.隐藏文本输入框
    _inputText.hidden = button.tag;
    
    //判断当前输入状态，如果是文本输入，显示录音按钮，隐藏键盘
    if (button.tag) {
        //1)隐藏键盘
        [_inputText resignFirstResponder];
        
        //2)切换按钮, 显示录音按钮
        [self setBtn:button image:@"ToolViewInputText" imageHL:@"ToolViewInputTextHL"];
    } else {
        //1)显示文本输入框
        [self setBtn:button image:@"ToolViewInputVoice" imageHL:@"ToolViewInputVoiceHL"];
        
        //2)显示键盘
        [_inputText becomeFirstResponder];
    }
}

//点击表情切换按钮
-(IBAction)clickEmote:(UIButton *)button{
    //1.如果当前正在录音,需要切换到文本状态
    if (!_recorderButton.hidden) {
        [self clickVoice:_voiceButton];
    }
    
    // 2.判断当前按钮的状态，如果是输入文本，替换输入视图（选择表情）
    //设置按钮的tag
    button.tag = !button.tag;
    
    //2)激活键盘
    [_inputText becomeFirstResponder];
    
    if (button.tag) {
        //2)显示表情选择视图
        [_inputText setInputView:_emoteView];
        
        //2)切换按钮图标，显示键盘选择图像
        [self setBtn:button image:@"ToolViewEmotion" imageHL:@"ToolViewEmotionHL"];
    } else {
        //1)显示系统默认键盘
        [_inputText setInputView:nil];
        
        //2)切换按钮图标，显示表情选择图像
        [self setBtn:button image:@"ToolViewInputText" imageHL:@"ToolViewInputTextHL"];
    }
    
    // 2.刷新键盘的输入视图
    [_inputText reloadInputViews];
}

#pragma mark 选中表情
//拼接字符串
-(void)EmoteSelectorViewSelectEmoteString:(NSString *)Emote
{
    //拼接现有文本
    // 1.取出文本
    NSMutableString *strM = [NSMutableString stringWithString:_inputText.text];
    
    // 2.拼接字符串
    [strM appendString:Emote];
    
    // 3.设置文本
    _inputText.text = strM;
}

//删除字符串
-(void)EmoteSelectorViewRemoveChar
{
    //1.当文本框不为空时，不执行删除
    
    if (_inputText.text.length > 0) {
        //1.取出文本
        NSString *str = _inputText.text;
        //    NSRange range = NSRangeFromString(_inputText.text);
        //    NSString *inputString = [_inputText.text substringToIndex:range.length -1];
        
        //2.删除最末尾的字符
        _inputText.text = [str substringToIndex:(str.length - 1)];
    }
}
@end
