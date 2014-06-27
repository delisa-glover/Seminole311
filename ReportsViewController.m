//
//  ReportsTableViewController.m
//  TestNavigation311Project
//
//  Created by DeLisa Glover on 5/24/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import "ReportsViewController.h"
#import "CategoryViewController.h"
#import "ReportDetailsViewController.h"
#import "SVProgressHUD.h"
#import "Reachability.h"
#import "LocalDataStorage.h"
#import "NewReport.h"
#import "Category.h"

@interface ReportsViewController ()

@end

@implementation ReportsViewController

NSMutableArray *categories;
NSMutableArray *tempArray;

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
    
    if (_reports.count == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"No Reports Found"
                                                       message: @"Tap '+' above to create a problem report."
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        
        
        [alert show];
    }
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
    if (self.reports.count == 0)
        return 3;
    return [self.reports count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView
                            dequeueReusableCellWithIdentifier:@"ReportCell"];
    
    if (_reports.count == 0)
    {
        if (indexPath.row == 2)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReportCellDefault"] ;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.text = @"No Reports";
            cell.textLabel.textColor = [UIColor grayColor];
            cell.textLabel.alpha = 0.5;
            cell.userInteractionEnabled = NO;
        }
        else{
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReportCellDefault"] ;
            cell.userInteractionEnabled = NO;
        }
        
    }
    else
    {
        NewReport *report = [self.reports objectAtIndex:indexPath.row];
        cell.textLabel.text = report.subCategoryName;
        cell.detailTextLabel.text = report.description;
        cell.imageView.image = report.reportImage;
    
    }
    
    return cell;
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
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ReportPushed"])
    {
        NewReport *report = [self.reports objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        
        ReportDetailsViewController *reportDetailsController = segue.destinationViewController;
        reportDetailsController.report = report;
    }
    else if ([[segue identifier] isEqualToString:@"NewReportPushed"])
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[LocalDataStorage categoriesFileName] ]) {
            
            UIImage *categoryImage;
            NSMutableArray *categories;
            NSMutableArray *tempArray;
            
            categories = [@[] mutableCopy];
            tempArray = [@[] mutableCopy];
            tempArray = [NSMutableArray arrayWithContentsOfFile:[LocalDataStorage categoriesFileName]];
            
            for(NSMutableDictionary *objCategory in tempArray)
            {
                categoryImage = [UIImage imageWithData:objCategory[@"CategoryImageData"]];
                
                
                Category *category = [[Category alloc] initWithTitle:objCategory[@"Name"] categoryID:[objCategory[@"ID"] intValue] photoURL:[objCategory[@"Icon"] stringByReplacingOccurrencesOfString:@"\\" withString:@""] categoryImage:categoryImage subCategoryMessage:objCategory[@"SubCategoryMessage"]];
                
                [categories addObject:category];
            }
            CategoryViewController *categoryController = segue.destinationViewController;
            categoryController.categories = categories;
        }
    }
}

- (IBAction)newReportTapped:(id)sender
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[LocalDataStorage categoriesFileName] ]) {
        [self performSegueWithIdentifier:@"NewReportPushed"
                                  sender:self];
        
    }
    else if (networkStatus == NotReachable)
    {
        [SVProgressHUD showErrorWithStatus:@"Network Connection Required"];
    }
    else
    {
        [SVProgressHUD showWithStatus:@"Loading Categories"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [LocalDataStorage loadCategories];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(checkCategoryFileExists) userInfo:nil repeats:NO];
                
            });
        });
        
    }

}

- (void)checkCategoryFileExists
{
    [SVProgressHUD dismiss];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[LocalDataStorage categoriesFileName] ]) {
        [self performSegueWithIdentifier:@"NewReportPushed"
                                  sender:self];
    }
    else{
        [SVProgressHUD showErrorWithStatus:@"Slow Data Connection...Try Again"];
    }
}
@end
