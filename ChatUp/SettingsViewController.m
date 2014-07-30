//
//  SettingsViewController.m
//  ChatUp
//
//  Created by Rakshit Pithadia on 7/21/14.
//  Copyright (c) 2014 Rakshit Pithadia. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (strong, nonatomic) IBOutlet UISlider *ageSlider;
@property (strong, nonatomic) IBOutlet UISwitch *menSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *womenSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *singlesOnlySwitch;
@property (strong, nonatomic) IBOutlet UIButton *logoutButton;
@property (strong, nonatomic) IBOutlet UIButton *editProfileButton;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;

@end

@implementation SettingsViewController

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
    self.ageSlider.value = [[NSUserDefaults standardUserDefaults]integerForKey:kCCAgeMaxKey];
    self.menSwitch.on = [[NSUserDefaults standardUserDefaults]boolForKey:kCCMenEnabledKey];
    self.womenSwitch.on = [[NSUserDefaults standardUserDefaults]boolForKey:kCCWomenEnabledKey];
    self.singlesOnlySwitch.on = [[NSUserDefaults standardUserDefaults]boolForKey:kCCSingleEnabledKey];
    
    [self.ageSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.menSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.womenSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.singlesOnlySwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    self.ageLabel.text = [NSString stringWithFormat:@"%i",(int)self.ageSlider.value];
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
- (IBAction)logoutButtonPressed:(UIButton *)sender {
}

- (IBAction)editProfileButtonPressed:(UIButton *)sender {
}



@end
