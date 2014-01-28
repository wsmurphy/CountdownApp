//
//  CountdownViewController.m
//  Countdown
//
//  Created by Murphy, Stephen - William S on 3/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CountdownViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Social/Social.h>
#import <EventKit/EventKit.h>

@interface CountdownViewController ()
{
    NSTimer *timer;
    UIView *secondsView;
    BOOL showing;
    NSDateFormatter *formatter;
}
@end

@implementation CountdownViewController

NS_ENUM(NSInteger, sharingOptions) {
    kFacebookSharingAction = 0,
    kTwitterSharingAction,
    kAddToCalendarAction,
    kAddReminderAction
};

- (NSTimeInterval)getIntervalInSeconds {

    NSTimeInterval since = [self.countdown.targetDate timeIntervalSinceNow];
    return since;
    
}

- (void)updateCounter:(NSTimer *)theTimer {

    NSTimeInterval since = [self getIntervalInSeconds];
    int days = since / 86400;
    int remHours = ((int)since % 86400) / 3600;
    int remMins = (((int)since % 86400) % 3600) / 60;
    int remSecs = (((int)since % 86400) % 3600) % 60;
    
    if(days > 1) {
        self.dateTimeLabel.text = [NSString stringWithFormat:@"%d days, %d hours, %d minutes, %dseconds", days, remHours, remMins, remSecs];
    } else if (days == 1){
        self.dateTimeLabel.text = [NSString stringWithFormat:@"%d days, %d hours, %d minutes, %dseconds", days, remHours, remMins, remSecs];
    } else {
        self.dateTimeLabel.text = [NSString stringWithFormat:@"%d hours, %d minutes, %dseconds", remHours, remMins, remSecs];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //Set initial date formatter style
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSTimeZone *tz = [NSTimeZone timeZoneWithName:@"America/New_York"];
    [formatter setTimeZone:tz];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

    showing = NO;
    
    if(self.countdown.untilText == nil) {
        self.targetLabel.text = [formatter stringFromDate:self.countdown.targetDate];
    } else {
        self.targetLabel.text = self.countdown.untilText;
    }

  /*  if(myCountdownDays.text.intValue + myCountdownHours.text.intValue + myCountdownMins.text.intValue + myCountdownSeconds.text.intValue < 0) {
        self.myCountdownSeconds.hidden = YES;
        self.myCountdownMins.hidden = YES;
        self.myCountdownHours.hidden = YES;
        self.myCountdownDays.hidden = YES;
        
        self.expiredView.hidden = NO;
        
        //Top to bottom angled "Expired"
        self.expiredView.transform = CGAffineTransformMakeRotation(45 * M_PI / 180);
        
        [self.view bringSubviewToFront:self.expiredView];
        
    } */

    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                             target:self
                                           selector:@selector(updateCounter:)
                                           userInfo:nil
                                            repeats:YES];
    [self updateCounter:nil];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    [timer invalidate];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)showFullDate:(id)sender {
    UILongPressGestureRecognizer *gr = (UILongPressGestureRecognizer *)sender;
    if(gr.state == 1) {
        if(showing == YES) {
            if(self.countdown.untilText == nil) {
                [formatter setDateStyle:NSDateFormatterMediumStyle];
                [formatter setTimeStyle:NSDateFormatterNoStyle];
                
                self.targetLabel.text = [formatter stringFromDate:self.countdown.targetDate];
            } else {
                self.targetLabel.text = self.countdown.untilText;
            }
            showing = NO;
        } else {
            [formatter setDateStyle:NSDateFormatterLongStyle];
            [formatter setTimeStyle:NSDateFormatterMediumStyle];
            
            self.targetLabel.text = [formatter stringFromDate:self.countdown.targetDate];
            showing = YES;
        }
    }
}

#pragma - UIActionSheetDelegate

- (IBAction)actionSheetButtonPressed:(id)sender {
    //Create action sheet
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook", @"Twitter", @"Add to Calendar", @"Add Reminder", nil];
    [actionSheet showFromBarButtonItem:sender animated:YES];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSInteger option = buttonIndex;
    switch (option) {
        case kFacebookSharingAction:
            [self fbButtonPressed];
            break;
        case kTwitterSharingAction:
            [self twtrButtonPressed];
            break;
        case kAddToCalendarAction:
            [self calendarButtonPressed];
            break;
        case kAddReminderAction:
            [self reminderButtonPressed];
            break;
        default:
            break;
    }
}

#pragma - Facebook Integration

- (void)fbButtonPressed {
    //Let's get the text to post
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        NSTimeInterval since = [self getIntervalInSeconds];
        int days = since / 86400;
        int remHours = ((int)since % 86400) / 3600;
        int remMins = (((int)since % 86400) % 3600) / 60;
        int remSecs = (((int)since % 86400) % 3600) % 60;
        
        SLComposeViewController *faceBookSheet=[SLComposeViewController composeViewControllerForServiceType: SLServiceTypeFacebook];
        
        //Calls the function for set Text
        [faceBookSheet setInitialText:[NSString stringWithFormat:@"I have %d days %d hours %d minutes %d seconds until %@.", days, remHours, remMins, remSecs, self.title]];
        
        // Specifying a block to be called when the user is finished. This block is not guaranteed
        // To be called on any particular thread. It is cleared after being called.
        [faceBookSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    break;
                case SLComposeViewControllerResultDone:
                    [[[UIAlertView alloc] initWithTitle:@"Facebook Completion Message"
                                                message:@"Post Successful"
                                               delegate:nil
                                      cancelButtonTitle:@"Ok"
                                      otherButtonTitles:nil] show];
                    break;
                default:
                    break;
            }
        }];
        
        //Presenting the FB sheet
        [self presentViewController:faceBookSheet animated: YES completion: nil];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot post to Twitter. Please check your Twitter Login in the Settings App" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    
}

#pragma - Twitter Integration

- (void)twtrButtonPressed {
    //Let's get the text to post
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        NSTimeInterval since = [self getIntervalInSeconds];
        int days = since / 86400;
        int remHours = ((int)since % 86400) / 3600;
        int remMins = (((int)since % 86400) % 3600) / 60;
        int remSecs = (((int)since % 86400) % 3600) % 60;
        
        SLComposeViewController *twitterSheet=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        //Calls the function for set Text
        [twitterSheet setInitialText:[NSString stringWithFormat:@"I have %d days %d hours %d minutes %d seconds until %@.", days, remHours, remMins, remSecs, self.title]];
        
        // Specifying a block to be called when the user is finished. This block is not guaranteed
        // To be called on any particular thread. It is cleared after being called.
        [twitterSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            ;
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    break;
                case SLComposeViewControllerResultDone:
                    [[[UIAlertView alloc] initWithTitle:@"Twitter Completion Message"
                                                message:@"Tweet Successful"
                                               delegate:nil
                                      cancelButtonTitle:@"Ok"
                                      otherButtonTitles:nil] show];
                    break;
                default:
                    break;
            }
        }];
        
        //Presenting the Twitter sheet
        [self presentViewController:twitterSheet animated: YES completion: nil];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot post to Twitter. Please check your Twitter Login in the Settings App" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    
}

#pragma mark - Calendar Integration

- (void)calendarButtonPressed {
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (granted) {
            EKEvent *event = [EKEvent eventWithEventStore:store];
            event.title = self.countdown.untilText;
            event.startDate = self.countdown.targetDate;
            event.endDate = self.countdown.targetDate;
            [event setCalendar:[store defaultCalendarForNewEvents]];
            NSError *err = nil;
            [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
            if(err != nil) {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:err.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }
    }];
    
}

#pragma mark - Reminder Integration

- (void)reminderButtonPressed {
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
        if (granted) {
            EKReminder *reminder = [EKReminder reminderWithEventStore:store];
            reminder.title = self.countdown.untilText;
            NSCalendar *calendar = [NSCalendar currentCalendar];
            reminder.dueDateComponents = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:self.countdown.targetDate];
            [reminder setCalendar:[store defaultCalendarForNewEvents]];
            NSError *err = nil;
            [store saveReminder:reminder commit:YES error:&err];
            if(err != nil) {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:err.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }
    }];
    
}

@end
