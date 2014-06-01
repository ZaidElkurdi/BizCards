//
//  linkedInViewController.h
//  Mitek Hackathon
//
//  Created by Aryaman Sharda on 4/26/14.
//  Copyright (c) 2014 Tempest Vision. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface linkedInViewController : UIViewController
{
IBOutlet UILabel *name;
IBOutlet UILabel *headline;
IBOutlet UIImageView *profile;
}
-(IBAction)pressedNo;
-(IBAction)pressedYes;
-(IBAction)pressedConnect;
@end
