//
//  ViewController.m
//  Chat
//
//  Created by qianfeng on 15/6/24.
//  Copyright (c) 2015年 ycp. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"


@interface LoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *hostNameText;

@end

@implementation LoginViewController

#pragma mark - AppDelegate的助手方法
-(AppDelegate *)appDelegate
{
    return [[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _userNameText.text = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPUserNameKey];
    _hostNameText.text = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPHostNameKey];
}

#pragma mark UITextField代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _userNameText) {
        [_passwordText becomeFirstResponder];
    } else if (textField == _passwordText){
        [_hostNameText becomeFirstResponder];
    } else {
        [self userLoginAndRegister:nil];
    }
    
    return YES;
}


- (IBAction)userLoginAndRegister:(UIButton *)button {
    // 1. 检查用户输入是否完整，在商业软件中，处理用户输入时
    // 通常会截断字符串前后的空格（密码除外），从而可以最大程度地降低用户输入错误
    
    NSString *userName = [_userNameText.text trimString];
    // 用些用户会使用空格做密码，因此密码不能去除空白字符
    NSString *password = _passwordText.text;
    NSString *hostName = [_hostNameText.text trimString];
    
    if ([userName isEmptyString] ||
        [password isEmptyString] ||
        [hostName isEmptyString]) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录信息不完整" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        
        return;
    }
    
    //2.将用户信息登录信息写入系统偏好
    [userName saveToNSDefaultsWithKey:kXMPPUserNameKey];
    [password saveToNSDefaultsWithKey:kXMPPPasswordKey];
    [hostName saveToNSDefaultsWithKey:kXMPPHostNameKey];
    
    //3.让AppDelegate开始连接
    //告诉AppDelegate，当前是注册用户
    NSString *actionName = nil;
    
    if (button.tag == 1) {
        [self appDelegate].isRegisterUser = YES;
        actionName = @"注册用户";
    } else {
        actionName = @"用户登录";
    }
    
    [[self appDelegate] connectionWithCompletion:^{
        NSLog(@"%@成功！",actionName);
        
        //[]
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserLoginState object:nil];
    }failed:^{
        NSLog(@"%@失败！",actionName);
    }];
}
@end
