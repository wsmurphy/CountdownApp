//
//  FormattedString.swift
//  TabbedCountdown
//
//  Created by Murphy, Stephen - William S on 6/3/14.
//
//

import UIKit
import Foundation


@objc class StringFormatter : NSObject {
    
     class func timeLeftStringFromDate(date:NSDate) -> String {
        var formattedDate = ""
        
        //TODO: Int math
        var since = date.timeIntervalSinceNow
        var days = since / 86400;
        var remHours = since % 86400 / 3600
        var remMins = since % 86400 % 3600 / 60
        var remSecs = since % 86400 % 3600 % 60
        
        var numberFormatter = NSNumberFormatter()
        numberFormatter.maximumFractionDigits = 0;
        numberFormatter.stringFromNumber(days)
        
        if days > 1 {
            formattedDate = "\(numberFormatter.stringFromNumber(days)) days, \(numberFormatter.stringFromNumber(remHours)) hours, \(numberFormatter.stringFromNumber(remMins)) minutes, \(numberFormatter.stringFromNumber(remSecs)) seconds"
        } else if days == 1 {
            formattedDate = "\(numberFormatter.stringFromNumber(days)) day, \(numberFormatter.stringFromNumber(remHours)) hours, \(numberFormatter.stringFromNumber(remMins)) minutes, \(numberFormatter.stringFromNumber(remSecs)) seconds"
        } else {
            formattedDate = "\(numberFormatter.stringFromNumber(remHours)) hours, \(numberFormatter.stringFromNumber(remMins)) minutes, \(numberFormatter.stringFromNumber(remSecs)) seconds"
        }
        
        return formattedDate;
    }
    
 //   @IBAction func showFullDate {
 /*   UILongPressGestureRecognizer *gr = (UILongPressGestureRecognizer *)sender;
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
    }*/
    
}
