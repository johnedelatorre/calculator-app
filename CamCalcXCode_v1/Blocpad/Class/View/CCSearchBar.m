//
//  CCSearchBar.m
//  Blocpad
//
//  Created by Hugh Lang on 4/8/13.
//
//

#import "CCSearchBar.h"
#import "UIColor+ColorWithHex.h"

@implementation CCSearchBar

@synthesize searchField;

NSString *kDefaultText = @"LOOK UP YOUR ACCOUNT";

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// http://stackoverflow.com/questions/6201406/how-to-customize-apperance-of-uisearchbar

- (void)layoutSubviews {
    NSLog(@"%s", __FUNCTION__);
    
    NSUInteger numViews = [self.subviews count];
    for(int i = 0; i < numViews; i++) {
        if([[self.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]) { //conform?
            searchField = [self.subviews objectAtIndex:i];
        }
    }
    if(!(searchField == nil)) {
        searchField.textColor = [UIColor darkGrayColor];
        searchField.backgroundColor = [UIColor clearColor];
        [searchField setBackground: [UIImage imageNamed:@"invisibutton-230x30.png"] ];
        [searchField setFont:[UIFont fontWithName:@"NewsGothic-Bold" size:16]];
        searchField.leftView = nil;
        [searchField setBorderStyle:UITextBorderStyleNone];
        searchField.placeholder = kDefaultText;
//        http://stackoverflow.com/questions/1340224/iphone-uitextfield-change-placeholder-text-color
        [searchField setValue:[UIColor colorWithHexValue:0xdfdfdf]
                        forKeyPath:@"_placeholderLabel.textColor"];
    }
    
    self.backgroundImage = [UIImage imageNamed:@"invisibutton-230x30.png"];
    
    [super layoutSubviews];
}

- (void) clearPlaceholderText {
    NSLog(@"%s", __FUNCTION__);
    searchField.placeholder = nil;
    
}
- (void) resetPlaceholderText {
    NSLog(@"%s", __FUNCTION__);
    searchField.placeholder = kDefaultText;
}


@end
