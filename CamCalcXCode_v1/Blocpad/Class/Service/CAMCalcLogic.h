//
//  CAMCalcLogic.h
//  Blocpad
//
//  Created by Hugh Lang on 8/11/13.
//
//

#import <Foundation/Foundation.h>
#import "TraccsVialHistory.h"

@interface CAMCalcLogic : NSObject {
    NSMutableArray *ccQuarterIds;
}

//@property (nonatomic, retain) NSMutableArray *ccQuarterIds;

+ (NSDate *) lookupCurrentDate:(NSString *)datetext;
+ (NSString *) readQuarterIDFromDate:(NSDate *)date;
+ (NSDate *) readDateFromQuarterID:(NSString *)qtrID;

+ (NSDateFormatter *) getQuarterDateFormatter;
+ (NSDateFormatter *) getShortDateFormatter;

+ (NSMutableArray *) listQuarterIDs;
+ (NSMutableArray *) listPastQuarterIDs:(NSMutableArray *)quarterIDList forDate:(NSDate *)date;
+ (int) lookupCurrentQuarterIndex:(NSMutableArray *)quarterIDList forDate:(NSDate *)date;
+ (TraccsVialHistory *) lookupVialHistory:(NSNumber *)contractId forQuarter:(NSString *)qtrID;

@end
