//
//  ChatViewController.m
//  ChatUp
//
//  Created by Rakshit Pithadia on 7/30/14.
//  Copyright (c) 2014 Rakshit Pithadia. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()

@property (strong, nonatomic) PFUser *withUser;

@property (strong, nonatomic) PFUser *currentUser;

@property (strong, nonatomic) NSTimer *chatsTimer;

@property (nonatomic) BOOL initialLoadComplete;

@property (strong, nonatomic) NSMutableArray *chats;

@end

@implementation ChatViewController

//Lazy initialization
-(NSMutableArray *)chats
{
    if (!_chats){
        _chats = [[NSMutableArray alloc] init];
    }
    return _chats;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
    
    self.dataSource = self;
    
    [[JSBubbleView appearance] setFont:[UIFont systemFontOfSize:16.0f]];
    
    self.messageInputView.textView.placeHolder = @"New Message";
    
    [self setBackgroundColor:[UIColor whiteColor]];
    
    self.currentUser = [PFUser currentUser];
    
    PFUser *testUser1 = self.chatRoom[@"user1"];
    
    if ([testUser1.objectId isEqual:self.currentUser.objectId]){
        
    self.withUser = self.chatRoom[@"user2"];
    }
    
    else {
        
        self.withUser = self.chatRoom[@"user1"];
        
    }
    
    self.title = self.withUser[@"profile"][@"firstName"];
    
    self.initialLoadComplete = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.chats count];
}

#pragma mark - TableView Delegate

-(void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date
{
    if (text.length != 0) {
        PFObject *chat = [PFObject objectWithClassName:@"Chat"];

        [chat setObject:self.chatRoom forKey:@"chatroom"];
        
        [chat setObject:[PFUser currentUser] forKey:@"fromUser"];
        
        [chat setObject:self.withUser forKey:@"toUser"];
        
        [chat setObject:text forKey:@"text"];
        
        [chat saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            NSLog(@"save complete");
            
            [self.chats addObject:chat];
            
            [JSMessageSoundEffect playMessageSentSound];
            
            [self.tableView reloadData];
            
            [self finishSend];
            
            [self scrollToBottomAnimated:YES];
            
        }];
        
    }
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath

{
    /* If we are doing the sending return JSBubbleMessageTypeOutgoing
     
     else JSBubbleMessageTypeIncoming
     
     */
    PFObject *chat = self.chats[indexPath.row];
    PFUser *currentUser = [PFUser currentUser];
    PFUser *testFromUser = chat[@"fromUser"];
    if ([testFromUser.objectId isEqual:currentUser.objectId])
    {
        return JSBubbleMessageTypeOutgoing;
    }
    else{
        return JSBubbleMessageTypeIncoming;
    }
}

- (UIImageView *)bubbleImageViewWithType:(JSBubbleMessageType)type forRowAtIndexPath:(NSIndexPath *)indexPath

{
    PFObject *chat = self.chats[indexPath.row];
    PFUser *currentUser = [PFUser currentUser];
    PFUser *testFromUser = chat[@"fromUser"];
    if ([testFromUser.objectId isEqual:currentUser.objectId])
    {
        return [JSBubbleImageViewFactory bubbleImageViewForType:type color:[UIColor js_bubbleGreenColor]];
    }
    else{
        return [JSBubbleImageViewFactory bubbleImageViewForType:type color:[UIColor js_bubbleLightGrayColor]];
    }
}

//
//- (JSMessagesViewTimestampPolicy)timestampPolicy
//
//{
//    
//    return JSMessagesViewTimestampPolicyAll
//    
//    ;
//    
//}
//
//- (JSMessagesViewAvatarPolicy)avatarPolicy
//
//{
//    
//    /* JSMessagesViewAvatarPolicyNone */
//    
//    return JSMessagesViewAvatarPolicyAll;
//    
//}
//
//- (JSMessagesViewSubtitlePolicy)subtitlePolicy
//
//{
//    
//    return JSMessagesViewSubtitlePolicyAll;
//    
//}

- (JSMessageInputViewStyle)inputViewStyle

{
    
    /* change style */
    
    return JSMessageInputViewStyleFlat;
    
}

#pragma mark - Messages View delegate optional

-(void)configureCell:(JSBubbleMessageCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if ([cell messageType] == JSBubbleMessageTypeOutgoing) {
        cell.bubbleView.textView.textColor = [UIColor whiteColor];
    }
}

- (BOOL)shouldPreventScrollToBottomWhileUserScrolling

{
    return YES;
}

#pragma mark - Messages view data source: REQUIRED

- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *chat = self.chats[indexPath.row];
    NSString *message = chat[@"text"];
    return message;
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (UIImageView *)avatarImageViewForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSString *)subtitleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - Helper Methods

-(void)checkForNewChats
{
    int oldChatCount = [self.chats count];
    PFQuery *queryForChats = [PFQuery queryWithClassName:@"Chat"];
    [queryForChats whereKey:@"chatroom" equalTo:self.chatRoom];
    [queryForChats orderByAscending:@"createdAt"];
    [queryForChats findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (self.initialLoadComplete == NO || oldChatCount != [objects count]){
                self.chats = [objects mutableCopy];
                if (self.initialLoadComplete == YES){
                    [JSMessageSoundEffect playMessageReceivedSound];
                }
                [self.tableView reloadData];
                self.initialLoadComplete = YES;
                [JSMessageSoundEffect playMessageReceivedSound];
                [self scrollToBottomAnimated:YES];
            }
        }
    }];
}


@end
