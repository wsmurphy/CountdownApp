//
//  DatePickerViewController.m
//  TabbedCountdown
//
//  Created by Murphy, Stephen - William S on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DatePickerViewController.h"


@implementation DatePickerViewController

@synthesize datePicker;
@synthesize dateLabel;
@synthesize delegate;

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

    datePicker.date = [NSDate date];

}

- (void)viewDidUnload
{
    self.datePicker = nil;
    [self setDateLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)pickerValueChanged:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    dateLabel.text = [dateFormatter stringFromDate:datePicker.date];
}

- (IBAction)cancel:(id)sender
{
	[self.delegate datePickerViewControllerDidCancel:self];
}

- (IBAction)done:(id)sender
{
    [self.delegate datePickerViewController:self didGetDate:datePicker.date];  
}

@end
