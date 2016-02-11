//
//  VolumeRebateModel.m
//  Blocpad
//
//  Created by Hugh Lang on 4/4/13.
//
//

#import "VolumeRebateModel.h"

/*
 5,000+	5000	10000000	14.0%
 4,500-4,999	4500	4999	13.0%
 4,000-4,499	4000	4499	12.5%
 3,500-3,999	3500	3999	12.0%
 3,000-3,499	3000	3499	11.5%
 2,500-2,999	2500	2999	11.0%
 2,000-2,499	2000	2499	10.5%
 1,750-1,999	1750	1999	10.0%
 1,500-1,749	1500	1749	9.5%
 1,250-1,499	1250	1499	9.0%
 900-1,249	900	1249	8.5%
 800-899	800	899	8.0%
 700-799	700	799	7.5%
 500-699	500	699	7.0%
 400-499	400	499	6.5%
 300-399	300	399	6.0%
 240-299	240	299	4.5%
 200-239	200	239	3.0%
 150-199	150	199	2.5%
 120-149	120	149	2.0%
 100-119	100	119	1.5%
 90-99	90	99	1.0%
 <90 (Not rebate eligible)	0	89	0.0%
 */
@implementation VolumeRebateModel

- (void) load {
    VolumeRebateTier *tier;
    volumeTiers = [[NSMutableArray alloc] init];
    
    tier = [[VolumeRebateTier alloc] initWithValues:0.0 min:0 max:89];
    [volumeTiers addObject:tier];

    tier = [[VolumeRebateTier alloc] initWithValues:1.0 min:90 max:99];
    [volumeTiers addObject:tier];
    tier = [[VolumeRebateTier alloc] initWithValues:1.5 min:100 max:119];
    [volumeTiers addObject:tier];
    tier = [[VolumeRebateTier alloc] initWithValues:2.0 min:120 max:149];
    [volumeTiers addObject:tier];
    tier = [[VolumeRebateTier alloc] initWithValues:2.5 min:150 max:199];
    [volumeTiers addObject:tier];
    tier = [[VolumeRebateTier alloc] initWithValues:3.0 min:200 max:239];
    [volumeTiers addObject:tier];
    tier = [[VolumeRebateTier alloc] initWithValues:4.5 min:240 max:299];
    [volumeTiers addObject:tier];
    tier = [[VolumeRebateTier alloc] initWithValues:6.0 min:300 max:399];
    [volumeTiers addObject:tier];
    tier = [[VolumeRebateTier alloc] initWithValues:6.5 min:400 max:499];
    [volumeTiers addObject:tier];
    tier = [[VolumeRebateTier alloc] initWithValues:7.0 min:500 max:699];
    [volumeTiers addObject:tier];
    tier = [[VolumeRebateTier alloc] initWithValues:7.5 min:700 max:799];
    [volumeTiers addObject:tier];
    tier = [[VolumeRebateTier alloc] initWithValues:8.0 min:800 max:899];
    [volumeTiers addObject:tier];
    tier = [[VolumeRebateTier alloc] initWithValues:8.5 min:900 max:1249];
    [volumeTiers addObject:tier];
    tier = [[VolumeRebateTier alloc] initWithValues:9.0 min:1250 max:1499];
    [volumeTiers addObject:tier];
    tier = [[VolumeRebateTier alloc] initWithValues:9.5 min:1500 max:1749];
    [volumeTiers addObject:tier];
    tier = [[VolumeRebateTier alloc] initWithValues:10.0 min:1750 max:1999];
    [volumeTiers addObject:tier];
    tier = [[VolumeRebateTier alloc] initWithValues:10.5 min:2000 max:2499];
    [volumeTiers addObject:tier];
    tier = [[VolumeRebateTier alloc] initWithValues:11.0 min:2500 max:2999];
    [volumeTiers addObject:tier];
    tier = [[VolumeRebateTier alloc] initWithValues:11.5 min:3000 max:3499];
    [volumeTiers addObject:tier];
    tier = [[VolumeRebateTier alloc] initWithValues:12.0 min:3500 max:3999];
    [volumeTiers addObject:tier];
    tier = [[VolumeRebateTier alloc] initWithValues:12.5 min:4000 max:4499];
    [volumeTiers addObject:tier];
    tier = [[VolumeRebateTier alloc] initWithValues:13.0 min:4500 max:4999];
    [volumeTiers addObject:tier];
    tier = [[VolumeRebateTier alloc] initWithValues:14.0 min:5000 max:10000000];
    [volumeTiers addObject:tier];

    
}
- (VolumeRebateTier *) lookupRebate:(int)qty {
    VolumeRebateTier *tier;
    for (int i=0; i<volumeTiers.count; i++) {
        tier = (VolumeRebateTier *) [volumeTiers objectAtIndex:i];
        if (qty >= tier.min && qty <= tier.max) {
            NSLog(@"Found tier %i - %i >> %f", tier.min, tier.max, tier.rebate);
            return tier;
        }
    }
    return nil;
}

@end
