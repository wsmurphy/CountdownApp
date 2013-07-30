//
//  TimePickerViewController.m
//  TabbedCountdown
//
//  Created by Murphy, Stephen - William S on 12/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimePickerViewController.h"


@implementation TimePickerViewController

@synthesize timePicker;
@synthesize timeLabel;
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
    
    timePicker.date = [NSDate date];
    
}

- (void)viewDidUnload
{
    self.timePicker = nil;
    [self setTimeLabel:nil];
    [super viewDidUnload];
}

//Support only portrait mode
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)pickerValueChanged:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    timeLabel.text = [dateFormatter stringFromDate:[self dateWithZeroSeconds:timePicker.date]];
}

- (NSDate *)dateWithZeroSeconds:(NSDate *)date
{
    NSTimeInterval time = floor([date timeIntervalSinceReferenceDate] / 60.0) * 60.0;
    return  [NSDate dateWithTimeIntervalSinceReferenceDate:time];
}

- (IBAction)cancel:(id)sender
{
	[self.delegate timePickerViewControllerDidCancel:self];
}

//If done button is pressed, call didGetTime
- (IBAction)done:(id)sender
{
    [self.delegate timePickerViewController:self didGetTime:timePicker.date];
}

@end
