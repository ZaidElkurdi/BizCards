//
//  cardCollectionViewController.m
//  Mitek Hackathon
//
//  Created by Zaid Elkurdi on 4/25/14.
//  Copyright (c) 2014 Tempest Vision. All rights reserved.
//

#import "cardCollectionViewController.h"
#import <Parse/Parse.h>
#import "detailViewController.h"
@interface cardCollectionViewController ()
{
    NSIndexPath *currEditingIndex;
    NSMutableData *webdata;
    NSArray *foundResults;
    NSArray *dataResults;
    NSDictionary *dictionary;
}
@end

@implementation cardCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *tempImages = [[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"localImages"]];
    
    NSMutableArray *tempInfo = [[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"localData"]];
    
    if(tempImages.count == 0 || tempInfo.count == 0)
    {
        NSLog(@"Loading data!");
        PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
        [query orderByAscending:@"createdAt"];
        
        foundResults = [query findObjects];
       
        for(PFObject *image in foundResults)
        {
            PFObject *image2 = image;
            
            PFFile *theImage = [image2 objectForKey:@"imageFile"];
            NSData *theImageData = [theImage getData];
            
            if(theImageData != NULL)
                [self.cardImages addObject:theImageData];
        }
        
        PFQuery *dataQuery = [PFQuery queryWithClassName:@"Card"];
        [dataQuery orderByAscending:@"createdAt"];
        
        dataResults = [dataQuery findObjects];
        
        for(PFObject *cardData in dataResults)
        {
            NSMutableDictionary *cardDict = [[NSMutableDictionary alloc] init];
            [cardDict setObject:[cardData objectForKey:@"Name"] forKey:@"Name"];
            [cardDict setObject:[cardData objectForKey:@"Email"] forKey:@"Email"];
            [cardDict setObject:[cardData objectForKey:@"Company"] forKey:@"Company"];
            [cardDict setObject:[cardData objectForKey:@"Phone"] forKey:@"Phone"];
            [cardDict setObject:[cardData objectForKey:@"Address"] forKey:@"Address"];
            [cardDict setObject:[cardData objectForKey:@"Title"] forKey:@"Title"];
            [cardDict setObject:[cardData objectForKey:@"Notes"] forKey:@"Notes"];
            [cardDict setObject:[cardData objectForKey:@"objectId"] forKey:@"parseID"];
            [self.cardInfo addObject:cardDict];
        }
        
        [prefs setObject:self.cardImages forKey:@"localImages"];
        [prefs setObject:self.cardInfo forKey:@"localData"];
        [prefs synchronize];
    }
    
    else
    {
        self.cardInfo = tempInfo;
        self.cardImages = tempImages;
        [self performSelectorInBackground:@selector(loadCardData) withObject:nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /* Init Table */
    CGRect tableFrame = CGRectMake(20, 40, 280, self.view.frame.size.height-40);
    self.cardCollectionTable = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped];
    
    self.cardCollectionTable.delegate = self;
    self.cardCollectionTable.dataSource = self;

    [self.cardCollectionTable setShowsHorizontalScrollIndicator:NO];
    [self.cardCollectionTable setShowsVerticalScrollIndicator:NO];

    UIColor *tableBGColor = [UIColor colorWithRed:219.0f/255.0f green:219.0f/255.0f blue:219.0f/255.0f alpha: 1.0];
    self.cardCollectionTable.backgroundColor = tableBGColor;
    
    [self.view addSubview:self.cardCollectionTable];
    [self setNeedsStatusBarAppearanceUpdate];
    
    
    /* Init swipe recognizer for deletion */
    UISwipeGestureRecognizer * swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(confirmDelete:)];
    [swipeRecognizer setDelegate:self];
    [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.cardCollectionTable addGestureRecognizer:swipeRecognizer];
    
    /* Init the card information and images */
    self.selectedCard = [businessCard alloc];
    self.cardImages = [[NSMutableArray alloc] init];
    self.cardInfo = [[NSMutableArray alloc] init];
    
    /* Set the status bar color and title */
    UIColor *barColor = [UIColor colorWithRed:29.0f/255.0f green:143.0f/255.0f blue:102.0f/255.0f alpha: 1.0];
    
    self.navigationController.navigationBar.barTintColor=barColor;
    
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    navTitle.text = @"Your Cards";
    navTitle.textColor = [UIColor whiteColor];
    UIFont *navFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:28.0];
    navTitle.font = navFont;
    navTitle.textAlignment = NSTextAlignmentCenter;
    [self.navigationController.navigationBar addSubview:navTitle];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{ 
    return UIStatusBarStyleLightContent; 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.cardImages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cardCollectionCellIdentifier";
    cardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell==nil)
    {
        cell = [[cardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell.cardImageView setImage:[UIImage imageWithData:[self.cardImages objectAtIndex:indexPath.section]]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return 35;
    return 10;
}

#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cardDict = [self.cardInfo objectAtIndex:indexPath.section];
    
    self.selectedCard.name = [cardDict objectForKey:@"Name"];
    self.selectedCard.email = [cardDict objectForKey:@"Email"];
    self.selectedCard.company = [cardDict objectForKey:@"Company"];
    self.selectedCard.phone = [cardDict objectForKey:@"Phone"];
    self.selectedCard.address = [cardDict objectForKey:@"Address"];
    self.selectedCard.title = [cardDict objectForKey:@"Title"];
    self.selectedCard.notes = [cardDict objectForKey:@"Notes"];
    self.selectedCard.parseID = [cardDict objectForKey:@"parseID"];
    self.selectedCard.imageData = [self.cardImages objectAtIndex:indexPath.section];

    [self performSegueWithIdentifier:@"toDetail" sender:tableView];
}

#pragma mark - Other methods
-(void)confirmDelete:(UIGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        CGPoint swipeLocation = [recognizer locationInView:self.cardCollectionTable];
        currEditingIndex = [self.cardCollectionTable indexPathForRowAtPoint:swipeLocation];
        UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:@"Confirm Delete" message:@"Are you sure you want to delete this card?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
        [deleteAlert show];
    
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [alertView cancelButtonIndex])
    {
        [self.cardImages removeObjectAtIndex:currEditingIndex.section];
        NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:currEditingIndex.section];
        [self.cardCollectionTable beginUpdates];
        [self.cardCollectionTable deleteSections:set withRowAnimation:UITableViewRowAnimationLeft];
        [self.cardCollectionTable endUpdates];
    }
    
    [alertView dismissWithClickedButtonIndex:1 animated:YES];
}

-(void)loadCardData
{
    NSMutableArray *tempCardImages = [[NSMutableArray alloc] init];
    NSMutableArray *tempCardInfo = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
    [query orderByAscending:@"createdAt"];

    foundResults = [query findObjects];

    for(PFObject *image in foundResults)
    {
        PFObject *image2 = image;

        PFFile *theImage = [image2 objectForKey:@"imageFile"];
        NSData *theImageData = [theImage getData];

        if(theImageData != NULL)
            [tempCardImages addObject:theImageData];
    }

    PFQuery *dataQuery = [PFQuery queryWithClassName:@"Card"];
    [dataQuery orderByAscending:@"createdAt"];

    dataResults = [dataQuery findObjects];

    for(PFObject *cardData in dataResults)
    {
        NSMutableDictionary *cardDict = [[NSMutableDictionary alloc] init];
        [cardDict setObject:[cardData objectForKey:@"Name"] forKey:@"Name"];
        [cardDict setObject:[cardData objectForKey:@"Email"] forKey:@"Email"];
        [cardDict setObject:[cardData objectForKey:@"Company"] forKey:@"Company"];
        [cardDict setObject:[cardData objectForKey:@"Phone"] forKey:@"Phone"];
        [cardDict setObject:[cardData objectForKey:@"Address"] forKey:@"Address"];
        [cardDict setObject:[cardData objectForKey:@"Title"] forKey:@"Title"];
        [cardDict setObject:[cardData objectForKey:@"Notes"] forKey:@"Notes"];
        [cardDict setObject:[cardData objectId] forKey:@"parseID"];
        
        [tempCardInfo addObject:cardDict];
    }
    
    /* Only reloads the table and sets new data if there has been a change */
    bool isChanged = [self compareOnlineAndLocal:tempCardInfo];
    if(isChanged)
    {
        self.cardInfo = tempCardInfo;
        self.cardImages = tempCardImages;
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:self.cardImages forKey:@"localImages"];
        [prefs setObject:self.cardInfo forKey:@"localData"];
        [prefs synchronize];
        
        [self.cardCollectionTable reloadData];
    }
}

- (bool)compareOnlineAndLocal:(NSMutableArray*)onlineInfo
{
    if(onlineInfo.count != self.cardInfo.count)
        return true;
    
    for(int i=0; i<onlineInfo.count; i++)
    {
        NSDictionary *currOnlineDict = [onlineInfo objectAtIndex:i];
        NSDictionary *currLocalDict = [self.cardInfo objectAtIndex:i];
        
        if(currOnlineDict.count != currLocalDict.count)
            return true;
        
        NSArray *onlineValues = [currOnlineDict allValues];
        NSArray *localValues = [currLocalDict allValues];
        
        for(int j=0; j<onlineValues.count; j++)
        {
            NSString *currOnlineValue = [onlineValues objectAtIndex:j];
            NSString *currLocalValue = [localValues objectAtIndex:j];

            if(![currOnlineValue isEqualToString:currLocalValue])
                return true;
        }
    }
    
    return false;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toDetail"])
    {
        NSLog(@"Here");
        UINavigationController *nav = [segue destinationViewController];
        detailViewController *detailView = (detailViewController*)nav.topViewController;
        [detailView initWithCard:self.selectedCard];
    }
}
@end
