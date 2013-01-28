//
//  DatePickerViewController.h
//  TabbedCountdown
//
//  Created by Murphy, Stephen - William S on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DatePickerViewController;


@protocol DatePickerViewControllerDelegate <NSObject>

    - (void)datePickerViewControllerDidCancel:(DatePickerViewController *)controller;
    - (void)datePickerViewController:(DatePickerViewController*)controller didGetDate:(NSDate *)date;

@end

@interface DatePickerViewController : UITableViewController

    @property (assign) id <DatePickerViewControllerDelegate> delegate;
    @property (nonatomic, retain) IBOutlet UIDatePicker* datePicker;
    @property (strong, nonatomic) IBOutlet UILabel *dateLabel;


    - (IBAction)pickerValueChanged:(id)sender;
    - (IBAction)cancel:(id)sender;
    - (IBAction)done:(id)sender;

@end