//
//  GRDirectoryViewController.m
//  _33_FileManagerTest
//
//  Created by Exo-terminal on 6/18/14.
//  Copyright (c) 2014 Evgenia. All rights reserved.
//

#import "GRDirectoryViewController.h"
#import "GRFileCell.h"
#import "UIView+UITableViewCell.h"

@interface GRDirectoryViewController ()


@property(strong, nonatomic)NSArray* contents;
@property(strong, nonatomic)NSString* selectedPath;

@end
@implementation GRDirectoryViewController

-(id)initWithFolderPath:(NSString*) path
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        self.path = path;
        
       }
    
    return self;
}


-(void) setPath:(NSString *)path{
    
    _path = path;
    NSError* error = nil;
    
    self.contents = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:path error:&error];
    
    if (error) {
        NSLog(@"error %@",[error localizedDescription]);
    }
    
    [self.tableView reloadData];
    
     self.navigationItem.title = [self.contents lastObject];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.path) {
        self.path = @"/Users/EXO-terminal/Desktop/ios-vkontakte";
    }
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if ([self.navigationController.viewControllers count] > 1) {
        
        UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithTitle:@"back to root"
                                                                style:UIBarButtonItemStylePlain target:self action:@selector(actionBackToRoot:)];
        
        self.navigationItem.rightBarButtonItem = item;
    }

}

-(void)dealloc{
    
//    NSLog(@"controller with path %@ has been dealocated", self.path);
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    NSLog(@"path = %@",self.path);
//    NSLog(@"view controllers stack = %lu",(unsigned long)[self.navigationController.viewControllers count]);
//    NSLog(@"index on stack - %lu",[self.navigationController.viewControllers indexOfObject:self]);
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    self.navigationItem.title = [self.path lastPathComponent];
}

-(BOOL)isDirectoryAtIndexPath:(NSIndexPath*)indexPath{
    
    NSString* fileName = [self.contents objectAtIndex:indexPath.row];
    
    NSString* filePath = [self.path stringByAppendingPathComponent:fileName];
    
    BOOL isDirectory = NO;
    
    [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
    
    return isDirectory;
}

-(void)actionBackToRoot:(UIBarButtonItem*)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(IBAction)actionInfoCell:(UIButton*)sender{
    NSLog(@"action Info"); 
    
    UITableViewCell* cell = [sender superCell];
    
    if (cell) {
        NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
        
        [[[UIAlertView alloc]initWithTitle:@"Yahoo"
                                 message:[NSString stringWithFormat:@"%ld %ld", (long)indexPath.section, (long)indexPath.row]
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles: nil]show];
        
//        NSLog(@"%ld %ld", (long)indexPath.section, indexPath.row);
    }
} 

-(NSString*)fileSizeFromValue:(unsigned long long)size{
    
    static NSString* units[] = {@"B", @"KB", @"MB", @"TB"};
    static NSInteger unitCount = 5;
    
    int index = 0;
    
    double  fileSize = (double)size;
    while (size > 1024 && index < unitCount) {
        fileSize /= 1024;
        index++;
    }
    return [NSString stringWithFormat:@"%.2f %@",fileSize,units[index]];
    
}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contents count ];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* folderIdentifier = @"folderIdentifier";
    static NSString* fileIdentifier = @"fileCell";

    NSString* fileName = [self.contents objectAtIndex:indexPath.row];
    
    if ([self isDirectoryAtIndexPath:indexPath]) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:folderIdentifier ];
        cell.textLabel.text = fileName;
        
        return cell;

    }else{
        
        NSString* path = [self.path stringByAppendingPathComponent:fileName];
        
        NSDictionary* attribute = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
        
        GRFileCell *cell = [tableView dequeueReusableCellWithIdentifier:fileIdentifier ];
        
        cell.nameLabel.text = fileName;
        cell.sizeLabel.text = [self fileSizeFromValue:[attribute fileSize]];
        
        static NSDateFormatter* dateFormatter = nil;
        
        if (!dateFormatter) {
            dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm a"];
        }
        
        cell.dataLabel.text = [dateFormatter stringFromDate:[attribute fileModificationDate]];
        
//        NSLog(@"%lld",[attribute fileSize]);
//        NSLog(@"%@",[attribute fileModificationDate]);
        
        return cell;

    }
    return nil;
 }


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self isDirectoryAtIndexPath:indexPath]) {
        
        NSString* fileName = [self.contents objectAtIndex:indexPath.row];
        NSString* filePath = [self.path stringByAppendingPathComponent:fileName];
        
//        GRDirectoryViewController* vc = [[GRDirectoryViewController alloc]initWithFolderPath:filePath];
//        [self.navigationController pushViewController:vc animated:YES];
        
       /* UIStoryboard* storyboad = self.storyboard;
        GRDirectoryViewController* vc = [storyboad instantiateViewControllerWithIdentifier:@"GRDirectoryViewController"];
        vc.path = filePath;
        
        [self.navigationController pushViewController:vc animated:YES];*/
        
        self.selectedPath = filePath;
        
        [self performSegueWithIdentifier:@"navigateDeep" sender:nil];
        
    } 
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self isDirectoryAtIndexPath:indexPath]) {
        return 44.f;
    }else{
        return 80.f;
    }
    
}

#pragma mark - Segue

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    GRDirectoryViewController* vc = segue.destinationViewController;
    vc.path = self.selectedPath;
}


@end
