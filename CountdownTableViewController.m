//
//  CountdownTableViewController.m
//  TabbedCountdown
//
//  Created by Murphy, Stephen - William S on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CountdownTableViewController.h"
#import "CountdownViewController.h"
#import "Countdown.h"
#import <UIKit/UILocalNotification.h>
#import <QuartzCore/QuartzCore.h>


@implementation CountdownTableViewController

@synthesize countdownsArray;

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
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIDeviceOrientationPortraitUpsideDown);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"AddCountdown"])
	{
		UINavigationController *navigationController = 
        segue.destinationViewController;
		AddCountdownViewController 
        *addCountdownViewController = 
        [[navigationController viewControllers] 
         objectAtIndex:0];
		addCountdownViewController.delegate = self;
	} else if ([segue.identifier isEqualToString:@"CountdownPush"])
	{
        CountdownViewController *countdownViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Countdown *countdown = [self.countdownsArray objectAtIndex:indexPath.row];
        countdownViewController.targetDate = countdown.targetDate;
        countdownViewController.title = countdown.name;
        countdownViewController.untilText = countdown.untilText;
        countdownViewController.delegate = self;
	}
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.countdownsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:@"CountdownCell"];
	Countdown *countdown = [self.countdownsArray objectAtIndex:indexPath.row];
       
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
	cell.detailTextLabel.text = [dateFormatter stringFromDate:countdown.targetDate];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = countdown.name;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor colorWithRed:0.0 green:214.0/256.0 blue:151.0/256.0 alpha:1.0];
    for ( UIView* view in cell.contentView.subviews )
    {
        view.backgroundColor = [ UIColor clearColor ];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
        
       	 Countdown *countdown = [self.countdownsArray objectAtIndex:indexPath.row];
             
       	 //Delete this countdown to the plist, so it will not reapper on opening the app
       	 NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
       	 NSString *docDir = [arrayPaths objectAtIndex:0];
       	 NSString *finalPath = [docDir stringByAppendingPathComponent:@"Countdowns.plist"];
       	 NSFileManager *fileManager = [NSFileManager defaultManager];
        
       	 //If list does not exist in documents dir, load default from bundle dir
       	 if(![fileManager fileExistsAtPath:finalPath]) {
            NSString *path = [[NSBundle mainBundle] bundlePath];
            finalPath = [path stringByAppendingPathComponent:@"Countdowns.plist"];
       	 }
        
       	NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: finalPath];
        
        [data removeObjectForKey:countdown.name];
        
        BOOL rc = [data writeToFile:finalPath atomically:YES];
        if (rc != YES) {
            NSLog(@"Write failed");
        }
        
	[self.countdownsArray removeObjectAtIndex:indexPath.row];
	[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}   
}

#pragma mark - AddCountdownViewControllerDelegate

- (void)addCountdownViewControllerDidCancel:(CountdownTableViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addCountdownViewController:(CountdownTableViewController *)controller didAddCountdown:(Countdown *)countdown
{
	[self.countdownsArray addObject:countdown];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.countdownsArray count] - 1 inSection:0];
	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    //Add this countdown to the plist, so it will reload on opening the app
    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [arrayPaths objectAtIndex:0];
    NSString *finalPath = [docDir stringByAppendingPathComponent:@"Countdowns.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //If list does not exist in documents dir, load default from bundle dir
    if(![fileManager fileExistsAtPath:finalPath]) {
        NSString *path = [[NSBundle mainBundle] bundlePath];
        finalPath = [path stringByAppendingPathComponent:@"Countdowns.plist"];
	//Log a message when the list is loaded
	NSLog(@"Loaded Countdowns.plist from bundle path");
    }
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: finalPath];
    
    NSLog(@"Before %@", data );
    
    [data setObject:countdown.targetDate forKey:countdown.name];
    
    NSLog(@"After %@", data );
    
    BOOL rc = [data writeToFile:finalPath atomically:YES];
    if (rc != YES) {
        //TODO: Handle conflicts better
        NSLog(@"Write failed");
    }
    
    //Schedule a local notification for this countdown.
    UILocalNotification *local = [[UILocalNotification alloc] init];
    [local setFireDate:countdown.targetDate];
    [local setTimeZone:[NSTimeZone localTimeZone]];
    [local setAlertBody:[NSString stringWithFormat:@"Countdown %@ has expired!", countdown.name]];
    [local setAlertAction:[NSString stringWithFormat:@"Dismiss"]];
  	
    [[UIApplication sharedApplication] scheduleLocalNotification:local];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CountdownViewControllerDelegate
- (void)countdownViewControllerDidCancel:(CountdownViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
