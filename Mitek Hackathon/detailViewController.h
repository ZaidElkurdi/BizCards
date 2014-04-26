//
//  detailViewController.h
//  Mitek Hackathon
//
//  Created by Zaid Elkurdi on 4/25/14.
//  Copyright (c) 2014 Tempest Vision. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailViewController : UIViewController <UIActionSheetDelegate, UIAlertViewDelegate>
{
    IBOutlet UIImageView *profileImageView;
    IBOutlet UIButton *linkedInButton;
    IBOutlet UIButton *phoneButton;
    IBOutlet UILabel *positionLabel;
    IBOutlet UIButton *shareButton;
    bool hasNotes;
}
@property (nonatomic,strong) NSDictionary *cardData;
@property (nonatomic,strong) NSString *fullName;
@property (nonatomic,strong) NSString *position;
@property (nonatomic,strong) NSArray *phoneNumbers;
@property (nonatomic,strong) NSArray *emailAddresses;
@property (nonatomic,strong) NSString *notes;
@property (nonatomic,strong) UIImage *profilePic;
@property (nonatomic,strong) NSString *uniqueID;
@property (nonatomic,strong) NSString *linkedInID;
@end
