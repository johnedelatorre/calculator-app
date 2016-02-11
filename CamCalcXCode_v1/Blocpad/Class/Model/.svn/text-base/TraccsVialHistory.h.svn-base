//
//  TraccsVialHistory.h
//  Blocpad
//
//  Created by Hugh Lang on 3/27/13.
//
//

#import <Foundation/Foundation.h>

/*
 Holds response data for web service method: "TraccsServiceGetVialHistoryByCalculationId": 
 
 Sample data: {"contractid":22,"qtrname":"2011Q2","ActUnits":139}
 
 
 */
@interface TraccsVialHistory : NSObject {
    NSInteger contractId;
    NSString *qtrname;
    NSInteger actUnits;
    
    // identifier for chart colors. 0=current, 1=future
    int state;
}

@property NSInteger contractId;
@property (nonatomic, retain) NSString *qtrname;
@property NSInteger actUnits;
@property int state;

- (NSString *) toString;
+ (TraccsVialHistory *) readFromDictionary:(NSDictionary *) dict;

@end
