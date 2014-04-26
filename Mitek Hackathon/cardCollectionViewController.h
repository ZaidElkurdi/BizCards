//
//  cardCollectionViewController.h
//  Mitek Hackathon
//
//  Created by Zaid Elkurdi on 4/25/14.
//  Copyright (c) 2014 Tempest Vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cardCell.h"
#import <Parse/Parse.h>

@interface cardCollectionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic,strong) UITableView *cardCollectionTable;
@property (nonatomic,strong) NSMutableArray *cardData;
@end
