//
//  postImageView.m
//  Mitek Hackathon
//
//  Created by Zaid Elkurdi on 4/26/14.
//  Copyright (c) 2014 Tempest Vision. All rights reserved.
//

#import "postImageView.h"

@interface postImageView ()

@end

@implementation postImageView
{
    int validEntry;
    int position;
    NSString *rawText;
    NSMutableArray *arrayToPass;
    NSMutableArray *rawLines;
    
    NSString *strName;
    NSString *strCompany;
    NSString *strTitle;
    NSString *strEmail;
    NSString *strPhone;
    NSString *strAddress;
    
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    strName = @"";
    strCompany = @"";
    strTitle = @"";
    strEmail  = @"";
    strPhone = @"";
    strAddress = @"";
    
    arrayToPass = [[NSMutableArray alloc] init];
    rawLines = [[NSMutableArray alloc] init];
    position = 0;
    validEntry = 0;
    self.addressFlags = [[NSArray alloc] initWithObjects:@"road",@"drive",@"avenue",@"place", @"st.", @"rd.", nil];
    
    self.titleFlags = [[NSArray alloc] initWithObjects:@"director",@"president", @"vice", @"operations", @"founder", @"ceo", @"analyst", @"marketing", @"developer", @"programmer", @"resources", @"partner", @"officer", @"executive", nil];
    
    self.possibleTitles = [[NSMutableArray alloc] init];
    self.possibleAddresses = [[NSMutableArray alloc] init];
    self.possibleCities = [[NSMutableArray alloc] init];
    self.possibleCompanies = [[NSMutableArray alloc] init];
    self.possibleEmails = [[NSMutableArray alloc] init];
    self.possibleNames = [[NSMutableArray alloc] init];
    self.possiblePhones = [[NSMutableArray alloc] init];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:[prefs objectForKey:@"rawImageText"] options:0];
    UIImage *rawImage = [UIImage imageWithData:decodedData];
    [passedImage setImage:rawImage];
    
    rawText = [prefs objectForKey:@"rawOCRText"];
     NSLog(@"Raw Text: %@",rawText);
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"rawTest" ofType:@".txt"];
//    NSError *error;
//    NSString *rawText =[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
//

    //[self parseText];
    rawLines = [[rawText componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] mutableCopy];
    [self progress:YES];
    
}
-(void)progress:(BOOL)doStuff
{

    
      NSLog(@"Position: %d", position);
      NSLog(@"valid entry: %d", validEntry);
    
      if([rawLines count] > position)
      {
        [txtData setText:[rawLines objectAtIndex:position]];
       }
       else
       {
            [arrayToPass addObject:strName];
            [arrayToPass addObject:strCompany];
            [arrayToPass addObject:strTitle];
            [arrayToPass addObject:strEmail];
            [arrayToPass addObject:strPhone];
            [arrayToPass addObject:strAddress];
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setObject:arrayToPass forKey:@"formattedArray"];
            [self performSegueWithIdentifier:@"transitionToEdit" sender:nil];
            NSLog(@"Done");
       }
    
}
-(IBAction)progressThrough:(id)sender
{
    if ([sender tag] == 1)
    {
        NSLog(@"here");
        position++;
        [self progress:NO];
        
    }
    else
    {
        if([sender tag] == 2)
        {
            strName = [NSString stringWithFormat:@"%@ %@",strName,txtData.text];
        }
        if([sender tag] == 3)
        {
            strCompany  = [NSString stringWithFormat:@"%@ %@",strCompany,txtData.text];
        }
        if([sender tag] == 4)
        {
            strTitle  = [NSString stringWithFormat:@"%@ %@",strTitle,txtData.text];
            NSLog(@"Str Title: %@", strTitle);
        }
        if([sender tag] == 5)
        {
            strEmail = [NSString stringWithFormat:@"%@ %@",strEmail,txtData.text];
        }
        if([sender tag] == 6)
        {
            strPhone = [NSString stringWithFormat:@"%@ %@",strPhone,txtData.text];
        }
        if([sender tag] == 7)
        {
            strAddress = [NSString stringWithFormat:@"%@ %@",strAddress,txtData.text];
        }
        validEntry++;
        position++;
        [self progress:YES];
    }
}

-(void)parseText
{
    NSLog(@"Raw: %@",rawText);
    NSMutableArray *rawLines = [[rawText componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] mutableCopy];
    
    
    
    /*
    for(NSString* currLine in rawLines)
    {
        NSString *cleanLine = [currLine stringByReplacingOccurrencesOfString:@"," withString:@" "];
        NSLog(@"Testing: %@",cleanLine);
        NSMutableArray *words = [[cleanLine componentsSeparatedByString:@" "] mutableCopy];
        for(NSString* currWord in words)
        {
            if([self.addressFlags containsObject:[currWord lowercaseString]])
            {
                NSLog(@"Address Match: %@",cleanLine);
                [self.possibleAddresses addObject:currLine];
                break;
            }
            
            if([self.titleFlags containsObject:[currWord lowercaseString]])
            {
                NSLog(@"Title Match: %@",cleanLine);
                [self.possibleTitles addObject:currLine];
                break;
            }
            
            NSString *zipregex = @"[0-9]{5}";
            NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", zipregex];

            BOOL matches = [test evaluateWithObject:currWord];
            if(matches)
            {
                NSLog(@"City Match: %@",cleanLine);
                [self.possibleCities addObject:cleanLine];
                break;
            }

            
            //Email parsing...
        }
        
        
        NSString *phoneRegex = @"[235689][0-9]{6}([0-9]{3})?";
        NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
        
        NSString * strippedNumber = [cleanLine stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [cleanLine length])];
        
        BOOL matches = [test evaluateWithObject:strippedNumber];
        if(matches)
        {
            NSLog(@"Phone Match: %@",cleanLine);
            [self.possiblePhones addObject:cleanLine];
            break;
        }
        
        NSMutableArray *splitLine = [[cleanLine componentsSeparatedByString:@" "] mutableCopy];
        NSLog(@"Split: %@ count: %d",splitLine, [splitLine count]);
        if([splitLine count]==2)
        {
            NSLog(@"Name Match: %@",cleanLine);
            [self.possibleNames addObject:cleanLine];
        }
    }
    
    if([self.possibleAddresses count] > 0 && [self.possibleCities count] > 0)
    {
        [txtAddress setText:[NSString stringWithFormat:@"%@ %@",[self.possibleAddresses objectAtIndex:0],[self.possibleCities objectAtIndex:0]]];
    }
    else
    {
        [txtAddress setText: @""];
    }
    
    if([self.possibleCompanies count] > 0 )
    {
        [txtCompany setText:[NSString stringWithFormat:@"%@",[self.possibleCompanies objectAtIndex:0]]];
    }
    else
    {
        [txtCompany setText: @""];
    }
    
    if([self.possibleEmails count] > 0 )
    {
        [txtEmail setText:[NSString stringWithFormat:@"%@",[self.possibleEmails objectAtIndex:0]]];
    }
    else
    {
        [txtEmail setText: @""];
    }
    
    if([self.possibleNames count] > 0 )
    {
        [txtName setText:[NSString stringWithFormat:@"%@",[self.possibleNames objectAtIndex:0]]];
    }
    else
    {
        [txtName setText: @""];
    }
    
    if([self.possiblePhones count] > 0 )
    {
        [txtPhone setText:[NSString stringWithFormat:@"%@",[self.possiblePhones objectAtIndex:0]]];
    }
    else
    {
        [txtPhone setText: @""];
    }
    
     if([self.possibleTitles count] > 0 )
    {
        [txtTitle setText:[NSString stringWithFormat:@"%@",[self.possibleTitles objectAtIndex:0]]];
    }
    else
    {
        [txtTitle setText: @""];
    }
    */
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
