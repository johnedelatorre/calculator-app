//
//  TrendBubble.m
//  Blocpad
//
//  Created by Hugh Lang on 4/16/13.
//
//

#import "TrendBubble.h"
#import "UIColor+ColorWithHex.h"
#import "NSString+NumberFormat.h"

@implementation TrendBubble

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        bubbleBG = [UIImage imageNamed:@"trend_bubble_bg"];
        bubbleView = [[UIImageView alloc] initWithImage:bubbleBG];
        [self addSubview:bubbleView];
        
        
        CGRect labelFrame1;
        
        labelFrame1 = CGRectMake(2, 9, 64, 20);
        countLabel = [[HelveticaNeueMdCnLabel alloc] initWithSize:15];
        countLabel.frame = labelFrame1;
        countLabel.text = @"# of Vials:";
        countLabel.textAlignment = UITextAlignmentRight;
        countLabel.backgroundColor = [UIColor clearColor];
        countLabel.textColor = [UIColor colorWithHexValue:0x3abded];

        [self addSubview:countLabel];
        
        CGRect labelFrame2;
        
        labelFrame2 = CGRectMake(2, 27, 64, 20);
        rebateLabel = [[HelveticaNeueMdCnLabel alloc] initWithSize:15];
        rebateLabel.frame = labelFrame2;
        rebateLabel.text = @"% Rebate:";
        rebateLabel.textAlignment = UITextAlignmentRight;
        rebateLabel.textColor = [UIColor colorWithHexValue:0x3abded];
        rebateLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:rebateLabel];
        
        CGRect numberFrame1;
        
        numberFrame1 = CGRectMake(labelFrame1.origin.x + labelFrame1.size.width + 3, 9, 50, 20);
        countValue = [[HelveticaNeueMdCnLabel alloc] initWithSize:15];
        countValue.frame = numberFrame1;
        countValue.text = @"";
        countValue.textAlignment = UITextAlignmentLeft;
        countValue.backgroundColor = [UIColor clearColor];
        countValue.textColor = [UIColor colorWithHexValue:0xFFFFFF];
        
        [self addSubview:countValue];
        
        CGRect numberFrame2;
        
        numberFrame2 = CGRectMake(labelFrame1.origin.x + labelFrame1.size.width + 3, 27, 50, 20);
        rebateValue = [[HelveticaNeueMdCnLabel alloc] initWithSize:15];
        rebateValue.frame = numberFrame2;
        rebateValue.text = @"1.0";
        rebateValue.textAlignment = UITextAlignmentLeft;
        rebateValue.textColor = [UIColor colorWithHexValue:0xFFFFFF];
        rebateValue.backgroundColor = [UIColor clearColor];
        
        [self addSubview:rebateValue];

    }
    return self;
}
- (void) configure:(NSString *)_count rebate:(NSString *)_rebate
{
    countValue.text = _count;
    rebateValue.text = _rebate;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
