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
