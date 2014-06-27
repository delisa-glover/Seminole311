//
//  CategoryViewController.m
//  TestNavigation311Project
//
//  Created by DeLisa Glover on 2/28/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import "CategoryViewController.h"
#import "SubcategoryViewController.h"
#import "Category.h"
#import "Subcategory.h"
#import "SVProgressHUD.h"
#import "Reachability.h"
#import "LocalDataStorage.h"

@interface CategoryViewController ()

@end

@implementation CategoryViewController

NSMutableArray *subCategories;

Reachability *networkReachability;
NetworkStatus networkStatus;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [self.categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:@"CategoryCell"];
    Category *category = [self.categories objectAtIndex:indexPath.row];
    cell.textLabel.text = category.title;
    cell.imageView.image = category.categoryImage;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SubcategoryViewController *subCategoryController = segue.destinationViewController;
    subCategoryController.subCategories = subCategories;


}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    Category *category = [self.categories objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    
    if (![category.subCategoryMessage length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Please Note:"
                                                       message: category.subCategoryMessage
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        
        
        [alert show];
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[LocalDataStorage subcategoriesFileName] ]) {
        
        [self loadSubCategories:category.categoryID categoryImage:category.categoryImage];
    }
    else if (networkStatus == NotReachable)
    {
        [SVProgressHUD showErrorWithStatus:@"Network Connection Required"];
    }
    else
    {
        [SVProgressHUD showWithStatus:@"Loading Subcategories"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [LocalDataStorage loadSubCategories];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(checkFileExists) userInfo:nil repeats:NO];
                
            });
        });
        
    }
}

- (void)checkFileExists
{
    [SVProgressHUD dismiss];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[LocalDataStorage subcategoriesFileName] ]) {
        [self performSegueWithIdentifier:@"CategoryPushed"
                                  sender:self];
    }
    else{
        [SVProgressHUD showErrorWithStatus:@"Slow Data Connection...Try Again"];
    }
}

- (void)loadSubCategories:(int)categoryID categoryImage:(UIImage *)categoryImage
{
    NSMutableArray *tempSubCategoryArray =[@[] mutableCopy];
    
    subCategories = [@[] mutableCopy];
    
    tempSubCategoryArray = [NSMutableArray arrayWithContentsOfFile:[LocalDataStorage subcategoriesFileName]];
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"ParentCategoryID = %d", categoryID];
    NSArray *filtered = [tempSubCategoryArray filteredArrayUsingPredicate:filter];
    NSLog(@"found matches: %d", filtered.count);
    
    if (filtered.count > 0) //subcategories found in local storage
    {
        for(NSMutableDictionary *objSubCategory in filtered)
        {
            Subcategory *subCategory = [[Subcategory alloc] initWithTitle:objSubCategory[@"Name"] subCategoryID:[objSubCategory[@"ID"] intValue] subCategoryImage:categoryImage];
            
            [subCategories addObject:subCategory];
        }
        [self performSegueWithIdentifier:@"CategoryPushed"
                                  sender:self];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"Subcategories Missing...Choose Another Category"];
       
    }
    
}



@end
