//
//  LoginViewController.m
//  ChatUp
//
//  Created by Rakshit Pithadia on 6/19/14.
//  Copyright (c) 2014 Rakshit Pithadia. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation LoginViewController

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
    self.activityIndicator.hidden = YES;
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

#pragma mark - IBActions
- (IBAction)loginButtonPressed:(UIButton *)sender {
    
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    //These are Facebook inbuilt requests
    NSArray *permissionsArray = @[@"user_about_me",@"user_interests",@"user_relationships",@"user_birthday",@"user_location",@"user_relationship_details"];
    
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
        if (!user) {
            if (!error) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Login Error" message:@"The Facebook login was cancelled" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                [alertView show];
            }else{
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Login Error" message:[error description] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil , nil];
                [alertView show];
            }
        }else{
            [self performSegueWithIdentifier:@"loginToTabBarSegue" sender:self];
        }
        
    }];
    
}


@end
