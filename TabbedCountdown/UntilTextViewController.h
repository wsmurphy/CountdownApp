//
//  UntilTextViewController.h
//  TabbedCountdown
//
//  Created by Murphy, Stephen - William S on 7/29/13.
//
//

#import <UIKit/UIKit.h>

@class UntilTextViewController;

@protocol UntilTextViewControllerDelegate <NSObject>

- (void)untilTextViewControllerDidCancel:(UntilTextViewController *)controller;
- (void)untilTextViewController:(UntilTextViewController*)controller didGetUntilText:(NSString *)text;

@end

@interface UntilTextViewController : UIViewController

@property (assign) id <UntilTextViewControllerDelegate> delegate;


@property (weak, nonatomic) IBOutlet UITextField *untilTextInputField;

- (IBAction)done:(id)sender;

@end
