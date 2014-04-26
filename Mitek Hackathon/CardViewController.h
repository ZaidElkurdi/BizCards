//
//  CardViewController.h
//  Mitek Hackathon
//
//  Created by Aryaman Sharda on 4/25/14.
//  Copyright (c) 2014 Tempest Vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MiSnap.h"
@interface CardViewController : UIViewController <MiSnapViewControllerDelegate>
@property (nonatomic)         BOOL isRunningMiSnap;
@property (nonatomic, strong) UIImage *miSnapImage;

- (IBAction)takeButtonPressed:(id)sender;
@end
