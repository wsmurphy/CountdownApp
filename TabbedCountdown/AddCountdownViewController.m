//
//  AddCountdownViewController.m
//  TabbedCountdown
//
//  Created by Murphy, Stephen - William S on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddCountdownViewController.h"
#import "Countdowns.h"

@implementation AddCountdownViewController

@synthesize delegate;
@synthesize titleTextField;
@synthesize chosenDate;
@synthesize dateDetailLabel;
@synthesize chosenTime;
@synthesize timeDetailLabel;

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

}

- (void)viewDidUnload
{
    [self setTitleTextField:nil];
    [self setDateDetailLabel:nil];
    [super viewDidUnload];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"datePicker"])
	{
		UINavigationController *navigationController = segue.destinationViewController;
		DatePickerViewController *datePickerViewController = 
        [[navigationController viewControllers] objectAtIndex:0];
		datePickerViewController.delegate = self;
        NSLog(@"DEBUG: delegate for datePicker set");
	}
    
    if ([segue.identifier isEqualToString:@"timePicker"])
	{
		UINavigationController *navigationController = segue.destinationViewController;
		TimePickerViewController *timePickerViewController =
        [[navigationController viewControllers] objectAtIndex:0];
		timePickerViewController.delegate = self;
        NSLog(@"DEBUG: delegate for timePicker set");
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0)
		[self.titleTextField becomeFirstResponder];
}

- (IBAction)cancel:(id)sender
{
	[self.delegate addCountdownViewControllerDidCancel:self];
}

- (IBAction)done:(id)sender
{
    Countdowns *countdown = [[Countdowns alloc] init];
	countdown.name = self.titleTextField.text;
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComps = [cal components:(NSYearCalendarUnit   |
                                                   NSMonthCalendarUnit  |
                                                   NSDayCalendarUnit) fromDate:self.chosenDate];
    NSDateComponents *timeComps = [cal components:(NSHourCalendarUnit   |
                                                   NSMinuteCalendarUnit |
                                                   NSSecondCalendarUnit ) fromDate:self.chosenTime];
    NSDateComponents *newDateComps = [[NSDateComponents alloc] init];
    [newDateComps setHour:timeComps.hour];
    [newDateComps setMinute:timeComps.minute];
    [newDateComps setDay:dateComps.day];
    [newDateComps setMonth:dateComps.month];
    [newDateComps setYear:dateComps.year];
    
    NSDate *newDate = [cal dateFromComponents:newDateComps];
    NSLog(@"New date is %@", newDate);
	countdown.targetDate = newDate;
	[self.delegate addCountdownViewController:self didAddCountdown:countdown];
}

#pragma mark - DatePickerViewControllerDelegate

-(void)datePickerViewController:(DatePickerViewController *)controller didGetDate:(NSDate *)date
{
    self.chosenDate = date;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    self.dateDetailLabel.text = [dateFormatter stringFromDate:date];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)datePickerViewControllerDidCancel:(DatePickerViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TimePickerViewControllerDelegate

-(void)timePickerViewController:(TimePickerViewController *)controller didGetTime:(NSDate *)time
{
    self.chosenTime = time;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    
    self.timeDetailLabel.text = [dateFormatter stringFromDate:time];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)timePickerViewControllerDidCancel:(TimePickerViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
