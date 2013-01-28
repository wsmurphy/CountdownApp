//
//  CountdownViewController.m
//  Countdown
//
//  Created by Murphy, Stephen - William S on 3/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CountdownViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CountdownViewController ()
{
    NSTimer *timer;
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
    self.myCountdownSeconds.text = [NSString stringWithFormat:@"%d", remSecs];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

    
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                     target:self
                                   selector:@selector(updateCounter:)
                                   userInfo:nil
                                    repeats:YES];
    [self updateCounter:nil];
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
        self.expiredView.transform = CGAffineTransformMakeRotation(135 * M_PI / 180);
        [self.view bringSubviewToFront:self.expiredView];
        
        
        
    } else {
       [self drawRect];  
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

- (void) drawRect {
    if(myCountdownDays.isHidden != YES) {
        CGRect daysRect=CGRectMake(25,103,50,50);
        UIView *dayView=[[UIView alloc]initWithFrame:daysRect];
        dayView.backgroundColor=[UIColor whiteColor];
        dayView.layer.cornerRadius = 8;
        [self.view addSubview:dayView];
        
        [self.myCountdownDays setFrame:daysRect];
        [self.myCountdownDays setTextColor:[UIColor blackColor]];
        [self.view addSubview:self.myCountdownDays];
    }
    
    CGRect hoursRect=CGRectMake(95,103,50,50);
    UIView *hourView=[[UIView alloc]initWithFrame:hoursRect];
    hourView.backgroundColor=[UIColor whiteColor];
    hourView.layer.cornerRadius = 8;
    [self.view addSubview:hourView];
    
    [self.myCountdownHours setFrame:hoursRect];
    [self.myCountdownHours setTextColor:[UIColor blackColor]];
    [self.view addSubview:self.myCountdownHours];
    
    
    CGRect minRect=CGRectMake(165,103,50,50);
    UIView *minView=[[UIView alloc]initWithFrame:minRect];
    minView.backgroundColor=[UIColor whiteColor];
    minView.layer.cornerRadius = 8;
    [self.view addSubview:minView];
    
    [self.myCountdownMins setFrame:minRect];
    [self.myCountdownMins setTextColor:[UIColor blackColor]];
    [self.view addSubview:self.myCountdownMins];
   
    
    CGRect secRect=CGRectMake(235,103,50,50);
    UIView *secView=[[UIView alloc]initWithFrame:secRect];
    secView.backgroundColor=[UIColor whiteColor];
    secView.layer.cornerRadius = 8;
    [self.view addSubview:secView];
    
    [self.myCountdownSeconds setFrame:secRect];
    [self.myCountdownSeconds setTextColor:[UIColor blackColor]];
    [self.view addSubview:self.myCountdownSeconds];
}

@end
