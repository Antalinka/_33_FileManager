//
//  GRFileCell.m
//  _33_FileManagerTest
//
//  Created by Exo-terminal on 6/19/14.
//  Copyright (c) 2014 Evgenia. All rights reserved.
//

#import "GRFileCell.h"

@implementation GRFileCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
