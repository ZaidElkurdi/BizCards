//
//  UploadToParseViewController.m
//  Mitek Hackathon
//
//  Created by Zaid Elkurdi on 4/26/14.
//  Copyright (c) 2014 Tempest Vision. All rights reserved.
//

#import "UploadToParseViewController.h"

@interface UploadToParseViewController ()

@end

@implementation UploadToParseViewController

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
    NSData *data = [[NSData alloc] initWithContentsOfFile:[prefs objectForKey:@"imagePlain"]];

    NSLog(@"Data: %@",data);
    UIImage *img = [UIImage imageWithData:data];
    [imgView setImage:img];
    
    //NSData *imageData = UIImagePNGRepresentation(img);

    /*
    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
 
    PFObject *userPhoto = [PFObject objectWithClassName:@"UserPhoto"];
    userPhoto[@"imageName"] = @"My trip to Hawaii!";
    userPhoto[@"imageFile"] = imageFile;
    [userPhoto save];
    */


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
    PFObject *uploadCard = [PFObject objectWithClassName:@"Card"];
    uploadCard[@"Name"] = txtName.text;
    uploadCard[@"Email"] = txtEmail.text;
    uploadCard[@"Company"] = txtCompany.text;
    uploadCard[@"Title"] = txtTitle.text;
    uploadCard[@"Phone"] = txtPhone.text;
    uploadCard[@"Address"] = txtAddress.text;
    
    
    
    
    
    
    
   
    [uploadCard saveInBackground];
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Card Uploaded"
                                                      message:@"Your card was succesfully added to your rolodex."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
     
    [message show];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
