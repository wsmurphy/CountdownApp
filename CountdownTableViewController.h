//
//  CountdownTableViewController.h
//  TabbedCountdown
//
//  Created by Murphy, Stephen - William S on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddCountdownViewController.h"
#import "CountdownViewController.h"

@interface CountdownTableViewController : UITableViewController  <AddCountdownViewControllerDelegate, CountdownViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *countdownsArray;

@end
