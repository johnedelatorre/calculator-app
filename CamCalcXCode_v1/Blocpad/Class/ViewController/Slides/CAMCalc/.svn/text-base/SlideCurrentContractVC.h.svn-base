//
//  SlideCurrentContractVC.h
//  Blocpad
//
//  Created by Hugh Lang on 3/21/13.
//
//

#import "SlideViewController.h"
#import "KeypadViewController.h"
#import "HelveticaNeueHvLabel.h"
#import "HelveticaNeueBdCnLabel.h"
#import "HelveticaNeueBdLabel.h"
#import "HelveticaNeueRomanLabel.h"
#import "HelveticaNeueRomanTextView.h"
#import "HelveticaNeueBdCnTextField.h"

#import "HelpModel.h"
#import "HelpCopy.h"

@interface SlideCurrentContractVC : SlideViewController<UIPopoverControllerDelegate, UITextFieldDelegate, KeypadViewControllerDelegate> {

    UITextField *_field;
    HelpModel *helpModel;
    UIImage *questionOffImage;
    UIImage *questionOnImage;
    double baseline;
}

@property (nonatomic, retain) UIPopoverController *_popoverVC;
@property (nonatomic, retain) KeypadViewController *_keypadVC;

@property (nonatomic, strong) IBOutlet HelveticaNeueHvLabel *groupNameLabel;
@property (nonatomic, strong) IBOutlet HelveticaNeueRomanLabel *locationLabel;
@property (nonatomic, strong) IBOutlet HelveticaNeueRomanLabel *timestampLabel;

@property (nonatomic, strong) IBOutlet HelveticaNeueBdCnLabel *aspPriceLabel;
@property (nonatomic, strong) IBOutlet HelveticaNeueBdCnLabel *aspPlus3Label;
@property (nonatomic, strong) IBOutlet HelveticaNeueBdCnLabel *benchmarkLabel;
@property (nonatomic, strong) IBOutlet HelveticaNeueBdCnLabel *currentVialCountLabel;

@property (nonatomic, strong) IBOutlet HelveticaNeueBdCnTextField *gpoRebateField;
@property (nonatomic, strong) IBOutlet HelveticaNeueBdCnTextField *estVialCountField;

@property (nonatomic, strong) IBOutlet HelveticaNeueBdLabel *helpTitle;
@property (nonatomic, strong) IBOutlet HelveticaNeueRomanTextView *helpDescription;

@property (nonatomic, strong) IBOutlet UIButton *help1;
@property (nonatomic, strong) IBOutlet UIButton *help2;
@property (nonatomic, strong) IBOutlet UIButton *help3;
@property (nonatomic, strong) IBOutlet UIButton *help4;
@property (nonatomic, strong) IBOutlet UIButton *help5;
@property (nonatomic, strong) IBOutlet UIButton *help6;


@property (nonatomic, strong) IBOutlet UIButton *previousButton;
@property (nonatomic, strong) IBOutlet UIButton *nextButton;
@property (nonatomic, strong) IBOutlet UIButton *homeButton;

- (IBAction)previousSlide;
- (IBAction)nextSlide;
- (IBAction)firstSlide;

- (IBAction)helpAction:(id)sender;

- (void)resetQuestionIcons;

@end
