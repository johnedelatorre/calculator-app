//
//  TrendLineChartView.m
//  Blocpad
//
//  Created by Hugh Lang on 4/6/13.
//
//

#import "TrendLineChartView.h"

#import "UIColor+ColorWithHex.h"
#import "NSString+NumberFormat.h"

#import "Constants.h"

#define kOriginX     187
#define kOriginY     393
#define kRangeY      290

#define kMarkerIntervalX   58
#define kMarkerIntervalY   58
#define kBubbleWidth  113
#define kBubbleHeight 61

#define kFirstMarkerX   35
#define kDotSize       18
#define kDotFrame   50

@implementation TrendLineChartView

@synthesize xAxisMarkers;
@synthesize bubbleView;

- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"%s", __FUNCTION__);
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // Initialize dictionaries with xAxis labels
        
        quartersArray = [[NSArray alloc] initWithObjects:@"2011Q1",@"2011Q2",@"2011Q3",@"2011Q4",
                         @"2012Q1",@"2012Q2",@"2012Q3",@"2012Q4",
                         @"2013Q1",@"2013Q2",@"2013Q3",@"2013Q4", nil];
        
        // Setup arrays for holding data (TraccsVialHistory) and dots (UIImageViews)
        dotImage1 = [UIImage imageNamed:@"trend_dot.png"];
        dotImage2 = [UIImage imageNamed:@"trend_dot_dark.png"];
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSLog(@"%s", __FUNCTION__);
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddPath(context, drawPath1);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 7);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexValue:kLabelLightBlue02c1ff].CGColor);
    
    CGContextStrokePath(context);
    
    CGContextAddPath(context, drawPath2);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 7);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexValue:kLabelDarkBlue0b4f9b].CGColor);
    
    CGContextStrokePath(context);
    
}

#pragma mark -- public methods

- (void) configure:(NSMutableArray *)xArray  maxY:(int)_maxY{
    NSLog(@"%s", __FUNCTION__);
    xAxisMarkers = xArray;
    yAxisMax = _maxY;
    
}

- (TraccsVialHistory *) findByQuarterName:(NSString *)qtrname {
    TraccsVialHistory *item;
    
    item = [[DataModel sharedInstance].vialHistoryDict objectForKey:qtrname];
    return item;
    
}

- (TraccsRebateHistory *) findRebateByQuarter:(NSString *)qtrname {
    TraccsRebateHistory *item;
    
    TraccsRebateHistory *foundItem = nil;
    
    for (int i=0; i<[DataModel sharedInstance].rebateHistory.count; i++) {
        item = [[DataModel sharedInstance].rebateHistory objectAtIndex:i];
        NSLog(@"%@ -- Evaluate rebate %f", item.qtrname, item.totalRebateAdj);
        
        if ([item.qtrname isEqualToString:qtrname]) {
            foundItem = item;
        }
    }
    
    return foundItem;
}


- (void) drawChart:(NSMutableArray *)xArray {
    NSLog(@"%s", __FUNCTION__);
    
    // Setup arrays for holding data (TraccsVialHistory) and dots (UIImageViews)
    
    dotsArray = [[NSMutableArray alloc] init];
    trendArray = [[NSMutableArray alloc] init];
    
    
    //    dataArray = [[NSMutableArray alloc] initWithCapacity:12];
    trendDictionary = [[NSMutableDictionary alloc] init];
    TraccsVialHistory *item;
    NSString *qtrname;
    for (int i=0; i<quartersArray.count; i++) {
        qtrname = [quartersArray objectAtIndex:i];
        item = [self findByQuarterName:qtrname];
        
        if (item != nil) {
            [trendDictionary setObject:item forKey:qtrname];
            NSLog(@"Found qtr %@ with vial couunt %i", qtrname, item.actUnits);
        }
    }
    
    
    // Draw lines. For each adjacent pair of data points, draw from point A to point B
    
    drawPath1 = CGPathCreateMutable();
    drawPath2 = CGPathCreateMutable();
    
    
    // For every quarter in x axis. Create dot imageview if data point exists.
    float xpos = 0;
    float ypos = 0;
    float yoffset = 0;
    float xMarker;
    NSNumber *xNumber;
    
    UIImageView *dotView;
    BOOL isFirstDot = YES;
    BOOL isTransitionDot = YES;
    
    CGPoint lastPoint = CGPointMake(0, 0);
    CGPoint nextPoint = CGPointMake(0, 0);
    CGMutablePathRef currentPath;
    
    UIImage *currentDot;
    
    NSLog(@"yAxisMax %i", yAxisMax);
    int count = 0;
    for (int index=0; index<quartersArray.count; index++) {
        qtrname = [quartersArray objectAtIndex:index];
        NSLog(@"%i -- %@", index, qtrname);
        BOOL isOk = YES;
        
        item = [trendDictionary objectForKey:qtrname];
        if (item == nil) {
            item = [[TraccsVialHistory alloc] init];
            item.state = 0;
            item.actUnits = 0;
            isOk = NO;
        }
        
        xNumber = [xAxisMarkers objectAtIndex:index];
        xMarker = xNumber.floatValue;
        
        
        xpos = xMarker;
        
        yoffset = (double)item.actUnits / (double)yAxisMax * kMarkerIntervalY * 5;
        ypos = self.frame.size.height - yoffset;
        
        if (item.state == 0) {
            currentPath = drawPath1;
            currentDot = dotImage1;
        } else if (item.state == 1) {
            
            // Force line style to stay light blue only once when switching to state 1
            if (isTransitionDot == YES) {
                currentPath = drawPath1;
                isTransitionDot = NO;
            } else {
                NSLog(@"Switch to new path: %@ at vials=%i", item.qtrname, item.actUnits);
                currentPath = drawPath2;
            }
//            currentPath = drawPath2;
            currentDot = dotImage2;
            CGPathMoveToPoint(currentPath, NULL, lastPoint.x, lastPoint.y);
            
        }
        
        if (isFirstDot == YES) {
            NSLog(@"lastPoint=nextPoint: xpos=%f / ypos=%f / yoffset=%f", xpos, ypos, yoffset);
            
            // ignore -- first run
            lastPoint = CGPointMake(xpos, ypos);
            CGPathMoveToPoint(currentPath, NULL, lastPoint.x, lastPoint.y);
            isFirstDot = NO;
        } else {
            NSLog(@"drawing line to nextPoint: xpos=%f / ypos=%f / yoffset=%f", xpos, ypos, yoffset);
            nextPoint = CGPointMake(xpos, ypos);
            CGPathAddLineToPoint(currentPath, NULL, nextPoint.x, nextPoint.y);
            lastPoint = nextPoint;
        }
        // Add dot
        dotView = [[UIImageView alloc] initWithImage:currentDot];
        dotView.userInteractionEnabled = YES;
        //            dotView.frame = CGRectMake(xpos - (kDotSize / 2), ypos - (kDotSize / 2), kDotSize, kDotSize);
        dotView.frame = CGRectMake(xpos - (kDotFrame / 2), ypos - (kDotFrame / 2), kDotFrame, kDotFrame);
        dotView.contentMode = UIViewContentModeCenter;
        
        [self addSubview:dotView];
        [trendArray addObject:item];
        dotView.tag = count + 100;
        count ++;
        
//        if (isOk) {
//            [trendArray addObject:item];
//            dotView.tag = count + 100;
//            count ++;
//        } else {
//            dotView.tag = count;
//        }
        [dotsArray addObject:dotView];
        
    }
    [self setNeedsDisplay];
    
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __FUNCTION__);
    
    
    CGPoint locationPoint = [[touches anyObject] locationInView:self];
    UIView* hitView = [self hitTest:locationPoint withEvent:event];
    TraccsVialHistory *item;
    
    UIImageView *dotView;
    int xpos, ypos = 0;
    int index = 0;
    if (hitView.tag >= 100) {
        NSLog(@"hitView.tag = %i", hitView.tag);
        dotView = (UIImageView *) [self viewWithTag:hitView.tag];
        index = hitView.tag - 100;
        
        if (dotView != nil) {
            NSLog(@"Evaluate index %i in array of length %i", index, trendArray.count);
            
            item = [trendArray objectAtIndex:index];
            
            xpos = (dotView.frame.origin.x + (kDotFrame / 2)) - kBubbleWidth / 2;
            ypos = dotView.frame.origin.y - kBubbleHeight + 12;
            
            [trendBubble removeFromSuperview];
            if (trendBubble == nil) {
                trendBubble = [[TrendBubble alloc] init];
            }
            CGRect bubbleFrame = CGRectMake(xpos, ypos, 113, 61);
            trendBubble.frame = bubbleFrame;
            
            NSString *_rebate = @"-";
            
            TraccsRebateHistory *rebateRecord = [self findRebateByQuarter:item.qtrname];
            
            if (rebateRecord != nil) {
                _rebate =  [NSString formatDoubleWithCommas:rebateRecord.totalRebateAdj*100 decimals:2];
                _rebate = [_rebate stringByAppendingString:@"%"];
                NSLog(@"%@ -- Found rebate %@", item.qtrname, _rebate);
            }
            
            [trendBubble configure:[NSString formatIntWithCommas:item.actUnits]
                            rebate:_rebate];
            [self addSubview:trendBubble];
            
            
        }
        
    }
    
    
    
}


@end
