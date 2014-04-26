//
//  UploadToParseViewController.h
//  Mitek Hackathon
//
//  Created by Zaid Elkurdi on 4/26/14.
//  Copyright (c) 2014 Tempest Vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "OAuthLoginView.h"
#import "OAConsumer.h"
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"
#import "OATokenManager.h"

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
@property(nonatomic, retain) OAToken *accessToken;
@property(nonatomic, retain) OAConsumer *consumer;
@end
