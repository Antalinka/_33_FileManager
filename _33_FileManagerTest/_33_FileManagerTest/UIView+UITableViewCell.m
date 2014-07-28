//
//  UIView+UITableViewCell.m
//  _33_FileManagerTest
//
//  Created by Exo-terminal on 6/19/14.
//  Copyright (c) 2014 Evgenia. All rights reserved.
//

#import "UIView+UITableViewCell.h"

@implementation UIView (UITableViewCell)


-(UITableViewCell*)superCell{
    if (!self.superview) {
        return nil;
    }
    
    if([self.superview isKindOfClass:[UITableViewCell class]]){
        
        return (UITableViewCell*)self.superview;
    }
    
    return [self.superview superCell];
}
@end
