//
//  SlideSavingsVC.h
//  Blocpad
//
//  Created by Hugh Lang on 4/3/13.
//
//

#import <UIKit/UIKit.h>
#import "SlideViewController.h"
#import "SlideResultsTableVC.h"
#import "SlideResultsChartVC.h"
#import "SlideResultsTrendVC.h"

#import "HelveticaNeueHvLabel.h"
#import "HelveticaNeueRomanLabel.h"
#import "HelveticaNeueBdLabel.h"
#import "HelveticaNeueBdCnLabel.h"

@interface SlideSavingsVC : SlideViewController {
    CGRect subframe;
    NSString *viewId;
    
    SlideResultsTableVC *resultsTableVC;
    SlideResultsChartVC *resultsChartVC;
    SlideResultsTrendVC *resultsTrendVC;
    UIImage *tableOnImg;
    UIImage *tableOffImg;
    UIImage *chartOnImg;
    UIImage *chartOffImg;
    UIImage *trendOnImg;
    UIImage *trendOffImg;
}
@property (nonatomic, strong) IBOutlet HelveticaNeueBdLabel *titleLabel;

@property (nonatomic, strong) IBOutlet HelveticaNeueHvLabel *groupNameLabel;
@property (nonatomic, strong) IBOutlet HelveticaNeueRomanLabel *locationLabel;

@property (nonatomic, strong) IBOutlet HelveticaNeueRomanLabel *timestampLabel;
@property (nonatomic, strong) IBOutlet HelveticaNeueRomanLabel *benchmarkLabel;
@property (nonatomic, strong) IBOutlet HelveticaNeueBdCnLabel *benchmarkValue;
@property (nonatomic, strong) IBOutlet HelveticaNeueBdCnLabel *disclaimerLabel;

@property (nonatomic, strong) IBOutlet UIButton *previousButton;
@property (nonatomic, strong) IBOutlet UIButton *homeButton;

@property (nonatomic, strong) IBOutlet UIButton *selectTableButton;
@property (nonatomic, strong) IBOutlet UIButton *selectChartButton;
@property (nonatomic, strong) IBOutlet UIButton *selectTrendButton;
@property (nonatomic, strong) IBOutlet UIButton *resetButton;


- (IBAction)previousSlide;
- (IBAction)firstSlide;

- (IBAction)selectTableView;
- (IBAction)selectChartView;
- (IBAction)selectTrendView;

- (IBAction)resetInputs;

@end
