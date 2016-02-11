//
//  QuarterData.m
//  Blocpad
//
//  Created by Hugh Lang on 4/4/13.
//
//

#import "SavingsData.h"
#import "VolumeRebateModel.h"
#import "VolumeRebateTier.h"
#import "GrowthRebateModel.h"
#import "GrowthRebateTier.h"

@implementation SavingsData

@synthesize index;
@synthesize qtrname;
@synthesize vialCount;
@synthesize cacost;
@synthesize volumeRebate;
@synthesize growthRebate;
@synthesize celgeneRebatePct;
@synthesize celgeneRebateAmt;
@synthesize gpoRebatePct;
@synthesize combinedRebatePct;
@synthesize combinedRebateAmt;
@synthesize netCost;
@synthesize netPricePerVial;

@synthesize showAlert;

- (void) recalculate:(int)_vialCount withContract:(CurrentContract *)contract
{
    showAlert = NO;
    
    vialCount = _vialCount;
    cacost = contract.aspMarkup * _vialCount;
    
    VolumeRebateTier *volumeTier = [[DataModel sharedInstance].volumeModel lookupRebate:_vialCount];
    if (volumeTier != nil) {
        volumeRebate = volumeTier.rebate;
    }
    
    NSLog(@"vial count %i / %i", _vialCount, [DataModel sharedInstance].contract.baselineVialCount);
    
    double growthPercent = (((double)_vialCount / (double)[DataModel sharedInstance].contract.baselineVialCount) - 1) * 100;
    
    if (growthPercent > 0) {
        GrowthRebateTier *growthTier = [[DataModel sharedInstance].growthModel lookupRebate:growthPercent];
        if (growthTier != nil) {
            growthRebate = growthTier.rebate;
        }
    } else {
        growthRebate = 0;
    }
    
    NSLog(@"growthPercent = %f //  rebate=%f", growthPercent, growthRebate);

    celgeneRebatePct = volumeRebate + growthRebate;
    celgeneRebateAmt = celgeneRebatePct/100 * cacost;
    gpoRebatePct = contract.gpoRebate;
    combinedRebatePct = celgeneRebatePct + gpoRebatePct;
    combinedRebateAmt = combinedRebatePct/100 * cacost;
    netCost = cacost - combinedRebateAmt;
    netPricePerVial = netCost / _vialCount;
}

/*
 Method for evaluating the 4th quarter vial count in relation to the 3rd quarter count.
 
 In 4Q 2013, any purchases over 1,000 vials AND 175% or more of 3Q purchases compared, are subject to a Growth Rebate and volume rebate.
 
 When this happens the purple box should show up.
 
 if Q3 vialcount > 1000:
    if Q3 vialcount less than Q2 vialcount *1.75:
        use Q3 vialount
    else:
        Q2 vialcount * 1.75
 else:
    Q3 vialcount

 
 */
- (void) recalculateWithCap:(int)_vialCount withContract:(CurrentContract *)contract previousVialCount:(int)_previousCount
{
    vialCount = _vialCount;

    showAlert = NO;
    int nonRebateVials = -1;
    int rebateVials = -1;
    
//    double growthRatio = (double) _vialCount / (double) _previousCount;
    double q2growthlimit = (double) _previousCount * 1.75;
    NSLog(@"growth limit=%f", q2growthlimit);

    if (_vialCount > 1000) {
        if (q2growthlimit > _vialCount) {
            // Less than the cap
            rebateVials = _vialCount;
            NSLog(@"showAlert = NO");
        } else {
            // Hits the cap. 
            rebateVials = q2growthlimit;
            showAlert = YES;
            NSLog(@"showAlert = YES");
        }
    } else {
        rebateVials = _vialCount;
    }
    
    nonRebateVials = _vialCount - rebateVials;
    
    cacost = contract.aspMarkup * rebateVials;
    
    VolumeRebateTier *volumeTier = [[DataModel sharedInstance].volumeModel lookupRebate:rebateVials];
    if (volumeTier != nil) {
        volumeRebate = volumeTier.rebate;
    }
    
    NSLog(@"vial count %i / %i", rebateVials, [DataModel sharedInstance].contract.baselineVialCount);
    
    double growthPercent = (((double)rebateVials / (double)[DataModel sharedInstance].contract.baselineVialCount) - 1) * 100;
    
    if (growthPercent > 0) {
        GrowthRebateTier *growthTier = [[DataModel sharedInstance].growthModel lookupRebate:growthPercent];
        if (growthTier != nil) {
            growthRebate = growthTier.rebate;
        }
    } else {
        growthRebate = 0;
    }
    
    NSLog(@"growthPercent = %f //  rebate=%f", growthPercent, growthRebate);
    
    celgeneRebatePct = volumeRebate + growthRebate;
    celgeneRebateAmt = celgeneRebatePct/100 * cacost;
    gpoRebatePct = contract.gpoRebate;
    combinedRebatePct = celgeneRebatePct + gpoRebatePct;

    combinedRebateAmt = (gpoRebatePct/100 * _vialCount * contract.aspMarkup) + celgeneRebateAmt;

//    combinedRebateAmt = combinedRebatePct/100 * cacost;
    netCost = (_vialCount * contract.aspMarkup) - combinedRebateAmt;
    
//    netCost = cacost - combinedRebateAmt;
    netPricePerVial = netCost / _vialCount;


}
@end
