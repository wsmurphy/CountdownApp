//
//  CountdownViewController.h
//  Countdown
//
//  Created by Murphy, Stephen - William S on 3/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CountdownViewController;

@protocol CountdownViewControllerDelegate <NSObject>

- (void)countdownViewControllerDidCancel:(CountdownViewController *)controller;

@end

@interface CountdownViewController : UIViewController <UITextFieldDelegate> {
    
    __weak IBOutlet UILabel *myCountdownMins;
    __weak IBOutlet UILabel *myCountdownDays;
}

@property (assign) id <CountdownViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *myCountdownDays;
@property (weak, nonatomic) IBOutlet UILabel *myCountdownMins;
@property (weak, nonatomic) IBOutlet UILabel *myCountdownHours;
@property (weak, nonatomic) IBOutlet UILabel *myCountdownSeconds;

@property (weak, nonatomic) IBOutlet UILabel *targetLabel;

@property (strong, nonatomic) IBOutlet UIView *expiredView;

@property (nonatomic, retain) NSDate *targetDate;

- (IBAction)showFullDate:(id)sender;

- (void)drawRect;

@end
