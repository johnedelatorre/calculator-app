//
//  TraccsVialHistory.m
//  Blocpad
//
//  Created by Hugh Lang on 3/27/13.
//
//

#import "TraccsVialHistory.h"

@implementation TraccsVialHistory

@synthesize contractId, qtrname, actUnits;
@synthesize state;

static NSString *rowFormat = @"%i|%@|%i";

- (NSString *) toString
{
    NSString *result = [NSString stringWithFormat:rowFormat, contractId, qtrname, actUnits];
    
    return result;
}

+ (TraccsVialHistory *) readFromDictionary:(NSDictionary *) dict {
    TraccsVialHistory *o = [[TraccsVialHistory alloc] init];
    NSString *text;
    
    text = [dict valueForKey:@"contractId"];
    o.contractId = text.integerValue;
    text = [dict valueForKey:@"qtrname"];
    o.qtrname = text;
    text = [dict valueForKey:@"actUnits"];
    o.actUnits = text.integerValue;
    
    return o;
}
@end
