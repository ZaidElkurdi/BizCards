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
#import "xmlreader.h"
#import "postImageView.h"

@interface CardViewController ()
{
    NSDictionary *finalImageDict;
    NSDictionary *finalTextDict;
}
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

- (void)miSnapFinishedReturningEncodedImage:(NSString *)encodedImage
							  originalImage:(UIImage *)originalImage
								 andResults:(NSDictionary *)results
{
    [self sendImage:encodedImage withResults:results];
    
}

- (void)miSnapCancelledWithResults:(NSDictionary *)results
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self authenticate];
    // Do any additional setup after loading the view.
    _isRunningMiSnap = NO;
    
    UIColor *barColor = [UIColor colorWithRed:29.0f/255.0f green:143.0f/255.0f blue:102.0f/255.0f alpha: 1.0];
    self.navigationController.navigationBar.frame = CGRectMake(0, 0, 320, 40);
    self.navigationController.navigationBar.barTintColor=barColor;
    
    //Make a call w/ dictionary
    
    self.rawText = nil;
    self.rawData = nil;
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self setTitle:@"Take Photo"];
}

-(void)sendImage:(NSString*)encodedImage withResults:(NSDictionary*)results
{
    NSDictionary *headerFieldsDict = [NSDictionary
                                      dictionaryWithObjectsAndKeys:@"Apple iPhone",@"User-Agent",
                                      @"text/xml; charset=utf-8", @"Content-Type",
                                      @"soapAction",@"SOAP_ACTION",nil];
    
    NSString *xmlPath = [[NSBundle mainBundle] pathForResource:@"sendImage" ofType:@"xml"];

    
    NSError *error;
    NSString *rawxmlString = [NSString stringWithContentsOfFile:xmlPath encoding:NSUTF8StringEncoding error:&error];
    NSString *xmlString = [NSString stringWithFormat:rawxmlString,encodedImage];
    if (error) {
        NSLog(@"Error with XML conversion: %@", [error description]);
    }
    else {
//        NSLog(@"XML Data: %@", xmlString);
    }
    
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://mip03.ddc.mitekmobile.com/MobileImagingPlatformWebServices/ImagingPhoneService.asmx"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setAllHTTPHeaderFields:headerFieldsDict];
    [theRequest setHTTPBody:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:theRequest queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"Connection error: %@", [connectionError description]);
        }
        else
        {
            
            NSString* theString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *dics=[[NSDictionary alloc]initWithDictionary:[XMLReader dictionaryForXMLString:theString error:nil]];
            NSDictionary *dic1 = [[NSDictionary alloc] initWithDictionary:[dics objectForKey:@"soap:Envelope"]];
            
            NSDictionary *dic2 = [[NSDictionary alloc] initWithDictionary:[dic1 objectForKey:@"soap:Body"]];
            NSDictionary *dic3 = [[NSDictionary alloc] initWithDictionary:[dic2 objectForKey:@"InsertPhoneTransactionResponse"]];
            NSDictionary *dic4 = [[NSDictionary alloc] initWithDictionary:[dic3 objectForKey:@"InsertPhoneTransactionResult"]];
            NSDictionary *dic5 = [[NSDictionary alloc] initWithDictionary:[dic4 objectForKey:@"Transaction"]];
            
            finalImageDict = [[dic5 objectForKey:@"GrayscaleImage"] copy];
            self.rawData = [[finalImageDict objectForKey:@"text"] copy];
            
            finalTextDict =[[dic5 objectForKey:@"ExtractedRawOCR"] copy];
            self.rawText = [[finalTextDict objectForKey:@"text"] copy];
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
           
           [prefs setObject:[NSString stringWithFormat:@"%@",[finalImageDict objectForKey:@"text"]] forKey:@"rawImageText"];
           
           
           [prefs setObject:[NSString stringWithFormat:@"%@",[finalTextDict objectForKey:@"text"]] forKey:@"rawOCRText"];
           [prefs synchronize];
        }
    }];
    
    [self performSelector:@selector(presentNew) withObject:nil afterDelay:3.0];
}

-(void)presentNew
{
    [self dismissViewControllerAnimated:NO completion:nil];
    postImageView *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"postImageView"];
    [self presentModalViewController:controller animated:YES];
}

#pragma mark - Rotation methods

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


-(void)authenticate
{
    NSDictionary *headerFieldsDict = [NSDictionary
                                      dictionaryWithObjectsAndKeys:@"Apple iPhone",@"User-Agent",
                                      @"text/xml; charset=utf-8", @"Content-Type",
                                      @"soapAction",@"SOAP_ACTION",nil];
    
    NSString *xmlPath = [[NSBundle mainBundle] pathForResource:@"authenticate" ofType:@"xml"];
    
    NSError *error;
    NSString *xmlString = [NSString stringWithContentsOfFile:xmlPath encoding:NSUTF8StringEncoding error:&error];
    
    if (error)
        NSLog(@"Error with XML conversion: %@", [error description]);
    
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://mip03.ddc.mitekmobile.com/MobileImagingPlatformWebServices/ImagingPhoneService.asmx"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setAllHTTPHeaderFields:headerFieldsDict];
    [theRequest setHTTPBody:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:theRequest queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError)
            NSLog(@"Connection error: %@", [connectionError description]);
        }];
}

@end
