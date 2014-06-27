//
//  DescriptionViewController.h
//  TestNavigation311Project
//
//  Created by DeLisa Glover on 4/8/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface DescriptionViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, assign) id delegate;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarButtonItem;

@property NSString *descriptionValue;

- (IBAction)doneTapped:(id)sender;
- (IBAction)cancelTapped:(id)sender;
@end
