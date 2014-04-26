//
//  settingsViewController.h
//  Mitek Hackathon
//
//  Created by Aryaman Sharda on 4/26/14.
//  Copyright (c) 2014 Tempest Vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAConsumer.h"
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"
#import "OATokenManager.h"
#import "OAuthLoginView.h"
#import <Parse/Parse.h>
@interface settingsViewController : UIViewController<UIWebViewDelegate>
{
    IBOutlet UIButton *btnLogout;
}
-(IBAction)logout;
-(IBAction)signInWithLinkedIn;
- (void)profileApiCall;
- (void)networkApiCall;
@property (nonatomic, retain) OAuthLoginView *oAuthLoginView;
@property (nonatomic, retain) IBOutlet UIButton *button;
@property (nonatomic, retain) IBOutlet UIButton *postButton;
@property (nonatomic, retain) IBOutlet UILabel *postButtonLabel;
@property (nonatomic, retain) IBOutlet UILabel *name;
@property (nonatomic, retain) IBOutlet UILabel *headline;
@property (nonatomic, retain) IBOutlet UILabel *status;
@property (nonatomic, retain) IBOutlet UILabel *updateStatusLabel;
@property (nonatomic, retain) IBOutlet UITextField *statusTextView;
@end

