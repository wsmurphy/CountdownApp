//
//  TimePickerViewController.h
//  TabbedCountdown
//
//  Created by Murphy, Stephen - William S on 12/14/12.
//
//

#import <UIKit/UIKit.h>

@class TimePickerViewController;


@protocol TimePickerViewControllerDelegate <NSObject>

- (void)timePickerViewControllerDidCancel:(TimePickerViewController *)controller;
- (void)timePickerViewController:(TimePickerViewController*)controller didGetTime:(NSDate *)date;

@end


@interface TimePickerViewController : UITableViewController

@property (assign) id <TimePickerViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIDatePicker* timePicker;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

- (IBAction)pickerValueChanged:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end