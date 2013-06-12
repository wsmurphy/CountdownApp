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

@interface CountdownViewController ()
{
    NSTimer *timer;
    UIView *secondsView;
    BOOL showing;
}
@end

@implementation CountdownViewController
@synthesize myCountdownDays;
@synthesize myCountdownHours;
@synthesize myCountdownMins;
@synthesize myCountdownSeconds;
@synthesize delegate;
@synthesize targetDate;
@synthesize targetLabel;

#define facebookAction 0
#define twitterAction 1

- (NSTimeInterval)getIntervalInSeconds {

    NSTimeInterval since = [self.targetDate timeIntervalSinceNow];
    return since;
    
}

- (void)updateCounter:(NSTimer *)theTimer {

    NSTimeInterval since = [self getIntervalInSeconds];
    int days = since / 86400;
    int remHours = ((int)since % 86400) / 3600;
    int remMins = (((int)since % 86400) % 3600) / 60;
    int remSecs = (((int)since % 86400) % 3600) % 60;
    
    if(days < 1) {
        self.myCountdownDays.hidden = YES;
    } else {
        self.myCountdownDays.text = [NSString stringWithFormat:@"%d", days];
    }
    
    self.myCountdownHours.text = [NSString stringWithFormat:@"%d", remHours];
    self.myCountdownMins.text = [NSString stringWithFormat:@"%d", remMins];
    

    //Animate seconds button
    CGRect newFrame = secondsView.frame;
    newFrame.origin.x += (newFrame.size.width / 2);
    newFrame.size.width = 0;
    secondsView.frame = newFrame;
    self.myCountdownSeconds.text = [NSString stringWithFormat:@"%d", remSecs];
    [UIView animateWithDuration:0.5
                     animations:^{
                         CGRect newFrame = secondsView.frame;
                         newFrame.origin.x -= 25;
                         newFrame.size.width = 50;
                         secondsView.frame = newFrame;
                     }];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

    showing = NO;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSTimeZone *tz = [NSTimeZone timeZoneWithName:@"America/New_York"];
    [formatter setTimeZone:tz];
    self.targetLabel.text = [formatter stringFromDate:targetDate];

    if(myCountdownDays.text.intValue + myCountdownHours.text.intValue + myCountdownMins.text.intValue + myCountdownSeconds.text.intValue < 0) {
        self.myCountdownSeconds.hidden = YES;
        self.myCountdownMins.hidden = YES;
        self.myCountdownHours.hidden = YES;
        self.myCountdownDays.hidden = YES;
        
        self.expiredView.hidden = NO;
        
        /* Bottom to top angled "Expired"
           self.expiredView.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(-1.0, -1.0), CGAffineTransformMakeRotation(135 * M_PI / 180));
        */
        
        //Top to bottom angled "Expired"
        self.expiredView.transform = CGAffineTransformMakeRotation(45 * M_PI / 180);
        
        [self.view bringSubviewToFront:self.expiredView];
        
    } else {
        if(myCountdownDays.isHidden != YES) {
            [self.view addSubview:self.myCountdownDays];
        }
        
        [self.view addSubview:self.myCountdownHours];
        [self.view addSubview:self.myCountdownMins];
        [self.view addSubview:self.myCountdownSeconds];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                 target:self
                                               selector:@selector(updateCounter:)
                                               userInfo:nil
                                                repeats:YES];
        [self updateCounter:nil];
    }

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    [timer invalidate];
}

- (void)viewDidUnload {
    myCountdownDays = nil;
    myCountdownHours = nil;
    myCountdownMins = nil;
    myCountdownSeconds = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)showFullDate:(id)sender {
    UILongPressGestureRecognizer *gr = (UILongPressGestureRecognizer *)sender;
    if(gr.state == 1) {
        if(showing == YES) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterNoStyle];
            
            NSTimeZone *tz = [NSTimeZone timeZoneWithName:@"America/New_York"];
            [formatter setTimeZone:tz];
            self.targetLabel.text = [formatter stringFromDate:targetDate];
            showing = NO;
        } else {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterLongStyle];
            [formatter setTimeStyle:NSDateFormatterMediumStyle];
            
            NSTimeZone *tz = [NSTimeZone timeZoneWithName:@"America/New_York"];
            [formatter setTimeZone:tz];
            self.targetLabel.text = [formatter stringFromDate:targetDate];
            showing = YES;
        }
    }
}

#pragma - UIActionSheetDelegate

- (IBAction)actionSheetButtonPressed:(id)sender {
    //Create action sheet
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Social actions" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share to Facebook", @"Share to Twitter", nil];
    [actionSheet showFromBarButtonItem:sender animated:YES];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //TODO: Are constants better than #defines?
    if(buttonIndex == facebookAction) {
        [self fbButtonPressed];
    } else if (buttonIndex == twitterAction) {
        [self twtrButtonPressed];
    } else {
        //WTF?
    }
}

#pragma - Facebook Integration

- (void)fbButtonPressed {
    //Let's get the text to post
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        
        SLComposeViewController *faceBookSheet=[SLComposeViewController composeViewControllerForServiceType: SLServiceTypeFacebook];
        
        //Calls the function for set Text
        [faceBookSheet setInitialText:[NSString stringWithFormat:@"I have %@ days %@ hours %@ minutes %@ seconds until %@.", myCountdownDays.text, myCountdownHours.text, myCountdownMins.text, myCountdownSeconds.text, self.title]];
        
        // Specifying a block to be called when the user is finished. This block is not guaranteed
        // To be called on any particular thread. It is cleared after being called.
        [faceBookSheet setCompletionHandler:[self fbCompletionHandlerFunction]];
        
        //Presenting the FB sheet
        [self presentViewController:faceBookSheet animated: YES completion: nil];
    }
    
}


- (SLComposeViewControllerCompletionHandler) fbCompletionHandlerFunction {
    SLComposeViewControllerCompletionHandler resultFB = ^(SLComposeViewControllerResult result) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook Completion Message"
                                                        message:@"Default"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                break;
            case SLComposeViewControllerResultDone:
                alert.message = @"Post Successfull";
                [alert show];
                break;
            default:
                break;
        }
    };
    
    return resultFB;
    
}

#pragma - Twitter Integration

- (void)twtrButtonPressed {
    //Let's get the text to post
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        
        SLComposeViewController *twitterSheet=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        //Calls the function for set Text
        [twitterSheet setInitialText:[NSString stringWithFormat:@"I have %@ days %@ hours %@ minutes %@ seconds until %@.", myCountdownDays.text, myCountdownHours.text, myCountdownMins.text, myCountdownSeconds.text, self.title]];
        
        // Specifying a block to be called when the user is finished. This block is not guaranteed
        // To be called on any particular thread. It is cleared after being called.
        [twitterSheet setCompletionHandler:[self twtrCompletionHandlerFunction]];
        
        //Presenting the FB sheet
        [self presentViewController:twitterSheet animated: YES completion: nil];
    }
    
}

- (SLComposeViewControllerCompletionHandler) twtrCompletionHandlerFunction {
    SLComposeViewControllerCompletionHandler resultTwtr = ^(SLComposeViewControllerResult result) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter Completion Message"
                                                        message:@"Default"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                break;
            case SLComposeViewControllerResultDone:
                alert.message = @"Tweet Successfull";
                [alert show];
                break;
            default:
                break;
        }
    };
    
    return resultTwtr;
    
}
@end
