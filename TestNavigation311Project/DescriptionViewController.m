//
//  DescriptionViewController.m
//  TestNavigation311Project
//
//  Created by DeLisa Glover on 4/8/13.
//  Copyright (c) 2013 Seminole County Government. All rights reserved.
//

#import "DescriptionViewController.h"
#import "NewReportTableViewController.h"

@interface DescriptionViewController ()

@end

@implementation DescriptionViewController

NSString * tempString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[self.descriptionTextView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.descriptionTextView layer] setBorderWidth:1];
    [[self.descriptionTextView layer] setCornerRadius:5];
    if (![_descriptionValue isEqualToString:@"Description"])
        self.descriptionTextView.text = _descriptionValue;
    
    self.descriptionTextView.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidChange:(UITextView *)textView{
    
    tempString = [_descriptionTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //replaces all whitespace
    
    if (tempString.length != 0)
    {
        _doneBarButtonItem.enabled = YES;
    }
    else
    {
        _doneBarButtonItem.enabled = NO;
    }
}

- (IBAction)doneTapped:(id)sender
{
    [self.descriptionTextView resignFirstResponder];
    [self.delegate setDescription:_descriptionTextView.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
