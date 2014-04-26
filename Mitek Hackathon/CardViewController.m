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

#pragma mark -
#pragma mark MiSnap Delegate methods

- (void)miSnapFinishedReturningEncodedImage:(NSString *)encodedImage
							  originalImage:(UIImage *)image
								 andResults:(NSDictionary *)results {
    
	self.isRunningMiSnap = NO;
    self.miSnapImage = image;
    
	[self dismissViewControllerAnimated:YES completion:^{
		// Show the image to the user
			}];
}

- (void)miSnapCancelledWithResults:(NSDictionary *)results {
	self.isRunningMiSnap = NO;
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isRunningMiSnap = NO;

}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self setTitle:@"Take Photo"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
