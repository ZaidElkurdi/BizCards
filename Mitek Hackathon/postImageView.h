//
//  postImageView.h
//  Mitek Hackathon
//
//  Created by Zaid Elkurdi on 4/26/14.
//  Copyright (c) 2014 Tempest Vision. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface postImageView : UIViewController <UITextFieldDelegate>
{
    IBOutlet UIImageView *passedImage;
    
    IBOutlet UIButton *btnName;
    IBOutlet UIButton *btnEmail;
    IBOutlet UIButton *btnCompany;
    IBOutlet UIButton *btnPhone;
    IBOutlet UIButton *btnAddress;
    IBOutlet UIButton *btnTitle;
    IBOutlet UIButton *btnIgnore;
    IBOutlet UILabel *txtData;

}
-(IBAction)progressThrough:(id)sender;
@property (nonatomic,strong) NSArray *addressFlags;
@property (nonatomic,strong) NSArray *emailFlags;
@property (nonatomic,strong) NSArray *titleFlags;
@property (nonatomic,strong) NSMutableArray *possibleAddresses;
@property (nonatomic,strong) NSMutableArray *possibleCities;
@property (nonatomic,strong) NSMutableArray *possibleNames;
@property (nonatomic,strong) NSMutableArray *possibleEmails;
@property (nonatomic,strong) NSMutableArray *possibleTitles;
@property (nonatomic,strong) NSMutableArray *possibleCompanies;
@property (nonatomic,strong) NSMutableArray *possiblePhones;

@end
