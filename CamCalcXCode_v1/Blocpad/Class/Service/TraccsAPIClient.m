//
//  TraccsAPIClient.m
//  Blocpad
//
//  Created by Hugh Lang on 4/21/13.
//
//

#import "TraccsAPIClient.h"

#import "FMDatabaseQueue.h"
#import "TraccsWebService.h"
#import "SBJson.h"
#import "SQLiteDB.h"

static NSString *kTraccsGetCalculationIdRequestFormat = @"TraccsServiceGetCalculation?$format=json";
static NSString *kTraccsRebateHistoryRequestFormat = @"TraccsServiceGetRebateHistory?&$format=json";
static NSString *kTraccsCurrentCalculationRequestFormat = @"TraccsServiceGetCurrentCalculationId?calcID=%@&$format=json";
static NSString *kTraccsContractsRequestFormat = @"TraccsServiceGetContractsByCalculationId?calcID=%@&$format=json";
static NSString *kTraccsVialHistoryRequestFormat = @"TraccsServiceGetVialHistoryByCalculationId?calcID=%@&$format=json";

// groupName || '##' || city || '##' || zipcode || '##' || contractId
static NSString *kSearchTextFormat = @"%@##%@##%@##%i";
@implementation TraccsAPIClient

@synthesize testmode;

- (BOOL) checkForUpdate
{
    dbqueue = [SQLiteDB sharedQueue];
    NSInteger calcId = [self refreshCalculationId];
    
    NSLog(@"calcId=%i", calcId);
//    calcId = 139;

    if (calcId > -1) {
        [self refreshAll:calcId];

        NSNotification* finishLoadingNotification = [NSNotification notificationWithName:@"finishLoadingNotification" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:finishLoadingNotification];

        return YES;
    } else {
        NSNotification* finishLoadingNotification = [NSNotification notificationWithName:@"finishLoadingNotification" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:finishLoadingNotification];
        return NO;

    }
}

- (void) refreshAll:(NSInteger)calcId
{
//    if (testmode) {
//        dbconn = [SQLiteDB testConnection];
//    } else {
//        dbconn = [SQLiteDB sharedConnection];
//    }
    [self refreshCalculationDB:calcId];
    [self refreshContractsDB:calcId];
    [self refreshVialHistoryDB:calcId];
    [self refreshRebateHistoryDB];
    

}

// Get current calcId from database
- (NSInteger)refreshCalculationId
{
    __block NSInteger calcId = [self apiGetCalculationId];
    __block NSInteger lastId = -1;
    
//    FMDatabaseQueue *queue = [SQLiteDB sharedQueue];
    
    [dbqueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql;
        sql = @"select * from config;";
        FMResultSet *rs = [db executeQuery:sql];

        if ([rs next]) {
            lastId = [rs intForColumnIndex:0];
            NSLog(@"Compare lastId %i vs calcId %i", lastId, calcId);
            BOOL success;
            if (lastId != calcId) {
                sql = @"DELETE from config;";
                success = [db executeUpdate:sql];
                
                sql = @"INSERT INTO config (calcId) VALUES (?);";
                success = [db executeUpdate:sql,
                           [NSNumber numberWithInt:calcId]
                           ];
                
            } else {
                calcId = -1;
            }
        } else {
            // No data in config table? Leave calcId
            NSLog(@">>>>>>>>>>>>> No data in config table!");
        }
        
    }];
    return calcId;

}

- (void)refreshCalculationDB:(NSInteger)calcId;
{
    NSLog(@"%s", __FUNCTION__);
    

    TraccsCalculation *traccsResult = [self apiGetTraccsCalculation:(calcId)];
    NSLog(@"calculation row=%@", traccsResult.toString);

    [dbqueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql;
        BOOL success;
        sql = @"DELETE from calculation";
        success = [db executeUpdate:sql];
        
        sql = @"INSERT INTO calculation (calcId, calcDate, qtrname, vialPrice, finalInd) VALUES (?, ?, ?, ?, ?);";
        success = [db executeUpdate:sql,
                   [NSNumber numberWithInt:calcId],
                   traccsResult.calculationDate,
                   traccsResult.name,
                   [NSNumber numberWithDouble:traccsResult.vialPrice],
                   [NSNumber numberWithInt:traccsResult.finalInd]
                   ];
        
        if (!success) {
            NSLog(@"################################### SQL Insert failed ###################################");
        } else {
            NSLog(@"=================================== SQL INSERT SUCCESS ===================================");
        }
    }];

    
    
}


- (void)refreshContractsDB:(NSInteger)calcId;
{
    NSLog(@"%s", __FUNCTION__);
    
    NSMutableArray *resultsArray = [self apiGetContracts:calcId];
    
    NSString *insertSql = @"INSERT INTO contract (contractId, groupName, city, state, zipcode, camName, territory, effectiveDate, gpoName, avgPrevYear, specialInd, newInd, search_text) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
    
    NSLog(@"dbfilepath %@", [SQLiteDB getDBfilepath]);
    NSString *txt = @"%i -- %f";
    [dbqueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"DELETE from contract";
        [db executeUpdate:sql];
        NSLog(@"row count = %i", resultsArray.count);

        for (int i=0; i<resultsArray.count; i++) {
            TraccsContract *dataRow = (TraccsContract *) [resultsArray objectAtIndex:i];
            NSString *searchText = [NSString stringWithFormat:kSearchTextFormat, dataRow.groupName, dataRow.city, dataRow.zipcode, dataRow.contractId];
//            NSLog(@"%@", searchText);
//            NSLog(txt, dataRow.contractId, dataRow.avgPrevYear);
            [db executeUpdate:insertSql,
                            [NSNumber numberWithInt:dataRow.contractId],
                            dataRow.groupName,
                            dataRow.city,
                            dataRow.state,
                            dataRow.zipcode,
                            dataRow.camName,
                            dataRow.territory,
                            dataRow.effectiveDate,
                            dataRow.gpoName,
                            [NSNumber numberWithDouble:dataRow.avgPrevYear],
                            [NSNumber numberWithInt:dataRow.specialInd],
                            [NSNumber numberWithInt:dataRow.newInd],
                            searchText
                            ];
            
//            if (!success) {
//                NSLog(@"################################### SQL Insert failed ###################################");
//                //        } else {
//                //            NSLog(@"=================================== SQL INSERT SUCCESS ===================================");
//            }
            
        }
    }];
    
}

- (void)refreshRebateHistoryDB
{
    NSLog(@"%s", __FUNCTION__);
    
    NSMutableArray *resultsArray = [self apiGetRebateHistory];
    
    NSLog(@"row count = %i", resultsArray.count);

    [dbqueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSString *sql;
        BOOL success;
        
        sql = @"DELETE from rebate_history";
        success = [db executeUpdate:sql];
        
        NSString *insertSql = @"INSERT INTO rebate_history (contractId, qtrname, totalRebateAdj) VALUES (?, ?, ?);";
        TraccsRebateHistory *dataRow;
        
        for (int i=0; i<resultsArray.count; i++) {
            dataRow = (TraccsRebateHistory *) [resultsArray objectAtIndex:i];
            
            success = [db executeUpdate:insertSql,
                            [NSNumber numberWithInt:dataRow.contractId],
                            dataRow.qtrname,
                            [NSNumber numberWithDouble:dataRow.totalRebateAdj]
                            ];
            
            if (!success) {
                NSLog(@"################################### SQL Insert failed ###################################");
            }
        }
    }];
}



- (void)refreshVialHistoryDB:(NSInteger)calcId;
{
    NSLog(@"%s", __FUNCTION__);
    
    NSMutableArray *resultsArray = [self apiGetVialHistory:calcId];
    
    NSLog(@"row count = %i", resultsArray.count);

    [dbqueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql;
        BOOL success;
        
        sql = @"DELETE from vial_history";
        success = [db executeUpdate:sql];
        
        NSString *insertSql = @"INSERT INTO vial_history (contractId, qtrname, actUnits) VALUES (?, ?, ?);";
        TraccsVialHistory *dataRow;
        
        for (int i=0; i<resultsArray.count; i++) {
            dataRow = (TraccsVialHistory *) [resultsArray objectAtIndex:i];
            
            BOOL success = [db executeUpdate:insertSql,
                            [NSNumber numberWithInt:dataRow.contractId],
                            dataRow.qtrname,
                            [NSNumber numberWithInt:dataRow.actUnits]
                            ];
            
            if (!success) {
                NSLog(@"################################### SQL Insert failed ###################################");
                //        } else {
                //            NSLog(@"=================================== SQL INSERT SUCCESS ===================================");
            }
        }
    }];
    

    
    
}

#pragma mark -- data access methods

- (NSInteger)apiGetCalculationId
{
    NSLog(@"%s", __FUNCTION__);
    TraccsWebService *ws = [[TraccsWebService alloc] init];
    
    NSData *data = [ws callWebService:kTraccsGetCalculationIdRequestFormat];
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSDictionary *dict;
    NSDictionary *resultData;
    
    NSString *jsonKey = @"TraccsServiceGetCalculation";
    NSString *text;
    NSString *tmp;
    
    dict = (NSDictionary *) [jsonParser objectWithData:data];;
    NSInteger calcId = 0;
    
    if (dict != nil) {
        NSDictionary *object = [dict objectForKey:@"d"];
        if (object != nil) {
            
            tmp = (NSString *) [object objectForKey:jsonKey];
            tmp = [tmp stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
            
            NSArray *resultRow = (NSArray *)[jsonParser objectWithString:tmp];
            
            if (resultRow != nil && resultRow.count > 0) {
                resultData = (NSDictionary *) [resultRow objectAtIndex:0];
                
                text = (NSString *) [resultData objectForKey:@"CalculationId"];
                
                calcId = text.integerValue;
                
            }
        }
    }
    return calcId;
    
}

- (TraccsCalculation *)apiGetTraccsCalculation:(NSInteger)calcId {
    TraccsWebService *ws = [[TraccsWebService alloc] init];
    
    NSString *idKey = [NSString stringWithFormat:@"%i", calcId];
    NSString *requestUrl = [NSString stringWithFormat:kTraccsCurrentCalculationRequestFormat, idKey];
    
    NSData *data = [ws callWebService:requestUrl];
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSDictionary *dict;
    NSDictionary *resultData;
    
    NSString *jsonKey = @"TraccsServiceGetCurrentCalculationId";
    NSString *text;
    NSString *tmp;
    TraccsCalculation *traccsResult = [[TraccsCalculation alloc] init];
    
    dict = (NSDictionary *) [jsonParser objectWithData:data];;
    
    if (dict != nil) {
        NSDictionary *object = [dict objectForKey:@"d"];
        if (object != nil) {
            
            tmp = (NSString *) [object objectForKey:jsonKey];
            tmp = [tmp stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
            
            NSArray *resultRow = (NSArray *)[jsonParser objectWithString:tmp];
            
            if (resultRow != nil && resultRow.count > 0) {
                resultData = (NSDictionary *) [resultRow objectAtIndex:0];
                
                
                traccsResult.name = (NSString *) [resultData objectForKey:@"Name"];
                
                text = (NSString *) [resultData objectForKey:@"CalculationDate"];
                traccsResult.calculationDate = text;
                
                text = (NSString *) [resultData objectForKey:@"FinalInd"];
                
                //                NSLog(@"FinalInd=%@", text);
                traccsResult.finalInd = text.intValue;
                
                text = (NSString *) [resultData objectForKey:@"VialPrice"];
                
                traccsResult.vialPrice = text.doubleValue;
                
//                NSLog(@"%@", traccsResult.toString);
                
            }
        }
    }
    return traccsResult;
}
- (NSMutableArray *)apiGetContracts:(NSInteger)calcId {
    TraccsWebService *ws = [[TraccsWebService alloc] init];
    NSString *idKey = [NSString stringWithFormat:@"%i", calcId];

    NSString *requestUrl = [NSString stringWithFormat:kTraccsContractsRequestFormat, idKey];
    
    NSData *data = [ws callWebService:requestUrl];
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSDictionary *dict;
    NSDictionary *dataRow;
    
    NSString *jsonKey = @"TraccsServiceGetContractsByCalculationId";
    NSString *text;
    NSString *tmp;
    
//    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    
    dict = (NSDictionary *) [jsonParser objectWithData:data];
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    TraccsContract *row;
    //  contractId, groupName, city, state, zipcode, gpoName, terrName, effectiveDate, avgPrevYear, specialInd, newInd;
    
    if (dict != nil) {
        NSDictionary *object = [dict objectForKey:@"d"];
        if (object != nil) {
            
            tmp = (NSString *) [object objectForKey:jsonKey];
            tmp = [tmp stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
            
            NSArray *dataRows = (NSArray *)[jsonParser objectWithString:tmp];
            NSLog(@"dataRows count = %i", dataRows.count);
            
            for (int i=0; i<dataRows.count; i++) {
                row = [[TraccsContract alloc] init];
                dataRow = (NSDictionary *) [dataRows objectAtIndex:i];
                
                text = (NSString *) [dataRow objectForKey:@"ContractId"];
                row.contractId = text.integerValue;
                
                text = (NSString *) [dataRow objectForKey:@"GroupName"];
                row.groupName = text;
                
                text = (NSString *) [dataRow objectForKey:@"City"];
                row.city = text;
                
                text = (NSString *) [dataRow objectForKey:@"State"];
                row.state = text;
                
                text = (NSString *) [dataRow objectForKey:@"ZipCode"];
                row.zipcode = text;
                
                text = (NSString *) [dataRow objectForKey:@"Camname"];
                row.camName = text;
                
                text = (NSString *) [dataRow objectForKey:@"GPOName"];
                row.gpoName = text;
                
                text = (NSString *) [dataRow objectForKey:@"terrname"];
                row.territory = text;
                
                text = (NSString *) [dataRow objectForKey:@"ContractEffectiveDate"];
                row.effectiveDate = text;
                
                text = (NSString *) [dataRow objectForKey:@"AvgPrevYear"];
                @try {
                    row.avgPrevYear = text.doubleValue;
                }
                @catch (NSException *exception) {
                    NSLog(@"FAIL: AvgPrevYear value: %@", text);
                    row.avgPrevYear = 0;
                }
                
                
                text = (NSString *) [dataRow objectForKey:@"SpecialInd"];
                row.specialInd = text.integerValue;
                
                text = (NSString *) [dataRow objectForKey:@"NewInd"];
                row.newInd = text.integerValue;
                
                //                NSLog(@"row = %@", row.toString);
                [resultsArray addObject:row];
                
                
            }
        }
    }
    return resultsArray;
}

- (NSMutableArray *)apiGetVialHistory:(NSInteger)calcId {
    TraccsWebService *ws = [[TraccsWebService alloc] init];
    NSString *idKey = [NSString stringWithFormat:@"%i", calcId];

    NSString *requestUrl = [NSString stringWithFormat:kTraccsVialHistoryRequestFormat, idKey];
    
    NSData *data = [ws callWebService:requestUrl];
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSDictionary *dict;
    NSDictionary *dataRow;
    
    NSString *jsonKey = @"TraccsServiceGetVialHistoryByCalculationId";
    NSString *text;
    NSString *tmp;
    
//    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    
    dict = (NSDictionary *) [jsonParser objectWithData:data];
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    TraccsVialHistory *row;
    
    if (dict != nil) {
        NSDictionary *object = [dict objectForKey:@"d"];
        if (object != nil) {
            tmp = (NSString *) [object objectForKey:jsonKey];
            tmp = [tmp stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
            
            NSArray *dataRows = (NSArray *)[jsonParser objectWithString:tmp];
            NSLog(@"dataRows count = %i", dataRows.count);
            
            for (int i=0; i<dataRows.count; i++) {
                row = [[TraccsVialHistory alloc] init];
                dataRow = (NSDictionary *) [dataRows objectAtIndex:i];
                
                text = (NSString *) [dataRow objectForKey:@"contractid"];
                row.contractId = text.integerValue;
                
                text = (NSString *) [dataRow objectForKey:@"qtrname"];
                row.qtrname = text;
                
                text = (NSString *) [dataRow objectForKey:@"ActUnits"];
                row.actUnits = text.integerValue;
                
//                NSLog(@"row = %@", row.toString);
                
                [resultsArray addObject:row];
                
                
            }
        }
    }
    return resultsArray;
}

- (NSMutableArray *)apiGetRebateHistory {
    TraccsWebService *ws = [[TraccsWebService alloc] init];
//    NSString *idKey = [NSString stringWithFormat:@"%i", calcId];
    
    NSData *data = [ws callWebService:kTraccsRebateHistoryRequestFormat];
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSDictionary *dict;
    NSDictionary *dataRow;
    
    NSString *jsonKey = @"TraccsServiceGetRebateHistory";
    NSString *text;
    NSString *tmp;
    
    dict = (NSDictionary *) [jsonParser objectWithData:data];
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    TraccsRebateHistory *row;
    
    if (dict != nil) {
        NSDictionary *object = [dict objectForKey:@"d"];
        if (object != nil) {
            
            tmp = (NSString *) [object objectForKey:jsonKey];
            tmp = [tmp stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
            
            NSArray *dataRows = (NSArray *)[jsonParser objectWithString:tmp];
            
            for (int i=0; i<dataRows.count; i++) {
                row = [[TraccsRebateHistory alloc] init];
                dataRow = (NSDictionary *) [dataRows objectAtIndex:i];
                
                text = (NSString *) [dataRow objectForKey:@"contractid"];
                row.contractId = text.integerValue;
                
                text = (NSString *) [dataRow objectForKey:@"Name"];
                row.qtrname = text;
                
                text = (NSString *) [dataRow objectForKey:@"TotalRebateAdj"];
                row.totalRebateAdj = text.doubleValue;
                
//                NSLog(@"row = %@", row.toString);
                
                [resultsArray addObject:row];
                
                
            }
        }
    }
    return resultsArray;
}

@end
