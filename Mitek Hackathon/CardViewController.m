//
//  CardViewController.m
//  Mitek Hackathon
//
//  Created by Aryaman Sharda on 4/25/14.
//  Copyright (c) 2014 Tempest Vision. All rights reserved.
//

#import "CardViewController.h"

#import <CoreGraphics/CoreGraphics.h>
#import <CoreMotion/CoreMotion.h>
#import <ImageIO/ImageIO.h>
@interface CardViewController ()
@property (weak, nonatomic) IBOutlet UIButton *takeButton;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (strong, nonatomic) NSString* serverVersion;
@end

@implementation CardViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)takeButtonPressed:(UIButton*)button {
    
    NSMutableDictionary* videoParameters
    = [[MiSnapViewController defaultParameters] mutableCopy];
    
	// If video mode was selected, setup needed params
	if (self.videoButton == button)
	{
		// MIP v2.1 or greater needed to allow video frames.
		[videoParameters setObject:@"1" forKey:kMiSnapAllowVideoFrames];
		[videoParameters setObject:@"2.1" forKey:kMiSnapMIPServerVersion];
	}
    
    MiSnapViewController* controller = [[MiSnapViewController alloc] init];
    controller.delegate = self;
	controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [controller setupMiSnapWithParams:videoParameters];
    
	self.isRunningMiSnap = YES;
    [self presentViewController:controller animated:YES completion:nil];
}



- (void)authenticateUserReturn:(NSDictionary *)dict {
    if ([[dict objectForKey:@"SecurityResult"] integerValue]) {
        // process failure
    } else {
        self.serverVersion = [dict objectForKey:@"MIPVersion"];
        if (!self.serverVersion)
            self.serverVersion = @"UNKNOWN";
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isRunningMiSnap = NO;
    
    NSArray *arr = [[NSArray alloc] initWithObjects:@"zaid.elkurdi@gmail.com",@"HI7WWP8VypoE",@"UCSD-Hack",nil];
    
    NSArray *arr2 = [[NSArray alloc] initWithObjects:@"userName",@"password",@"orgName",nil];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:arr forKeys:arr2];
    [self authenticateUserReturn:dict];
    //Make a call w/ dictionary


}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self setTitle:@"Take Photo"];
}

#pragma mark - Rotation methods
#pragma mark -

// iOS 6 methods
- (NSUInteger)supportedInterfaceOrientations
{
	// if we're actively presenting the MiSnap View Controller then we want to support
	// landscape modes. Otherwise, just portrait
	if (self.isRunningMiSnap)
	{
		return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape;
	}
	else
	{
		return UIInterfaceOrientationMaskPortrait;
	}
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
	return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate {
	return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
