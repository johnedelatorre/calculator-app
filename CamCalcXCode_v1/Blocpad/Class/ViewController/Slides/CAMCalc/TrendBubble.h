//
//  TrendBubble.h
//  Blocpad
//
//  Created by Hugh Lang on 4/16/13.
//
//

#import <UIKit/UIKit.h>
#import "HelveticaNeueMdCnLabel.h"

@interface TrendBubble : UIView {
    UIImageView *bubbleView;
    UIImage *bubbleBG;
    HelveticaNeueMdCnLabel *countLabel;
    HelveticaNeueMdCnLabel *countValue;
    HelveticaNeueMdCnLabel *rebateLabel;
    HelveticaNeueMdCnLabel *rebateValue;
}

- (void) configure:(NSString *)_count rebate:(NSString *)_rebate;

@end
