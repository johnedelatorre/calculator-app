//
//  SlideResultsChartVC.h
//  Blocpad
//
//  Created by Hugh Lang on 4/3/13.
//
//

#import "HelveticaNeueMdCnLabel.h"
#import "HelveticaNeueBdCnLabel.h"
#import "SavingsData.h"


@interface SlideResultsChartVC : UIViewController {
    UIImage *bar1pattern;
    UIImage *bar2pattern;
    UIImage *bar3pattern;
    UIImage *bar4pattern;
    double largestValue;
    
    UIView *q1bar1;
    UIView *q1bar2;
    UIView *q1bar3;
    UIView *q1bar4;
    
    UIView *q2bar1;
    UIView *q2bar2;
    UIView *q2bar3;
    UIView *q2bar4;
    
    UIView *q3bar1;
    UIView *q3bar2;
    UIView *q3bar3;
    UIView *q3bar4;

    HelveticaNeueMdCnLabel *q1label1;
    HelveticaNeueMdCnLabel *q1label2;
    HelveticaNeueMdCnLabel *q1label3;
    HelveticaNeueMdCnLabel *q1label4;
    
    HelveticaNeueMdCnLabel *q2label1;
    HelveticaNeueMdCnLabel *q2label2;
    HelveticaNeueMdCnLabel *q2label3;
    HelveticaNeueMdCnLabel *q2label4;
    
    HelveticaNeueMdCnLabel *q3label1;
    HelveticaNeueMdCnLabel *q3label2;
    HelveticaNeueMdCnLabel *q3label3;
    HelveticaNeueMdCnLabel *q3label4;

}


@property (nonatomic, strong) IBOutlet HelveticaNeueMdCnLabel *q1Label;
@property (nonatomic, strong) IBOutlet HelveticaNeueMdCnLabel *q2Label;
@property (nonatomic, strong) IBOutlet HelveticaNeueMdCnLabel *q3Label;

@property (nonatomic, strong) IBOutlet HelveticaNeueMdCnLabel *q1Count;
@property (nonatomic, strong) IBOutlet HelveticaNeueMdCnLabel *q2Count;
@property (nonatomic, strong) IBOutlet HelveticaNeueMdCnLabel *q3Count;

@property (nonatomic, strong) IBOutlet HelveticaNeueBdCnLabel *q1SavingsPct;
@property (nonatomic, strong) IBOutlet HelveticaNeueBdCnLabel *q2SavingsPct;
@property (nonatomic, strong) IBOutlet HelveticaNeueBdCnLabel *q3SavingsPct;

@property (nonatomic, strong) IBOutlet HelveticaNeueBdCnLabel *contractSavingsAmt;


- (void) reset;
- (void) update;
- (void) setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners;

@end
