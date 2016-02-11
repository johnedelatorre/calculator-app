//
//  GrowthRebateModel.m
//  Blocpad
//
//  Created by Hugh Lang on 4/4/13.
//
//

#import "GrowthRebateModel.h"

@implementation GrowthRebateModel

/*
 Min	Max	Rebate
 50.00%	100000000.00%	2.50%
 45.00%	49.99%	2.25%
 40.00%	44.99%	2.00%
 35.00%	39.99%	1.75%
 30.00%	34.99%	1.50%
 25.00%	29.99%	1.25%
 20.00%	24.99%	1.00%
 0%	19.99%	0%*/

- (void) load {
    GrowthRebateTier *tier;
    tiers = [[NSMutableArray alloc] init];
    
    tier = [[GrowthRebateTier alloc] initWithValues:0.0 min:0 max:19.99];
    [tiers addObject:tier];    
    tier = [[GrowthRebateTier alloc] initWithValues:1.00 min:20.00 max:24.99];
    [tiers addObject:tier];
    tier = [[GrowthRebateTier alloc] initWithValues:1.25 min:25.00 max:29.99];
    [tiers addObject:tier];
    tier = [[GrowthRebateTier alloc] initWithValues:1.50 min:30.00 max:34.99];
    [tiers addObject:tier];
    tier = [[GrowthRebateTier alloc] initWithValues:1.75 min:35.00 max:39.99];
    [tiers addObject:tier];
    tier = [[GrowthRebateTier alloc] initWithValues:2.00 min:40.00 max:44.99];
    [tiers addObject:tier];
    tier = [[GrowthRebateTier alloc] initWithValues:2.25 min:45.00 max:49.99];
    [tiers addObject:tier];
    tier = [[GrowthRebateTier alloc] initWithValues:2.50 min:50.00 max:100000000.00];
    [tiers addObject:tier];
    
    
}
- (GrowthRebateTier *) lookupRebate:(double)growth {
    GrowthRebateTier *tier;
    for (int i=0; i<tiers.count; i++) {
        NSLog(@"%f == Evaluate tier %f - %f >> %f", growth, tier.min, tier.max, tier.rebate);
        
        tier = (GrowthRebateTier *) [tiers objectAtIndex:i];
        if ((float)growth >= (float)tier.min) {
            NSLog(@"%f == Greater than lower bound %f", growth, tier.min);
            if ((float)growth <= (float)tier.max) {
                NSLog(@"%f == Found tier %f - %f >> %f", growth, tier.min, tier.max, tier.rebate);
                return tier;                
            } else {
                NSLog(@"%f == Greater than upper bound %f", growth, tier.max);
            }
        }

        
//        if (growth >= tier.min && growth <= tier.max) {
//            NSLog(@"%f == Found tier %f - %f >> %f", growth, tier.min, tier.max, tier.rebate);
//            return tier;
//        }
    }
    return nil;
}

@end
