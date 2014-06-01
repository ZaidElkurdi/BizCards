//
//  detailViewController.h
//  Mitek Hackathon
//
//  Created by Zaid Elkurdi on 4/25/14.
//  Copyright (c) 2014 Tempest Vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "businessCard.h"
#import <Parse/Parse.h>

@interface detailViewController : UIViewController <UIActionSheetDelegate, UITextFieldDelegate, UIAlertViewDelegate, UITextViewDelegate>
{
    IBOutlet UIImageView *profileImageView;
    IBOutlet UIButton *linkedInButton;
    IBOutlet UIButton *phoneButton;
    IBOutlet UITextField *positionField;
    IBOutlet UITextField *emailField;
    IBOutlet UITextField *phoneField;
    IBOutlet UITextView *notesField;
    IBOutlet UIButton *shareButton;
}
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *position;
@property (nonatomic,strong) NSString *phoneNumber;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *notes;
@property (nonatomic,strong) UIImage *profilePic;
@property (nonatomic,strong) NSString *cardID;
@property (nonatomic,strong) NSString *linkedInID;
@property (nonatomic,strong) businessCard *oldCard;

-(IBAction)didTapShare;
-(IBAction)didTapBack;
-(IBAction)didTapCall;
-(IBAction)didTapLinkedIn;
-(void)initWithCard:(businessCard*)theCard;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@end
