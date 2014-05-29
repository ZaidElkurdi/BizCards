//
//  iPhone OAuth Starter Kit
//
//  Supported providers: LinkedIn (OAuth 1.0a)
//
//  Lee Whitney
//  http://whitneyland.com
//

#import <Foundation/NSNotificationQueue.h>
#import "ProfileTabView.h"


@implementation ProfileTabView

@synthesize button, name, headline, oAuthLoginView, 
            status, postButton, postButtonLabel,
            statusTextView, updateStatusLabel;

- (IBAction)button_TouchUp:(UIButton *)sender
{    
    oAuthLoginView = [[OAuthLoginView alloc] initWithNibName:nil bundle:nil];
 
    // register to be told when the login is finished
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(loginViewDidFinish:) 
                                                 name:@"loginViewDidFinish" 
                                               object:oAuthLoginView];
    
    [self presentModalViewController:oAuthLoginView animated:YES];
}


-(void) loginViewDidFinish:(NSNotification*)notification
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // We're going to do these calls serially just for easy code reading.
    // They can be done asynchronously
    // Get the profile, then the network updates
    [self profileApiCall];
	
}

- (void)profileApiCall
{
    //NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people/~:(first-name,last-name,formatted-name,picture-url,phone-numbers)?format=json"];
    
    NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people-search:(people:(id,first-name,last-name,picture-url,headline),num-results)?first-name=aryaman&last-name=sharda"];
    
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
                didFinishSelector:@selector(profileApiCallResult:didFinish:)
                  didFailSelector:@selector(profileApiCallResult:didFail:)];
    
}

- (void)profileApiCallResult:(OAServiceTicket *)ticket didFinish:(NSData *)data 
{
//    NSString *responseBody = [[NSString alloc] initWithData:data
//                                                   encoding:NSUTF8StringEncoding];
//    
//    NSDictionary *profile = [responseBody objectFromJSONString];
//    NSLog(@"%@", profile);
//    
//
//    if (profile)
//    {
//        name.text = [[NSString alloc] initWithFormat:@"%@ %@",
//                     [profile objectForKey:@"firstName"], [profile objectForKey:@"lastName"]];
//        headline.text = [profile objectForKey:@"headline"];
//        
//        NSDictionary *numbers = [profile objectForKey:@"phoneNumbers"];
//        NSArray *values = [numbers objectForKey:@"values"];
//        NSLog(@"Phone Number: %@", [values objectAtIndex:0]);
//    }
//    
//    
//    // The next thing we want to do is call the network updates
//    [self networkApiCall];

}

- (void)profileApiCallResult:(OAServiceTicket *)ticket didFail:(NSData *)error 
{
    NSLog(@"%@",[error description]);
}

- (void)networkApiCall
{
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
//    NSString *responseBody = [[NSString alloc] initWithData:data
//                                                   encoding:NSUTF8StringEncoding];
//    NSLog(@"Person: %@", responseBody);
//    NSDictionary *person = [[[[[responseBody objectFromJSONString] 
//                                objectForKey:@"values"] 
//                                    objectAtIndex:0]
//                                        objectForKey:@"updateContent"]
//                                            objectForKey:@"person"];
//    
//
//    
//    if ( [person objectForKey:@"currentStatus"] )
//    {
//        [postButton setHidden:false];
//        [postButtonLabel setHidden:false];
//        [statusTextView setHidden:false];
//        [updateStatusLabel setHidden:false];
//        status.text = [person objectForKey:@"currentStatus"];
//    } else {
//        [postButton setHidden:false];
//        [postButtonLabel setHidden:false];
//        [statusTextView setHidden:false];
//        [updateStatusLabel setHidden:false];
//        status.text = [[[[person objectForKey:@"personActivities"] 
//                            objectForKey:@"values"]
//                                objectAtIndex:0]
//                                    objectForKey:@"body"];
//        
//    }
//    
//    [self dismissModalViewControllerAnimated:YES];
}

- (void)networkApiCallResult:(OAServiceTicket *)ticket didFail:(NSData *)error 
{
    NSLog(@"%@",[error description]);
}

- (IBAction)postButton_TouchUp:(UIButton *)sender
{    
    [statusTextView resignFirstResponder];
    NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people/~/shares"];
    OAMutableURLRequest *request = 
    [[OAMutableURLRequest alloc] initWithURL:url
                                    consumer:oAuthLoginView.consumer
                                       token:oAuthLoginView.accessToken
                                    callback:nil
                           signatureProvider:nil];
    
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *updateString;
    
    [request setHTTPBodyWithString:updateString];
	[request setHTTPMethod:@"POST"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(postUpdateApiCallResult:didFinish:)
                  didFailSelector:@selector(postUpdateApiCallResult:didFail:)];
}

- (void)postUpdateApiCallResult:(OAServiceTicket *)ticket didFinish:(NSData *)data 
{
    // The next thing we want to do is call the network updates
    [self networkApiCall];
    
}

- (void)postUpdateApiCallResult:(OAServiceTicket *)ticket didFail:(NSData *)error 
{
    NSLog(@"%@",[error description]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
