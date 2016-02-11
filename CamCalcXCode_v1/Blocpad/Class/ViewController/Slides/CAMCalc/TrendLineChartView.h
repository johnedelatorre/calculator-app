//
//  TrendLineChartView.h
//  Blocpad
//
//  Created by Hugh Lang on 4/6/13.
//
//

#import <UIKit/UIKit.h>
#import "TraccsVialHistory.h"
#import "TraccsRebateHistory.h"

#import "TrendBubble.h"

#import "HelveticaNeueRomanLabel.h"

@interface TrendLineChartView : UIView {
    NSMutableArray *xAxisMarkers;
    NSMutableDictionary *trendDictionary;
    NSArray *quartersArray;
    NSMutableArray *dotsArray;
    NSMutableArray *trendArray;
    
    int yAxisInterval;
    int yAxisMax;
    
    UIImage *dotImage1;
    UIImage *dotImage2;
    CGMutablePathRef drawPath1;
    CGMutablePathRef drawPath2;
    
    TrendBubble *trendBubble;

}

@property (nonatomic, retain) NSMutableArray *xAxisMarkers;
@property (nonatomic, retain) UIImageView *bubbleView;


- (void) configure:(NSMutableArray *)xArray maxY:(int)_maxY;

- (void) drawChart:(NSMutableArray *)xArray;

- (TraccsVialHistory *) findByQuarterName:(NSString *)qtrname;

- (TraccsRebateHistory *) findRebateByQuarter:(NSString *)qtrname;

@end
