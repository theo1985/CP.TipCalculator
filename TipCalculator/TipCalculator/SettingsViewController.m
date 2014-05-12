//
//  SettingsViewController.m
//  TipCalculator
//
//  Created by Theofanis Pantelides on 5/11/14.
//  Copyright (c) 2014 CodePath. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *btnTip;
@property (weak, nonatomic) IBOutlet UILabel *lblPeople;
@property (weak, nonatomic) IBOutlet UIStepper *btnPeople;
@property (weak, nonatomic) IBOutlet UISegmentedControl *btnRounding;

- (IBAction) onValueChange:(id)sender;
- (void) updateUI;

@end

@implementation SettingsViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *btnTipIndex = [defaults objectForKey:@"btnTipIndex"];
    NSString *btnPeopleValue = [defaults objectForKey:@"btnPeopleValue"];
    NSString *btnRoundingIndex = [defaults objectForKey:@"btnRoundingIndex"];
    
    if(btnTipIndex != nil)
    {
        self.btnTip.selectedSegmentIndex = [btnTipIndex floatValue];
    }
    
    if(btnPeopleValue != nil)
    {
        self.btnPeople.value = [btnPeopleValue floatValue];
    }
    
    if(btnRoundingIndex != nil)
    {
        self.btnRounding.selectedSegmentIndex = [btnRoundingIndex floatValue];
    }
    
    [self updateUI];
}

- (IBAction) onValueChange:(id)sender
{
    int btnTipIndex = (int)self.btnTip.selectedSegmentIndex;
    int btnPeopleValue = self.btnPeople.value;
    int btnRoundingIndex = (int)self.btnRounding.selectedSegmentIndex;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSString stringWithFormat:@"%d", btnTipIndex] forKey:@"btnTipIndex"];
    [defaults setObject:[NSString stringWithFormat:@"%d", btnPeopleValue] forKey:@"btnPeopleValue"];
    [defaults setObject:[NSString stringWithFormat:@"%d", btnRoundingIndex] forKey:@"btnRoundingIndex"];
    [defaults synchronize];
    
    [self updateUI];
}

- (void) updateUI
{
    int totalPeople = self.btnPeople.value;
    
    NSString *pplString = (totalPeople == 1 ? @"person" : @"people");
    self.lblPeople.text = [NSString stringWithFormat:@"People: (%d %@)", totalPeople, pplString];
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
