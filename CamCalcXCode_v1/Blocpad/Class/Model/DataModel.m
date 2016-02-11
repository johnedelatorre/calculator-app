//
//  DataModel.m
//
//  Created by Hugh Lang on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

@synthesize accountData;
@synthesize vialHistoryDict, trendMax;
@synthesize rebateHistory;
@synthesize contractId;
@synthesize traccsContract;
@synthesize contract;
@synthesize volumeModel;
@synthesize growthModel;
@synthesize q1Savings, q2Savings, q3Savings, totalSavings;
@synthesize timestampText;
@synthesize needsLookup, needsRefresh;
@synthesize quarterIdList;
@synthesize currentQuarterIndex;
@synthesize currentDate;

static DataModel *instance = nil;

+ (DataModel *) sharedInstance {
    @synchronized(self)
    {
        if (instance == nil) {
            instance = [[DataModel alloc] init];            
        }
        return instance;
    }
}


@end
