//
//  ChatViewController.h
//  ChatUp
//
//  Created by Rakshit Pithadia on 7/30/14.
//  Copyright (c) 2014 Rakshit Pithadia. All rights reserved.
//

#import "JSMessagesViewController.h"

@interface ChatViewController : JSMessagesViewController <JSMessagesViewDataSource, JSMessagesViewDelegate>

@property (strong, nonatomic) PFObject *chatRoom;

@end
