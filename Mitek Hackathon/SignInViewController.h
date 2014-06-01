//
//  ViewController.h
//  Mitek Hackathon
//
//  Created by Aryaman Sharda on 4/24/14.
//  Copyright (c) 2014 Tempest Vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface SignInViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UITextField *txtUsername;
    IBOutlet UITextField *txtPassword;
    
    IBOutlet UIButton *signIn;
    IBOutlet UIButton *forgotPassword;
}
-(IBAction)signIn;
-(IBAction)forgotPassword;

@end
