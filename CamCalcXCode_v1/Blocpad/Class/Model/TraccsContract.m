//
//  TraccsContract.m
//  Blocpad
//
//  Created by Hugh Lang on 3/27/13.
//
//

#import "TraccsContract.h"

@implementation TraccsContract

@synthesize contractId, groupName, camName, city, state, zipcode, gpoName, territory, effectiveDate, avgPrevYear, specialInd, newInd;

static NSString *rowFormat = @"%i|%@|%@|%@|%@|%@|%@|%@|%f|%i|%i";

- (NSString *) toString
{
    NSString *result = [NSString stringWithFormat:rowFormat, contractId, groupName, city, state, zipcode, gpoName, territory, effectiveDate, avgPrevYear, specialInd, newInd];
    
    return result;
}

+ (TraccsContract *) readFromDictionary:(NSDictionary *) dict {
    TraccsContract *o = [[TraccsContract alloc] init];
    NSString *text;
    
    text = [dict valueForKey:@"contractId"];
    o.contractId = text.integerValue;
    text = [dict valueForKey:@"groupName"];
    o.groupName = text;
    text = [dict valueForKey:@"camName"];
    o.camName = text;
    text = [dict valueForKey:@"city"];
    o.city = text;
    text = [dict valueForKey:@"state"];
    o.state = text;
    text = [dict valueForKey:@"zipcode"];
    o.zipcode = text;
    text = [dict valueForKey:@"gpoName"];
    o.gpoName = text;
    text = [dict valueForKey:@"territory"];
    o.territory = text;
    text = [dict valueForKey:@"effectiveDate"];
    o.effectiveDate = text;
    text = [dict valueForKey:@"avgPrevYear"];
    o.avgPrevYear = text.doubleValue;

    
    return o;
}

@end
