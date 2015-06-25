//
//  NSString+Helper.m
//  Chat
//
//  Created by qianfeng on 15/6/24.
//  Copyright (c) 2015年 ycp. All rights reserved.
//

#import "NSString+Helper.h"

@implementation NSString (Helper)

#pragma mark  清空字符串中的空白字符
-(NSString *)trimString
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


#pragma  mark 是否空字符串
-(BOOL)isEmptyString
{
    return (self == nil || self.length == 0);
}

#pragma mark 返回沙盒中的文件路径
-(NSString *)documentsPath
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [path stringByAppendingString:self];
}

#pragma mark 写入系统偏好
-(void)saveToNSDefaultsWithKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:self forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
