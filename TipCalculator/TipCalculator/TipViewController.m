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
- (float) roundValue:(float)rawValue extraValue:(float)extraValue;

@end

@implementation TipViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Tip Calculator";
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *btnTipIndex = [defaults objectForKey:@"btnTipIndex"];
    NSString *btnPeopleValue = [defaults objectForKey:@"btnPeopleValue"];
    
    if(btnTipIndex != nil)
    {
        self.btnTip.selectedSegmentIndex = [btnTipIndex floatValue];
    }
    
    if(btnPeopleValue != nil)
    {
        self.btnPeople.value = [btnPeopleValue floatValue];
    }
    
    [self updateUI];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Keyboard" style:UIBarButtonItemStylePlain target:self action:@selector(onKeyboardClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(onSettingsClick)];

    [self.txtBill becomeFirstResponder];
}

- (IBAction) onChange:(id)sender
{
    [self updateUI];
}

- (void) onKeyboardClick
{
    [self.view endEditing:YES];
}

- (void) onSettingsClick
{
    [self.navigationController pushViewController:[[SettingsViewController alloc] init] animated:YES];
}

- (void) updateUI
{
    NSArray *tipValues = @[@(0.15), @(0.18), @(0.20), @(0.22), @(0.25)];
    float tipVal = [tipValues[self.btnTip.selectedSegmentIndex] floatValue];
    
    int totalPeople = self.btnPeople.value;
    float billAmount = [self.txtBill.text floatValue] / totalPeople;
    float tipAmount = [self roundValue:(billAmount * tipVal) extraValue:fmodf(billAmount, 1.0f)];
    float totalAmount = [self roundValue:(billAmount + tipAmount) extraValue:0.0f];
    
    NSString *pplString = (totalPeople == 1 ? @"person" : @"people");
    
    self.lblPeople.text = [NSString stringWithFormat:@"(%d %@)", totalPeople, pplString];
    self.lblBillPerson.text = [NSString stringWithFormat:@"%.02f", [self roundValue:billAmount extraValue:0.0f]];
    self.lblTipPerson.text = [NSString stringWithFormat:@"%.02f", tipAmount];
    self.lblPerPerson.text = [NSString stringWithFormat:@"%.02f", totalAmount];
}

- (float) roundValue:(float)rawValue extraValue:(float)extraValue
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *btnRoundingIndex = [defaults objectForKey:@"btnRoundingIndex"];
    
    int roundingMethod = 1;
    if(btnRoundingIndex != nil && (extraValue > 0.0f || fmodf(rawValue, 1.0f) > 0.0f))
    {
        roundingMethod = [btnRoundingIndex floatValue];
        rawValue = ceilf(rawValue * 100) / 100;
    }
    
    switch (roundingMethod) {
        case 0:
            rawValue -= fmodf(extraValue + rawValue, 1.0f);
            break;
            
        case 2:
            rawValue += (1.0f - fmodf(extraValue + rawValue, 1.0f));
            
        default:
            break;
    }
    
    return ceilf(rawValue * 100) / 100;
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
