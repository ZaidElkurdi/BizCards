//
//  CreateAccountViewController.h
//  NameGuru
//
//  Created by Aryaman Sharda on 4/24/14.
//  Copyright (c) 2014 NameGuru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateAccountViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UIButton *signUp;
    
    IBOutlet UITextField *txtFirstName;
    IBOutlet UITextField *txtLastName;
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtPassword;
    IBOutlet UITextField *txtConfirmPassword;
}
-(IBAction)signUp;
@end
