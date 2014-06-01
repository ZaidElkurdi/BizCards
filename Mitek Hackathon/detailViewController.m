//
//  detailViewController.m
//  Mitek Hackathon
//
//  Created by Zaid Elkurdi on 4/25/14.
//  Copyright (c) 2014 Tempest Vision. All rights reserved.
//

#import "detailViewController.h"

#define kOFFSET_FOR_KEYBOARD 140.0

@interface detailViewController ()
{
    UIActionSheet *phonePicker;
    NSString *fullName;
}
@end

@implementation detailViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {}
    return self;
}

-(void)initWithCard:(businessCard*)theCard
{
    self.name = theCard.name;
    self.position = theCard.title;
    self.phoneNumber = theCard.phone;
    self.email = theCard.email;
    self.notes = theCard.notes;
    self.cardID = theCard.parseID;
    self.profilePic = [UIImage imageWithData:theCard.imageData];
    
    self.oldCard = theCard;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /* Init Nav Bar */
    UIColor *barColor = [UIColor colorWithRed:29.0f/255.0f green:143.0f/255.0f blue:102.0f/255.0f alpha: 1.0];
    
    self.navigationController.navigationBar.barTintColor=barColor;
    
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 240, 40)];
    navTitle.text = self.name;
    navTitle.textColor = [UIColor whiteColor];
    UIFont *navFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20.0];
    navTitle.font = navFont;
    navTitle.textAlignment = NSTextAlignmentCenter;
    [self.navigationController.navigationBar addSubview:navTitle];
    
    profileImageView.image = self.profilePic;
    
    emailField.text = self.email;
    phoneField.text = self.phoneNumber;
    notesField.text = self.notes;
    
    emailField.delegate = self;
    phoneField.delegate = self;
    notesField.delegate = self;
    
}

-(UIStatusBarStyle)preferredStatusBarStyle
{ 
    return UIStatusBarStyleLightContent; 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Buttons
-(IBAction)didTapCall
{
    NSString *phoneNumberFormat = [NSString  stringWithFormat:@"tel:%@",self.phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[phoneNumberFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

-(IBAction)didTapLinkedIn
{
    if(self.linkedInID != NULL)
    {
        NSString *rawURL = [NSString stringWithFormat:@"http://www.linkedin.com/profile/view?id=%@", self.linkedInID];
        
        NSURL *url = [NSURL URLWithString:rawURL];
        
        [[UIApplication sharedApplication] openURL:url];
    }
    
    else
    {
        UIAlertView *noIDAlert =  [[UIAlertView alloc] initWithTitle:@"Error!" message:@"This person does not have a LinkedIn account set." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [noIDAlert show];
    }
}

-(IBAction)didTapBack
{
     [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)didTapShare
{
    NSArray *activityItems = @[@"Add Contact"];

    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypePostToWeibo];
    [self presentViewController:activityVC animated:TRUE completion:nil];
   
}


#pragma -mark Delegates/Data Sources

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView dismissWithClickedButtonIndex:1 animated:YES];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(self.view.frame.origin.y >= 0)
        [self setViewOffset:TRUE];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if(self.view.frame.origin.y >= 0)
        [self setViewOffset:TRUE];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    [notesField resignFirstResponder];
    [emailField resignFirstResponder];
    [phoneField resignFirstResponder];
    
    if(self.view.frame.origin.y < 0)
        [self setViewOffset:FALSE];
}

-(void)setViewOffset:(BOOL)moveUp
{
    CGRect rect = self.view.frame;
    if(moveUp)
    {
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
        
    }
    
    [UIView animateWithDuration:0.5
    delay:0
    usingSpringWithDamping:500.0f
    initialSpringVelocity:0.0f
    options:UIViewAnimationOptionCurveLinear
    animations:
    ^{
         self.view.frame = rect;
    }
    completion:nil];
}

#pragma -mark Other Methods
-(void)uploadNewInfo
{
    PFObject *parseCard = [PFQuery getObjectOfClass:@"Card" objectId:self.cardID];
    [parseCard setObject:emailField.text forKey:@"Email"];
    [parseCard setObject:phoneField.text forKey:@"Phone"];
    [parseCard setObject:notesField.text forKey:@"Notes"];
    [parseCard save];
    
    self.oldCard.phone = phoneField.text;
    self.oldCard.email = emailField.text;
    self.oldCard.notes = notesField.text;
}

-(bool)cardInfoChanged
{
    NSString *oldPhone = self.oldCard.phone;
    NSString *oldEmail = self.oldCard.email;
    NSString *oldNotes = self.oldCard.notes;
    
    if(![oldEmail isEqualToString:emailField.text])
        return true;
    
    if(![oldPhone isEqualToString:phoneField.text])
        return true;
    
    if(![oldNotes isEqualToString:notesField.text])
        return true;
    
    return false;
}

- (void)viewWillDisappear:(BOOL)animated
{
    bool isChanged = [self cardInfoChanged];
    
    if(isChanged)
    {
        [self uploadNewInfo];
    }
}

@end
