//
//  CAMCalcLogic.m
//  Blocpad
//
//  Created by Hugh Lang on 8/11/13.
//
//

#import "CAMCalcLogic.h"
#import "NSString+NumberFormat.h"
#import "SQLiteDB.h"

@implementation CAMCalcLogic

static NSDateFormatter *qtrDateFormatter;
static NSDateFormatter *shortDateFormatter;

+ (NSDateFormatter *) getQuarterDateFormatter {
    if (qtrDateFormatter == nil) {
        qtrDateFormatter = [[NSDateFormatter alloc]init];
        [qtrDateFormatter setDateFormat:@"yyyy'Q'Q"];
    }
    return qtrDateFormatter;
}
+ (NSDateFormatter *) getShortDateFormatter {
    if (shortDateFormatter == nil) {
        shortDateFormatter = [[NSDateFormatter alloc]init];
        [shortDateFormatter setDateFormat:@"yyyy-MM-dd"];
        [shortDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    }
    return shortDateFormatter;
}

//@synthesize ccQuarterIds = _ccQuarterIds;

/*
    Returns current date or fixed date
 */
+ (NSDate *) lookupCurrentDate:(NSString *)datetext {
    
    BOOL *useFixed = datetext != nil;
    
    if (useFixed) {
        return [[self getShortDateFormatter] dateFromString:datetext];
    } else {
        NSDate *date = [NSDate date];
        return date;
    }

}
// Convert date to format 2013Q1
+ (NSString *) readQuarterIDFromDate:(NSDate *)date {
    NSString *qtrname = [[self getQuarterDateFormatter] stringFromDate:date];
    return qtrname;
}
+ (NSDate *) readDateFromQuarterID:(NSString *)qtrID {
    NSDate *date = [[self getQuarterDateFormatter] dateFromString:qtrID];
    return date;
}

+ (NSMutableArray *) listQuarterIDs {
    NSMutableArray *qtrs = [[NSMutableArray alloc] init];
    
    [qtrs addObject:@"2013Q2"];
    [qtrs addObject:@"2013Q3"];
    [qtrs addObject:@"2013Q4"];
    return qtrs;
}

/*
 
 Helper function to determine the list of past quarters based on current date.
 Should smartly handle date after last quarter
 
 */
+ (NSMutableArray *) listPastQuarterIDs:(NSMutableArray *)quarterIDList forDate:(NSDate *)date {
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    int index = [self lookupCurrentQuarterIndex:quarterIDList forDate:date];
    if (index > -1) {
        // Increase index value if after last quarter
        for (int i=0; i<index; i++) {
            NSLog(@"Adding qtrID %@ with index %i ", [quarterIDList objectAtIndex:i], i);
            [results addObject:[quarterIDList objectAtIndex:i]];
        }
    }
    return results;
}

+ (int) lookupCurrentQuarterIndex:(NSMutableArray *)quarterIDList forDate:(NSDate *)date {
    NSString *currentQtr = [self readQuarterIDFromDate:date];
        
    // start index at -1 so that current quarter is ignored
    int index = -1;
    NSDate *beginDate;
    for (NSString *qtrID in quarterIDList) {
        
        beginDate = [self readDateFromQuarterID:qtrID];
        
        if ([date compare:beginDate] == NSOrderedDescending) {
            index ++;
            NSLog(@"Found currentQtr %@ with index %i ", currentQtr, index);
        }
    }
    
    // Create and initialize date component instance
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:92];
    
    // Retrieve date with increased days count
    NSDate *finalDate = [[NSCalendar currentCalendar]
                         dateByAddingComponents:dateComponents
                         toDate:beginDate options:0];
    
    if ([date compare:finalDate] == NSOrderedDescending) {
        index ++;
        NSLog(@"Found currentQtr %@ with index %i ", currentQtr, index);
    }
    
    return index;
}

+ (TraccsVialHistory *) lookupVialHistory:(NSNumber *)contractId forQuarter:(NSString *)qtrID {
    TraccsVialHistory *result;
    NSString * sql= @"select * from vial_history where contractId=? and qtrname=?";
    
    FMResultSet *rs = [[SQLiteDB sharedConnection] executeQuery:sql, contractId, qtrID];
    NSDictionary *dict;
    
    if ([rs next]) {
        dict = [rs resultDictionary];
        if (dict != nil) {
            result = [TraccsVialHistory readFromDictionary:dict];
        }
    }

    return result;
}
@end
