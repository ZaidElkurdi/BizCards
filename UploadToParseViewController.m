//
//  UploadToParseViewController.m
//  Mitek Hackathon
//
//  Created by Zaid Elkurdi on 4/26/14.
//  Copyright (c) 2014 Tempest Vision. All rights reserved.
//

#import "UploadToParseViewController.h"
#import "OAConsumer.h"

@interface UploadToParseViewController ()
{
    bool canSearch;
}
@end

@implementation UploadToParseViewController
{
    PFFile *imageFile;
}
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
    
    
   
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary *oAuthConsumerInfo = [prefs objectForKey:@"oAuthConsumerInfo"];
    NSDictionary *oAuthTokenInfo = [prefs objectForKey:@"oAuthTokenInfo"];
    
    NSString *consumerKey = [oAuthConsumerInfo objectForKey:@"key"];
    NSString *secretKey = [oAuthConsumerInfo objectForKey:@"secret"];
    NSString *realmKey = [oAuthConsumerInfo objectForKey:@"realm"];
    
    self.consumer = [[OAConsumer alloc] initWithKey:consumerKey secret:secretKey realm:realmKey];
    
    NSString *tokenKey = [oAuthTokenInfo objectForKey:@"key"];
    NSString *tokenSecret = [oAuthTokenInfo objectForKey:@"secret"];
    
    self.accessToken = [[OAToken alloc] initWithKey:tokenKey secret:tokenSecret];
    
    if(self.consumer && self.accessToken)
        canSearch=TRUE;
    

    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:[prefs objectForKey:@"rawImageText"] options:0];
    
    NSLog(@"Decoded: %@", [prefs objectForKey:@"rawImageText"]);
    [imgView setImage:[UIImage imageWithData:decodedData]];
    imageFile = [PFFile fileWithName:@"image.png" data:decodedData];
    

}

-(void)viewDidAppear:(BOOL)animated
{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    NSArray *myArray = [prefs objectForKey:@"formattedArray"];
    
    [txtName setText:[myArray objectAtIndex:0]];
    [txtCompany setText:[myArray objectAtIndex:1]];
    [txtTitle setText:[myArray objectAtIndex:2]];
    [txtEmail setText:[myArray objectAtIndex:3]];
    [txtPhone setText:[myArray objectAtIndex:4]];
    [txtAddress setText:[myArray objectAtIndex:5]];
}

-(IBAction)takeToParse
{
    NSLog(@"Made it here");
    
    PFUser *curr  = [PFUser currentUser];
    PFObject *uploadCard = [PFObject objectWithClassName:@"Card"];
    uploadCard[@"Name"] = txtName.text;
    uploadCard[@"Email"] = txtEmail.text;
    uploadCard[@"Title"] = txtTitle.text;
    uploadCard[@"Phone"] = txtPhone.text;
    uploadCard[@"Address"] = txtAddress.text;
    
    NSLog(@"UPload Card: %@", uploadCard);
    [uploadCard saveInBackground];
    
    
    PFObject *userPhoto = [PFObject objectWithClassName:@"UserPhoto"];
    userPhoto[@"imageName"] = txtName.text;
    userPhoto[@"imageFile"] = imageFile;
    userPhoto[@"Owner"] = curr.objectId;
    [userPhoto saveInBackground];
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Card Uploaded"
                                                      message:@"Your card was succesfully added to your rolodex."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [message show];
    
    
    [self profileApiCall];
    //[self performSegueWithIdentifier:@"backToHome" sender:nil];
}
-(UIImage*)thumbnail:(UIImage*)fullImage
{
    UIImage *originalImage = fullImage;
    CGSize destinationSize = CGSizeMake(80, 80);
    UIGraphicsBeginImageContext(destinationSize);
    [originalImage drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)profileApiCall
{
    NSLog(@"Making call!");
    
    NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people-search:(people:(id,first-name,last-name,picture-url,headline),num-results)?first-name=aryaman&last-name=sharda"];
    
    OAMutableURLRequest *request =
    [[OAMutableURLRequest alloc] initWithURL:url
                                    consumer:self.consumer
                                       token:self.accessToken
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
        if([profile objectForKey:@"numResults"]>0)
        {
            NSDictionary *people = [profile objectForKey:@"people"];
            NSArray *values = [people objectForKey:@"values"];
            NSDictionary *person = [values objectAtIndex:0];
            NSLog(@"%@", [person objectForKey:@"firstName"]);
            NSLog(@"%@", [person objectForKey:@"lastName"]);
            NSLog(@"%@", [person objectForKey:@"headline"]);
            NSLog(@"%@", [person objectForKey:@"id"]);
        }
    }
}


- (void)profileApiCallResult:(OAServiceTicket *)ticket didFail:(NSData *)error
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
