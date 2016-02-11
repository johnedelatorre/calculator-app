//
//  TraccsAPIClient_Test.m
//  Blocpad
//
//  Created by Hugh Lang on 4/23/13.
//
//

#import "TraccsAPIClient_Test.h"

#import "WebServiceClass.h"
#import "SBJson.h"
#import "TraccsCalculation.h"
#import "TraccsContract.h"
#import "TraccsRebateHistory.h"
#import "TraccsVialHistory.h"

@implementation TraccsAPIClient_Test

- (void)setUp
{
    [super setUp];
    saveData = YES;
    
    apiClient = [[TraccsAPIClient alloc]init];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testRun
{
    NSLog(@"%s", __FUNCTION__);
    apiClient.testmode = YES;
    [apiClient checkForUpdate];
    
    
}
@end
