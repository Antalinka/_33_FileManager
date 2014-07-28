//
//  GRDirectoryViewController.h
//  _33_FileManagerTest
//
//  Created by Exo-terminal on 6/18/14.
//  Copyright (c) 2014 Evgenia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GRDirectoryViewController : UITableViewController

@property(strong,nonatomic)NSString* path;

-(id)initWithFolderPath:(NSString*) path;

-(IBAction)actionInfoCell:(UIButton*)sender;

@end
