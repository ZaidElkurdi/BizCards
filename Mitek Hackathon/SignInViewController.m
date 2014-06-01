//
//  ViewController.m
//  Mitek Hackathon
//
//  Created by Aryaman Sharda on 4/24/14.
//  Copyright (c) 2014 Tempest Vision. All rights reserved.
//

#import "SignInViewController.h"
#import "cardCollectionViewController.h"
#import <Parse/Parse.h>

#define kOFFSET_FOR_KEYBOARD 140.0

@interface SignInViewController ()
@property (strong, nonatomic) NSString* serverVersion;
@end

@implementation SignInViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
       NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@",[prefs stringForKey:@"username"]);
    
    if([prefs stringForKey:@"username"].length != 0)
    {
        [txtUsername setText:[prefs stringForKey:@"username"]];
    }
    
}
-(void)viewDidAppear:(BOOL)animated
{
    PFUser *currentUser = [PFUser currentUser];
    
    if(currentUser == NULL)
    {
        
    }
    else
    {
        [self performSegueWithIdentifier:@"succesfulLogin" sender:self];
    }
    

}
-(UIStatusBarStyle)preferredStatusBarStyle
{ 
    return UIStatusBarStyleLightContent; 
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{

}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    [txtUsername resignFirstResponder];
    [txtPassword resignFirstResponder];
    
}

-(void)setViewMoveUp:(BOOL)moveUp{
    
    CGRect rect = self.view.frame;
    if(moveUp)
    {
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
        
    }
    self.view.frame = rect;
}
-(IBAction)forgotPassword
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Reset Password" message:@"To reset your password, enter your email address below." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [PFUser requestPasswordResetForEmailInBackground:[[alertView textFieldAtIndex:0] text]];
    }
}
-(IBAction)signIn
{
    [PFUser logInWithUsernameInBackground:txtUsername.text password:txtPassword.text
        block:^(PFUser *user, NSError *error) {
            if (user) {
                // Do stuff after successful login.
                NSLog(@"Succesfully logged in!");
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                [prefs setObject:txtUsername.text forKey:@"username"];
                [prefs synchronize];
                [user saveInBackground];
                
                //Call to segue
                [self performSegueWithIdentifier:@"succesfulLogin" sender:self];

            } else {
                // The login failed. Check error to see why.
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid login credentials" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                // optional - add more buttons:
                [alert show];
            }
        }];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
