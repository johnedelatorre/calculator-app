//
//  TraccsCalculationData.h
//  Blocpad
//
//  Created by Hugh Lang on 3/27/13.
//
//

#import <Foundation/Foundation.h>

/*
 Holds response data for web service method:  TraccsServiceGetCurrentCalculationId
 
 Sample data:  {"CalculationDate":"03/14/13","FinalInd":false,"Name":"2013Q1","VialPrice":942.23}
 
 */
@interface TraccsCalculation : NSObject {
    NSInteger calcId;
    NSString *name;
    double vialPrice;
    NSString *calculationDate;
    int finalInd;
}

@property NSInteger calcId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *calculationDate;
@property double vialPrice;
@property int finalInd;

- (NSString *) toString;
+ (TraccsCalculation *) readFromDictionary:(NSDictionary *) dict;

@end
