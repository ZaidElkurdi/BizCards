//
//  detailViewController.m
//  Mitek Hackathon
//
//  Created by Zaid Elkurdi on 4/25/14.
//  Copyright (c) 2014 Tempest Vision. All rights reserved.
//

#import "detailViewController.h"

@interface detailViewController ()
{
    UIActionSheet *phonePicker;
    NSString *fullName;
}
@end

@implementation detailViewController
@synthesize cardData;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    NSLog(@"Creating detail view");
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    cardData = [[NSDictionary alloc] initWithDictionary:[prefs objectForKey:@"cardData"]];
    
    NSLog(@"Name Data: %@", [cardData objectForKey:@"Name"]);
    
    /* Init Nav Bar */
    UIColor *barColor = [UIColor colorWithRed:29.0f/255.0f green:143.0f/255.0f blue:102.0f/255.0f alpha: 1.0];
    
    self.navigationController.navigationBar.frame = CGRectMake(0, 0, 320, 40);
    self.navigationController.navigationBar.barTintColor=barColor;
    NSLog(@"Nav bar: %@", self.navigationController.navigationBar);
    
    
    self.phoneNumbers = [self.cardData objectForKey:@"phoneNumbers"];
    self.emailAddresses = [self.cardData objectForKey:@"emailAddresses"];
    fullName = [self.cardData objectForKey:@"fullName"];
    self.position = [self.cardData objectForKey:@"position"];
    self.uniqueID = [self.cardData objectForKey:@"uniqueID"];
    self.linkedInID = [self.cardData objectForKey:@"linkedInID"];
    
    profileImageView.layer.borderWidth = 3.0f;
    profileImageView.layer.borderColor =[UIColor whiteColor].CGColor;
    profileImageView.layer.masksToBounds = NO;
    profileImageView.clipsToBounds = YES;
    profileImageView.layer.cornerRadius=70;
    
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    navTitle.text = fullName;
    NSLog(@"name: %@",self.fullName);
    navTitle.textColor = [UIColor whiteColor];
    UIFont *navFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:28.0];
    navTitle.font = navFont;
    navTitle.textAlignment = NSTextAlignmentCenter;
    [self.navigationController.navigationBar addSubview:navTitle];
    
    positionLabel.text = self.position;
    
}

-(UIStatusBarStyle)preferredStatusBarStyle
{ 
    return UIStatusBarStyleLightContent; 
}

-(void)viewWillAppear:(BOOL)animated
{

    /* Init instance variables */
 
    


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Buttons
-(void)didTapPhone
{
    if([self.phoneNumbers count]==0)
    {
        UIAlertView *noPhone = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"You don't have a phone number for this person." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [noPhone show];
    }
    
    else if([self.phoneNumbers count] == 1)
    {
        NSString *phoneNo = [self.phoneNumbers objectAtIndex:0];
        [self makeCall:phoneNo];
    }
    
    else if([self.phoneNumbers count] > 1)
    {
        phonePicker = [[UIActionSheet alloc] initWithTitle:@"Which number?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        
        for(NSString *number in self.phoneNumbers)
            [phonePicker addButtonWithTitle:number];
        
        [phonePicker showInView:self.view];
    }
    
    
}

-(void)didTapLinkedIn
{
    if(self.linkedInID != NULL)
    {
        NSString *rawURL = [NSString stringWithFormat:@"http://www.linkedin.com/profile/view?id=%@", self.linkedInID];
        
        NSURL *url = [NSURL URLWithString:rawURL];
        
        [[UIApplication sharedApplication] openURL:url];
    }
    
    else
    {
        UIAlertView *noIDAlert =  [[UIAlertView alloc] initWithTitle:@"Error!" message:@"This person does not have a LinkedIn account set." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [noIDAlert show];
    }
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
-(void)didTapShare
{
    NSArray *activityItems = @[@"hi", @"bro"];

    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypePostToWeibo];
    [self presentViewController:activityVC animated:TRUE completion:nil];
   
}

-(void)makeCall:(NSString*)phoneNo
{
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"tel:%@",phoneNo]];
    [[UIApplication sharedApplication] openURL:phoneUrl];
}

#pragma -mark Delegates/Data Sources

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView dismissWithClickedButtonIndex:1 animated:YES];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    NSString *phoneNo = [phonePicker buttonTitleAtIndex:buttonIndex];
    [self makeCall:phoneNo];
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
