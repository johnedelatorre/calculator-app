//
//  QuarterData.h
//  Blocpad
//
//  Created by Hugh Lang on 4/4/13.
//
//

#import <Foundation/Foundation.h>
#import "CurrentContract.h"

@interface SavingsData : NSObject {
    int index;
    NSString *qtrname;
    int vialCount;
    double cacost;
    double volumeRebate;
    double growthRebate;
    double celgeneRebatePct;
    double celgeneRebateAmt;
    double gpoRebatePct;
    double combinedRebatePct;
    double combinedRebateAmt;
    double netCost;
    double netPricePerVial;
    
    BOOL showAlert;
}


@property int index;
@property (nonatomic, retain) NSString *qtrname;
@property int vialCount;
@property double cacost;
@property double volumeRebate;
@property double growthRebate;
@property double celgeneRebatePct;
@property double celgeneRebateAmt;
@property double gpoRebatePct;
@property double combinedRebatePct;
@property double combinedRebateAmt;
@property double netCost;
@property double netPricePerVial;
@property BOOL showAlert;

- (void) recalculate:(int)vialCount withContract:(CurrentContract *)contract;

- (void) recalculateWithCap:(int)_vialCount withContract:(CurrentContract *)contract previousVialCount:(int)_previousCount;

@end
