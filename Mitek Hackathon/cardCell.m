//
//  cardCell.m
//  Mitek Hackathon
//
//  Created by Zaid Elkurdi on 4/25/14.
//  Copyright (c) 2014 Tempest Vision. All rights reserved.
//

#import "cardCell.h"

@implementation cardCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initCell];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)initCell
{
    CGRect imageFrame = CGRectMake(0, 0, 280, 150);
    self.cardImageView = [[UIImageView alloc] initWithFrame:imageFrame];
    [self addSubview:self.cardImageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
