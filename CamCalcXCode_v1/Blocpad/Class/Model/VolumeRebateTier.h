//
//  VolumeRebateTier.h
//  Blocpad
//
//  Created by Hugh Lang on 4/4/13.
//
//

#import <Foundation/Foundation.h>

@interface VolumeRebateTier : NSObject {
    int min;
    int max;
    double rebate;
}

@property int min;
@property int max;
@property double rebate;

- (id)initWithValues:(double)_rebate min:(int)_min max:(int)_max;

@end
