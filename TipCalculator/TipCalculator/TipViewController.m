//
//  TipViewController.m
//  TipCalculator
//
//  Created by Theofanis Pantelides on 5/8/14.
//  Copyright (c) 2014 CodePath. All rights reserved.
//

#import "TipViewController.h"
#import "SettingsViewController.h"

@interface TipViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblBillPerson;
@property (weak, nonatomic) IBOutlet UILabel *lblTipPerson;
@property (weak, nonatomic) IBOutlet UILabel *lblPerPerson;
@property (weak, nonatomic) IBOutlet UILabel *lblPeople;
@property (weak, nonatomic) IBOutlet UITextField *txtBill;
@property (weak, nonatomic) IBOutlet UISegmentedControl *btnTip;
@property (weak, nonatomic) IBOutlet UIStepper *btnPeople;

- (IBAction) onChange:(id)sender;
- (void) onKeyboardClick;
- (void) onSettingsClick;
- (void) updateUI;
- (float) roundValue:(float)rawValue;
- (float) roundValue:(float)rawValue extraValue:(float)extraValue;

@end

@implementation TipViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // Set the title of the View
        self.title = @"Tip Calculator";
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    // Load User Defaults (as set in SettingsViewController)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *btnTipIndex = [defaults objectForKey:@"btnTipIndex"];
    NSString *btnPeopleValue = [defaults objectForKey:@"btnPeopleValue"];
    
    // Check if value isSet
    if(btnTipIndex != nil)
    {
        self.btnTip.selectedSegmentIndex = [btnTipIndex floatValue];
    }
    
    // Check if value isSet
    if(btnPeopleValue != nil)
    {
        self.btnPeople.value = [btnPeopleValue floatValue];
    }
    
    // Update UI
    [self updateUI];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Set the buttons left/right
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Keyboard" style:UIBarButtonItemStylePlain target:self action:@selector(onKeyboardClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(onSettingsClick)];

    // Set focus to txtBill
    [self.txtBill becomeFirstResponder];
}

- (IBAction) onChange:(id)sender
{
    // On any change, Update UI
    [self updateUI];
}

- (void) onKeyboardClick
{
    // Close the keyboard
    [self.view endEditing:YES];
}

- (void) onSettingsClick
{
    // Animate to the SettingsViewController
    [self.navigationController pushViewController:[[SettingsViewController alloc] init] animated:YES];
}

- (void) updateUI
{
    // Build an array of values, based on what on Segmented Control
    NSArray *tipValues = @[@(0.15), @(0.18), @(0.20), @(0.22), @(0.25)];
    float tipVal = [tipValues[self.btnTip.selectedSegmentIndex] floatValue];
    
    // Load UI values into variables and do calculations
    int totalPeople = self.btnPeople.value;
    float billAmount = [self.txtBill.text floatValue] / totalPeople;
    float tipAmount = [self roundValue:(billAmount * tipVal) extraValue:fmodf(billAmount, 1.0f)];
    float totalAmount = [self roundValue:(billAmount + tipAmount)];
    
    // Update UI with calculated values
    NSString *pplString = (totalPeople == 1 ? @"person" : @"people");
    
    self.lblPeople.text = [NSString stringWithFormat:@"(%d %@)", totalPeople, pplString];
    self.lblBillPerson.text = [NSString stringWithFormat:@"%.02f", [self roundValue:billAmount]];
    self.lblTipPerson.text = [NSString stringWithFormat:@"%.02f", tipAmount];
    self.lblPerPerson.text = [NSString stringWithFormat:@"%.02f", totalAmount];
}

- (float) roundValue:(float)rawValue
{
    // Return ceiling of value (2 decimal places)
    return ceilf(rawValue * 100) / 100;
}

- (float) roundValue:(float)rawValue extraValue:(float)extraValue
{
    // Load Rounding information from User Defaults (as set in SettingsViewController)
    NSString *btnRoundingIndex = [[NSUserDefaults standardUserDefaults] objectForKey:@"btnRoundingIndex"];
    
    // Check if value isSet
    if(btnRoundingIndex != nil)
    {
        int roundingMethod = [btnRoundingIndex floatValue];
        
        // Value must always be less than 1
        extraValue = fmodf(extraValue + rawValue, 1.0f);
    
        switch (roundingMethod)
        {
            case 0:
                rawValue -= extraValue;
                break;
            
            case 2:
                rawValue += fmodf(1.0f - extraValue, 1.0f);
                break;
        }
    }
    
    // return floor of value (2 decimal places)
    return floorf(rawValue * 100) / 100;
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
