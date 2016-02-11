//
//  UserSettings.m
//
//  Created by hugh
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserSettings.h"

static UserSettings *sharedInstance = nil;

@implementation UserSettings


@synthesize isContinuousFlowSelected;
@synthesize isMixingPensSelected;
@synthesize isPoorVentilationSelected;
@synthesize isExposureToSIVSelected;
@synthesize isComminglingPigsSelected;
@synthesize isOvercrowdedPensSelected;
@synthesize isNoIsolationSelected;

@synthesize calculatorPigs;
@synthesize calculator1AverageWean;
@synthesize calculator1AverageGain;
@synthesize calculator1IncreaseInFC;
@synthesize calculator2AverageWeanCost;
@synthesize calculator3weanDays;
@synthesize calculator3Adg;
@synthesize calculator3DecreaseInADG;
@synthesize calculator4Cwt;
@synthesize calculator4Lbs;
@synthesize calculator4feed;
@synthesize giltSelection;
@synthesize sowSelection;

+ (UserSettings *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[UserSettings alloc] init];
    });
    
    return sharedInstance;
}

- (id)init{
    if((self = [super init])) {
        //set defaults
    }
    return self;
}


@end
