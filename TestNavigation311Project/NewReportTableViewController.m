//
//  NewReportTableViewController.m
//  TestNavigation311Project
//
//  Created by DeLisa Glover on 3/29/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import "NewReportTableViewController.h"
#import "DescriptionViewController.h"
#import "UpdateAccountViewController.h"
#import "LoginViewController.h"
#import "LocationViewController.h"
#import "SVProgressHUD.h"
#import "Reachability.h"
#import "LocalDataStorage.h"
#import "NewReport.h"

@interface NewReportTableViewController ()
    
@end

@implementation NewReportTableViewController

UIActionSheet *_addPhotoActionSheet;

Reachability *networkReachability;
NetworkStatus networkStatus;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _myReport = [NewReport alloc];
    
    _myReport.subCategoryID = _subCategoryID;
    _myReport.subCategoryName = _subCategoryName;
    
    _myReport.reporterInfo = [Reporter alloc];
    
    [_myReport.reporterInfo loadFromSandbox];
    _reporterLabel.text = _myReport.reporterInfo.fullName;
    
}
- (void) viewWillAppear:(BOOL)animated
{
    //NSLog(@"View will appear");
}
- (void)viewDidAppear:(BOOL)animated
{
    //NSLog(@"View did appear");
    
    //Prompt for address if not set
    if (_myReport.reporterInfo.fullName.length > 0 && _myReport.reporterInfo.address.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Address Needed"
                                       message: @"Select 'Find My Address' on the next screen."
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
    return 4;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
}*/

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:@"Location"]){
        
        LocationViewController *vc = segue.destinationViewController;
        vc.locationValue = self.locationLabel.text;
        vc.subCategoryName = self.myReport.subCategoryName;
        [vc setDelegate:self];
        
    }
    else if([segue.identifier isEqualToString:@"Description"]){
        
        DescriptionViewController *vc = segue.destinationViewController;
        vc.descriptionValue = self.descriptionLabel.text;
        [vc setDelegate:self];
        
    }
    else if([segue.identifier isEqualToString:@"Reporter"]){
        
        UpdateAccountViewController *vc = segue.destinationViewController;
        vc.itemReporter = _myReport.reporterInfo;
        [vc setDelegate:self];
        
    }
    
    

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Yes"])
    {
        //NSLog(@"Cancelling report.");
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if([title isEqualToString:@"No"])
    {
        //NSLog(@"Proceed with report.");
        
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
    else if([title isEqualToString:@"OK"])
    {
        //NSLog(@"Show reporter information scene.");
        
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        
        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        
    }
}

#pragma mark - Button Taps
- (IBAction)cancelTapped:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Report Not Sent"
                                        message: @"Do you want to cancel the report?"
                                        delegate: self
                                        cancelButtonTitle:@"No"
                                        otherButtonTitles:@"Yes", nil];
    
    
    [alert show];    
}

- (IBAction)submitTapped:(id)sender
{    
    __block NSArray *keys;
    __block NSArray *objects;
    
    if (networkStatus == NotReachable)
    {
        [SVProgressHUD showErrorWithStatus:@"Network Connection Required"];
    }
    else
    {
        // save report to local storage
        [LocalDataStorage saveReport:_myReport];
        
        //save report to database
        
        [SVProgressHUD showWithStatus:@"Saving Report" maskType:SVProgressHUDMaskTypeBlack];
        
        NSURL *url = [NSURL URLWithString:@"http://mobilews.seminolecountyfl.gov/Service1.svc/SaveProblemReport"];
        
        NSLog(@"Save Report Url %@", url);
        
        __block NSError *errorReturned;
        
        //Get reporter's address
        NSString *reportersAddress = [NSString stringWithFormat: @"%@, %@, %@, %@ %@", _myReport.reporterInfo.address, _myReport.reporterInfo.address2, _myReport.reporterInfo.city, _myReport.reporterInfo.state, _myReport.reporterInfo.zipCode];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (_myReport.reportImage != nil)
            {
                keys = [NSArray arrayWithObjects:@"ReporterName", @"ReporterEmail", @"ReporterAddress", @"ReporterPhoneNumber", @"ReporterDeviceID", @"Description", @"LocationLatitude", @"LocationLongitude", @"LocationFullAddress", @"SubcategoryID", @"Photo", nil];
                
                //store photo in a byte [] since that is what web service expects
                //not as efficient as base 64, may upgrade to using base 64 in the future
                NSData *photoData = UIImageJPEGRepresentation(_myReport.reportImage, 0.3);
                const unsigned char *bytes = [photoData bytes];
                NSUInteger length = [photoData  length];
                NSMutableArray *byteArray = [NSMutableArray array];
                
                for (NSUInteger i = 0; i < length; i++) {
                    [byteArray addObject:[NSNumber numberWithUnsignedChar:bytes[i]]];
                }
                
                objects = [NSArray arrayWithObjects:_myReport.reporterInfo.fullName, _myReport.reporterInfo.emailAddress, reportersAddress, _myReport.reporterInfo.phoneNumber, _myReport.reporterInfo.deviceID, _myReport.description, [[NSNumber numberWithDouble:_myReport.location.coordinate.latitude] stringValue], [[NSNumber numberWithDouble:_myReport.location.coordinate.longitude] stringValue], _myReport.location.subtitle, [NSNumber numberWithInt:_myReport.subCategoryID], byteArray, nil];
            }
            else
            {
                keys = [NSArray arrayWithObjects:@"ReporterName", @"ReporterEmail", @"ReporterAddress", @"ReporterPhoneNumber", @"ReporterDeviceID", @"Description", @"LocationLatitude", @"LocationLongitude", @"LocationFullAddress", @"SubcategoryID", nil];
                
                
                
                objects = [NSArray arrayWithObjects:_myReport.reporterInfo.fullName, _myReport.reporterInfo.emailAddress, reportersAddress, _myReport.reporterInfo.phoneNumber, _myReport.reporterInfo.deviceID, _myReport.description, [[NSNumber numberWithDouble:_myReport.location.coordinate.latitude] stringValue], [[NSNumber numberWithDouble:_myReport.location.coordinate.longitude] stringValue], _myReport.location.subtitle, [NSNumber numberWithInt:_myReport.subCategoryID],  nil];
            }
            
            
            NSData *__jsonData = nil;
            NSString *__jsonString = nil;
            
            
            NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
            
            if([NSJSONSerialization isValidJSONObject:jsonDictionary])
            {
                __jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:nil];
                __jsonString = [[NSString alloc]initWithData:__jsonData encoding:NSUTF8StringEncoding];
            }
            
            // Be sure to properly escape your url string.
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody: __jsonData];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:[NSString stringWithFormat:@"%d", [__jsonData length]] forHTTPHeaderField:@"Content-Length"];
            
            errorReturned = nil;
            NSURLResponse *theResponse =[[NSURLResponse alloc]init];
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&errorReturned]; //ignore warning
            
            if (errorReturned)
            {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"Failed with error: %@", errorReturned.localizedDescription]];                    
                });
            }
            else{
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showSuccessWithStatus:@"Report Sent"];
                    [self performSegueWithIdentifier:@"UnwindToMenu"
                                              sender:self];
                });
            }
            
        });
        
        
    }
    
}

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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:@"ReportReporterCell"])
    {
        if (_reporterLabel.text.length == 0)  
        {
            NSString * storyboardName = @"MainStoryboard_iPhone";
            NSString * viewControllerID = @"LoginViewController";
            UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
            LoginViewController * controller = (LoginViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
            [controller setDelegate:self];
            [self presentViewController:controller animated:YES completion:nil];
            

        }
        else
        {
            NSString * storyboardName = @"MainStoryboard_iPhone";
            NSString * viewControllerID = @"UpdateAccountViewController";
            UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
            UpdateAccountViewController * controller = (UpdateAccountViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
            controller.itemReporter = _myReport.reporterInfo;
            [controller setDelegate:self];
            [self presentViewController:controller animated:YES completion:nil];
            
    
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Action Sheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"Take Photo"]) {
        [self takePhotoTapped:_addPhotoButton];
    }
    else if ([buttonTitle isEqualToString:@"Choose Existing Photo"]) {
        [self chooseExistingPhotoTapped:_addPhotoButton];
    }
    else  {
        //NSLog(@"Cancel pressed");
    }
    
    
}

#pragma mark - Image Capture methods

- (IBAction)addPhotoTapped:(id)sender{
       
    _addPhotoActionSheet = [[UIActionSheet alloc]
                    initWithTitle:@"Select a Photo"
                    delegate:self
                    cancelButtonTitle:@"Cancel"
                    destructiveButtonTitle:nil 
                    otherButtonTitles:@"Take Photo", @"Choose Existing Photo", nil];
    
	[_addPhotoActionSheet showFromRect:self.addPhotoButton.frame inView:self.view animated:YES];

}


- (void)takePhotoTapped:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
        _newMedia = YES;
    }
    
}

- (void)chooseExistingPhotoTapped:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            _popOver = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
            _popOver.delegate = self;
            
           // [_popOver
           //  presentPopoverFromBarButtonItem:sender
          //   permittedArrowDirections:UIPopoverArrowDirectionUp
          //   animated:YES];
            [_popOver presentPopoverFromRect:[sender bounds]
                                inView:sender
              permittedArrowDirections:UIPopoverArrowDirectionAny
                              animated:YES];
            //[popover presentPopoverFromRect:self.imageView.bounds inView:self.imageView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            // self.popOver = _popOver;
        }
        else {
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        //[self presentViewController:imagePicker animated:YES completion:nil];
        _newMedia = NO;
    }

}

#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [_popOver dismissPopoverAnimated:true];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        _imageView.image = image;
        _myReport.reportImage = [self image:image scaledToSize:CGSizeMake(image.size.width*.25,image.size.height*.25)];
        
        if (_newMedia)
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
        _addPhotoLabel.text = @"Update Photo";
        _addPhotoLabel.textAlignment = NSTextAlignmentCenter;
        _addPhotoLabel.textColor = [UIColor whiteColor];
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
		// Code here to support video if enabled
	}
}

-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save Failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage*) image:(UIImage *) image scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1);
    CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(), kCGInterpolationHigh);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

# pragma mark Set Report objects
- (void)setLocation:(LocationAnnotation *)annotation{
    if (annotation.subtitle.length == 0)
        annotation.subtitle = @"";
    self.locationLabel.text = annotation.subtitle;
    _myReport.location = annotation;
    
    [self validateForm];
}

- (void)setDescription:(NSString *)text{
    self.descriptionLabel.text = text;
    _myReport.description = text;
    
    [self validateForm];

}

- (void)setReporter:(Reporter *) reporter{
    self.reporterLabel.text = reporter.fullName;
    self.myReport.reporterInfo = reporter;
    
    [self validateForm];

}

-(void)validateForm
{
    _submitBarButtonItem.enabled = NO;
    
    if (_locationLabel.text.length > 0 && ![_locationLabel.text isEqualToString:@"Location"])
        if (_descriptionLabel.text.length > 0 && ![_descriptionLabel.text isEqualToString:@"Description"])
            if (_reporterLabel.text.length > 0)
            {
                _submitBarButtonItem.enabled = YES;
            }
}

@end
