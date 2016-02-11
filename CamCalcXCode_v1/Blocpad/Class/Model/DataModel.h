//
//  DataModel.h
//
//  Created by Hugh Lang on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TraccsContract.h"
#import "CurrentContract.h"
#import "VolumeRebateModel.h"
#import "GrowthRebateModel.h"
#import "SavingsData.h"

#define contains(str1, str2) ([str1 rangeOfString: str2 ].location != NSNotFound)

@interface DataModel : NSObject {
    NSMutableDictionary *accountData;
    NSMutableDictionary *vialHistoryDict;
    NSMutableArray *rebateHistory;
    NSMutableArray *quarterIdList;
    
    NSInteger contractId;
    TraccsContract *traccsContract;
    CurrentContract *contract;
    VolumeRebateModel *volumeModel;
    GrowthRebateModel *growthModel;
    SavingsData *q1Savings;
    SavingsData *q2Savings;
    SavingsData *q3Savings;
    SavingsData *totalSavings;
    
    NSDate *currentDate;
    int currentQuarterIndex;
    int trendMax;
    NSString *timestampText;
    BOOL needsLookup;
    BOOL needsRefresh;
    
}

@property NSInteger contractId;
@property (nonatomic, retain) NSMutableDictionary *accountData;
@property (nonatomic, retain) NSMutableDictionary *vialHistoryDict;
@property (nonatomic, retain) NSMutableArray *rebateHistory;
@property (nonatomic, retain) NSMutableArray *quarterIdList;

@property (nonatomic, retain) NSDate *currentDate;

@property (nonatomic, retain) CurrentContract *contract;
@property (nonatomic, retain) TraccsContract *traccsContract;
@property (nonatomic, retain) VolumeRebateModel *volumeModel;
@property (nonatomic, retain) GrowthRebateModel *growthModel;

@property (nonatomic, retain) SavingsData *q1Savings;
@property (nonatomic, retain) SavingsData *q2Savings;
@property (nonatomic, retain) SavingsData *q3Savings;
@property (nonatomic, retain) SavingsData *totalSavings;
@property (nonatomic, retain) NSString *timestampText;

@property int currentQuarterIndex;
@property int trendMax;

@property BOOL needsLookup;
@property BOOL needsRefresh;


+ (DataModel *) sharedInstance;

@end
