//
//  settingsViewController.m
//  Mitek Hackathon
//
//  Created by Aryaman Sharda on 4/26/14.
//  Copyright (c) 2014 Tempest Vision. All rights reserved.
//

#import "settingsViewController.h"

@interface settingsViewController ()

@end

@implementation settingsViewController

@synthesize button, name, headline, oAuthLoginView,
status, postButton, postButtonLabel,
statusTextView, updateStatusLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIColor *barColor = [UIColor colorWithRed:29.0f/255.0f green:143.0f/255.0f blue:102.0f/255.0f alpha: 1.0];
    
    self.navigationController.navigationBar.barTintColor=barColor;
    
//    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
//    navTitle.text = @"Settings";
//    navTitle.textColor = [UIColor whiteColor];
//    UIFont *navFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:28.0];
//    navTitle.font = navFont;
//    navTitle.textAlignment = NSTextAlignmentCenter;
//     [self.navigationController.navigationBar addSubview:navTitle];
}

-(void) loginViewDidFinish:(NSNotification*)notification
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // We're going to do these calls serially just for easy code reading.
    // They can be done asynchronously
    // Get the profile, then the network updates
    [self profileApiCall];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)signInWithLinkedIn
{
    self.oAuthLoginView = [[OAuthLoginView alloc] initWithNibName:nil bundle:nil];
    
    // register to be told when the login is finished
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginViewDidFinish:)
                                                 name:@"loginViewDidFinish"
                                               object:self.oAuthLoginView];
    
    [self presentModalViewController:self.oAuthLoginView animated:YES];
}


- (void)profileApiCall
{
    //NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people/~:(first-name,last-name,formatted-name,picture-url,phone-numbers)?format=json"];
    
    NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people-search:(people:(id,first-name,last-name,picture-url,headline),num-results)?first-name=aryaman&last-name=sharda"];
    
    OAMutableURLRequest *request =
    [[OAMutableURLRequest alloc] initWithURL:url
                                    consumer:self.oAuthLoginView.consumer
                                       token:self.oAuthLoginView.accessToken
                                    callback:nil
                           signatureProvider:nil];
    
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(profileApiCallResult:didFinish:)
                  didFailSelector:@selector(profileApiCallResult:didFail:)];
    
}



- (void)profileApiCallResult:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
    NSError *error = nil;
    NSDictionary *profile = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    NSLog(@"%@", profile);
    
    if (profile)
    {
        name.text = [[NSString alloc] initWithFormat:@"%@ %@",
                     [profile objectForKey:@"firstName"], [profile objectForKey:@"lastName"]];
        headline.text = [profile objectForKey:@"headline"];
        
        NSDictionary *numbers = [profile objectForKey:@"phoneNumbers"];
        NSArray *values = [numbers objectForKey:@"values"];
        NSLog(@"Phone Number: %@", [values objectAtIndex:0]);
    }
    
    
    // The next thing we want to do is call the network updates
    //[self networkApiCall];
    
}

-(IBAction)logout
{
    
    [PFUser logOut];
    [self performSegueWithIdentifier:@"backToHome" sender:nil];
}
- (void)profileApiCallResult:(OAServiceTicket *)ticket didFail:(NSData *)error
{
    NSLog(@"%@",[error description]);
}

- (void)networkApiCall
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSArray *consumerArray = [[NSArray alloc] initWithObjects:oAuthLoginView.consumer.key,oAuthLoginView.consumer.secret,oAuthLoginView.consumer.realm, nil];
    NSArray *consumerKeys = [[NSArray alloc] initWithObjects:@"key",@"secret", @"realm", nil];
    
    NSDictionary *consumerInfo = [[NSDictionary alloc] initWithObjects:consumerArray forKeys:consumerKeys];
    ////////
    
    NSArray *tokenArray = [[NSArray alloc] initWithObjects:oAuthLoginView.accessToken.key,oAuthLoginView.accessToken.secret, nil];
    NSArray *tokenKeys = [[NSArray alloc] initWithObjects:@"key",@"secret", nil];
    
    NSDictionary *tokenInfo = [[NSDictionary alloc] initWithObjects:tokenArray forKeys:tokenKeys];
    
    [prefs setObject:consumerInfo forKey:@"oAuthConsumerInfo"];
    [prefs setObject:tokenInfo forKey:@"oAuthTokenInfo"];
    
    [prefs synchronize];
    
    NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people/~/network/updates?scope=self&count=1&type=STAT"];
    OAMutableURLRequest *request =
    [[OAMutableURLRequest alloc] initWithURL:url
                                    consumer:oAuthLoginView.consumer
                                       token:oAuthLoginView.accessToken
                                    callback:nil
                           signatureProvider:nil];
    
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(networkApiCallResult:didFinish:)
                  didFailSelector:@selector(networkApiCallResult:didFail:)];
    
}

- (void)networkApiCallResult:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
    NSError *error = nil;
    NSDictionary *profile = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    NSLog(@"Person: %@", profile);
    NSDictionary *person = [[[[profile
                               objectForKey:@"values"]
                              objectAtIndex:0]
                             objectForKey:@"updateContent"]
                            objectForKey:@"person"];
    
    if ( [person objectForKey:@"currentStatus"] )
    {
        [postButton setHidden:false];
        [postButtonLabel setHidden:false];
        [statusTextView setHidden:false];
        [updateStatusLabel setHidden:false];
        status.text = [person objectForKey:@"currentStatus"];
    } else {
        [postButton setHidden:false];
        [postButtonLabel setHidden:false];
        [statusTextView setHidden:false];
        [updateStatusLabel setHidden:false];
        status.text = [[[[person objectForKey:@"personActivities"]
                         objectForKey:@"values"]
                        objectAtIndex:0]
                       objectForKey:@"body"];
        
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)networkApiCallResult:(OAServiceTicket *)ticket didFail:(NSData *)error
{
    NSLog(@"%@",[error description]);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
