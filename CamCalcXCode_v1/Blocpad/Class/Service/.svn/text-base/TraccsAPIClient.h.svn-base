//
//  TraccsAPIClient.h
//  Blocpad
//
//  Created by Hugh Lang on 4/21/13.
//
//

#import <Foundation/Foundation.h>

#import "SQLiteDB.h"

#import "TraccsCalculation.h"
#import "TraccsContract.h"
#import "TraccsRebateHistory.h"
#import "TraccsVialHistory.h"

@interface TraccsAPIClient : NSObject {
    BOOL testmode;
//    FMDatabase *dbconn;
    FMDatabaseQueue *dbqueue;
    NSNumberFormatter *decimalFormatter;
}

@property BOOL testmode;

- (BOOL) checkForUpdate;
- (void) refreshAll:(NSInteger)calcId;

// db refresh methods
- (NSInteger)refreshCalculationId;
- (void)refreshCalculationDB:(NSInteger)calcId;
- (void)refreshContractsDB:(NSInteger)calcId;
- (void)refreshVialHistoryDB:(NSInteger)calcId;
- (void)refreshRebateHistoryDB;

// api client methods
- (NSInteger)apiGetCalculationId;
- (TraccsCalculation *)apiGetTraccsCalculation:(NSInteger)calcId;
- (NSMutableArray *)apiGetContracts:(NSInteger)calcId;
- (NSMutableArray *)apiGetVialHistory:(NSInteger)calcId;
- (NSMutableArray *)apiGetRebateHistory;

@end
