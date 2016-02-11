//
//  TraccsRebateHistory.h
//  Blocpad
//
//  Created by Hugh Lang on 3/27/13.
//
//

#import <Foundation/Foundation.h>

/*
 
 Holds response data for web service method: TraccsServiceGetRebateHistory
 
 Sample json object:  {"contractid":22,"Name":"2012Q2","TotalRebateAdj":0.0300}
 
 */
@interface TraccsRebateHistory : NSObject {
    NSInteger contractId;
    NSString *qtrname;
    double totalRebateAdj;
}

@property NSInteger contractId;
@property (nonatomic, retain) NSString *qtrname;
@property double totalRebateAdj;

- (NSString *) toString;

@end
