//
//  AddCountdownViewController.m
//  TabbedCountdown
//
//  Created by Murphy, Stephen - William S on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddCountdownViewController.h"
#import "Countdown.h"

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
    
    [self.tableView setBackgroundView:nil];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.0 green:214.0/256.0 blue:151.0/256.0 alpha:1.0];
    
    [self addTapGesture];

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
    Countdown *countdown = [[Countdown alloc] init];
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

    countdown.untilText = self.untilField.text;
    
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
    self.chosenTime = [self dateWithZeroSeconds:time];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:kCFDateFormatterShortStyle];
    
    self.timeDetailLabel.text = [dateFormatter stringFromDate:time];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)timePickerViewControllerDidCancel:(TimePickerViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSDate *)dateWithZeroSeconds:(NSDate *)date
{
    NSTimeInterval time = floor([date timeIntervalSinceReferenceDate] / 60.0) * 60.0;
    return  [NSDate dateWithTimeIntervalSinceReferenceDate:time];
}


#pragma mark - Private
- (void)addTapGesture
{
    // Add a tap gesture to the view to hide the keyboard if the user taps outside of it
    UITapGestureRecognizer *tapView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
    tapView.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapView];
}

- (void)closeKeyboard
{
    [self.view endEditing:YES];
}



@end
