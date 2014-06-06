//
//  SAddCountdownViewController.swift
//  TabbedCountdown
//
//  Created by Murphy, Stephen - William S on 6/6/14.
//
//

import UIKit

@objc protocol AddCountdownViewControllerDelegate {
    func addCountdownViewControllerDidCancel(controller:AddCountdownViewController)
    func addCountdownViewController(controller:AddCountdownViewController, didAddCountdown countdown:Countdown)
}

@objc class AddCountdownViewController: UITableViewController, DatePickerViewControllerDelegate, TimePickerViewControllerDelegate {
    @IBOutlet var titleTextField : UITextField
    @IBOutlet var untilField : UITextField
    @IBOutlet var timeDetailLabel : UILabel
    @IBOutlet var dateDetailLabel : UILabel
    var delegate: AddCountdownViewControllerDelegate?
    var chosenDate : NSDate?
    var chosenTime : NSDate?
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    init(style: UITableViewStyle) {
        super.init(style: style)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.backgroundView = nil
        self.tableView.backgroundColor = UIColor(red: 0.0, green: 214.0/256.0, blue: 151.0/256.0, alpha: 1.0)
        
        addTapGesture()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addTapGesture() {
        var tapView = UIGestureRecognizer(target: self, action: "closeKeyboard")
        // Add a tap gesture to the view to hide the keyboard if the user taps outside of it
        tapView.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapView)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "datePicker" {
            let navigationController = segue.destinationViewController as UINavigationController
            var datePickerViewController = navigationController.viewControllers[0] as DatePickerViewController
            datePickerViewController.delegate = self
            
            
        }
        if segue.identifier == "timePicker" {
            let navigationController = segue.destinationViewController as UINavigationController
            var timePickerViewController = navigationController.viewControllers[0] as TimePickerViewController
            timePickerViewController.delegate = self
        }
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        if indexPath.section == 0 {
            titleTextField.becomeFirstResponder()
        }
    }
    
    func closeKeyboard() {
        self.view.endEditing(false)
    }
    
    func dateWithZeroSeconds(date: NSDate) -> NSDate {
        var time = floor((date.timeIntervalSinceReferenceDate / 60.0) * 60.0)
        return NSDate(timeIntervalSinceReferenceDate: time)
    }
    
    @IBAction func cancel(sender:AnyObject) {
        self.delegate!.addCountdownViewControllerDidCancel(self)
    }
    
    @IBAction func done(sender:AnyObject) {
        var countdown = Countdown()
        countdown.name = self.titleTextField.text
        
        let cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        let dateComponents = cal.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: self.chosenDate)
        let timeComponents = cal.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond, fromDate: self.chosenTime)
        
        var newDateComponents = NSDateComponents()
        newDateComponents.hour = timeComponents.hour
        newDateComponents.minute = timeComponents.minute
        newDateComponents.day = dateComponents.day
        newDateComponents.month = dateComponents.month
        newDateComponents.year = dateComponents.year
        
        let newDate = cal.dateFromComponents(newDateComponents)
         countdown.targetDate = newDate
        countdown.untilText = self.untilField.text
        
        self.delegate!.addCountdownViewController(self, didAddCountdown: countdown)
    }
    
    //DatePickerViewControllerDelegate
    func datePickerViewController(controller: DatePickerViewController!, didGetDate date: NSDate!) {
        
        self.chosenDate = date
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .NoStyle
        
        self.dateDetailLabel.text = dateFormatter.stringFromDate(date)
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func datePickerViewControllerDidCancel(controller: DatePickerViewController!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //TimePickerViewControllerDelegate
    func timePickerViewController(controller: TimePickerViewController!, didGetTime time: NSDate!) {
        
        self.chosenTime = time
        
        var timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = .NoStyle
        timeFormatter.timeStyle = .ShortStyle
        
        self.timeDetailLabel.text = timeFormatter.stringFromDate(time)
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func timePickerViewControllerDidCancel(controller: TimePickerViewController!) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
