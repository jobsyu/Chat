//
//  EditVCardViewController.m
//  Chat
//
//  Created by qianfeng on 15/6/26.
//  Copyright (c) 2015年 ycp. All rights reserved.
//

#import "EditVCardViewController.h"
#import "AppDelegate.h"

@interface EditVCardViewController()<UITextFieldDelegate>

@property (nonatomic,weak) IBOutlet UITextField *contentText;

-(IBAction)save:(id)sender;
@end

@implementation EditVCardViewController


-(void)viewDidLoad
{
    //设置标题
    self.title = _contentTitle;
    //设置文本
    _contentText.text = _contentLabel.text;
    //设置文本框的焦点
    [_contentText becomeFirstResponder];
}

#pragma mark UITextFieldDelegate 代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self save:nil];
    
    return YES;
}

#pragma mark 保存
-(IBAction)save:(id)sender{
    _contentLabel.text = [_contentText.text trimString];
    
    [_delegate editVCardViewControllerDidFinished];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
