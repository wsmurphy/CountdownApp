//
//  AddCountdownViewController.h
//  TabbedCountdown
//
//  Created by Murphy, Stephen - William S on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerViewController.h"
#import "TimePickerViewController.h"

@class AddCountdownViewController;
@class Countdowns;

@protocol AddCountdownViewControllerDelegate <NSObject>

    - (void)addCountdownViewControllerDidCancel:(AddCountdownViewController *)controller;
    - (void)addCountdownViewController:(AddCountdownViewController *)controller didAddCountdown:(Countdowns *)countdown;
@end

@interface AddCountdownViewController : UITableViewController <DatePickerViewControllerDelegate, TimePickerViewControllerDelegate>

    @property (assign) id <AddCountdownViewControllerDelegate> delegate;
    @property (strong, nonatomic) IBOutlet UITextField *titleTextField;
    @property (strong, nonatomic) NSDate *chosenDate;
    @property (strong, nonatomic) IBOutlet UILabel *dateDetailLabel;
    @property (strong, nonatomic) NSDate *chosenTime;
    @property (strong, nonatomic) IBOutlet UILabel *timeDetailLabel;
    - (IBAction)cancel:(id)sender;
    - (IBAction)done:(id)sender;

@end
