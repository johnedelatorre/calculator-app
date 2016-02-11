//
//  TraccsCalculationData.m
//  Blocpad
//
//  Created by Hugh Lang on 3/27/13.
//
//

#import "TraccsCalculation.h"

@implementation TraccsCalculation

@synthesize calcId, calculationDate, name, vialPrice, finalInd;

static NSString *rowFormat = @"%@|%@|%f|%i";

- (NSString *) toString
{
    NSString *result = [NSString stringWithFormat:rowFormat, calculationDate, name, vialPrice, finalInd];
    
    return result;
}

+ (TraccsCalculation *) readFromDictionary:(NSDictionary *) dict {
    
    TraccsCalculation *o = [[TraccsCalculation alloc] init];
    NSString *text;
    
    text = [dict valueForKey:@"calcId"];
    o.calcId = text.integerValue;
    text = [dict valueForKey:@"calcDate"];
    NSLog(@"calcDate = %@", text);
    
    o.calculationDate = text;
    text = [dict valueForKey:@"qtrname"];
    o.name = text;
    text = [dict valueForKey:@"vialPrice"];
    o.vialPrice = text.doubleValue;

    return o;
}
@end
