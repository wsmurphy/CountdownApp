//
//  UntilTextViewController.m
//  TabbedCountdown
//
//  Created by Murphy, Stephen - William S on 7/29/13.
//
//

#import "UntilTextViewController.h"

@interface UntilTextViewController ()

@end

@implementation UntilTextViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self addTapGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender
{
    [self.delegate untilTextViewController:self didGetUntilText:_untilTextInputField.text];
}


#pragma mark - Private
- (void)addTapGesture
{
    // Add a tap gesture to the view to hide the keyboard if the user taps outside of it
    UITapGestureRecognizer *tapView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
    tapView.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapView];
}

- (void)closeKeyboard
{
    [self.view endEditing:YES];
}

@end
