//
//  linkedInViewController.m
//  Mitek Hackathon
//
//  Created by Aryaman Sharda on 4/26/14.
//  Copyright (c) 2014 Tempest Vision. All rights reserved.
//

#import "linkedInViewController.h"

@interface linkedInViewController ()

@end

@implementation linkedInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary *person = [prefs objectForKey:@"rawLinkedIn"];
    NSString *firstName = [person objectForKey:@"firstName"];
    NSString *lastName =[person  objectForKey:@"lastName"];
    NSString *headlineText =[person objectForKey:@"headline"];
    
    name.text = [NSString stringWithFormat:@"Is this %@ %@?", firstName, lastName];
    headline.text = headlineText;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)pressedNo
{
    [self performSegueWithIdentifier:@"goHomePlease" sender:nil];
}

-(IBAction)pressedYes
{
    [self performSegueWithIdentifier:@"goHomePlease" sender:nil];
}

-(IBAction)pressedConnect
{
    [self performSegueWithIdentifier:@"goHomePlease" sender:nil];
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

@end
