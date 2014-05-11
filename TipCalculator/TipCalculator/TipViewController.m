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

- (IBAction)onChange:(id)sender;
- (void)onKeyboardClick;
- (void)onSettingsClick;
- (void)updateUI;

@end

@implementation TipViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Tip Calculator";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Keyboard" style:UIBarButtonItemStylePlain target:self action:@selector(onKeyboardClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(onSettingsClick)];

    [self.txtBill becomeFirstResponder];
}

- (IBAction)onChange:(id)sender
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

- (void)updateUI
{
    NSArray *tipValues = @[@(0.15), @(0.18), @(0.20), @(0.22), @(0.25)];
    float tipVal = [tipValues[self.btnTip.selectedSegmentIndex] floatValue];
    
    int totalPeople = self.btnPeople.value;
    float billAmount = [self.txtBill.text floatValue] / totalPeople;
    float tipAmount = ceilf(billAmount * tipVal * 100) / 100;
    float totalAmount = ceilf((billAmount + tipAmount) * 100) / 100;
    
    NSString *pplString = (totalPeople == 1 ? @"person" : @"people");
    
    self.lblPeople.text = [NSString stringWithFormat:@"(%d %@)", totalPeople, pplString];
    self.lblBillPerson.text = [NSString stringWithFormat:@"%.02f", ceilf(billAmount * 100) / 100];
    self.lblTipPerson.text = [NSString stringWithFormat:@"%.02f", tipAmount];
    self.lblPerPerson.text = [NSString stringWithFormat:@"%.02f", totalAmount];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
