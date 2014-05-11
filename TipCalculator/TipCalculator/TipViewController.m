//
//  TipViewController.m
//  TipCalculator
//
//  Created by Theofanis Pantelides on 5/8/14.
//  Copyright (c) 2014 CodePath. All rights reserved.
//

#import "TipViewController.h"

@interface TipViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblTipPerson;
@property (weak, nonatomic) IBOutlet UILabel *lblPerPerson;
@property (weak, nonatomic) IBOutlet UILabel *lblPeople;
@property (weak, nonatomic) IBOutlet UITextField *txtBill;
@property (weak, nonatomic) IBOutlet UISegmentedControl *btnTip;
@property (weak, nonatomic) IBOutlet UIStepper *btnPeople;

- (IBAction)onChange:(id)sender;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.txtBill becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onChange:(id)sender
{
    [self updateUI];
}

- (void)updateUI
{
    NSArray *tipValues = @[@(0.15), @(0.18), @(0.20), @(0.22), @(0.25)];
    float tipVal = [tipValues[self.btnTip.selectedSegmentIndex] floatValue];
    
    int totalPeople = self.btnPeople.value;
    float billAmount = [self.txtBill.text floatValue] / totalPeople;
    float tipAmount = billAmount * tipVal;
    float totalAmount = billAmount + tipAmount;
    
    NSString *pplString = (totalPeople == 1 ? @"person" : @"people");
    
    self.lblPeople.text = [NSString stringWithFormat:@"(%d %@)", totalPeople, pplString];
    self.lblTipPerson.text = [NSString stringWithFormat:@"%.02f", floorf(tipAmount * 100) / 100];
    self.lblPerPerson.text = [NSString stringWithFormat:@"%.02f", floorf(totalAmount * 100) / 100];
}
@end
