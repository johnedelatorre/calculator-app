//
//  SlideCurrentContractVC.m
//  Blocpad
//
//  Created by Hugh Lang on 3/21/13.
//
//

#import "SlideCurrentContractVC.h"

#import "SQLiteDB.h"
#import "CurrentContract.h"
#import "TraccsContract.h"
#import "TraccsVialHistory.h"

#import "NSString+NumberFormat.h"
#import "UIColor+ColorWithHex.h"

#include <math.h>

#define kTagGPORebate        0
#define kTagEstVialCount       1
#define kBaselineMinimum    50

@interface SlideCurrentContractVC ()

@end

@implementation SlideCurrentContractVC

@synthesize _popoverVC;
@synthesize _keypadVC;
@synthesize gpoRebateField;
@synthesize estVialCountField;

//static NSString* 
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        helpModel = [[HelpModel alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.timestampLabel.text = [DataModel sharedInstance].timestampText;

    // Do any additional setup after loading the view from its nib.
    
    questionOffImage = [UIImage imageNamed:@"question-icon-off"];
    questionOnImage = [UIImage imageNamed:@"question-icon-on"];
    
    // 1. Set contract name and location
    NSString *text;
    
    if ([DataModel sharedInstance].accountData != nil) {
        text = [[DataModel sharedInstance].accountData objectForKey:@"groupName"];
        self.groupNameLabel.text = text;
        text = [[DataModel sharedInstance].accountData objectForKey:@"city"];
        
        NSString *locFormatter = @"%@, %@ %@";
        
        NSString *location;
        location = [NSString stringWithFormat:locFormatter, text,
                    [[DataModel sharedInstance].accountData objectForKey:@"state"],
                    [[DataModel sharedInstance].accountData objectForKey:@"zipcode"]];
        self.locationLabel.text = location;
        
//        if ([[DataModel sharedInstance].accountData objectForKey:@"state"] != nil) {
//            NSString *loc =@"%@, %@";
//            self.locationLabel.text = [NSString stringWithFormat:loc, text, [[DataModel sharedInstance].accountData objectForKey:@"state"]];
//        } else {
//            self.locationLabel.text = text;
//        }
    }
    
    // 2. Query database for current contractId and set DataModel CurrentContract
    
    
    NSString *sql;
    

    sql = @"select avgPrevYear as baseline from contract where contractId=?";
    
    NSNumber *contractId = [NSNumber numberWithInteger:[DataModel sharedInstance].contractId];
    
    FMResultSet *rs;
    rs = [[SQLiteDB sharedConnection] executeQuery:sql, contractId];
    
    double fixedBenchmark;
    
    if ([rs next]) {
        NSLog(@"baseline = %f", baseline);
        baseline = [rs doubleForColumnIndex:0];
    } else {
        baseline = 0;
    }
    NSLog(@"baseline = %f", baseline);
    if (baseline < kBaselineMinimum) {
        fixedBenchmark = kBaselineMinimum;
    } else {
        fixedBenchmark = baseline;
    }

    [DataModel sharedInstance].contract.baselineVialCount = [NSNumber numberWithDouble:fixedBenchmark].intValue;

    self.benchmarkLabel.text = [NSString formatDoubleWithCommas:fixedBenchmark decimals:0];

    // 2B. Calculate actual average of prior quarters for help text

    
    sql= @"select avg(actUnits) as baseline from vial_history where contractId=? and qtrname in ('2011Q4', '2012Q1', '2012Q2', '2012Q3')";

    FMResultSet *calcRS;
    calcRS = [[SQLiteDB sharedConnection] executeQuery:sql, contractId];
    double calcBaseline;
    
    if ([calcRS next]) {
        calcBaseline = [calcRS doubleForColumnIndex:0];
    } else {
        calcBaseline = 0;
    }

    if (calcBaseline <= 50) {
        baseline = calcBaseline;
    } else {
        baseline = fixedBenchmark;
    }
    // 3. Query database for current quarter
    
    int currentQuarterVialCount = 0;
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *quarterOnly = [[NSDateFormatter alloc]init];
    [quarterOnly setDateFormat:@"yyyy'Q'Q"];
    
    NSString *qtrname = [quarterOnly stringFromDate:date];
    
//    qtrname = @"2013Q2";
    
    NSLog(@"quarter :    %@", qtrname);

    sql= @"select * from vial_history where contractId=? and qtrname=?";
    
    rs = [[SQLiteDB sharedConnection] executeQuery:sql, contractId, qtrname];
    NSDictionary *dict;
    NSNumber *value;
    if ([rs next]) {
        dict = [rs resultDictionary];
        if (dict != nil) {
            value = [dict objectForKey:@"actUnits"];
            currentQuarterVialCount = value.intValue;
        }
    } else {
        currentQuarterVialCount = 0;
    }
    self.currentVialCountLabel.text = [NSString stringWithFormat:@"%i", currentQuarterVialCount];
    

    // 4. Set other values
    self.aspPriceLabel.text = [NSString formatDoubleWithCommas:[DataModel sharedInstance].contract.aspPrice decimals:2];
    
    self.aspPlus3Label.text = [NSString formatDoubleWithCommas:[DataModel sharedInstance].contract.aspMarkup decimals:2];
    
    
    if ([DataModel sharedInstance].contract != nil) {
        self.gpoRebateField.text = [NSString formatDoubleWithCommas:[DataModel sharedInstance].contract.gpoRebate decimals:1];
        self.estVialCountField.text = [NSString formatDoubleWithCommas:[DataModel sharedInstance].contract.estVialCount decimals:0];
    }
    // Prevent default keyboard from appearing
    UIView* dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    self.gpoRebateField.inputView = dummyView;
    self.estVialCountField.inputView = dummyView;
    self.helpDescription.inputView = dummyView;
    
    NSString *suffix = @"%";
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont fontWithName:@"HelveticaNeueLTStd-BdCn" size:20]];
    [label setTextColor:[UIColor colorWithHexValue:0x006EDD]];
    [label setAlpha:0.7];
    [label setText:suffix];
    
    CGSize suffixSize = [suffix sizeWithFont:label.font];
    label.frame = CGRectMake(0, 0, suffixSize.width + 2, gpoRebateField.frame.size.height);
    
    [gpoRebateField setRightView:label];
    [gpoRebateField setRightViewMode:UITextFieldViewModeAlways];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closePopoverNotificationHandler:)     name:@"closePopoverNotification"            object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)closePopoverNotificationHandler:(NSNotification*)notification
{
#ifdef DEBUGX
    NSLog(@"%s", __FUNCTION__);
#endif
    
    if (_popoverVC != nil) {
        [_popoverVC dismissPopoverAnimated:YES];
    }
    
}

#pragma mark - UITextField methods

-(BOOL) textFieldShouldBeginEditing:(UITextField*)textField {
    NSLog(@"%s", __FUNCTION__);
    _field = textField;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"%s", __FUNCTION__);
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    NSLog(@"%s", __FUNCTION__);

    _field = textField;
    textField.placeholder = nil;
    
    switch (textField.tag) {
        case kTagGPORebate:
            
            // Remove percent sign
            
            break;
            
        case kTagEstVialCount:
            
            break;
            
    }

    _keypadVC = [[KeypadViewController alloc] init];
    _keypadVC.delegate = self;

    _popoverVC = [[UIPopoverController alloc]
                  initWithContentViewController:_keypadVC];
    _popoverVC.delegate = self;
    CGSize popoverSize = CGSizeMake(380, 340);
    [_popoverVC setPopoverContentSize:popoverSize];

    [_popoverVC presentPopoverFromRect:textField.bounds inView:textField
              permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    
    [_field selectAll:self];
    [UIMenuController sharedMenuController].menuVisible = NO;
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"%s", __FUNCTION__);
    //#ifdef kDEBUG
    //    // NSLog(@"%s tag=%i", __FUNCTION__, textField.tag);
    //#endif
    switch (textField.tag) {
        case kTagGPORebate:
            if (textField.text.length == 0) {
                textField.text = @"0";
            } else {
                if (textField.text.doubleValue > 10) {
                    textField.text = @"10";
                }
            }
            break;
            
        case kTagEstVialCount:
            if (textField.text.length == 0) {
                textField.text = @"0";
            } else {
                
                
            }
            break;
            
    }
    [textField resignFirstResponder];
    [textField endEditing:YES];
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    NSLog(@"%s", __FUNCTION__);
    [_popoverVC dismissPopoverAnimated:YES];
//    [self update:0];
    return YES;
}

// IGNORE THIS METHOD. ONLY WORKS FOR NATIVE KEYBOARD INPUT
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    if ([string isEqualToString:@"."] && contains(textField.text, @".")) {
        return NO;
    }
    return YES;
}


#pragma mark -- UIPopover delegate methods

//---called when the user clicks outside the popover view---
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    
    NSLog(@"popover about to be dismissed");
    return YES;
}

//---called when the popover view is dismissed---
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    
    NSLog(@"popover dismissed");
    [_field resignFirstResponder];

    
}

#pragma mark - calculator delegate

- (void)keyHandler:(CalculatorKeys)key
{
    NSLog(@"%s %i", __FUNCTION__, key);
    
    switch (key) {
        case CalculatorKeysBack:
            [_field deleteBackward];
            break;
            
        case CalculatorKeysDecimal:
            if (_field.tag == 0) {
                if (!contains(_field.text, @".")) {
                    [_field insertText:@"."];
                }
            }

            break;
        case CalculatorKeysEnter:
            [_field resignFirstResponder];
            [_popoverVC dismissPopoverAnimated:YES];

            break;
            
            
        default:
            [_field insertText:[NSString stringWithFormat:@"%i", key]];
            break;
    }

    
}
- (void)totalUpdated {
    
}

- (IBAction)previousSlide
{
    if (_popoverVC != nil) {
        [_popoverVC dismissPopoverAnimated:YES];
    }
    [_delegate gotoPreviousSlide];
}

- (IBAction)nextSlide
{
    if (_popoverVC != nil) {
        [_popoverVC dismissPopoverAnimated:YES];
    }

    // Get values from input fields
    // TODO: Prevent zero values
    NSString *text;
    text = gpoRebateField.text;
    [DataModel sharedInstance].contract.gpoRebate = text.doubleValue;
    
    text = estVialCountField.text;
    // Strip out commas
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *estNumber = [f numberFromString:text];
    if (estNumber.intValue > 0) {

        [DataModel sharedInstance].contract.estVialCount = estNumber.intValue;

        [_delegate gotoNextSlide];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: nil
                              message: @"Please enter a non-zero value for Estimated Quarterly Vial Purchase."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    
}

- (IBAction)firstSlide
{
    [DataModel sharedInstance].accountData = nil;
    [_delegate gotoFirstSlide];
}


- (IBAction)helpAction:(id)sender
{
    HelpCopy *helpcopy;
    NSString *actualsCopy;
    actualsCopy= @"%@\n\nActual average quarterly vials purchased is %@.";
    NSString *helpText;
    
    switch ([sender tag]) {
        case 1:
            helpcopy = [helpModel.helpDB objectForKey:@"ASP"];
            
            [self resetQuestionIcons];
            [self.help1 setImage:questionOnImage forState:UIControlStateNormal];
            self.helpTitle.text = helpcopy.title;
            self.helpDescription.text = helpcopy.description;
            break;
            
        case 2:
            helpcopy = [helpModel.helpDB objectForKey:@"ASP3"];
            [self resetQuestionIcons];
            [self.help2 setImage:questionOnImage forState:UIControlStateNormal];
            self.helpTitle.text = helpcopy.title;
            self.helpDescription.text = helpcopy.description;
            break;
            
        case 3:
            
            helpcopy = [helpModel.helpDB objectForKey:@"GPOrebate"];
            [self resetQuestionIcons];
            [self.help3 setImage:questionOnImage forState:UIControlStateNormal];
            
            self.helpTitle.text = helpcopy.title;
            self.helpDescription.text = helpcopy.description;
            break;
            
        case 4:
            helpcopy = [helpModel.helpDB objectForKey:@"benchmark"];
            [self resetQuestionIcons];
            [self.help4 setImage:questionOnImage forState:UIControlStateNormal];

//            [NSString formatDoubleWithCommas:[DataModel sharedInstance].contract.baselineVialCount decimals:0]
            helpText = [NSString stringWithFormat:actualsCopy, helpcopy.description,
                                    [NSString formatDoubleWithCommas:baseline decimals:0]];
            
            self.helpTitle.text = helpcopy.title;
            self.helpDescription.text = helpText;
            break;
            
        case 5:
            helpcopy = [helpModel.helpDB objectForKey:@"currentQuarterly"];
            [self resetQuestionIcons];
            [self.help5 setImage:questionOnImage forState:UIControlStateNormal];
            self.helpTitle.text = helpcopy.title;
            self.helpDescription.text = helpcopy.description;
            break;
            
        case 6:
            
            helpcopy = [helpModel.helpDB objectForKey:@"estimatedQuarterly"];
            [self resetQuestionIcons];
            [self.help6 setImage:questionOnImage forState:UIControlStateNormal];
            self.helpTitle.text = helpcopy.title;
            self.helpDescription.text = helpcopy.description;
            break;
    }


}

- (void) resetQuestionIcons
{
    [self.help1 setImage:questionOffImage forState:UIControlStateNormal];
    [self.help2 setImage:questionOffImage forState:UIControlStateNormal];
    [self.help3 setImage:questionOffImage forState:UIControlStateNormal];
    [self.help4 setImage:questionOffImage forState:UIControlStateNormal];
    [self.help5 setImage:questionOffImage forState:UIControlStateNormal];
    [self.help6 setImage:questionOffImage forState:UIControlStateNormal];
}
@end
