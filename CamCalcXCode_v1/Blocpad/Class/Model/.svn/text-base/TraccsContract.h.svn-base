//
//  TraccsContract.h
//  Blocpad
//
//  Created by Hugh Lang on 3/27/13.
//
//

#import <Foundation/Foundation.h>

/*
 Holds response data for web service method: TraccsServiceGetContractsByCalculationId
 {"ContractId":22,"GroupName":"Abington Hematology Oncology Associates","City":"Willow Grove","State":"PA","ZipCode":"19090","Camname":"Rick Baloh","terrname":"Philadelphia","SpecialInd":true,"NewInd":false,"ContractEffectiveDate":"04/01/12","AvgPrevYear":124.25,"GPOName":"ION General"}
 
 */
@interface TraccsContract : NSObject {
    NSInteger contractId;
    NSString *groupName;
    NSString *city;
    NSString *state;
    NSString *zipcode;
    NSString *camName;
    NSString *territory;
    NSString *effectiveDate;
    NSString *gpoName;
    double avgPrevYear;
    int specialInd;
    int newInd;
    
}

@property NSInteger contractId;
@property (nonatomic, retain) NSString *groupName;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *zipcode;
@property (nonatomic, retain) NSString *camName;
@property (nonatomic, retain) NSString *territory;
@property (nonatomic, retain) NSString *effectiveDate;
@property (nonatomic, retain) NSString *gpoName;
@property double avgPrevYear;
@property int specialInd;
@property int newInd;

- (NSString *) toString;

+ (TraccsContract *) readFromDictionary:(NSDictionary *) dict;

@end
