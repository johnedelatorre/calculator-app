//
//  SlideResultsChartVC.m
//  Blocpad
//
//  Created by Hugh Lang on 4/3/13.
//
//

#import "SlideResultsChartVC.h"
#import <QuartzCore/QuartzCore.h>

#import "NSString+NumberFormat.h"

#include <math.h>

#define kChartBarX   218
#define kChartBar1Y     30
#define kChartBar2Y     188
#define kChartBar3Y     348

#define kBarWidthMax    300
#define kBarSeparator   5
#define kLabelFontSize   14
#define kLabelWidth     100
#define kLabelLeftMargin 10
#define kBarHeight      23
/*
 Bar chart calculations:
 - bar 1: contract acquisition cost (CAcost)
 - bar 2: net total cost
 - bar 3: celgene rebate amt
 - bar 4: CAcost * combined rebate %
 
 */
@interface SlideResultsChartVC ()

@end

static NSString *kLabelFont = @"HelveticaNeueLTStd-MdCn";

@implementation SlideResultsChartVC

@synthesize q1SavingsPct, q2SavingsPct, q3SavingsPct, contractSavingsAmt;
@synthesize q1Count, q2Count, q3Count;

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
    NSLog(@"%s", __FUNCTION__);
    [super viewDidLoad];
    q1Count.text = [NSString formatIntWithCommas:[DataModel sharedInstance].q1Savings.vialCount];
    q2Count.text = [NSString formatIntWithCommas:[DataModel sharedInstance].q2Savings.vialCount];
    q3Count.text = [NSString formatIntWithCommas:[DataModel sharedInstance].q3Savings.vialCount];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) reset {
    [q1bar1 removeFromSuperview];
    [q1bar2 removeFromSuperview];
    [q1bar3 removeFromSuperview];
    [q1bar4 removeFromSuperview];
    
    [q2bar1 removeFromSuperview];
    [q2bar2 removeFromSuperview];
    [q2bar3 removeFromSuperview];
    [q2bar4 removeFromSuperview];
    
    [q3bar1 removeFromSuperview];
    [q3bar2 removeFromSuperview];
    [q3bar3 removeFromSuperview];
    [q3bar4 removeFromSuperview];
    
    [q1label1 removeFromSuperview];
    [q1label2 removeFromSuperview];
    [q1label3 removeFromSuperview];
    [q1label4 removeFromSuperview];
    
    [q2label1 removeFromSuperview];
    [q2label2 removeFromSuperview];
    [q2label3 removeFromSuperview];
    [q2label4 removeFromSuperview];
    
    [q3label1 removeFromSuperview];
    [q3label2 removeFromSuperview];
    [q3label3 removeFromSuperview];
    [q3label4 removeFromSuperview];
    
    // Initialize these here and not viewDidLoad. Needed for bar bg color in update method
    bar1pattern = [UIImage imageNamed:@"chart_bar_slice1.png"];
    bar2pattern = [UIImage imageNamed:@"chart_bar_slice2.png"];
    bar3pattern = [UIImage imageNamed:@"chart_bar_slice3.png"];
    bar4pattern = [UIImage imageNamed:@"chart_bar_slice4.png"];

}
- (void) update {
    NSLog(@"%s", __FUNCTION__);
    
    q1Count.text = [NSString formatIntWithCommas:[DataModel sharedInstance].q1Savings.vialCount];
    q2Count.text = [NSString formatIntWithCommas:[DataModel sharedInstance].q2Savings.vialCount];
    q3Count.text = [NSString formatIntWithCommas:[DataModel sharedInstance].q3Savings.vialCount];

    double currentValue = 0;
    largestValue = 0;
    
    currentValue = [DataModel sharedInstance].q1Savings.netCost;
    largestValue = MAX(currentValue, largestValue);
    
    currentValue = [DataModel sharedInstance].q2Savings.netCost;
    largestValue = MAX(currentValue, largestValue);
    
    currentValue = [DataModel sharedInstance].q3Savings.netCost;
    largestValue = MAX(currentValue, largestValue);
    
    NSLog(@"largest Value is: %f", largestValue);
    
    int xpos = kChartBarX;
    int ypos;
    ypos = kChartBar1Y;
    
    double amt = 0;
    float length = 0;
    CGRect barFrame;
    CGRect labelFrame;
    // Q1 chart build

    // q1 bar1
    currentValue = [DataModel sharedInstance].q1Savings.cacost;
    
    if (largestValue == 0) {
        amt = 0;
    } else {
        amt = currentValue / largestValue;
    }
    
    NSLog(@"currentValue = %f, largestValue=%f", currentValue, largestValue);
    
    length = amt * kBarWidthMax;
    
    NSLog(@"q1bar1 length = %f", length);
    
    NSLog(@"lastPoint=nextPoint: xpos=%i / ypos=%i", xpos, ypos);

    barFrame = CGRectMake(xpos, ypos, length, kBarHeight);
    q1bar1 = [[UIView alloc] initWithFrame:barFrame];
    q1bar1.backgroundColor = [UIColor colorWithPatternImage:bar1pattern];
    [self setMaskTo:q1bar1 byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight];
    [self.view addSubview:q1bar1];

    // q1 label1
    labelFrame = CGRectMake(xpos + length + kLabelLeftMargin, ypos, kLabelWidth, kBarHeight);
    q1label1 = [[HelveticaNeueMdCnLabel alloc] init];
    q1label1.textAlignment = NSTextAlignmentLeft;
    q1label1.frame = labelFrame;
    q1label1.backgroundColor = [UIColor clearColor];
    q1label1.font = [UIFont fontWithName:kLabelFont size:kLabelFontSize];
    q1label1.textColor = [UIColor darkGrayColor];
    q1label1.text = [NSString formatDoubleAsCurrency:currentValue decimals:0];
    [self.view addSubview:q1label1];
    
    // q1 bar2
    ypos += 27;
    currentValue = [DataModel sharedInstance].q1Savings.netCost;
    if (largestValue == 0) {
        amt = 0;
    } else {
        amt = currentValue / largestValue;
    }
    length = amt * kBarWidthMax;
    barFrame = CGRectMake(xpos, ypos, length, kBarHeight);
    q1bar2 = [[UIView alloc] initWithFrame:barFrame];
    q1bar2.backgroundColor = [UIColor colorWithPatternImage:bar2pattern];
    [self setMaskTo:q1bar2 byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight];
    [self.view addSubview:q1bar2];
    
    // q1 label2
    labelFrame = CGRectMake(xpos + length + kLabelLeftMargin, ypos, kLabelWidth, kBarHeight);
    q1label2 = [[HelveticaNeueMdCnLabel alloc] init];
    q1label2.textAlignment = NSTextAlignmentLeft;
    q1label2.frame = labelFrame;
    q1label2.backgroundColor = [UIColor clearColor];
    q1label2.font = [UIFont fontWithName:kLabelFont size:kLabelFontSize];
    q1label2.textColor = [UIColor darkGrayColor];
    q1label2.text = [NSString formatDoubleAsCurrency:currentValue decimals:0];
    [self.view addSubview:q1label2];

    // q1 bar3
    ypos += 27;
    currentValue = [DataModel sharedInstance].q1Savings.celgeneRebateAmt;
    if (largestValue == 0) {
        amt = 0;
    } else {
        amt = currentValue / largestValue;
    }
    length = amt * kBarWidthMax;
    barFrame = CGRectMake(xpos, ypos, length, kBarHeight);
    q1bar3 = [[UIView alloc] initWithFrame:barFrame];
    q1bar3.backgroundColor = [UIColor colorWithPatternImage:bar3pattern];
    [self setMaskTo:q1bar3 byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight];
    [self.view addSubview:q1bar3];
    
    // q1 label3
    labelFrame = CGRectMake(xpos + length + kLabelLeftMargin, ypos, kLabelWidth, kBarHeight);
    q1label3 = [[HelveticaNeueMdCnLabel alloc] init];
    q1label3.textAlignment = NSTextAlignmentLeft;
    q1label3.frame = labelFrame;
    q1label3.backgroundColor = [UIColor clearColor];
    q1label3.font = [UIFont fontWithName:kLabelFont size:kLabelFontSize];
    q1label3.textColor = [UIColor darkGrayColor];
    q1label3.text = [NSString formatDoubleAsCurrency:currentValue decimals:0];
    [self.view addSubview:q1label3];
    
    // q1 bar4
    ypos += 27;
    currentValue = ([DataModel sharedInstance].q1Savings.cacost * [DataModel sharedInstance].q1Savings.combinedRebatePct/100) - [DataModel sharedInstance].q1Savings.celgeneRebateAmt;
    if (largestValue == 0) {
        amt = 0;
    } else {
        amt = currentValue / largestValue;
    }
    length = amt * kBarWidthMax;
    barFrame = CGRectMake(xpos, ypos, length, kBarHeight);
    q1bar4 = [[UIView alloc] initWithFrame:barFrame];
    q1bar4.backgroundColor = [UIColor colorWithPatternImage:bar4pattern];
    [self setMaskTo:q1bar4 byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight];
    [self.view addSubview:q1bar4];
    
    // q1 label4
    labelFrame = CGRectMake(xpos + length + kLabelLeftMargin, ypos, kLabelWidth, kBarHeight);
    q1label4 = [[HelveticaNeueMdCnLabel alloc] init];
    q1label4.textAlignment = NSTextAlignmentLeft;
    q1label4.frame = labelFrame;
    q1label4.backgroundColor = [UIColor clearColor];
    q1label4.font = [UIFont fontWithName:kLabelFont size:kLabelFontSize];
    q1label4.textColor = [UIColor darkGrayColor];
    q1label4.text = [NSString formatDoubleAsCurrency:currentValue decimals:0];
    [self.view addSubview:q1label4];
    

    // Q2 chart build
    ypos = kChartBar2Y;
    // q2 bar1
    currentValue = [DataModel sharedInstance].q2Savings.cacost;
    if (largestValue == 0) {
        amt = 0;
    } else {
        amt = currentValue / largestValue;
    }
    length = amt * kBarWidthMax;
    barFrame = CGRectMake(xpos, ypos, length, kBarHeight);
    q2bar1 = [[UIView alloc] initWithFrame:barFrame];
    q2bar1.backgroundColor = [UIColor colorWithPatternImage:bar1pattern];
    [self setMaskTo:q2bar1 byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight];
    [self.view addSubview:q2bar1];
    
    // q2 label1
    labelFrame = CGRectMake(xpos + length + kLabelLeftMargin, ypos, kLabelWidth, kBarHeight);
    q2label1 = [[HelveticaNeueMdCnLabel alloc] init];
    q2label1.textAlignment = NSTextAlignmentLeft;
    q2label1.frame = labelFrame;
    q2label1.backgroundColor = [UIColor clearColor];
    q2label1.font = [UIFont fontWithName:kLabelFont size:kLabelFontSize];
    q2label1.textColor = [UIColor darkGrayColor];
    q2label1.text = [NSString formatDoubleAsCurrency:currentValue decimals:0];
    [self.view addSubview:q2label1];
    
    // q2 bar2
    ypos += 27;
    currentValue = [DataModel sharedInstance].q2Savings.netCost;
    if (largestValue == 0) {
        amt = 0;
    } else {
        amt = currentValue / largestValue;
    }
    length = amt * kBarWidthMax;
    barFrame = CGRectMake(xpos, ypos, length, kBarHeight);
    q2bar2 = [[UIView alloc] initWithFrame:barFrame];
    q2bar2.backgroundColor = [UIColor colorWithPatternImage:bar2pattern];
    [self setMaskTo:q2bar2 byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight];
    [self.view addSubview:q2bar2];
    
    // q2 label2
    labelFrame = CGRectMake(xpos + length + kLabelLeftMargin, ypos, kLabelWidth, kBarHeight);
    q2label2 = [[HelveticaNeueMdCnLabel alloc] init];
    q2label2.textAlignment = NSTextAlignmentLeft;
    q2label2.frame = labelFrame;
    q2label2.backgroundColor = [UIColor clearColor];
    q2label2.font = [UIFont fontWithName:kLabelFont size:kLabelFontSize];
    q2label2.textColor = [UIColor darkGrayColor];
    q2label2.text = [NSString formatDoubleAsCurrency:currentValue decimals:0];
    [self.view addSubview:q2label2];
    
    // q2 bar3
    ypos += 27;
    currentValue = [DataModel sharedInstance].q2Savings.celgeneRebateAmt;
    if (largestValue == 0) {
        amt = 0;
    } else {
        amt = currentValue / largestValue;
    }
    length = amt * kBarWidthMax;
    barFrame = CGRectMake(xpos, ypos, length, kBarHeight);
    q2bar3 = [[UIView alloc] initWithFrame:barFrame];
    q2bar3.backgroundColor = [UIColor colorWithPatternImage:bar3pattern];
    [self setMaskTo:q2bar3 byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight];
    [self.view addSubview:q2bar3];
    
    // q2 label3
    labelFrame = CGRectMake(xpos + length + kLabelLeftMargin, ypos, kLabelWidth, kBarHeight);
    q2label3 = [[HelveticaNeueMdCnLabel alloc] init];
    q2label3.textAlignment = NSTextAlignmentLeft;
    q2label3.frame = labelFrame;
    q2label3.backgroundColor = [UIColor clearColor];
    q2label3.font = [UIFont fontWithName:kLabelFont size:kLabelFontSize];
    q2label3.textColor = [UIColor darkGrayColor];
    q2label3.text = [NSString formatDoubleAsCurrency:currentValue decimals:0];
    [self.view addSubview:q2label3];
    
    // q2 bar4
    ypos += 27;
    currentValue = ([DataModel sharedInstance].q2Savings.cacost * [DataModel sharedInstance].q2Savings.combinedRebatePct/100) - [DataModel sharedInstance].q2Savings.celgeneRebateAmt;
    if (largestValue == 0) {
        amt = 0;
    } else {
        amt = currentValue / largestValue;
    }
    length = amt * kBarWidthMax;
    barFrame = CGRectMake(xpos, ypos, length, kBarHeight);
    q2bar4 = [[UIView alloc] initWithFrame:barFrame];
    q2bar4.backgroundColor = [UIColor colorWithPatternImage:bar4pattern];
    [self setMaskTo:q2bar4 byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight];
    [self.view addSubview:q2bar4];
    
    // q2 label4
    labelFrame = CGRectMake(xpos + length + kLabelLeftMargin, ypos, kLabelWidth, kBarHeight);
    q2label4 = [[HelveticaNeueMdCnLabel alloc] init];
    q2label4.textAlignment = NSTextAlignmentLeft;
    q2label4.frame = labelFrame;
    q2label4.backgroundColor = [UIColor clearColor];
    q2label4.font = [UIFont fontWithName:kLabelFont size:kLabelFontSize];
    q2label4.textColor = [UIColor darkGrayColor];
    q2label4.text = [NSString formatDoubleAsCurrency:currentValue decimals:0];
    [self.view addSubview:q2label4];
    
    // Q3 chart build
    ypos = kChartBar3Y;
    // q3 bar1
    currentValue = [DataModel sharedInstance].q3Savings.cacost;
    if (largestValue == 0) {
        amt = 0;
    } else {
        amt = currentValue / largestValue;
    }
    length = amt * kBarWidthMax;
    barFrame = CGRectMake(xpos, ypos, length, kBarHeight);
    q3bar1 = [[UIView alloc] initWithFrame:barFrame];
    q3bar1.backgroundColor = [UIColor colorWithPatternImage:bar1pattern];
    [self setMaskTo:q3bar1 byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight];
    [self.view addSubview:q3bar1];
    
    // q3 label1
    labelFrame = CGRectMake(xpos + length + kLabelLeftMargin, ypos, kLabelWidth, kBarHeight);
    q3label1 = [[HelveticaNeueMdCnLabel alloc] init];
    q3label1.textAlignment = NSTextAlignmentLeft;
    q3label1.frame = labelFrame;
    q3label1.backgroundColor = [UIColor clearColor];
    q3label1.font = [UIFont fontWithName:kLabelFont size:kLabelFontSize];
    q3label1.textColor = [UIColor darkGrayColor];
    q3label1.text = [NSString formatDoubleAsCurrency:currentValue decimals:0];
    [self.view addSubview:q3label1];
    
    // q3 bar2
    ypos += 27;
    currentValue = [DataModel sharedInstance].q3Savings.netCost;
    if (largestValue == 0) {
        amt = 0;
    } else {
        amt = currentValue / largestValue;
    }
    length = amt * kBarWidthMax;
    barFrame = CGRectMake(xpos, ypos, length, kBarHeight);
    q3bar2 = [[UIView alloc] initWithFrame:barFrame];
    q3bar2.backgroundColor = [UIColor colorWithPatternImage:bar2pattern];
    [self setMaskTo:q3bar2 byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight];
    [self.view addSubview:q3bar2];
    
    // q3 label2
    labelFrame = CGRectMake(xpos + length + kLabelLeftMargin, ypos, kLabelWidth, kBarHeight);
    q3label2 = [[HelveticaNeueMdCnLabel alloc] init];
    q3label2.textAlignment = NSTextAlignmentLeft;
    q3label2.frame = labelFrame;
    q3label2.backgroundColor = [UIColor clearColor];
    q3label2.font = [UIFont fontWithName:kLabelFont size:kLabelFontSize];
    q3label2.textColor = [UIColor darkGrayColor];
    q3label2.text = [NSString formatDoubleAsCurrency:currentValue decimals:0];
    [self.view addSubview:q3label2];
    
    // q3 bar3
    ypos += 27;
    currentValue = [DataModel sharedInstance].q3Savings.celgeneRebateAmt;
    if (largestValue == 0) {
        amt = 0;
    } else {
        amt = currentValue / largestValue;
    }
    length = amt * kBarWidthMax;
    barFrame = CGRectMake(xpos, ypos, length, kBarHeight);
    q3bar3 = [[UIView alloc] initWithFrame:barFrame];
    q3bar3.backgroundColor = [UIColor colorWithPatternImage:bar3pattern];
    [self setMaskTo:q3bar3 byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight];
    [self.view addSubview:q3bar3];
    
    // q3 label3
    labelFrame = CGRectMake(xpos + length + kLabelLeftMargin, ypos, kLabelWidth, kBarHeight);
    q3label3 = [[HelveticaNeueMdCnLabel alloc] init];
    q3label3.textAlignment = NSTextAlignmentLeft;
    q3label3.frame = labelFrame;
    q3label3.backgroundColor = [UIColor clearColor];
    q3label3.font = [UIFont fontWithName:kLabelFont size:kLabelFontSize];
    q3label3.textColor = [UIColor darkGrayColor];
    q3label3.text = [NSString formatDoubleAsCurrency:currentValue decimals:0];
    [self.view addSubview:q3label3];
    
    // q3 bar4
    ypos += 27;
    currentValue = ([DataModel sharedInstance].q3Savings.cacost * [DataModel sharedInstance].q3Savings.combinedRebatePct/100) - [DataModel sharedInstance].q3Savings.celgeneRebateAmt;
    if (largestValue == 0) {
        amt = 0;
    } else {
        amt = currentValue / largestValue;
    }
    length = amt * kBarWidthMax;
    barFrame = CGRectMake(xpos, ypos, length, kBarHeight);
    q3bar4 = [[UIView alloc] initWithFrame:barFrame];
    q3bar4.backgroundColor = [UIColor colorWithPatternImage:bar4pattern];
    [self setMaskTo:q3bar4 byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight];
    [self.view addSubview:q3bar4];
    
    // q3 label4
    labelFrame = CGRectMake(xpos + length + kLabelLeftMargin, ypos, kLabelWidth, kBarHeight);
    q3label4 = [[HelveticaNeueMdCnLabel alloc] init];
    q3label4.textAlignment = NSTextAlignmentLeft;
    q3label4.frame = labelFrame;
    q3label4.backgroundColor = [UIColor clearColor];
    q3label4.font = [UIFont fontWithName:kLabelFont size:kLabelFontSize];
    q3label4.textColor = [UIColor darkGrayColor];
    q3label4.text = [NSString formatDoubleAsCurrency:currentValue decimals:0];
    [self.view addSubview:q3label4];
    

    // Set total and percents
    self.q1SavingsPct.text = [NSString formatDoubleWithMaxDecimals:[DataModel sharedInstance].q1Savings.combinedRebatePct minDecimals:1 maxDecimals:2  AndPrefix:(NSString *)nil AndSuffix:nil];
    self.q2SavingsPct.text = [NSString formatDoubleWithMaxDecimals:[DataModel sharedInstance].q2Savings.combinedRebatePct minDecimals:1 maxDecimals:2  AndPrefix:(NSString *)nil AndSuffix:nil];
    self.q3SavingsPct.text = [NSString formatDoubleWithMaxDecimals:[DataModel sharedInstance].q3Savings.combinedRebatePct minDecimals:1 maxDecimals:2  AndPrefix:(NSString *)nil AndSuffix:nil];

//    self.q1SavingsPct.text = [NSString formatDoubleWithCommas:[DataModel sharedInstance].q1Savings.combinedRebatePct decimals:1];
//    self.q2SavingsPct.text = [NSString formatDoubleWithCommas:[DataModel sharedInstance].q2Savings.combinedRebatePct decimals:1];
//    self.q3SavingsPct.text = [NSString formatDoubleWithCommas:[DataModel sharedInstance].q3Savings.combinedRebatePct decimals:1];
    self.contractSavingsAmt.text = [NSString formatDoubleAsCurrency:[DataModel sharedInstance].totalSavings.combinedRebateAmt decimals:0];

    NSLog(@"q1SavingsPct %@", self.q1SavingsPct.text);
    NSLog(@"q2SavingsPct %@", self.q2SavingsPct.text);
    NSLog(@"q3SavingsPct %@", self.q3SavingsPct.text);

}

// See: http://stackoverflow.com/questions/4847163/round-two-corners-in-uiview
-(void) setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners
{
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                  byRoundingCorners:corners
                                                        cornerRadii:CGSizeMake(6.0, 6.0)];
    
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    view.layer.mask = shape;
}
@end
