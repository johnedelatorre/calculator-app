//
//  DataUtils.m
//  WetCement
//
//  Created by Hugh Lang on 8/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataUtils.h"

@implementation DataUtils

static NSString *simpleTimeFormat = @"h:mm a";

static NSDateFormatter *dbDateTimeFormatter;
static NSDateFormatter *dbDateFormatter;
//static NSDateFormatter *simpleTimeFormatter;

+ (NSDateFormatter *) sharedDbDateTimeFormatter {
    if (dbDateTimeFormatter==nil) {
        dbDateTimeFormatter = [[NSDateFormatter alloc] init];
        [dbDateTimeFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];   
        [dbDateTimeFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    }
    
    return dbDateTimeFormatter;
}

+ (NSDateFormatter *) sharedDbDateFormatter {
    if (dbDateFormatter==nil) {
        dbDateFormatter = [[NSDateFormatter alloc] init];
        [dbDateFormatter setDateFormat:@"yyyy-MM-dd"];   
        [dbDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    }
    return dbDateFormatter;
}


+ (NSString *) readKeyValue:(NSString *)key data:(NSDictionary *)dict 
{
    if ([dict valueForKey:key] == [NSNull null]) {
        return @"";
    } else {
        return [dict valueForKey:key];
    }
    
}
+ (NSDate *) dateFromDBDateString:(NSString *)dbDate {
    
    return [self.sharedDbDateTimeFormatter dateFromString:dbDate];
}

+ (NSString *) simpleTimeLabelFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:simpleTimeFormat];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];

    return [dateFormatter stringFromDate:date];
}

+ (NSString *) dbDateTimeStampFromDate:(NSDate *)date{        
    return [self.sharedDbDateTimeFormatter stringFromDate:date];
}

+ (NSDate *) dateFromDBDateStringNoOffset:(NSString *)dbDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];   
    return [dateFormatter dateFromString:dbDate];
}

+ (NSString *) dbDateStampFromDate:(NSDate *)date {
    
    return [self.sharedDbDateFormatter stringFromDate:date];
}
+ (NSString *) dbTimeStampFromDateNoOffset:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];   
    return [dateFormatter stringFromDate:date];
}

+ (int) readSelectedIndex:(NSString *)key data:(NSMutableDictionary *)dict 
{
    return 0;
}



@end
