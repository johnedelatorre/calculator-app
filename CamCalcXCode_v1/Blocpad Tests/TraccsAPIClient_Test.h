//
//  TraccsAPIClient_Test.h
//  Blocpad
//
//  Created by Hugh Lang on 4/23/13.
//
//

#import <SenTestingKit/SenTestingKit.h>

#import "TraccsAPIClient.h"
#import "TraccsWebService.h"

@interface TraccsAPIClient_Test : SenTestCase {
    BOOL saveData;
    TraccsAPIClient *apiClient;
}

@end
