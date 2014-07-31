//
//  MatchesViewController.m
//  ChatUp
//
//  Created by Rakshit Pithadia on 7/30/14.
//  Copyright (c) 2014 Rakshit Pithadia. All rights reserved.
//

#import "MatchesViewController.h"

@interface MatchesViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *availableChatRooms;

@end

@implementation MatchesViewController

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

#pragma mark - Helper Methods

-(void)updateAvailableChatRooms
{
    PFQuery *query = [PFQuery queryWithClassName:@"ChatRoom"];
    [query whereKey:@"user1" equalTo:[PFUser currentUser]];
    PFQuery *queryInverse = [PFQuery queryWithClassName:@"ChatRoom"];
    [queryInverse whereKey:@"user2" equalTo:[PFUser currentUser]];
    
    PFQuery *combinedQuery = [PFQuery orQueryWithSubqueries:@[query,queryInverse]];
    [combinedQuery includeKey:@"chat"];
    [combinedQuery includeKey:@"user1"];
    [combinedQuery includeKey:@"user2"];
    [combinedQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self.availableChatRooms removeAllObjects];
            self.availableChatRooms = [objects mutableCopy];
            [self.tableView reloadData];
        }
    }];
}


@end
