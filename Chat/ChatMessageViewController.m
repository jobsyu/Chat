//
//  ChatMessageViewController.m
//  Chat
//
//  Created by qianfeng on 15/6/27.
//  Copyright (c) 2015年 ycp. All rights reserved.
//

#import "ChatMessageViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "ChatMessageCell.h"

@interface ChatMessageViewController()<UITextFieldDelegate,NSFetchedResultsControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSFetchedResultsController *_fetchedResultsController;
}

@property (nonatomic,strong) IBOutlet NSLayoutConstraint *noInputTextConstraint;
@property (weak,nonatomic) IBOutlet UITableView *tableView;

//点击添加照片按钮
-(IBAction)clickAddPhoto;
@end

@implementation ChatMessageViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //1.利用通知中心监听键盘的变化（打开，关闭，中英文切换）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
    //2.初始化查询结果控制器
    [self setupFetchedResultsController];
}

-(void)setupFetchedResultsController
{
    //1.实例化数据存储上下文
    NSManagedObjectContext *context = [[xmppDelegate xmppMessageArchivingStorage] mainThreadManagedObjectContext];
    
    //2.定义查询请求
    NSFetchRequest *request =[NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    
    //3.定义排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    
    // 4. 定义查询条件(谓词，NSPredicate)
    // 查询来自与hello发给admin的消息
    WXLog(@"%@",[LoginUser sharedLoginUser].myJIDName);
    request.predicate = [NSPredicate predicateWithFormat:@"bareJidStr CONTAINS[cd] %@ AND streamBareJidStr CONTAINS[cd] %@",_bareJidStr,[LoginUser  sharedLoginUser].myJIDName];
    [request setSortDescriptors:@[sort]];
    
    //5.实例化查询控制器
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    //6.设置代理
    _fetchedResultsController.delegate =self;
    
    //7.执行查询
    NSError *error =nil;
    if (![_fetchedResultsController performFetch:&error]) {
        NSLog(@"查询数据出错 －%@",error.localizedDescription);
    } else {
        [self scrollToTableBottom];
    }
}

#pragma mark 查询结果控制器代理方法
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // 刷新表格
    [self.tableView reloadData];
    
    // 滚动到表格末尾
    [self scrollToTableBottom];
}

#pragma mark －键盘边框大小变化
-(void)keyboardChangeFrame:(NSNotification *)notification
{
    WXLog(@"%@",notification.userInfo);
    
    // 1. 获取键盘的目标位置
    NSDictionary *info = notification.userInfo;
    CGRect rect = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 2. 根据rect的orgion.y可以判断键盘是开启还是关闭
    if (rect.origin.y == [UIScreen mainScreen].bounds.size.height) {
//        //关闭键盘
//        NSArray *array = [self.view constraints];
//        if (![array containsObject:_noInputTextConstraint]) {
//            [self.view addConstraint:_noInputTextConstraint];
//        }
//        
//        if (![array containsObject:_englishInputConstraint]) {
//            [self.view addConstraint:_englishInputConstraint];
//        }
        _noInputTextConstraint.constant = 0.0;
    } else{
        //打开键盘或中英文切换
        //根据目标位置的高度判断键盘类型
//        if (rect.size.height == 216) {
//            // 英文键盘
//            // 删除没有键盘时，输入视图的约束
//            [self.view removeConstraint:_noInputTextConstraint];
//            // 判断英文约束是否存在，如果没有，重新添加
//            NSArray *array = [self.view constraints];
//            if (![array containsObject:_englishInputConstraint]) {
//                [self.view addConstraint:_englishInputConstraint];
//            }
//        } else if (rect.size.height == 252){
//            // 中文键盘
//            // 将两个约束都删除
//            [self.view removeConstraint:_noInputTextConstraint];
//            [self.view removeConstraint:_englishInputConstraint];
//        } else if (rect.size.height == 253){
//            // 中文键盘
//            // 将两个约束都删除
//            [self.view removeConstraint:_noInputTextConstraint];
//            [self.view removeConstraint:_englishInputConstraint];
//        }
        _noInputTextConstraint.constant = rect.size.height;
        
    }
    
    // 用自动布局系统实现动画，调整位置
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self scrollToTableBottom];
    }];
}

#pragma mark - UITextFieldDelegate代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //关闭键盘
    //[textField resignFirstResponder];
    //1.取出文本并截断空白字符串
    NSString *str = [textField.text trimString];
    
    //2.实例化xmppSendMessage,以便发送
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithString:_bareJidStr]];
    
    [message addBody:str];
    
    [[xmppDelegate xmppStream] sendElement:message];
    
    textField.text = nil;
    return YES;
}

#pragma mark - 表格操作
#pragma mark 滚动到表格末尾
-(void)scrollToTableBottom
{
    //要选中滚动到最末尾的记录
    //1.要知道所有的记录总数
    id <NSFetchedResultsSectionInfo> info = _fetchedResultsController.sections[0];
    NSInteger count  = [info numberOfObjects];
    
    if (count <= 0) {
        return;
    }
    
    // 2.根据行数实例化NSIndexPath
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:count - 1 inSection:0];
    // 3.选中并滚动到表格末尾
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
    
}

#pragma mark - UITableView 数据源方法
#pragma mark 表格行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> info = _fetchedResultsController.sections[section];
    return [info numberOfObjects];
}

#pragma mark 表格行
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *FromID = @"ChatFromCell";
    static NSString *ToID = @"ChatToCell";
    
    XMPPMessageArchiving_Message_CoreDataObject *message = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    ChatMessageCell *cell= nil;
    
    if (message.isOutgoing) {
        cell = [tableView dequeueReusableCellWithIdentifier:FromID];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:ToID];
    }
    
    // 设置单元格
    cell.detailTextLabel.text = message.body;
    
    if (message.isOutgoing) {
        cell.headImageView.image = _myImage;
    } else {
        cell.headImageView.image = _bareImage;
    }
    
    return cell;
}
@end
