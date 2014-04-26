//
//  CreateAccountViewController.m
//  NameGuru
//
//  Created by Aryaman Sharda on 4/24/14.
//  Copyright (c) 2014 NameGuru. All rights reserved.
//

#import "CreateAccountViewController.h"
#import <Parse/Parse.h>


@interface CreateAccountViewController ()

@end

@implementation CreateAccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [txtFirstName becomeFirstResponder];
}

- (IBAction)signUp
{
    if(txtPassword.text.length > 5 && txtFirstName.text.length > 0 && txtLastName.text.length > 0 && [txtEmail.text rangeOfString:@"@"].location != NSNotFound)
    {
        PFUser *user = [PFUser user];
        user.username = [txtEmail text];
        user.password = [txtPassword text];
        user.email =  [txtEmail text];
        user[@"FullName"] = [NSString stringWithFormat:@"%@ %@",[txtFirstName text], [txtLastName text]];
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                // Hooray! Let them use the app now.
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                [prefs setObject:txtEmail.text forKey:@"username"];
                [prefs synchronize];
                [user saveInBackground];

            } else {
                NSString *errorString = [error userInfo][@"error"];
                NSLog(@"%@",errorString);
                // Show the errorString somewhere and let the user try again.
            }
        }];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please review sign up credentials" message:@"Illegal characters were found. Please fill in all fields correctly." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        // optional - add more buttons:
        [alert addButtonWithTitle:@"Ok"];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txtFirstName resignFirstResponder];
    [txtLastName resignFirstResponder];
    [txtEmail resignFirstResponder];
    [txtPassword resignFirstResponder];
    [txtConfirmPassword resignFirstResponder];

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
