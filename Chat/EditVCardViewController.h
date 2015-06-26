//
//  EditVCardViewController.h
//  Chat
//
//  Created by qianfeng on 15/6/26.
//  Copyright (c) 2015年 ycp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditVCardViewControllerDelegate <NSObject>

-(void)editVCardViewControllerDidFinished;

@end
@interface EditVCardViewController : UIViewController

@property (nonatomic,weak) id<EditVCardViewControllerDelegate> delegate;

@property (nonatomic,strong) NSString *contentTitle;
@property (nonatomic,weak) UILabel  *contentLabel;

@end
