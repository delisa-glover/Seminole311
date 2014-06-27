//
//  NewReportTableViewController.h
//  TestNavigation311Project
//
//  Created by DeLisa Glover on 3/29/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "LocationAnnotation.h"
#import "Reporter.h"
#import "NewReport.h"

@class NewReport;
@class ChoosePhotoViewController;

@interface NewReportTableViewController : UITableViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NewReport *myReport;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *reporterLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *addPhotoButton;
@property (weak, nonatomic) IBOutlet UILabel *addPhotoLabel;

@property (strong, nonatomic) UIImagePickerController * picker;
@property (nonatomic, strong) UIPopoverController *popOver;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *submitBarButtonItem;

@property BOOL newMedia;
@property (assign) int subCategoryID;
@property (strong) NSString *subCategoryName;

- (void)takePhotoTapped:(id)sender;
- (void)chooseExistingPhotoTapped:(id)sender;
- (IBAction)addPhotoTapped:(id)sender;
- (IBAction)submitTapped:(id)sender;
- (IBAction)cancelTapped:(id)sender;

- (void)setLocation:(LocationAnnotation *)annotation;
- (void)setDescription:(NSString *)text;
- (void)setReporter:(Reporter *) reporter;


@end
