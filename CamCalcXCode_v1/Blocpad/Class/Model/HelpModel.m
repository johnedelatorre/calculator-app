//
//  HelpModel.m
//  Blocpad
//
//  Created by Hugh Lang on 4/9/13.
//
//

#import "HelpModel.h"
#import "HelpCopy.h"

#define kASP   ASP

@implementation HelpModel

@synthesize helpDB;

- (id)init{
    if ((self = [super init])) {
        [self load];
    }
    return self;
}

- (void) load {
    HelpCopy *helpcopy;
    helpDB = [[NSMutableDictionary alloc] init];
    
    helpcopy = [[HelpCopy alloc] initWithKey:@"ASP"
                                       title:@"ASP"
                                        desc:@"Average sales price for the current quarter."];
    [helpDB setObject:helpcopy forKey:@"ASP"];

    helpcopy = [[HelpCopy alloc] initWithKey:@"ASP3"
                                       title:@"ASP + 3%"
                                        desc:@"Average sales price for the current quarter plus 3%."];
    [helpDB setObject:helpcopy forKey:@"ASP3"];

    helpcopy = [[HelpCopy alloc] initWithKey:@"GPOrebate"
                                       title:@"Estimated GPO Rebate"
                                        desc:@"The customer's estimate of the rebate earned by the GPO with which an office participates.\n\nEstimated GPO Rebate to be provided by customer."];
    [helpDB setObject:helpcopy forKey:@"GPOrebate"];

    helpcopy = [[HelpCopy alloc] initWithKey:@"benchmark"
                                       title:@"Fixed Benchmark"
                                        desc:@"The average quarterly vial purchases between 4Q 2011 and 3Q 2012. \n\nIf the average number of vials is <50, the Fixed Benchmark will default to 50."];
    [helpDB setObject:helpcopy forKey:@"benchmark"];
    
    helpcopy = [[HelpCopy alloc] initWithKey:@"currentQuarterly"
                                       title:@"Current Quarterly Vial Purchase"
                                        desc:@"Current number of vials purchased in the current quarter."];
    [helpDB setObject:helpcopy forKey:@"currentQuarterly"];
    
    helpcopy = [[HelpCopy alloc] initWithKey:@"estimatedQuarterly"
                                       title:@"Estimated Quarterly Vial Purchase"
                                        desc:@"Number of vials purchased in a quarter."];
    [helpDB setObject:helpcopy forKey:@"estimatedQuarterly"];
    
}

/*
 ASP:
 ASP + 3%: Average sales price for the current quarter plus 3%.
 Estimated GPO rebate: The estimated rebate earned by the GPO with which an office participates.
 Fixed benchmark: The baseline quarterly average vial purchases between 4Q 2011 and 3Q 2012.
 Current quarterly vial purchase: Current number of vials purchased in the current quarter.
 Estimated quarterly vial purchase: Estimated number of vials purchased in the current quarter.
 */

@end
