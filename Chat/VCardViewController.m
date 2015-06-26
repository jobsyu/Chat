//
//  VCardViewController.m
//  Chat
//
//  Created by qianfeng on 15/6/26.
//  Copyright (c) 2015年 ycp. All rights reserved.
//

#import "VCardViewController.h"
#import "AppDelegate.h"

@interface VCardViewController()

-(IBAction)logout:(id)sender;

@end

@implementation VCardViewController

-(AppDelegate *)appDelegate
{
    return  [[UIApplication sharedApplication] delegate];
}

-(IBAction)logout:(id)sender
{
    [[self appDelegate] logout];
}

@end
