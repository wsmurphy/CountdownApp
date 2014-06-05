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
    
    class func socialStringFromDate(date:NSDate, title:NSString) -> String {
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
            formattedDate = "I have \(numberFormatter.stringFromNumber(days)) days, \(numberFormatter.stringFromNumber(remHours)) hours, \(numberFormatter.stringFromNumber(remMins)) minutes, \(numberFormatter.stringFromNumber(remSecs)) seconds until \(title)"
        } else if days == 1 {
            formattedDate = "I have \(numberFormatter.stringFromNumber(days)) day, \(numberFormatter.stringFromNumber(remHours)) hours, \(numberFormatter.stringFromNumber(remMins)) minutes, \(numberFormatter.stringFromNumber(remSecs)) seconds until \(title)"
        } else {
            formattedDate = "I have \(numberFormatter.stringFromNumber(remHours)) hours, \(numberFormatter.stringFromNumber(remMins)) minutes, \(numberFormatter.stringFromNumber(remSecs)) seconds until \(title)"
        }
        
        return formattedDate;
    }
    
}
