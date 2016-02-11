//
//  SlideResultsTrendVC.m
//  Blocpad
//
//  Created by Hugh Lang on 4/3/13.
//
//

#import "SlideResultsTrendVC.h"

#import "TraccsVialHistory.h"
#import "TraccsRebateHistory.h"

#import "UIColor+ColorWithHex.h"
#import "SQLiteDB.h"
#import "CAMCalcLogic.h"

#define kOriginX     187
#define kOriginY     393
#define kRangeY      290

#define kMarkerIntervalX   58
#define kMarkerIntervalY   58

#define kFirstMarkerX   35
#define kDotSize       18



@interface SlideResultsTrendVC ()

@end

@implementation SlideResultsTrendVC

@synthesize x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12;
@synthesize y1, y2, y3, y4, y5;

static NSString *kIntStringFormat = @"%i";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"%s", __FUNCTION__);
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        xAxisMarkers = [[NSMutableArray alloc] init];
        
        quartersArray = [[NSArray alloc] initWithObjects:@"2011Q1",@"2011Q2",@"2011Q3",@"2011Q4",
                         @"2012Q1",@"2012Q2",@"2012Q3",@"2012Q4",
                         @"2013Q1",@"2013Q2",@"2013Q3",@"2013Q4", nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"%s", __FUNCTION__);
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Initialize dictionaries with xAxis labels
    xAxisDictionary = [[NSMutableDictionary alloc] init];
    [xAxisDictionary setObject:x1 forKey:@"2011Q1"];
    [xAxisDictionary setObject:x2 forKey:@"2011Q2"];
    [xAxisDictionary setObject:x3 forKey:@"2011Q3"];
    [xAxisDictionary setObject:x4 forKey:@"2011Q4"];
    [xAxisDictionary setObject:x5 forKey:@"2012Q1"];
    [xAxisDictionary setObject:x6 forKey:@"2012Q2"];
    [xAxisDictionary setObject:x7 forKey:@"2012Q3"];
    [xAxisDictionary setObject:x8 forKey:@"2012Q4"];
    [xAxisDictionary setObject:x9 forKey:@"2013Q1"];
    [xAxisDictionary setObject:x10 forKey:@"2013Q2"];
    [xAxisDictionary setObject:x11 forKey:@"2013Q3"];
    [xAxisDictionary setObject:x12 forKey:@"2013Q4"];

    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) reset {
    NSLog(@"%s", __FUNCTION__);
//    [xAxisMarkers removeAllObjects];
    [trendLineView removeFromSuperview];
    
}
- (void) update {
    NSLog(@"%s", __FUNCTION__);
    // Get entire vial history for Trend report
    NSString *sql;
    FMResultSet *rs;
    NSDictionary *dict;
    NSString *text;
    NSNumber *value;

    int quarterIndex;
    quarterIndex = [CAMCalcLogic lookupCurrentQuarterIndex:[DataModel sharedInstance].quarterIdList
                                                   forDate:[DataModel sharedInstance].currentDate];

    // Load vial history
    sql= @"select * from vial_history where contractId=? order by qtrname";
    NSNumber *contractId = [NSNumber numberWithInteger:[DataModel sharedInstance].contractId];

    rs = [[SQLiteDB sharedConnection] executeQuery:sql, contractId];
    
    
    int maxQty = 0;
    TraccsVialHistory *vialRecord;
//    NSMutableArray *vialHistory = [[NSMutableArray alloc] init];
    NSMutableDictionary *vialHistoryDict = [[NSMutableDictionary alloc] init];
    
    while ([rs next]) {
        dict = [rs resultDictionary];
        if (dict != nil) {
            
            vialRecord = [[TraccsVialHistory alloc] init];
            
            text = [dict objectForKey:@"qtrname"];
            vialRecord.qtrname = text;
            value = [dict objectForKey:@"actUnits"];
            vialRecord.actUnits = value.intValue;
            maxQty = MAX(maxQty, value.intValue);
            vialRecord.state = 0;
            
            NSLog(@"%@ vialcount = %@", text, value);
            [vialHistoryDict setObject:vialRecord forKey:vialRecord.qtrname];
            
        }
    }
    
    // Append future quarters as estimates.
    
    // q1
    vialRecord = [[TraccsVialHistory alloc] init];
    vialRecord.qtrname = [DataModel sharedInstance].q1Savings.qtrname;
    vialRecord.actUnits = [DataModel sharedInstance].q1Savings.vialCount;
    
    if (quarterIndex > 0) {
        vialRecord.state = 0;
    } else {
        vialRecord.state = 1;
    }
    maxQty = MAX(maxQty, vialRecord.actUnits);
    NSLog(@"Adding vialRecord %@", vialRecord.toString);
    [vialHistoryDict setObject:vialRecord forKey:vialRecord.qtrname];
    
    // q2
    vialRecord = [[TraccsVialHistory alloc] init];
    vialRecord.qtrname = [DataModel sharedInstance].q2Savings.qtrname;
    vialRecord.actUnits = [DataModel sharedInstance].q2Savings.vialCount;
    
    if (quarterIndex > 1) {
        vialRecord.state = 0;
    } else {
        vialRecord.state = 1;
    }

    maxQty = MAX(maxQty, vialRecord.actUnits);
    NSLog(@"Adding vialRecord %@", vialRecord.toString);
    [vialHistoryDict setObject:vialRecord forKey:vialRecord.qtrname];

    // q3
    vialRecord = [[TraccsVialHistory alloc] init];
    vialRecord.qtrname = [DataModel sharedInstance].q3Savings.qtrname;
    vialRecord.actUnits = [DataModel sharedInstance].q3Savings.vialCount;
    if (quarterIndex > 2) {
        vialRecord.state = 0;
    } else {
        vialRecord.state = 1;
    }

    maxQty = MAX(maxQty, vialRecord.actUnits);
    NSLog(@"Adding vialRecord %@", vialRecord.toString);
    [vialHistoryDict setObject:vialRecord forKey:vialRecord.qtrname];

    // Load rebate history
    
    sql= @"select * from rebate_history where contractId=? order by qtrname";
    
    rs = [[SQLiteDB sharedConnection] executeQuery:sql, contractId];
    
    TraccsRebateHistory *rebateRecord;
    NSMutableArray *rebateHistory = [[NSMutableArray alloc] init];
    
    while ([rs next]) {
        dict = [rs resultDictionary];
        if (dict != nil) {
            rebateRecord = [[TraccsRebateHistory alloc] init];
            
            text = [dict objectForKey:@"qtrname"];
            rebateRecord.qtrname = text;
            value = [dict objectForKey:@"totalRebateAdj"];
            rebateRecord.totalRebateAdj = value.doubleValue;
            
            NSLog(@"%@ rebate = %@", text, value);
            
            [rebateHistory addObject:rebateRecord];
            
        }
    }
    
    // q1
    rebateRecord = [[TraccsRebateHistory alloc] init];
    rebateRecord.qtrname = @"2013Q2";
    rebateRecord.totalRebateAdj = [DataModel sharedInstance].q1Savings.combinedRebatePct / 100;
    [rebateHistory addObject:rebateRecord];
    // q2
    rebateRecord = [[TraccsRebateHistory alloc] init];
    rebateRecord.qtrname = @"2013Q3";
    rebateRecord.totalRebateAdj = [DataModel sharedInstance].q2Savings.combinedRebatePct / 100;
    [rebateHistory addObject:rebateRecord];
    // q3
    rebateRecord = [[TraccsRebateHistory alloc] init];
    rebateRecord.qtrname = @"2013Q4";
    rebateRecord.totalRebateAdj = [DataModel sharedInstance].q3Savings.combinedRebatePct / 100;
    [rebateHistory addObject:rebateRecord];

    
    
    NSLog(@"Max value is %i in vial history with %i items", maxQty, vialHistoryDict.count);
    [DataModel sharedInstance].trendMax = maxQty;
    [DataModel sharedInstance].vialHistoryDict = vialHistoryDict;
    [DataModel sharedInstance].rebateHistory = rebateHistory;
    
    
// ###########################################################################
    
    
    int tmpInterval = [DataModel sharedInstance].trendMax / 5;
    
    if (tmpInterval <= 20) {
        yAxisInterval = (ceil(tmpInterval/10) + 1) * 10;
    } else {
        yAxisInterval = (ceil(tmpInterval/100) + 1) * 100;
    }
    
    NSLog(@"tmpInterval = %i rounds up to %i", tmpInterval, yAxisInterval);
    int yValue = yAxisInterval;
    
    y1.text = [NSString stringWithFormat:kIntStringFormat, yValue];
    yValue += yAxisInterval;
    
    y2.text = [NSString stringWithFormat:kIntStringFormat, yValue];
    yValue += yAxisInterval;
    
    y3.text = [NSString stringWithFormat:kIntStringFormat, yValue];
    yValue += yAxisInterval;
    
    y4.text = [NSString stringWithFormat:kIntStringFormat, yValue];
    yValue += yAxisInterval;
    
    y5.text = [NSString stringWithFormat:kIntStringFormat, yValue];
    yAxisMax = yValue;
    
    
    // Get x positions of all x-axis labels and load into array
    HelveticaNeueRomanLabel *xAxisLabel;
    
    float xpos = 0;
    
    NSString *qtrname;
    NSNumber *xNumber;
    for (int index=0; index<quartersArray.count; index++) {
        qtrname = [quartersArray objectAtIndex:index];
        xAxisLabel = [xAxisDictionary objectForKey:qtrname];
        xpos = xAxisLabel.center.x - kOriginX;
        xNumber = [NSNumber numberWithFloat:xpos];
        NSLog(@"Add xAxisMarker for qtrname %@ - %f", qtrname, xNumber.doubleValue);
        [xAxisMarkers addObject:xNumber];
    }

    
    CGRect chartFrame = CGRectMake(kOriginX, kOriginY - 300, 700, 300);
    
    
    // Initialize trend line chart view and set the x-axis positions
    
    trendLineView = [[TrendLineChartView alloc] initWithFrame:chartFrame];
    trendLineView.backgroundColor = [UIColor clearColor];
    [trendLineView configure:xAxisMarkers maxY:yAxisMax];
    
    [self.view addSubview:trendLineView];
    
    [trendLineView drawChart:nil];


    
}



@end
