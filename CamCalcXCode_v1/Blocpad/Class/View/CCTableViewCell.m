//
//  CCTableViewCell.m
//  Blocpad
//
//  Created by Hugh Lang on 4/8/13.
//
//

#import "CCTableViewCell.h"

@implementation CCTableViewCell

@synthesize titleLabel, subtitleLabel, idLabel;
@synthesize rowdata;

static NSString *idFormatter = @"%i";
static NSString *locFormatter = @"%@, %@ %@";

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString *) reuseIdentifier {
    return @"CCTableCell";
}
- (void)setRowdata:(TraccsContract *)data
{
    rowdata = data;
    
    self.titleLabel.text = self.rowdata.groupName;
    NSString *location;
    location = [NSString stringWithFormat:locFormatter, rowdata.city, rowdata.state, rowdata.zipcode];
    
    self.subtitleLabel.text = location;
    self.idLabel.text = [NSString stringWithFormat:idFormatter, self.rowdata.contractId];
    
    
}

@end
