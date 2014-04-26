//
//  UploadToParseViewController.h
//  Mitek Hackathon
//
//  Created by Zaid Elkurdi on 4/26/14.
//  Copyright (c) 2014 Tempest Vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface UploadToParseViewController : UIViewController
{
    IBOutlet UITextField *txtName;
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtCompany;
    IBOutlet UITextField *txtPhone;
    IBOutlet UITextField *txtAddress;
    IBOutlet UITextField *txtTitle;
    NSString *rawText;
    IBOutlet UIButton *takeToParse;
    IBOutlet UIImageView *imgView;
}
-(IBAction)takeToParse;
@end
