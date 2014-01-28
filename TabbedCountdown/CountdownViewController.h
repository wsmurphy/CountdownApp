//
//  CountdownViewController.h
//  Countdown
//
//  Created by Murphy, Stephen - William S on 3/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Countdown.h"

@class CountdownViewController;

@protocol CountdownViewControllerDelegate <NSObject>

- (void)countdownViewControllerDidCancel:(CountdownViewController *)controller;

@end

@interface CountdownViewController : UIViewController <UITextFieldDelegate, UIActionSheetDelegate>

@property (assign) id <CountdownViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *targetLabel;

@property (strong, nonatomic) IBOutlet UIView *expiredView;

@property (weak, nonatomic) Countdown *countdown;

- (IBAction)showFullDate:(id)sender;

-(IBAction)actionSheetButtonPressed:(id)sender;

- (void)fbButtonPressed;

- (void)twtrButtonPressed;

@end
