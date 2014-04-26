//
//  ViewController.m
//  Mitek Hackathon
//
//  Created by Aryaman Sharda on 4/24/14.
//  Copyright (c) 2014 Tempest Vision. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#define kOFFSET_FOR_KEYBOARD 140.0
@interface ViewController ()
@property (strong, nonatomic) NSString* serverVersion;
@end

@implementation ViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([prefs stringForKey:@"username"].length != 0)
    {
        [txtUsername setText:[prefs stringForKey:@"userPassword"]];
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


-(IBAction)signIn
{
    [PFUser logInWithUsernameInBackground:txtUsername.text password:txtPassword.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            
                                            //Call to segue
                                        } else {
                                            // The login failed. Check error to see why.
                                        }
                                    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
