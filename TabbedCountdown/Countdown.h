//
//  Countdowns.h
//  TabbedCountdown
//
//  Created by Murphy, Stephen - William S on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Countdown : NSObject

//Properties for name and target date
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSDate *targetDate;
@property (nonatomic, copy) NSString *untilText;

@end
