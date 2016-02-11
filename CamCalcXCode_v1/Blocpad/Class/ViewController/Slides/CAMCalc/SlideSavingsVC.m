//
//  SlideSavingsVC.m
//  Blocpad
//
//  Created by Hugh Lang on 4/3/13.
//
//

#import "SlideSavingsVC.h"
#import "NSString+NumberFormat.h"

@interface SlideSavingsVC ()

@end

@implementation SlideSavingsVC

@synthesize benchmarkValue;
static NSString *kTableView = @"table";
static NSString *kChartView = @"chart";
static NSString *kTrendView = @"trend";

static NSString *kDefaultTitle = @"PROJECTED REBATE";
static NSString *KTrendTitle = @"VIAL HISTORY";


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
 
    self.timestampLabel.text = [DataModel sharedInstance].timestampText;
    self.benchmarkValue.text = [NSString formatIntWithCommas:[DataModel sharedInstance].contract.baselineVialCount];
    
    NSString *text;
    
    if ([DataModel sharedInstance].accountData != nil) {
        text = [[DataModel sharedInstance].accountData objectForKey:@"groupName"];
        NSLog(@"GroupName=%@", text);
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

    viewId = kTableView;
    
    tableOffImg = [UIImage imageNamed:@"button_table_off"];
    tableOnImg = [UIImage imageNamed:@"button_table_on"];
    chartOffImg = [UIImage imageNamed:@"button_chart_off"];
    chartOnImg = [UIImage imageNamed:@"button_chart_on"];
    trendOffImg = [UIImage imageNamed:@"button_trend_off"];
    trendOnImg = [UIImage imageNamed:@"button_trend_on"];
    
    subframe = CGRectMake(25, 205, 974, 480);
    resultsTableVC = [[SlideResultsTableVC alloc] initWithNibName:@"SlideResultsTableVC" bundle:nil];
    resultsTableVC.view.frame = subframe;
    [self.view addSubview:resultsTableVC.view];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)previousSlide
{
    [_delegate gotoPreviousSlide];
}


- (IBAction)nextSlide
{
    [_delegate gotoNextSlide];
}

- (IBAction)firstSlide
{
    [DataModel sharedInstance].accountData = nil;
    [_delegate gotoFirstSlide];
    
}

- (IBAction)helpAction
{
    [_delegate gotoFirstSlide];
    
}


- (IBAction)selectTableView
{
    NSLog(@"%s", __FUNCTION__);
    
    
    if (![viewId isEqualToString:kTableView]) {
        viewId = kTableView;

        [self.selectTableButton setImage:tableOnImg forState:UIControlStateNormal];
        [self.selectChartButton setImage:chartOffImg forState:UIControlStateNormal];
        [self.selectTrendButton setImage:trendOffImg forState:UIControlStateNormal];
        self.resetButton.hidden = NO;
        self.benchmarkLabel.hidden = NO;
        self.benchmarkValue.hidden = NO;
        self.disclaimerLabel.hidden = NO;
        
        self.titleLabel.text = kDefaultTitle;

        if (resultsChartVC != nil) {
            [resultsChartVC.view removeFromSuperview];
        }
        if (resultsTrendVC != nil) {
            [resultsTrendVC.view removeFromSuperview];
        }

        if (resultsTableVC == nil) {
            resultsTableVC = [[SlideResultsTableVC alloc] initWithNibName:@"SlideResultsTableVC" bundle:nil];
        }
        resultsTableVC.view.frame = subframe;
        [self.view addSubview:resultsTableVC.view];
    }
    
}

- (IBAction)selectChartView
{
    NSLog(@"%s %@", __FUNCTION__, viewId);
    if (![viewId isEqualToString:kChartView]) {
        viewId = kChartView;

        [self.selectTableButton setImage:tableOffImg forState:UIControlStateNormal];
        [self.selectChartButton setImage:chartOnImg forState:UIControlStateNormal];
        [self.selectTrendButton setImage:trendOffImg forState:UIControlStateNormal];
        self.resetButton.hidden = YES;
        self.benchmarkLabel.hidden = YES;
        self.benchmarkValue.hidden = YES;
        self.disclaimerLabel.hidden = YES;

        self.titleLabel.text = kDefaultTitle;
        if (resultsTableVC != nil) {
            [resultsTableVC.view removeFromSuperview];
        }
        if (resultsTrendVC != nil) {
            [resultsTrendVC.view removeFromSuperview];
        }

        if (resultsChartVC == nil) {
            resultsChartVC = [[SlideResultsChartVC alloc] initWithNibName:@"SlideResultsChartVC" bundle:nil];
        }
        [resultsChartVC reset];
        [resultsChartVC update];
        resultsChartVC.view.frame = subframe;
        [self.view addSubview:resultsChartVC.view];
    }


}
- (IBAction)selectTrendView
{
    NSLog(@"%s", __FUNCTION__);
    
    if (![viewId isEqualToString:kTrendView]) {
        viewId = kTrendView;
        [self.selectTableButton setImage:tableOffImg forState:UIControlStateNormal];
        [self.selectChartButton setImage:chartOffImg forState:UIControlStateNormal];
        [self.selectTrendButton setImage:trendOnImg forState:UIControlStateNormal];
        self.resetButton.hidden = YES;
        self.benchmarkLabel.hidden = YES;
        self.benchmarkValue.hidden = YES;
        self.disclaimerLabel.hidden = YES;

        self.titleLabel.text = KTrendTitle;

        if (resultsTableVC != nil) {
            [resultsTableVC.view removeFromSuperview];
        }
        if (resultsChartVC != nil) {
            [resultsChartVC.view removeFromSuperview];
        }

        if (resultsTrendVC == nil) {
            resultsTrendVC = [[SlideResultsTrendVC alloc] initWithNibName:@"SlideResultsTrendVC" bundle:nil];
        }
        [resultsTrendVC reset];
        [self.view addSubview:resultsTrendVC.view];
        
        [resultsTrendVC update];
        resultsTrendVC.view.frame = subframe;
        
    }

}

- (IBAction)resetInputs {
    NSLog(@"%s", __FUNCTION__);
    [resultsTableVC reset];

}

@end
