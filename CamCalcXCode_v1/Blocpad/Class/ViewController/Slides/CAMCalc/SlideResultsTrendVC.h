//
//  SlideResultsTrendVC.h
//  Blocpad
//
//  Created by Hugh Lang on 4/3/13.
//
//

#import <UIKit/UIKit.h>
#import "TrendLineChartView.h"

#import "HelveticaNeueRomanLabel.h"
#import "TraccsVialHistory.h"

@interface SlideResultsTrendVC : UIViewController {
    NSMutableDictionary *xAxisDictionary;
    NSArray *quartersArray;
//    NSMutableArray *dotsArray;
    NSMutableArray *xAxisMarkers;
//    NSMutableArray *dataArray;
    int yAxisInterval;
    int yAxisMax;
    
//    UIImage *dotImage;
    TrendLineChartView *trendLineView;
    
}
@property (nonatomic, strong) IBOutlet HelveticaNeueRomanLabel *x1;
@property (nonatomic, strong) IBOutlet HelveticaNeueRomanLabel *x2;
@property (nonatomic, strong) IBOutlet HelveticaNeueRomanLabel *x3;
@property (nonatomic, strong) IBOutlet HelveticaNeueRomanLabel *x4;
@property (nonatomic, strong) IBOutlet HelveticaNeueRomanLabel *x5;
@property (nonatomic, strong) IBOutlet HelveticaNeueRomanLabel *x6;
@property (nonatomic, strong) IBOutlet HelveticaNeueRomanLabel *x7;
@property (nonatomic, strong) IBOutlet HelveticaNeueRomanLabel *x8;
@property (nonatomic, strong) IBOutlet HelveticaNeueRomanLabel *x9;
@property (nonatomic, strong) IBOutlet HelveticaNeueRomanLabel *x10;
@property (nonatomic, strong) IBOutlet HelveticaNeueRomanLabel *x11;
@property (nonatomic, strong) IBOutlet HelveticaNeueRomanLabel *x12;

@property (nonatomic, strong) IBOutlet HelveticaNeueRomanLabel *y1;
@property (nonatomic, strong) IBOutlet HelveticaNeueRomanLabel *y2;
@property (nonatomic, strong) IBOutlet HelveticaNeueRomanLabel *y3;
@property (nonatomic, strong) IBOutlet HelveticaNeueRomanLabel *y4;
@property (nonatomic, strong) IBOutlet HelveticaNeueRomanLabel *y5;

- (void) update;
- (void) reset;
@end
